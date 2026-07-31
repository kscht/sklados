# Типизация связей — каталог рёбер в SKOS

Как добавить Домовому типизацию отношений между узлами, **не отказываясь от свободы** schemaless-графа. Ответ на критику «в Anytype всё типизировано, а тут полная свобода».

> Переписан под канон (D-35): носитель каталога — концепты рёбер в `vocab:domovoy_edge` (SKOS), не отдельный `kind='тип-связи'`. Добавлены мета-классы субъектов `party`/`actor` (D-43). Механика (`enforce`, `fn::check_edge`, линт, дискаверабилити) сохранена из первой редакции.

Смежные документы: [`kind-audit.md`](kind-audit.md), [`kind-audit-domains.md`](kind-audit-domains.md) (канон 41), [`access-control.md`](access-control.md) (тот же приём «свобода в данных, enforcement обобщённый»), [`decisions.md`](decisions.md).

## Критика, на которую отвечаем

> «Одна schemaless-таблица `thing` и рёбра `FROM thing TO thing` — соединить можно что угодно с чем угодно. `RELATE task->answered->device` пройдёт молча. Нет валидации, нет машинного ответа "что к чему присоединяется"».

Критика бьёт в реальную дыру, но смешивает два понятия. **Schemaless ≠ untyped**: узлы типизированы `kind`, рёбра — самим именем-предикатом. Не хватает двух вещей: (1) ограничений на концы ребра, (2) дискаверабилити. Обе закрываются каталогом-данными.

## Почему не нативная типизация SurrealDB

`DEFINE TABLE assigned_to TYPE RELATION FROM task TO person` работает **между таблицами**. У нас всё — одна таблица `thing`, конструкция вырождается в `FROM thing TO thing`. Типизация должна жить на уровне `kind`. Разносить `thing` по таблицам — стать Anytype и потерять ядро.

## Решение: типизация живёт на концептах рёбер

Каталог рёбер **уже существует** — `vocab:domovoy_edge`, 27 концептов (в seed с фазы 1). Типизация — это дополнительные поля на тех же концептах:

```surql
UPDATE thing:`edge_assigned_to` SET
  from_kinds  = NONE,               -- NONE = любой kind
  to_kinds    = ['actor'],          -- слаг kind ИЛИ слаг класса (см. ниже)
  cardinality = 'many-to-one',
  enforce     = false;              -- false = только линт; true = блокировать
```

Отдельный `kind='тип-связи'` из первой редакции **упразднён**: он не прошёл в канон 41, а его роль полностью покрывает концепт ребра. Один узел на ребро несёт всё: `_i18n`-метки, типизацию, версионирование через `supersedes`, права через `can_access`.

## Мета-классы субъектов: `party` и `actor` (D-43)

Проблема: «взято у кого» — не только у человека. У **другой семьи** (`group`), у **проката** (`org`). А «исполнитель» — ещё шире: шаг пайплайна `assigned_to → agent`, уведомление `assigned_to → gateway`.

Перечислять kinds в каждом ребре — расползётся. Вместо этого — **иерархия концептов kind** через `part_of`, тем же механизмом, что у категорий («агрохимия» разворачивается в «удобрения»):

```
vocab:domovoy_kind
├── class_party  «социальный субъект»        ← мета-концепт (is_class=true), НЕ kind
│   ├── kind_person
│   ├── kind_group        ← другая семья
│   └── kind_org          ← прокат, сервис, инстанция
└── class_actor  «исполнитель» ⊃ party
    ├── class_party (part_of)
    ├── kind_agent        ← AI-агент
    ├── kind_worker       ← воркер берёт job
    └── kind_gateway      ← шлюз доставляет уведомление
```

В `from_kinds`/`to_kinds` допустимы и слаги kind, и слаги классов; проверка разворачивает класс обходом `part_of`. Узлы с `is_class=true` — **не** значения поля `kind`, только группировка в словаре.

### Типизация субъектных рёбер

| Ребро | from_kinds | to_kinds | Комментарий |
|---|---|---|---|
| `lent_to` | `['item','device']` | `['party']` | одолжить можно и семье, и прокату |
| `borrowed_from` | `['item','device']` | `['party']` | у org это аренда — поля `deposit`/`due` на ребре |
| `promised_to` | `['task']` | `['party']` | обещание всей семье |
| `assigned_to` | NONE | `['actor']` | исполнитель: человек … шлюз |
| `participant` | NONE | `['party']` | подрядчик-org — участник с ролью |
| `expert_in` | `['person','org']` | NONE | эксперт в чём угодно (в seed — и в верстаке) |
| `filed_with` | `['appeal']` | `['org']` | **сознательно узко**: инстанция — только org |
| `can_access` | NONE | NONE | политика-данные, не ограничиваем |

Уведомления группе/org резолвятся через контактное лицо: `participant {role:'contact'}` (паттерн уже в seed — 7 контактов у `family`), fallback — члены через `part_of`.

## Градация строгости — флаг `enforce`

- `enforce = true` — несущие рёбра: нарушение блокируется на записи.
- `enforce = false` — каталог **описывает** ожидание; линт помечает странности, не мешая.

Это gradual typing: строго где важно, свободно где хвост. Стартовое состояние (фаза 1): **все рёбра `enforce=false`** — машинерия проверки появится вместе с воркерами; включать строгость — после линт-прогона накопленных данных.

## Enforcement: общая функция + тонкие события

