# Требования к VM под Домовой

Документ для заведения виртуальной машины под dev/прод-стенд. После создания — передать креды (раздел «Что передать»), дальнейшую настройку беру на себя.

## Что будет крутиться

Весь стек — Docker Compose (`docker-compose.yml` + prod-оверрайды):

| Сервис | Образ/рантайм | Постоянно? |
|---|---|---|
| SurrealDB (RocksDB) | `surrealdb/surrealdb` | да |
| MinIO + init | `minio/minio`, `minio/mc` | да |
| web (Next.js 15) | node:22, dev-режим | да (с фазы 2) |
| worker-scheduler / playbook / bot | node:22 | позже (фаза 9+) |
| worker-ai / worker-files | python:3.12 | позже (AI-вертикаль) |
| Surrealist GUI | nginx, profile `tools` | по желанию |

LLM/embeddings на этой VM **не живут** — Ollama на отдельном GPU-сервере (`OLLAMA_ENDPOINT`), VM ходит к нему по сети. До AI-вертикали не нужен вовсе.

## Размер: два профиля

| Ресурс | **Минимум** (фазы 2–10: web+db+minio) | **Полный dev** (+ все воркеры, worker-ai на CPU) |
|---|---|---|
| vCPU | 2 | 4 |
| RAM | 4 GB | 16 GB (BGE-M3 + reranker + Whisper на CPU прожорливы) |
| Диск | 40 GB SSD | 120 GB SSD |
| Своп | 2 GB | 4 GB |

**Рекомендация: начать с минимума** — до фазы 9 воркеры не нужны, ресайз VM дешевле простоя. Если гипервизор позволяет горячий ресайз — тем более.

Раскладка диска (ориентир для полного профиля):

| Что | Объём |
|---|---|
| ОС + Docker + образы | ~15 GB |
| `surrealdb_data` (RocksDB) | 5–10 GB (seed мизерный, растёт с историей) |
| `minio_data` | 20–60 GB — зависит от медиафикстур (`~/cursor/yascrap/.../\*.jpg`, `~/shorts/*.mp4`) и будущих сканов |
| `ai_models` (кэш BGE-M3/Whisper) | ~12 GB (только полный профиль) |
| `backups/` | ≥ размер surrealdb_data + minio-метаданных, ×2 |

Отдельные разделы не обязательны; достаточно одного корня на SSD. Thin-provisioning ок.

## ОС и базовое ПО

- **Ubuntu Server 24.04 LTS** x86_64 (или Debian 12 — оба ок; главное не Alpine).
- **Docker Engine ≥ 27** + **compose-плагин v2** (`docker compose`, не `docker-compose`).
- Пакеты: `git`, `make`, `curl`, `rsync`, `python3` (≥3.10 достаточно для скриптов), `jq`.
- Часовой пояс и NTP настроены (у нас `time::now()` в данных).
- Автообновления безопасности (`unattended-upgrades`) — желательно.

## Сеть и порты

Наружу VM ничего публиковать **не нужно** — только LAN/VPN:

| Порт | Сервис | Доступ |
|---|---|---|
| 22 | SSH | мой доступ (см. ниже) |
| 8000 | SurrealDB | LAN/VPN |
| 9000 / 9001 | MinIO API / консоль | LAN/VPN |
| 3000 | web (Next.js) | LAN/VPN |
| 8080 | Surrealist | LAN/VPN, опционально |

- В compose биндинг управляется переменной `LOCAL_IP` (по умолчанию `127.1.0.1`) — выставим в LAN-адрес VM или оставим localhost + SSH-туннели, решу на месте.
- **Исходящий доступ**: интернет (docker pull, npm/pip), GPU-сервер с Ollama (какой адрес/порт — сообщи, впишу в `.env` как `OLLAMA_ENDPOINT`; до AI-фаз не критично).
- Если VM вне домашней сети — доступ через WireGuard/Tailscale предпочтительнее проброса портов.

## Доступ и безопасность

- Пользователь **`domovoy`** (или любой), **не root**: в группах `sudo` и `docker`.
- SSH: **только по ключу**, `PasswordAuthentication no`, root-логин запрещён.
- Мой публичный ключ добавить в `~/.ssh/authorized_keys` (пришлю отдельно, либо положи свой — креды передашь, ключ сгенерирую на месте).
- Файрвол (ufw/nftables): 22 отовсюду из LAN/VPN, 3000/8000/8080/9000/9001 — только LAN/VPN, остальное closed.
- Снапшот VM после базовой настройки — на случай отката.

## Что передать мне

```
host:        <IP или hostname>          (+ как ходить: LAN / WireGuard / Tailscale)
ssh_port:    22 (или иной)
user:        domovoy
auth:        путь к приватному ключу / или скажи «добавь свой ключ» и я дам публичный
sudo:        да (пароль или NOPASSWD — как удобнее)
ollama:      http://<gpu-server>:11434  (можно позже, к AI-вертикали)
```

Секреты для `.env` (SURREAL_USER/PASS, MINIO_USER/PASS) генерирую сам на VM, в репозиторий не попадут (`.env` в `.gitignore`).

## Что я сделаю после получения кредов (для сверки ожиданий)

1. Проверка базы: ОС, docker, диск, сеть до GitHub.
2. Клонирование репо, генерация `.env` из `.env.example` со свежими секретами.
3. `make infra` → SurrealDB + MinIO; `make seed` → 2583 стейтмента; контрольные запросы.
4. Настройка `make deploy` под эту VM (сейчас цель — `home-server`).
5. Бэкапы: `scripts/backup.sh` в cron, ротация в `backups/`.
6. Дальше — фаза 2 (web) уже на живом стенде.

## Чек-лист заведения (кратко)

- [ ] VM: 2 vCPU / 4 GB / 40 GB SSD (минимум) — или сразу полный профиль
- [ ] Ubuntu 24.04 LTS, NTP, unattended-upgrades
- [ ] Docker + compose v2, `git make curl rsync jq`
- [ ] Пользователь `domovoy` (sudo + docker), SSH только по ключу
- [ ] Файрвол: LAN/VPN-only для 3000/8000/8080/9000/9001
- [ ] (опц.) WireGuard/Tailscale, если стенд вне домашней сети
- [ ] Снапшот после настройки
- [ ] Передать креды по форме выше
