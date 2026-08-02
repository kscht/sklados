# Домовой — контекст для Claude

## Что это

Self-hosted граф-система управления жизнью семьи. Заменяет десятки приложений одной моделью данных: инвентарь, задачи, медицина, IT-инфраструктура, обучение, AI-чаты, плейбуки, документы.

Полная схема данных: `docs/database.md` (~10 000 строк) — **поколение 1, справочник**: кириллические `kind` оттуда в код не копировать, канон — `docs/kind-audit.md`.
Сравнение с конкурентами: `docs/comparison.md`.
Индекс документации и порядок чтения: `docs/README.md`. Открытые вопросы и решения: `docs/decisions.md`.

## Ключевые архитектурные решения

**Граф-модель:** одна таблица `thing` (schemaless), 27 типизированных рёбер. Никаких отдельных таблиц под домены. Новый домен = новые `kind`-значения у `thing`, не новые таблицы.

**Воркеры — конкурирующие потребители:** атомарный захват задачи через `UPDATE ... WHERE status = 'queued' AND locked_by = NONE` (канонический слаг по D-32, см. `docs/status-audit.md`). Язык воркера не важен — TS, Python, Go подключаются к одной очереди. Фильтрация по `kind` + `subtype`.

**LIVE SELECT вместо polling** — воркеры держат WebSocket к SurrealDB, получают задачи мгновенно. Исключение: `worker-scheduler` — polling раз в минуту (сам создаёт задачи по cron).

**MinIO как primary storage** — файлы хранятся в MinIO (S3 API), в SurrealDB только метаданные (`kind: файл`) + чанки с embeddings. Локальный бэкенд только для dev.

**Embeddings в SurrealDB** — MTREE-индекс, измерение 1024 (BGE-M3). Нет отдельного Qdrant/Weaviate. Гибридный поиск: BM25 + vector → RRF → BGE-Reranker.

**Мультиязычность** — поля `_lang` + `_i18n` (embedded JSON) на каждом `thing`. Без отдельных узлов для локалей — переводы путешествуют с узлом при федерации.

**Vision через Ollama** — subtype `vision-local` (qwen2-vl) или `vision-api` (GPT-4o). Тот же паттерн datasource что у LLM и STT.

## Стек

| Слой | Технология |
|------|-----------|
| БД | SurrealDB (RocksDB в prod, memory в тестах) |
| Web | Next.js 15, TypeScript, Tailwind, shadcn/ui, TanStack Query |
| TS-воркеры | Node.js 22 — scheduler, playbook, bot |
| Python-воркеры | Python 3.12 — AI (BGE-M3, Reranker, Whisper), Files (pypdf, tesseract) |
| Storage | MinIO (S3-совместимый) |
| LLM/Embed | Ollama на отдельном GPU-сервере (RTX 3090 24GB) |
| LLM модель | Qwen2.5 32B Q4_K_M |
| Embed модель | BGE-M3 (1024d, multilingual, русский) |
| Reranker | BGE-Reranker-v2-m3 |
| STT | faster-whisper large-v3 |

## Структура проекта

```
domovoy/
├── docker-compose.yml       — dev
├── docker-compose.prod.yml  — prod overrides
├── docker-compose.test.yml  — тесты (SurrealDB memory + MinIO tmpfs)
├── Makefile                 — make up/down/test/deploy/seed/shell-db
├── .env / .env.example
├── docker/
│   └── surrealist/          — кастомный build Surrealist GUI (nginx)
├── web/                     — Next.js (ещё не инициализирован)
├── worker-scheduler/        — TS: cron + counter-триггеры
├── worker-playbook/         — TS: DAG-исполнение плейбуков, HTTP-интеграции
├── worker-bot/              — TS: Telegram, голосовой шлюз
├── worker-ai/               — Python: embeddings, reranker, Whisper, vision
├── worker-files/            — Python: chunking, OCR, thumbnails
├── scripts/
│   ├── seed.surql              — тестовый датасет (2161 оператор, все 27 рёбер)
│   ├── generate_seed.py        — генератор основного датасета
│   ├── generate_forum_seed.py  — wiki/чаты из forum30.jsonl
│   └── import_fixtures.py      — загрузка медиафайлов в MinIO
└── docs/
    ├── README.md            — индекс документации, статусы, порядок чтения
    ├── database.md          — полная схема (~10 000 строк; поколение 1, справочник)
    ├── comparison.md        — сравнение с конкурентами
    ├── access-control.md    — модель доступа и маппинг на SurrealDB
    ├── relation-typing.md   — типизация связей (каталог рёбер, gradual typing)
    ├── kind-audit.md        — аудит kind, миграция 56→27, иерархия категорий, SKOS
    ├── ui-architecture.md   — UI как данные (виджеты + декларативная композиция)
    ├── roadmap-inventory.md — роадмап первой вертикали: инвентарь + места хранения
    ├── categorization.md    — категоризация как процесс (моменты, источники, роли)
    ├── decisions.md         — реестр решений и открытых вопросов (D-01…D-36)
    └── docs-audit.md        — ревизия документации (два поколения, блокеры фазы 1)
```