```surql
-- Разворачивание класса в слаги kind (один уровень + вложенный класс)
DEFINE FUNCTION fn::expand_kinds($list: option<array>) {
    IF $list = NONE { RETURN NONE; };
    RETURN array::group($list.map(|$slug|
        array::len((LET $kids = (SELECT VALUE identifier FROM thing
            WHERE kind = 'concept'
              AND ->part_of->thing.identifier CONTAINS $slug)); $kids)) > 0
        AND $kids OR [$slug]));
};

-- Единая проверка: читает концепт ребра из vocab:domovoy_edge
DEFINE FUNCTION fn::check_edge($predicate: string, $in: record, $out: record) {
    LET $spec = (SELECT from_kinds, to_kinds, enforce FROM thing
                 WHERE kind = 'concept' AND identifier = $predicate
                   AND ->part_of->thing CONTAINS thing:`vocab_domovoy_edge`)[0];
    IF $spec = NONE OR $spec.enforce = false { RETURN true; };
    LET $from = fn::expand_kinds($spec.from_kinds);
    LET $to   = fn::expand_kinds($spec.to_kinds);
    LET $ok_from = $from = NONE OR $in.kind  IN $from;
    LET $ok_to   = $to   = NONE OR $out.kind IN $to;
    IF !($ok_from AND $ok_to) {
        THROW 'Недопустимая связь: ' + <string>$in.kind
            + ' -' + $predicate + '-> ' + <string>$out.kind;
    };
    RETURN true;
};

-- Тонкая обёртка на ребре (одна строка на предикат с enforce=true)
DEFINE EVENT typecheck ON TABLE assigned_to WHEN $event = 'CREATE'
    THEN fn::check_edge('assigned_to', $after.in, $after.out);
```

Логика централизована; поменять правило = `UPDATE` концепта ребра, **без миграции схемы**.

## Soft-режим: линт-воркер

Для `enforce=false` и аудита накопленного — запрос, находящий нарушения постфактум; воркер прогоняет по всем предикатам и помечает флагом `_lint_warning`, никого не блокируя:

```surql
LET $spec = (SELECT from_kinds, to_kinds FROM thing
             WHERE kind = 'concept' AND identifier = 'assigned_to'
               AND ->part_of->thing CONTAINS thing:`vocab_domovoy_edge`)[0];
SELECT id, in.kind AS from_kind, out.kind AS to_kind FROM assigned_to
WHERE !(in.kind IN fn::expand_kinds($spec.from_kinds))
   OR !(out.kind IN fn::expand_kinds($spec.to_kinds));
```

## Дискаверабилити: автокомплит из каталога

```surql
-- Что можно присоединить, исходя из узла kind = 'task'?
SELECT identifier, to_kinds, cardinality, _i18n FROM thing
WHERE kind = 'concept'
  AND ->part_of->thing CONTAINS thing:`vocab_domovoy_edge`
  AND ('task' IN from_kinds OR from_kinds = NONE);
```

UI рисует меню: «от задачи: `assigned_to` → actor, `depends_on` → task/service, `part_of` → …». Тот же UX, что в Anytype, но источник истины — данные.

## Кардинальность

Чаще дешевле линтом, чем на каждой записи:

```surql
-- Вещи, одолженные более чем одному party (нарушение many-to-one)
SELECT in AS item, count() AS holders FROM lent_to
GROUP BY in HAVING holders > 1;
```

Write-time проверка — только для критичных инвариантов (стоимость: подсчёт рёбер до вставки).

## Новый домен = один UPDATE, не миграция

Добавляем CRM: «сделка ссылается на контакт». В Anytype — миграция онтологии. Здесь:

```surql
UPDATE thing:`edge_about` SET from_kinds += 'order';
```

Одна запись — и домен типизирован, провалидирован, виден в автокомплите.

## Каталог ест свою собачью еду

Концепты рёбер — обычные `thing`: версионирование через `supersedes` (ужесточили `to_kinds` — старая версия для аудита), права на изменение каталога через `can_access`, `_i18n`-метки для UI, федерация вместе с данными. Отдельной «системы типов» нет.

## Чем это бьёт Anytype на его поле

| Критика | Ответ Домового |
|---|---|
| «нет типов связей» | есть — поля на концептах `vocab:domovoy_edge` |
| «непонятно, что к чему подключается» | каталог → автокомплит, как в Anytype |
| «ничто не валидирует связи» | `enforce=true` = schema-on-write |
| «Anytype гибче через типы» | новый тип/правило = `UPDATE` записи; у них — миграция онтологии |
| «свобода = хаос» | строгость градуируется per-edge |

## Честные границы

- **Стоимость EVENT на запись** — SELECT каталога на вставку; кэшировать (каталог меняется редко).
- **`fn::expand_kinds` ходит по иерархии** — глубина классов фиксирована (2 уровня: actor ⊃ party), кэшируемо.
- **Гонки кардинальности** EVENT-проверкой не ловятся полностью — уникальный индекс либо линт-сверка.
- **Включение `enforce=true` на живых данных** — сначала линт, чистка, потом блокировка.

## Практические инварианты

- Тип связи — **поля на концепте ребра** в `vocab:domovoy_edge`; отдельного kind для этого нет.
- `from_kinds`/`to_kinds`: слаги kind или классов (`party`, `actor`); `NONE` = любой.
- Мета-классы — концепты с `is_class=true`; в поле `kind` узлов не попадают.
- `filed_with` — единственное субъектное ребро, суженное до `org`; это фича.
- Уведомления party-получателю — через `participant {role:'contact'}`, fallback — члены группы.
- Логика — в `fn::check_edge`; на ребре — тонкая обёртка-EVENT; новый домен = `UPDATE` каталога.
- Перед включением `enforce` — линт и чистка.