## Текущий статус

- [x] Полная схема данных в `docs/database.md`
- [x] Docker Compose: dev + prod + test
- [x] Makefile с командами
- [x] `scripts/seed.surql` — **мигрирован на канон 41 kind** (фаза 1): ASCII-слаги, статусы-слаги, SKOS-словари в начале файла; категории проставлены из таблицы миграции, словарь ~45 концептов с иерархией (`legacy_kind` удалён — D-33 пересмотрен)
- [x] Surrealist GUI контейнер (`docker/surrealist/`, profile: tools) — см. проблему ниже
- [x] `web/` — Next.js 15 инициализирован (фаза 2 v1): маршрут `/w/[slug]` рендерит workspace-узлы из графа, generic-фолбэк `/things`; деплой на VM, снаружи — https://v1.spiridus.ru/w/sklad
- [ ] `worker-scheduler/` — минимальный воркер
- [ ] DEFINE-схема в SurrealDB (из database.md выжать в .surql файл)
- [ ] UI-спайки (спайк A: thing list + detail, спайк B: граф-визуализация)
- [ ] Залить медиафикстуры (`python3 scripts/import_fixtures.py`)

## Тестовый датасет

`scripts/seed.surql` — готов, мигрирован (фаза 1). Залить: `make seed`.
`scripts/generate_seed.py` — ⚠️ ещё генерирует старый формат (56 кириллических kind); обновить отдельным коммитом перед следующей регенерацией.

Медиафикстуры (пока не залиты):
- Источник изображений: `~/cursor/yascrap/yaplakal-scraper/data/*.jpg`
- Источник видео: `~/shorts/*.mp4`
- Команда: `python3 scripts/import_fixtures.py` (или `--dry-run`)

## Команды

```bash
make infra              # поднять только SurrealDB + MinIO (для локальной разработки)
make up                 # поднять всё
make surrealist         # генерирует instance.json из .env, поднимает Surrealist :8080
make surrealist-update  # pull новой версии + restart
make test               # все тесты (TS + Python)
make test-ts            # только TS тесты
make test-e2e           # Playwright E2E
make test-py            # все Python тесты
make shell-db           # SurrealQL REPL
make seed               # залить тестовый датасет
make deploy             # деплой на home-server через SSH
```

## Важные детали

- `.env` в `.gitignore`, не коммитить
- Тесты используют SurrealDB `memory` backend — данные не сохраняются между прогонами
- GPU-сервер (Ollama) внешний, в docker-compose не входит, адрес в `OLLAMA_ENDPOINT`
- Если нужен Go-воркер для конкретного `subtype` — добавить новый сервис в compose, тот же паттерн захвата задачи
- Граф-визуализация в UI — библиотека ещё не выбрана (кандидат: React Flow)
- SurrealQL: все IDs в бэктиках `` `id` ``, строки в одинарных `'...'`, `time::now()` без кавычек
- SurrealDB v2 API: `POST /sql` с заголовками `surreal-ns` / `surreal-db`

## Surrealist GUI (нерешённая проблема)

Контейнер поднимается (`make surrealist` → http://localhost:8080), но Surrealist показывает "Create connections" вместо pre-configured подключения из `instance.json`.

**Причина:** официальный образ `surrealdb/surrealist` собран без `VITE_SURREALIST_DOCKER=true`, поэтому DockerAdapter не активируется и `/instance.json` не читается. Наш кастомный build из исходников (`docker/surrealist/Dockerfile`) собирается с этим флагом, но при проверке бандла `"/instance.json"` встречается только в changelog, не в runtime-fetch.

**Следующий шаг:** открыть http://localhost:8080 → DevTools → Network tab — проверить, есть ли запрос к `instance.json`. Если нет — пересобрать `--no-cache` и проверить наличие строки `"/instance.json"` в js-бандле.
