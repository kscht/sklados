# Структура базы данных (SurrealDB)

> ⚠️ **Статус: поколение 1 — справочник сценариев в исходной нотации.**
> Документ описывает домены с кириллическими `kind` и до-SKOS-ными конструкциями — так, как они проектировались до аудита. Действующий канон:
> - `kind` и словари — [`kind-audit.md`](kind-audit.md) (кириллические `kind` отсюда в код не копировать);
> - UI-модель — [`ui-architecture.md`](ui-architecture.md); разделы «UI-слой» и «Дашборды, виджеты и отчёты» ниже — предшествующий слой (см. [`decisions.md`](decisions.md), D-34);
> - каталог рёбер — SKOS `vocab:domovoy_edge` (D-35);
> - открытые вопросы — [`decisions.md`](decisions.md); расхождения — [`docs-audit.md`](docs-audit.md).
>
> Разделы приводятся к канону по мере реализации доменов, не оптом.

## Концепция

Всё есть **вещь** (`thing`). Гараж, полка, мотоцикл, масло, рецепт, магазин, человек, семья,
задача, подзадача, платёж, обращение, инстанция — один тип узла.
Смысл задаётся только рёбрами (связями) между вещами.

---

## Узлы

| Таблица | Примеры |
|---------|---------|
| `thing` | предмет, место, контейнер, транспорт, человек, группа, задача, подзадача, рецепт, процедура, запуск, список, платёж, обращение, решение, инстанция |

Типичные поля по смыслу:

| Смысл | Поля |
|-------|------|
| Любая вещь | `name`, `description`, `notes` |
| Физический предмет | `quantity`, `unit`, `purchase_date`, `price` |
| Задача / обращение | `status`, `deadline`, `priority`, `original_deadline`, `postponed_count` |
| Периодическая задача / платёж | `period`, `schedule`, `amount`, `due_day`, `paid_until` |
| Напоминание | `deadline`, `repeat` |
| Человек | `role` (папа, мама, сын, дочь, бабушка) |
| Физическая/цифровая вещь | `kind` (физическое / цифровое / смешанное) |
| Сообщение | `text`, `created_at` |
| Событие / мероприятие | `date`, `duration` |
| Шаблон | `template` (true/false) |

**`status` задачи:** `не начато` / `в процессе` / `выполнено` / `ожидает` / `на паузе` / `отменено`  
**`status` обещания:** `ожидается` / `выполнено` / `нарушено`  
**`status` заказа:** `оформлен` / `в пути` / `на таможне` / `получено` / `не доставлено` / `возврат`

---

## Темпоральная природа узлов

Все узлы — `thing`, но у них разная природа во времени:

| Природа | Признак | Пример |
|---------|---------|--------|
| **Шаблон** | `template: true` | Процедура ТО, рецепт, план опыта |
| **План** | `template: false` + `status: не начато` + будущий `deadline` | Запланированное ТО в июне |
| **Текущее** | `status: в процессе` | ТО которое делается прямо сейчас |
| **Исторический факт** | `status: выполнено` + дата в прошлом | ТО от апреля 2026 |

Шаблоны хранятся в корневом контейнере `thing:templates` через `part_of`.
Запуски (экземпляры) — `part_of` своего шаблона.

```mermaid
graph TD
    Templates[Шаблоны\nкорневой контейнер]

    T1[Процедура ТО\ntemplate: true]
    T2[Рецепт блинов\ntemplate: true]
    T3[Опыт с кристаллами\ntemplate: true]

    R1[ТО апрель 2026\nstatus: выполнено]
    R2[ТО июнь 2026\nstatus: не начато\ndeadline: 1 июня]
    R3[Готовка 17 мая\nstatus: выполнено]
    R4[Опыт 12 мая\nstatus: в процессе]

    T1 -->|part_of| Templates
    T2 -->|part_of| Templates
    T3 -->|part_of| Templates

    R1 -->|part_of| T1
    R2 -->|part_of| T1
    R3 -->|part_of| T2
    R4 -->|part_of| T3
```

```surql
-- Все шаблоны
SELECT * FROM thing WHERE template = true;

-- Шаблоны в корневом контейнере
SELECT <-part_of<-thing FROM thing:templates;

-- Все запуски конкретного шаблона (история + планы)
SELECT <-part_of<-thing[WHERE template != true].* FROM thing:template_oil_service;

-- Только история (факты)
SELECT <-part_of<-thing[WHERE status = "выполнено"].* FROM thing:template_oil_service;

-- Только планы
SELECT <-part_of<-thing[WHERE status = "не начато"].* FROM thing:template_oil_service;

-- Что сейчас в процессе (не шаблоны)
SELECT * FROM thing WHERE status = "в процессе" AND template != true;
```  
**`period`:** `ежедневно` / `еженедельно` / `ежемесячно` / `ежеквартально` / `ежегодно`  
**`schedule`:** произвольная строка — `каждую пятницу`, `1-е число месяца`, `каждые 10000 км`

---

## Рёбра

| Связь | Описание | Поля на ребре |
|-------|----------|---------------|
| `contains` | Где физически находится вещь | `reason`, `since` |
| `part_of` | Часть чего / подзадача / запуск шаблона / членство в группе | `until` |
| `assigned_to` | Кто отвечает (человек, группа или вся семья) | — |
| `depends_on` | Задача ждёт выполнения другой | — |
| `about` | Задача/обращение касается этой вещи или решения | — |
| `filed_with` | Обращение подано в эту инстанцию/организацию | — |
| `needs` | Что нужно купить (список → вещь) | `quantity`, `unit` |
| `requires` | Плановый расход (шаблон → ингредиент/деталь) | `quantity`, `unit` |
| `produces` | Результат выполнения (решение, документ, блюдо) | — |
| `used` | Фактический расход при запуске | `quantity`, `unit` |
| `participant` | Участник с ролью (организатор, посредник, информирован…) | `role` |
| `located_at` | Где происходит событие или мероприятие | — |
| `lent_to` | Вещь отдана этому человеку во временное пользование | `since` |
| `borrowed_from` | Вещь взята у этого человека | `since` |
| `triggered_by` | Задача активируется при встрече с местом/человеком | — |
| `expert_in` | Человек — эксперт в этой теме/области | — |
| `answered` | Попытка → вопрос с результатом ответа | `chosen`, `correct`, `points_earned` |
| `promised_to` | Кому дано обещание | — |
| `represents` | Цифровая копия → физический оригинал | — |
| `can_access` | Кто имеет доступ к цифровой вещи | — |
| `related_to` | Произвольная связь с меткой | `label` |
| `references` | Блок ссылается на другой блок с режимом включения | `mode`, `snapshot_text`, `snapshot_at` |
| `identified_by` | Вещь идентифицируется этим кодом / маркировкой | `printed_at` |

**`reason` на ребре `contains`:** `хранение` / `транспорт` / `ремонт` / `покупка`  
**`until` на ребре `part_of`:** дата окончания временного членства; если отсутствует — постоянно  
**`role` на ребре `participant`:** `исполнитель` / `организатор` / `посредник` / `обещавший` / `информирован` / `свидетель` / `заказчик`  
**`mode` на ребре `references`:** `live` — живая трансклюзия / `snapshot` — заморожено / `link` — ссылка для навигации  
**`printed_at` на ребре `identified_by`:** дата когда физическая наклейка была распечатана и наклеена; если отсутствует — код известен, но наклейка не печаталась

---

## Люди и группы

```mermaid
graph TD
    Family[Семья]
    Dad[Папа]
    Mom[Мама]
    Son[Сын]
    Daughter[Дочь]
    Grandma[Бабушка]

    Dad -->|part_of| Family
    Mom -->|part_of| Family
    Son -->|part_of| Family
    Daughter -->|part_of| Family
    Grandma -->|part_of| Family
```

- `assigned_to` → конкретный человек: личная ответственность
- `assigned_to` → несколько людей: совместная
- `assigned_to` → Семья: открытая задача, берёт кто свободен

---

## Физическое и цифровое

Физическая вещь отвечает на вопрос **где находится** → `contains`.  
Цифровая вещь отвечает на вопрос **кто имеет доступ** → `can_access`.  
Связь между ними — `represents`.

Поле `kind`: `физическое` / `цифровое` / `смешанное`.

```mermaid
graph TD
    Drawer[Ящик стола]
    CD[CD-диск со снимками\nkind: физическое]
    DocPhysical[Направление от врача\nkind: физическое]

    XrayFiles[Снимки рентгена\nkind: цифровое]
    DocScan[Скан направления\nkind: цифровое]

    ShareDoctor[Подборка для Петрова]
    Doctor[Доктор Петров]

    CD -->|contains| Drawer
    DocPhysical -->|contains| Drawer

    XrayFiles -->|represents| CD
    DocScan -->|represents| DocPhysical

    XrayFiles -->|part_of| ShareDoctor
    DocScan -->|part_of| ShareDoctor
    Doctor -->|can_access| ShareDoctor
```

- Диск физически лежит в ящике, врач его не трогает
- Врач получает `can_access` только к цифровым копиям
- Один физический оригинал может иметь несколько цифровых представлений (скан, фото, PDF)

---

## Доступ и шаринг

> Как эта модель ложится на пользователей и `PERMISSIONS` SurrealDB — см. [`access-control.md`](access-control.md).

`can_access` — прямое ребро от субъекта к ресурсу. Два правила против рекурсии:

1. **Нет каскада по рёбрам** — доступ к контейнеру не наследуется дочерними узлами автоматически. Доступ к `thing:share_legal` даёт доступ только к нему; содержимое (`part_of`) проверяется отдельным запросом.
2. **Одно звено через группу** — если субъект `part_of` группы, а группа `can_access` ресурсу — это максимальная глубина. Дальнейший обход не ведётся.

### Поля ребра can_access

```
can_access
  permissions:            ["view"]          ← множество прав
  status:                 active            ← active | pending | revoked
  granted_by:             thing:son         ← кто инициировал
  requires_approval_from: thing:admins      ← группа, любой член которой может подтвердить
  approved_by:            thing:dad         ← конкретный член группы кто подтвердил
  approved_at:            datetime
  expires_at:             datetime | null   ← временный доступ
  reason:                 string | null     ← причина выдачи
```

Уровни прав (`permissions`):

| Право | Смысл |
|-------|-------|
| `view` | читать узел и его поля |
| `edit` | изменять поля, добавлять дочерние узлы |
| `delete` | удалять узел |
| `run` | выполнять код / пайплайн / триггер |
| `share` | выдавать доступ другим (не выше своего уровня) |
| `manage` | менять права (владелец) |

### Группа подтверждающих

`requires_approval_from` — это `thing`-узел группы. Подтвердить может **любой** её член.
`approved_by` фиксирует кто именно подтвердил.

```
thing:family_admins
  name: "Семейные администраторы"
  ← part_of ← thing:dad
  ← part_of ← thing:mom
```

```mermaid
graph TD
    Son[Сын]
    Friend[Друг Коля]
    Dad[Папа]
    Mom[Мама]
    Admins[Семейные администраторы]
    Vault[Семейный vault]
    Share[Подборка для Коли]

    Dad -->|part_of| Admins
    Mom -->|part_of| Admins

    Son -->|"can_access\nstatus: pending\ngranted_by: Сын\nrequires_approval_from: Admins"| Share
    Friend -.->|"ждёт подтверждения"| Share
    Share -->|part_of| Vault
    Dad -->|"approved_by → active"| Son
```

Пока `status: pending` — Коля доступа не имеет.
Папа или Мама видит задачу-уведомление и подтверждает → `status: active`, `approved_by: dad`.

### Запрос: разрешение доступа

```surql
-- Есть ли у person:x право edit на thing:resource?
-- Прямой доступ + доступ через группу (одно звено, не глубже)
SELECT permissions, status, expires_at FROM can_access
WHERE out = thing:resource
  AND in INSIDE [
    thing:person_x,
    ...(SELECT out FROM part_of WHERE in = thing:person_x)
  ]
  AND "edit" INSIDE permissions
  AND status = "active"
  AND (expires_at = NONE OR expires_at > time::now());

-- Все pending-запросы, которые может подтвердить person:dad
SELECT in.name AS кто_дал, out.name AS ресурс,
       permissions, reason,
       requires_approval_from.name AS группа
FROM can_access
WHERE status = "pending"
  AND requires_approval_from IN (
    SELECT out FROM part_of WHERE in = thing:dad
  );

-- Аудит: кто, кому, что и когда дал доступ
SELECT granted_by.name AS инициатор,
       in.name AS субъект,
       out.name AS ресурс,
       permissions, status,
       approved_by.name AS подтвердил,
       approved_at, expires_at
FROM can_access
ORDER BY approved_at DESC;
```

### Автоматическое уведомление при pending

```surql
DEFINE EVENT notify_approvers ON TABLE can_access
  WHEN $event = "CREATE" AND $value.status = "pending"
  THEN {
    CREATE thing SET
      kind        = "задача",
      name        = "Подтвердить выдачу доступа",
      status      = "не начато",
      priority    = "высокий",
      created_at  = time::now()
    ;
    RELATE $last->assigned_to->$value.requires_approval_from;
    RELATE $last->about->$after.id;
  };
```

### Пример: доступ к документам

```mermaid
graph TD
    Alexey[Алексей\nюрпомощник]
    Doctor[Доктор Петров]
    Mom[Мама]
    Dad[Папа]
    Admins[Администраторы\nМама + Папа]

    ShareLegal[Подборка для Алексея]
    ShareMed[Снимки для Петрова]
    PersonalMom[Личные задачи мамы]

    Case1[Дело о заборе] -->|part_of| ShareLegal
    Case3[Дело о земле]  -->|part_of| ShareLegal
    Xray[Снимки рентгена] -->|part_of| ShareMed
    Mri[МРТ колена]       -->|part_of| ShareMed

    Alexey -->|"can_access [view]\ngranted_by: Папа\nstatus: active"| ShareLegal
    Doctor -->|"can_access [view]\nrequires_approval_from: Admins\nstatus: pending"| ShareMed
    Mom    -->|"can_access [manage]"| PersonalMom
    Dad    -->|"can_access [view, edit]"| ShareLegal
```

**Шаблон доступа** — заранее созданный контейнер с типовым набором.
Врачу выдаётся `can_access` к контейнеру с нужными копиями — и ничего лишнего.

---

## Сценарий: планирование мероприятий

Мероприятие — `thing` с датой. Место через `located_at`, участники через `participant`,
ресурсы через `requires`, подзадачи через `part_of`. Нехватка ресурсов → список покупок.

```mermaid
graph TD
    Party[День рождения сына\ndate: 15 июня\nstatus: не начато]
    Venue[Парк Горького]
    Dad[Папа]
    Son[Сын]
    Alex[Алексей]
    Misha[Михаил]

    Cake[Торт\nquantity: 0шт]
    Balloons[Шарики\nquantity: 3шт]
    ShoppingList[Список покупок]

    T1[Отправить приглашения\ndeadline: 1 июня]
    T2[Заказать торт\ndeadline: 10 июня]
    T3[Украсить место\ndeadline: 15 июня]

    Party -->|located_at| Venue
    Party -->|assigned_to| Dad
    Party -->|participant, role: именинник| Son
    Party -->|participant, role: гость| Alex
    Party -->|participant, role: гость| Misha
    Party -->|requires qty:1| Cake
    Party -->|requires qty:20| Balloons

    Cake -->|quantity=0, нужно купить| ShoppingList
    ShoppingList -->|needs qty:1| Cake
    ShoppingList -->|needs qty:17| Balloons

    T1 -->|part_of| Party
    T2 -->|part_of| Party
    T3 -->|part_of| Party
    T2 -->|about| Cake
```

---

## Сценарий: журналистика и описание событий

Событие — `thing` с датой и местом. Статья/репортаж `about` событие, `produces` публикацию.
Источники — через `related_to, label: "источник"`. Свидетели — через `participant`.

```mermaid
graph TD
    Event[Событие: пожар на заводе\ndate: 12 мая 14:30]
    Factory[Завод №5\nул. Промышленная 7]
    Journalist[Журналист Петров]
    Witness[Свидетель Иванов]
    Photo[Фотографии с места\nkind: цифровое]
    FireReport[Официальный отчёт МЧС\nkind: цифровое]

    Draft[Черновик репортажа]
    Article[Репортаж: пожар на заводе\nопубликован: 13 мая]

    Event -->|located_at| Factory
    Event -->|participant, role: свидетель| Witness

    Draft -->|about| Event
    Draft -->|assigned_to| Journalist
    Draft -->|participant, role: свидетель| Witness
    Draft -->|related_to, label: источник| Photo
    Draft -->|related_to, label: источник| FireReport
    Draft -->|produces| Article

    Photo -->|about| Event
    FireReport -->|about| Event
```

**Журналистский цикл:**
```mermaid
graph LR
    A[Событие происходит] -->|produces| B[Полевые заметки / фото]
    B -->|about| C[Черновик]
    C -->|produces| D[Опубликованная статья]
    D -->|about| E[Следующее событие\nреакция, расследование]
    E -->|about| C2[Новый черновик...]
```

```surql
-- Все события в определённом месте
SELECT <-located_at<-thing.* FROM thing:factory_5;

-- Все материалы по событию (статьи, фото, заметки)
SELECT <-about<-thing.* FROM thing:event_fire_may12;

-- Участники мероприятия с их ролями
SELECT ->participant->thing.name AS person, ->participant.role AS role
FROM thing:party_birthday;

-- Что нужно купить для мероприятия
SELECT ->requires->thing.name AS item,
       ->requires.quantity AS нужно,
       ->requires->thing.quantity AS есть
FROM thing:party_birthday
WHERE ->requires->thing.quantity < ->requires.quantity;

-- Ближайшие мероприятия
SELECT * FROM thing WHERE date > time::now()
  AND date < time::now() + 30d
  AND ->located_at->thing != NONE
  ORDER BY date ASC;
```

---

## Сценарий: роли участников и временные группы

Врач — самостоятельная вещь со своими контактами. Постоянно `part_of` больница.
Временное участие в задаче — через `participant` напрямую или через временную группу.

```mermaid
graph TD
    Doctor[Врач Смирнов\nтел: +7-900-...\nспециализация: кардиолог]
    Hospital[Городская больница №3]
    Duty[Дежурный Петрова]
    Friend[Товарищ Алексей]
    Dad[Папа]

    Promise[Обещание: записать на приём\ndeadline: 21 мая\nstatus: ожидается]
    Task[Запись на приём к кардиологу\ndeadline: до 1 июля\nstatus: ожидает]

    Doctor -->|part_of, постоянно| Hospital
    Duty -->|part_of, постоянно| Hospital

    Promise -->|assigned_to| Duty
    Promise -->|promised_to| Dad
    Promise -->|participant, role: посредник| Friend
    Promise -->|produces| Task

    Task -->|assigned_to| Doctor
    Task -->|participant, role: посредник| Friend
    Task -->|participant, role: информирован| Dad
```

**Постоянное vs временное членство через `part_of`:**

| Ситуация | Ребро |
|----------|-------|
| Смирнов работает в больнице | `part_of` без `until` |
| Смирнов в рабочей группе по делу | `part_of, until: 1 июня` |
| Алексей помогает с юрделами | `participant, role: посредник` на конкретной задаче |

**Временная группа** нужна только когда один набор людей участвует сразу в нескольких
связанных задачах. Для одной задачи — проще `participant` напрямую.

```surql
-- Все задачи где участвует врач Смирнов (в любой роли)
SELECT <-assigned_to<-thing.*, <-participant<-thing.*
FROM thing:doctor_smirnov;

-- Контакты всех участников задачи
SELECT ->assigned_to->thing.name, ->assigned_to->thing.phone,
       ->participant->thing.name, ->participant->thing.phone
FROM thing:task_appointment;

-- Временные членства которые скоро истекают
SELECT * FROM part_of WHERE until < time::now() + 7d;
```

---

## Сценарий: обсуждения

Сообщение — `thing` с полем `text` и `created_at`. Привязывается к любой вещи через `about`.
Автор — через `assigned_to`. Из сообщения через `produces` может вырасти задача или обещание.

```mermaid
graph TD
    Task[Задача: ТО мотоцикла]

    M1[Сообщение: надо купить фильтр\ncreated_at: 15 мая 10:00\nassigned_to: Папа]
    M2[Сообщение: я куплю в субботу\ncreated_at: 15 мая 10:05\nassigned_to: Мама]
    M3[Сообщение: договорились 👍\ncreated_at: 15 мая 10:06\nassigned_to: Папа]

    Promise[Обещание: куплю фильтр в субботу\ndeadline: 17 мая\nstatus: ожидается]

    M1 -->|about| Task
    M2 -->|about| Task
    M3 -->|about| Task
    M2 -->|produces| Promise
    Promise -->|assigned_to| Mom[Мама]
    Promise -->|promised_to| Dad[Папа]
```

Обсуждение — просто поток сообщений `about` одной вещи, упорядоченных по `created_at`.
Отдельного контейнера не нужно.

---

## Сценарий: обещания и каскад

Обещание — `thing` с дедлайном и статусом. Когда выполняется — `produces` порождает
задачи, покупки, другие обещания. Дедлайн может быть через год.

```mermaid
graph TD
    Dad[Папа]
    Son[Сын]
    Doctor[Доктор Петров]
    Alex[Алексей]

    P1[Обещание: куплю велосипед к лету\ndeadline: 1 июня\nstatus: ожидается]
    P2[Обещание: направлю на МРТ\ndeadline: через 2 недели\nstatus: выполнено]
    P3[Обещание: помогу с забором в мае\ndeadline: 31 мая\nstatus: нарушено]

    T1[Задача: выбрать велосипед]
    T2[Задача: купить велосипед]
    L1[Список: велосипед + шлем + замок]

    P1 -->|assigned_to| Dad
    P1 -->|promised_to| Son
    P1 -->|produces| T1
    P1 -->|produces| T2
    T1 -->|produces| L1

    P2 -->|assigned_to| Doctor
    P2 -->|promised_to| Dad

    P3 -->|assigned_to| Alex
    P3 -->|promised_to| Dad
```

**Нарушенное обещание** (`status: нарушено`) не исчезает — остаётся в графе как факт,
на него можно ссылаться в новых обсуждениях или обращениях.

```surql
-- Все обещания данные нам (promised_to: папа), ещё не выполненные
SELECT * FROM thing WHERE ->promised_to->thing = thing:dad
  AND status = "ожидается";

-- Просроченные обещания
SELECT * FROM thing WHERE status = "ожидается"
  AND deadline < time::now()
  AND ->promised_to->thing != NONE;

-- Обсуждение под задачей (все сообщения, по времени)
SELECT * FROM thing WHERE ->about->thing = thing:task_motorcycle_service
  AND text != NONE
  ORDER BY created_at ASC;

-- Что выросло из обещания (каскад)
SELECT ->produces->thing.* FROM thing:promise_bicycle DEPTH 5;

-- Нарушенные обещания от конкретного человека
SELECT * FROM thing WHERE ->assigned_to->thing = thing:alex
  AND status = "нарушено";
```

---

## Сценарий: периодические задачи и напоминания

Периодическая задача — шаблон с расписанием. Каждое выполнение — `run` через `part_of`.
Напоминание — отдельный `thing` с `about` на конкретный запуск.

```mermaid
graph TD
    Template[Шаблон: долить воду в бочку\nperiod: еженедельно\nschedule: каждую пятницу]

    Run1[Запуск: 16 мая\nstatus: выполнено]
    Run2[Запуск: 23 мая\ndeadline: 23 мая\nstatus: не начато]

    R1[Напоминание: чт 22 мая 9:00\nassigned_to: Семья]
    R2[Напоминание: пт 23 мая 12:00\nassigned_to: Семья]

    Run1 -->|part_of| Template
    Run2 -->|part_of| Template
    R1 -->|about| Run2
    R2 -->|about| Run2
```

На одну задачу — сколько угодно напоминаний, каждому своё (`assigned_to`), в любое время.

### Поля шаблона периодической задачи

```yaml
kind: задача
template: true                        # это шаблон, не конкретный экземпляр
period: еженедельно                   # ежедневно | еженедельно | ежемесячно | ежеквартально | ежегодно | счётчик
schedule: "каждую пятницу"            # человекочитаемое описание
cron: "0 9 * * FRI"                  # машиночитаемое для time-based расписаний
trigger_field: ~                      # для счётчиков: "odometer_km"
trigger_threshold: ~                  # для счётчиков: 10000
trigger_source: thing:moto_bmw        # узел, у которого читается поле
next_run_at: "2026-05-23T09:00:00Z"  # когда создать следующий run (планировщик читает это поле)
last_run_at: "2026-05-16T09:00:00Z"  # когда был последний run
enabled: true
```

Два типа расписания — **time-based** (cron) и **counter-based** (счётчик/показание):

| Тип | Поля | Пример |
|-----|------|--------|
| Time-based | `cron`, `next_run_at` | «каждую пятницу», «1-е число месяца» |
| Counter-based | `trigger_field`, `trigger_threshold`, `trigger_source` | «каждые 10 000 км» |

### Планировщик: как создаётся следующий run

Воркер-планировщик (`kind: воркер`, subtype: `scheduler`) просыпается каждую минуту
и делает один атомарный запрос:

```surql
-- Найти все шаблоны, у которых next_run_at наступило
SELECT id, cron, period, assigned_to, name, trigger_field, trigger_source, trigger_threshold
FROM thing
WHERE template = true
  AND enabled  = true
  AND period  != "счётчик"
  AND next_run_at <= time::now();
```

Для каждого найденного шаблона воркер:

1. Создаёт `run` — новый экземпляр задачи:

```surql
CREATE thing SET
  kind       = "задача",
  name       = string::concat($template.name, " — ", time::format(time::now(), "%d.%m.%Y")),
  status     = "не начато",
  template   = false,
  deadline   = <следующий срок по cron>,
  created_at = time::now();

RELATE $new_run->part_of->$template_id;

-- скопировать assigned_to если есть
IF $template.assigned_to != NONE {
  RELATE $new_run->assigned_to->$template.assigned_to;
};
```

2. Обновляет `next_run_at` на следующее срабатывание:

```surql
UPDATE $template_id SET
  last_run_at = time::now(),
  next_run_at = <вычислить по cron>;
```

Вычисление следующего `next_run_at` — стандартная cron-библиотека на стороне воркера
(например, `croner` для Node.js или `croniter` для Python).

### Counter-based расписание (пробег, показания счётчика)

Для «каждые 10 000 км» триггер — не время, а значение поля у другого узла:

```yaml
# шаблон ТО мотоцикла
kind: задача
template: true
period: счётчик
trigger_source: thing:moto_bmw      # у этого узла читаем поле
trigger_field: odometer_km          # какое поле
trigger_threshold: 10000            # порог изменения
last_trigger_value: 43200           # значение при последнем создании run
enabled: true
```

Планировщик для counter-based шаблонов:

```surql
-- Найти счётчики, у которых текущее значение превысило порог
SELECT
  t.id AS template_id,
  t.trigger_field,
  t.trigger_threshold,
  t.last_trigger_value,
  s.*[t.trigger_field] AS current_value
FROM thing AS t, thing AS s
WHERE t.template = true
  AND t.enabled  = true
  AND t.period   = "счётчик"
  AND t.trigger_source = s.id
  AND (s.*[t.trigger_field] - t.last_trigger_value) >= t.trigger_threshold;
```

При срабатывании — создаётся `run` и обновляется `last_trigger_value`:

```surql
UPDATE $template_id SET last_trigger_value = $current_value;
```

### Диаграмма: жизненный цикл периодической задачи

```mermaid
graph TD
    Tmpl["Шаблон\nperiod: еженедельно\ncron: 0 9 * * FRI\nnext_run_at: 23 мая 09:00"]
    Sched["Планировщик\n(воркер, каждую минуту)"]
    Run1["Run: 16 мая\nstatus: выполнено"]
    Run2["Run: 23 мая\nstatus: не начато"]
    Rem["Напоминание\n22 мая 09:00"]

    Sched -->|next_run_at наступило| Tmpl
    Sched -->|CREATE| Run2
    Sched -->|UPDATE next_run_at → 30 мая| Tmpl
    Run1 -->|part_of| Tmpl
    Run2 -->|part_of| Tmpl
    Rem  -->|about| Run2
```

### Пропущенные запуски

Если планировщик был офлайн и пропустил несколько срабатываний —
создаётся только **один** `run` (последний), а не все пропущенные.
Поле `missed_runs_count` на шаблоне фиксирует количество пропусков для аудита:

```surql
UPDATE $template_id SET
  missed_runs_count = missed_runs_count + $skipped,
  next_run_at       = <ближайшее будущее срабатывание по cron>;
```

---

## Перенос, пауза, история

```mermaid
graph LR
    A[не начато] --> B[в процессе]
    B --> C[на паузе]
    C --> B
    B --> D[выполнено]
    A -->|перенесено\ndeadline обновляется\npostponed_count ++| A
    B -->|перенесено| B
    B --> E[отменено]
    A --> E
```

**Перенос задачи:**
- `deadline` обновляется на новую дату
- `original_deadline` сохраняет изначальный срок
- `postponed_count` увеличивается на 1
- Напоминания пересоздаются с новыми датами

**Пауза:**
- `status: на паузе` — задача видна, но не давит дедлайном
- Используется когда задача заблокирована внешними обстоятельствами,
  но `depends_on` формально не выражает причину

**Примеры расписаний:**

| Задача | `period` | `schedule` |
|--------|----------|------------|
| Долить воду в бочку | еженедельно | каждую пятницу |
| Оплатить электричество | ежемесячно | до 10-го числа |
| ТО мотоцикла | — | каждые 10000 км / раз в год |
| Проверить аптечку | ежеквартально | 1-е число квартала |
| Забрать ребёнка из секции | еженедельно | вт, чт 18:00 |

---

## Сценарий: периодические платежи

Каждый периодический платёж — шаблон (`thing`) с расписанием.
Каждая оплата — запуск (`run`), `part_of` шаблона.

```mermaid
graph TD
    Dad[Папа]
    Apartment[Квартира]

    Electric[Шаблон: электричество\nperiod: ежемесячно\namount: ~3500р\ndue_day: 10]
    Water[Шаблон: вода\nperiod: ежемесячно\namount: ~1800р\ndue_day: 10]
    Internet[Шаблон: интернет\nperiod: ежемесячно\namount: 600р\ndue_day: 25]
    HOA[Шаблон: УК / кап. ремонт\nperiod: ежемесячно\namount: ~4200р\ndue_day: 20]

    RunElectric[Оплата электричества\nмай 2026\nstatus: выполнено]
    RunWater[Оплата воды\nмай 2026\nstatus: не начато]

    Electric -->|assigned_to| Dad
    Electric -->|about| Apartment
    Water -->|assigned_to| Dad
    Water -->|about| Apartment
    Internet -->|assigned_to| Dad
    HOA -->|assigned_to| Dad
    HOA -->|about| Apartment

    RunElectric -->|part_of| Electric
    RunWater -->|part_of| Water
```

Просроченные платежи — обычный запрос: `paid_until < сегодня`.

---

## Сценарий: юридические обращения

Цепочка обжалований строится через `about` (это обращение обжалует то решение)
и `filed_with` (подано в эту инстанцию).

```mermaid
graph TD
    Dad[Папа]
    Subject[Предмет спора\nнапр. земельный участок]

    LocalAuth[Районная администрация]
    RegionalAuth[Областная администрация]
    Court[Суд первой инстанции]
    AppCourt[Апелляционный суд]

    Case1[Обращение №1\ndeadline: 15 июня\nstatus: выполнено]
    Decision1[Отказ от 20 июня]

    Case2[Обжалование №1\ndeadline: 20 июля\nstatus: выполнено]
    Decision2[Частичный отказ от 5 авг]

    Case3[Исковое заявление\ndeadline: 1 окт\nstatus: в процессе]
    Decision3[Решение суда]

    Case4[Апелляция\nstatus: не начато]

    Case1 -->|assigned_to| Dad
    Case1 -->|about| Subject
    Case1 -->|filed_with| LocalAuth
    Case1 -->|produces| Decision1

    Case2 -->|assigned_to| Dad
    Case2 -->|about| Decision1
    Case2 -->|filed_with| RegionalAuth
    Case2 -->|produces| Decision2

    Case3 -->|assigned_to| Dad
    Case3 -->|about| Decision2
    Case3 -->|filed_with| Court
    Case3 -->|produces| Decision3
    Case3 -->|depends_on| Case2

    Case4 -->|about| Decision3
    Case4 -->|filed_with| AppCourt
    Case4 -->|depends_on| Case3
```

Вся цепочка читается как путь по `about` и `produces`:  
Обращение → решение → следующее обращение → решение → ...

---

## Сценарий: подзадачи

```mermaid
graph TD
    Main[Задача: подготовить мотоцикл к сезону\nstatus: в процессе]

    T1[Купить масло и фильтры\nstatus: выполнено\nassigned_to: Папа]
    T2[Сделать ТО\nstatus: не начато\nassigned_to: Папа]
    T3[Проверить шины\nstatus: не начато\nassigned_to: Семья]
    T4[Помыть мотоцикл\nstatus: не начато\nassigned_to: Сын]

    T1 -->|part_of| Main
    T2 -->|part_of| Main
    T3 -->|part_of| Main
    T4 -->|part_of| Main
    T2 -->|depends_on| T1
```

---

## Сценарий: открытые и личные задачи

```mermaid
graph TD
    Family[Семья]
    Dad[Папа]
    Daughter[Дочь]
    Mom[Мама]

    T1[Задача: долить воду в бочку\nstatus: не начато]
    T2[Задача: убраться на кухне\nstatus: не начато]
    T3[Задача: оплатить воду\ndeadline: 10 июня\nstatus: не начато]

    T1 -->|assigned_to| Family
    T2 -->|assigned_to| Daughter
    T2 -->|assigned_to| Mom
    T3 -->|assigned_to| Dad
```

---

## Уведомления (логика приложения)

| Событие | Кто получает уведомление |
|---------|--------------------------|
| Новая задача `assigned_to` человек | Этот человек |
| Новая задача `assigned_to` Семья | Все члены семьи |
| Задача `depends_on` выполнена | Исполнитель следующей задачи |
| Дедлайн приближается (за 3 дня) | Исполнитель задачи |
| `quantity` = 0 | Все (или исполнитель задачи на покупку) |
| `paid_until` истекает | Исполнитель шаблона платежа |
| Решение по обращению получено (`produces`) | Исполнитель следующего обращения |

---

## SurrealDB: схема

```surql
DEFINE TABLE thing SCHEMALESS;

DEFINE TABLE contains TYPE RELATION FROM thing TO thing SCHEMAFULL;
DEFINE FIELD reason ON contains TYPE option<string>;
DEFINE FIELD since  ON contains TYPE option<datetime>;

DEFINE TABLE part_of TYPE RELATION FROM thing TO thing SCHEMAFULL;
DEFINE FIELD until ON part_of TYPE option<datetime>;

DEFINE TABLE participant TYPE RELATION FROM thing TO thing SCHEMAFULL;
DEFINE FIELD role ON participant TYPE string;

DEFINE TABLE located_at TYPE RELATION FROM thing TO thing;

DEFINE TABLE lent_to TYPE RELATION FROM thing TO thing SCHEMAFULL;
DEFINE FIELD since ON lent_to TYPE option<datetime>;

DEFINE TABLE borrowed_from TYPE RELATION FROM thing TO thing SCHEMAFULL;
DEFINE FIELD since ON borrowed_from TYPE option<datetime>;

DEFINE TABLE triggered_by TYPE RELATION FROM thing TO thing;

DEFINE TABLE expert_in TYPE RELATION FROM thing TO thing;

DEFINE TABLE answered TYPE RELATION FROM thing TO thing SCHEMAFULL;
DEFINE FIELD chosen        ON answered TYPE option<string>;
DEFINE FIELD correct       ON answered TYPE option<bool>;
DEFINE FIELD points_earned ON answered TYPE option<number>;
DEFINE TABLE assigned_to TYPE RELATION FROM thing TO thing;
DEFINE TABLE depends_on  TYPE RELATION FROM thing TO thing;
DEFINE TABLE about       TYPE RELATION FROM thing TO thing;
DEFINE TABLE filed_with  TYPE RELATION FROM thing TO thing;
DEFINE TABLE produces    TYPE RELATION FROM thing TO thing;

DEFINE TABLE needs TYPE RELATION FROM thing TO thing SCHEMAFULL;
DEFINE FIELD quantity ON needs TYPE option<number>;
DEFINE FIELD unit     ON needs TYPE option<string>;

DEFINE TABLE requires TYPE RELATION FROM thing TO thing SCHEMAFULL;
DEFINE FIELD quantity ON requires TYPE option<number>;
DEFINE FIELD unit     ON requires TYPE option<string>;

DEFINE TABLE used TYPE RELATION FROM thing TO thing SCHEMAFULL;
DEFINE FIELD quantity ON used TYPE option<number>;
DEFINE FIELD unit     ON used TYPE option<string>;

DEFINE TABLE represents TYPE RELATION FROM thing TO thing;

DEFINE TABLE can_access TYPE RELATION FROM thing TO thing SCHEMAFULL;
DEFINE FIELD permissions            ON can_access TYPE set<string> DEFAULT ["view"];
DEFINE FIELD status                 ON can_access TYPE string      DEFAULT "active";
DEFINE FIELD granted_by             ON can_access TYPE option<record<thing>>;
DEFINE FIELD requires_approval_from ON can_access TYPE option<record<thing>>;
DEFINE FIELD approved_by            ON can_access TYPE option<record<thing>>;
DEFINE FIELD approved_at            ON can_access TYPE option<datetime>;
DEFINE FIELD expires_at             ON can_access TYPE option<datetime>;
DEFINE FIELD reason                 ON can_access TYPE option<string>;

DEFINE TABLE related_to TYPE RELATION FROM thing TO thing SCHEMAFULL;
DEFINE FIELD label ON related_to TYPE string;

DEFINE TABLE references TYPE RELATION FROM thing TO thing SCHEMAFULL;
DEFINE FIELD mode          ON references TYPE string;
DEFINE FIELD snapshot_text ON references TYPE option<string>;
DEFINE FIELD snapshot_at   ON references TYPE option<datetime>;

DEFINE TABLE identified_by TYPE RELATION FROM thing TO thing SCHEMAFULL;
DEFINE FIELD printed_at ON identified_by TYPE option<datetime>;

DEFINE TABLE promised_to TYPE RELATION FROM thing TO thing;

-- Поле params на requires: для передачи конфигурации модулю/рантайму
DEFINE FIELD params ON requires TYPE option<object>;

-- Версионирование (см. раздел «Версии и совместимость»)
DEFINE TABLE supersedes TYPE RELATION FROM thing TO thing SCHEMALESS;

-- Декларация совместимости потребителя с версией семейства (semver-диапазон)
DEFINE FIELD constraint ON requires TYPE option<string>;

-- Инвалидация кэша / пересборки (см. раздел «Публикации»)
DEFINE TABLE invalidates TYPE RELATION FROM thing TO thing SCHEMALESS;

-- Происхождение артефактов / lineage (см. раздел «Происхождение артефактов»)
DEFINE TABLE derived_from TYPE RELATION FROM thing TO thing SCHEMALESS;
DEFINE FIELD method ON derived_from TYPE option<string>;        -- chunk|embed|thumbnail|translate|summarize|train|extract
DEFINE FIELD run    ON derived_from TYPE option<record<thing>>; -- узел kind:запуск, если трансформация была оркестрована
DEFINE FIELD at     ON derived_from TYPE option<datetime>;
```

> Рёбра `FROM thing TO thing` не ограничивают концы. Как добавить типизацию связей
> (какой `kind` каким предикатом соединяется с каким `kind`), не теряя свободы —
> через каталог-данные и градуированный enforcement — см. [relation-typing.md](relation-typing.md).

### Индексы

```surql
-- Основные фильтры по узлам
DEFINE INDEX idx_kind        ON thing FIELDS kind;
DEFINE INDEX idx_status      ON thing FIELDS status;
DEFINE INDEX idx_kind_status ON thing FIELDS kind, status;
DEFINE INDEX idx_template    ON thing FIELDS template;
DEFINE INDEX idx_language    ON thing FIELDS language;

-- Полнотекстовый поиск
DEFINE INDEX idx_name ON thing FIELDS name
  SEARCH ANALYZER ascii BM25;
DEFINE INDEX idx_text ON thing FIELDS text
  SEARCH ANALYZER ascii BM25;
DEFINE INDEX idx_description ON thing FIELDS description
  SEARCH ANALYZER ascii BM25;

-- Векторный поиск (изображения и текстовые эмбеддинги, 1536-мерный OpenAI / 768 local)
DEFINE INDEX idx_embedding ON thing FIELDS embedding
  MTREE DIMENSION 1536;

-- Очереди и задания (для оркестрации)
DEFINE INDEX idx_queue_status ON thing FIELDS kind, status, priority;
```

Единая таблица `thing` с индексами эффективна при типичном масштабе семейной системы
(десятки тысяч записей). Разбивать `thing` на отдельные таблицы по типу (`task`, `person`,
`document`) стоит только если один `kind` вырастет за ~100 000 записей.

### Зарезервированные слова и переносимость

Имена таблиц, рёбер и полей выбраны под граф-домен, а не под SQL-совместимость. Часть из них совпадает с зарезервированными словами SurrealQL и/или целевых СУБД при миграции. Принцип: **экранируем, не переименовываем** — узлы и рёбра сохраняют доменные имена, конфликт решается кавычками.

Экранирование по диалектам:

| Диалект | Кавычки |
|---------|---------|
| SurrealQL, MySQL, Cypher | бэктики `` `order` `` |
| PostgreSQL, SQLite, ANSI | двойные `"order"` |
| SQL Server | скобки `[order]` |

⚠️ **В самом SurrealQL** часть имён уже ключевые — квотировать сразу в позиции поля/проекции (в позиции ребра `->contains->` проблемы нет):

- `order` — `ORDER BY` → `` `order` `` или `["order"]`
- `value` — `SELECT VALUE` → `` `value` ``
- `contains` — оператор `CONTAINS` → квотировать как поле/таблицу при прямой выборке
- `references` — пересекается с record-references → квотировать на всякий случай

⚠️ **PostgreSQL:** квотированный идентификатор становится регистрозависимым (неквотированные складываются в lowercase). Квотировать единообразно во всех слоях, иначе `order` ≠ `"order"`.

Таблица коллизий (R = зарезервировано → нужны кавычки):

| идентификатор | где у нас | SurrealQL | PG | MySQL | SQLite | ANSI | Cypher |
|---------------|-----------|:---------:|:--:|:-----:|:------:|:----:|:------:|
| `order` | свойство порядка (блоки, шаги, навигация) | R | R | R | R | R | R |
| `references` | ребро #22 | R? | R | R | R | R | – |
| `contains` | ребро #1 | R | – | – | – | – | R |
| `constraint` | поле на `requires` | – | R | R | R | R | – |
| `value` | контакт-метод, настройка, показание | R | – | – | – | R | – |
| `condition` | триггер, шаг | – | – | R | – | R | – |
| `key` | `storage_locations` | – | – | R | R | – | – |
| `user` | терминал-сессия | – | R | – | – | R | – |
| `position` `language` `role` `date` `text` | разные поля | – | – | – | – | R / тип | – |

**Правило миграции:** при переезде в SQL/Neo4j — маппинг идентификаторов 1:1 с квотированием в целевом диалекте; имена узлов и рёбер не меняются. Эта таблица — основа миграционного слоя.

---

## SurrealQL: примеры запросов

```surql
-- Платежи которые нужно оплатить в этом месяце
SELECT * FROM thing WHERE paid_until < time::now() + 30d
  AND period != NONE;

-- Вся цепочка обжалований по делу (рекурсивно)
SELECT ->about->thing.* FROM thing:case_1 DEPTH 10;

-- Открытые задачи для любого члена семьи
SELECT * FROM thing WHERE status = "не начато"
  AND ->assigned_to->thing CONTAINS thing:family;

-- Мои задачи (личные + семейные, не выполненные)
SELECT * FROM thing WHERE status != "выполнено"
  AND (->assigned_to->thing CONTAINS thing:dad
    OR ->assigned_to->thing CONTAINS thing:family);

-- Задачи без невыполненных зависимостей (можно начать)
SELECT * FROM thing WHERE status = "не начато"
  AND ->depends_on->thing[WHERE status != "выполнено"] IS EMPTY;

-- Все документы/решения по юридическому делу
SELECT ->produces->thing.* FROM thing WHERE ->filed_with->thing != NONE;

-- Просроченные задачи и платежи
SELECT * FROM thing
  WHERE deadline < time::now() AND status NOT IN ["выполнено", "отменено"];

-- Задачи на паузе
SELECT * FROM thing WHERE status = "на паузе";

-- Напоминания на сегодня
SELECT * FROM thing WHERE deadline < time::now() + 1d
  AND ->about->thing.status NOT IN ["выполнено", "отменено"];

-- Следующий запуск периодической задачи
SELECT * FROM thing WHERE part_of = thing:template_barrel
  ORDER BY deadline DESC LIMIT 1;

-- Задачи которые переносили больше 2 раз
SELECT * FROM thing WHERE postponed_count > 2
  AND status NOT IN ["выполнено", "отменено"];
```

---

## YAML: описание схемы

```yaml
узел:
  тип: thing
  поля:
    обязательные:
      - название: текст
    необязательные:
      - описание: текст
      - количество: число
      - единица: текст
      - куплено: дата
      - цена: число
      - заметки: текст
      - шаблон: булево             # true = абстрактный шаблон; false/отсутствует = конкретный экземпляр
      - истекает: дата             # срок действия документа, подписки, страховки
      - энергия: текст             # для задач: низкая / средняя / высокая
      - стрик: число               # для привычек: выполнений подряд
      - желание: булево            # true = вишлист, ещё не куплено и не планируется
      - вопрос: текст              # текст вопроса в квизе
      - варианты: список           # варианты ответов для multiple_choice
      - ответ: текст               # правильный ответ
      - объяснение: текст          # почему именно так
      - тип_вопроса: текст         # multiple_choice / true_false / open_ended / fill_blank
      - сложность: текст           # лёгкий / средний / сложный
      - баллы: число               # результат попытки
      - макс_баллы: число          # максимум за попытку
      - тип: текст                 # для контактов: phone / email / messenger / address / website / social
      - значение: текст            # для контактов: сам номер, адрес, ник
      - платформа: текст           # для мессенджеров: Telegram / WhatsApp / Signal / ВКонтакте
      - метка: текст               # для контактов: личный / рабочий / домашний
      - предпочтительный: булево   # true = основной способ связи
      - identified: булево         # false = stub-узел, ещё не идентифицирован (ожидает фото и AI)
      - code_type: текст           # тип кода: ean13 / ean8 / qr / datamatrix / честный_знак / serial / imei / vin / isbn / rfid / custom_qr / ozon / wb / артикул
      - code_value: текст          # значение кода: "4607082660271", "X1Y2Z3..."
      - code_system: текст         # кто выдал: производитель / ozon / wb / wildberries / честный_знак / домовой
      - filename: текст            # для файловых узлов: имя файла на диске ("scan.pdf")
      - mime_type: текст           # для файловых узлов: "image/jpeg", "application/pdf"
      - size: число                # размер файла в байтах
      - width: число               # для изображений: ширина в пикселях
      - height: число              # для изображений: высота в пикселях
      - duration: число            # для аудио/видео: длительность в секундах
      - трекинг: текст             # номер отслеживания (когда один простой номер)
      - перевозчик: текст          # carrier: Почта Китая / СДЭК / DHL
      - url: текст                 # ссылка: трекинг, товар, документ, госпортал
      - статус: текст              # не начато / в процессе / выполнено / ожидает / на паузе / отменено
      - дедлайн: дата
      - изначальный_дедлайн: дата  # сохраняется при первом переносе
      - перенесено_раз: число      # сколько раз переносили
      - приоритет: текст           # низкий / средний / высокий
      - период: текст              # ежедневно / еженедельно / ежемесячно / ежеквартально / ежегодно
      - расписание: текст          # "каждую пятницу", "до 10-го числа", "каждые 10000 км"
      - повтор_напоминания: текст  # для напоминаний: "каждый день за 3 дня до"
      - роль: текст                # для людей: папа / мама / сын / дочь / бабушка
      - сумма: число               # для платежей и смет: договорная цена
      - сумма_факт: число          # итоговая стоимость после выполнения (может отличаться от сметы)
      - день_оплаты: число         # число месяца: 1–31
      - оплачено_до: дата
    дополнительные: любые

связи:
  contains:
    от: thing
    к: thing
    поля:
      - reason: текст         # хранение / транспорт / ремонт / покупка
      - since: дата
  part_of:
    описание: часть чего / подзадача / запуск шаблона / членство в группе
    от: thing
    к: thing
    поля:
      - until: дата   # если указана — временное членство; если нет — постоянное
  assigned_to:
    описание: кто отвечает (человек, несколько людей или вся семья)
    от: thing
    к: thing
  depends_on:
    описание: задача ждёт выполнения другой
    от: thing
    к: thing
  about:
    описание: задача/обращение касается этой вещи или обжалует это решение
    от: thing
    к: thing
  filed_with:
    описание: обращение подано в эту инстанцию/организацию
    от: thing
    к: thing
  needs:
    описание: нужно купить
    от: thing
    к: thing
    поля:
      - quantity: число
      - unit: текст
  requires:
    описание: плановый расход (шаблон → ингредиент/деталь)
    от: thing
    к: thing
    поля:
      - quantity: число
      - unit: текст
  produces:
    описание: результат выполнения (решение, документ, блюдо, изделие)
    от: thing
    к: thing
  used:
    описание: фактический расход при запуске
    от: thing
    к: thing
    поля:
      - quantity: число
      - unit: текст
  located_at:
    описание: где происходит событие или мероприятие
    от: thing
    к: thing

  lent_to:
    описание: вещь отдана этому человеку во временное пользование
    от: thing   # вещь
    к: thing    # человек
    поля:
      - since: дата

  borrowed_from:
    описание: вещь взята у этого человека
    от: thing   # вещь
    к: thing    # владелец
    поля:
      - since: дата

  triggered_by:
    описание: задача активируется при встрече с местом, человеком или ситуацией
    от: thing   # задача
    к: thing    # место / человек / событие

  expert_in:
    описание: человек является экспертом в этой теме или области
    от: thing   # человек
    к: thing    # область / тема / навык

  answered:
    описание: попытка → вопрос с результатом ответа
    от: thing   # попытка (attempt)
    к: thing    # вопрос (question)
    поля:
      - chosen: текст         # что выбрал/написал ученик
      - correct: булево       # правильно или нет
      - points_earned: число  # баллы за этот вопрос

  participant:
    описание: участник с конкретной ролью (не основной ответственный)
    от: thing   # задача, обещание, событие
    к: thing    # человек или группа
    поля:
      - role: текст   # исполнитель / организатор / посредник / обещавший / информирован / свидетель

  promised_to:
    описание: кому дано обещание
    от: thing   # обещание
    к: thing    # человек или группа

  represents:
    описание: цифровая копия → физический оригинал
    от: thing   # цифровое
    к: thing    # физическое

  can_access:
    описание: кто имеет доступ к цифровой вещи или контейнеру
    от: thing   # человек или группа
    к: thing    # цифровая вещь или контейнер

  related_to:
    описание: произвольная связь
    от: thing
    к: thing
    поля:
      - label: текст

  references:
    описание: блок ссылается на другой блок с тремя режимами поведения
    от: thing   # блок-источник (в документе)
    к: thing    # блок-цель (любой thing с text)
    поля:
      - mode: текст           # live / snapshot / link
      - snapshot_text: текст  # для mode=snapshot: замороженный текст цели на момент фиксации
      - snapshot_at: дата     # когда был сделан снапшот

  identified_by:
    описание: вещь идентифицируется этим кодом или маркировкой
    от: thing   # физическая вещь
    к: thing    # код / маркировка
    поля:
      - printed_at: дата   # когда наклейка физически распечатана; null = код известен, наклейки нет
```

---

## Сценарий: жалоба с fan-out по инстанциям

Одна жалоба охватывает несколько объектов. Вышестоящая инстанция пересылает её вниз —
каждое подзадело живёт независимо, но остаётся связано с корнем через `part_of`.

```mermaid
graph TD
    Root[Жалоба в облпрокуратуру\nstatus: выполнено]
    RegProc[Областная прокуратура]
    Notify[Уведомление о пересылке]

    Root -->|filed_with| RegProc
    Root -->|about| School1[Школа №1]
    Root -->|about| School2[Школа №2]
    Root -->|about| School10[Школа №10 ...]
    Root -->|produces| Notify

    Sub1[Дело: школа №1\nstatus: в процессе]
    Sub2[Дело: школа №2\nstatus: выполнено]
    Sub10[Дело: школа №10\nstatus: не начато]

    Sub1 -->|part_of| Root
    Sub2 -->|part_of| Root
    Sub10 -->|part_of| Root

    Sub1 -->|filed_with| Proc1[Прокуратура района 1]
    Sub1 -->|about| School1
    Sub1 -->|produces| Result1[Результат проверки №1\nнарушения выявлены]

    Sub2 -->|filed_with| Proc2[Прокуратура района 2]
    Sub2 -->|about| School2
    Sub2 -->|produces| Result2[Результат проверки №2\nнарушений не выявлено]

    Appeal2[Обжалование по школе №2\nstatus: не начато]
    Appeal2 -->|about| Result2
    Appeal2 -->|filed_with| RegProc
```

**Почему это работает без изменений схемы:**
- `part_of` связывает подзадела с корневой жалобой — всегда виден источник
- Каждое подзадело независимо: своя прокуратура (`filed_with`), свой результат (`produces`), своё обжалование (`about`)
- Fan-out естественен для графа — у одного узла может быть сколько угодно рёбер любого типа

```surql
-- Все подзадела и их статусы
SELECT name, status, ->filed_with->thing.name AS прокуратура
FROM thing WHERE ->part_of->thing = thing:root_complaint;

-- Результаты которые можно обжаловать (есть результат, нет обжалования)
SELECT * FROM thing WHERE ->part_of->thing = thing:root_complaint
  AND ->produces->thing != NONE
  AND NOT (SELECT * FROM thing WHERE ->about->thing = (->produces->thing));

-- Вся цепочка от корневой жалобы вглубь
SELECT ->part_of<-thing.* FROM thing:root_complaint DEPTH 5;
```

---

## Сценарий: медицина — приёмы, назначения, направления

Врач `part_of` больница. Приём — задача с дедлайном. Назначения и направления —
`produces` из приёма. Следующий приём `about` направление.

```mermaid
graph TD
    Patient[Папа]
    HospA[Городская поликлиника]
    HospB[Областной центр]
    Doctor[Врач Иванов]

    Visit1[Приём у Иванова\nstatus: выполнено]
    Prescription[Назначение: курс лечения]
    Referral[Направление в областной центр]

    Visit2[Приём в областном центре\ndeadline: до 1 июля\nstatus: ожидает]

    SelfReg[Записаться самим онлайн\nstatus: выполнено]
    Queue[Встать в очередь у дежурного\nstatus: выполнено]
    Callback[Ждём звонка от дежурного\ndeadline: 21 мая\nstatus: ожидает]
    Followup[Позвонить дежурному самим\ndeadline: 22 мая\nstatus: не начато]

    Doctor -->|part_of| HospA
    Visit1 -->|filed_with| HospA
    Visit1 -->|about| Doctor
    Visit1 -->|about| Patient
    Visit1 -->|produces| Prescription
    Visit1 -->|produces| Referral
    Visit1 -->|assigned_to| Patient

    Visit2 -->|about| Referral
    Visit2 -->|filed_with| HospB
    Visit2 -->|about| Patient
    Visit2 -->|assigned_to| Patient

    SelfReg -->|about| Visit2
    Queue -->|about| Visit2
    Callback -->|depends_on| Queue
    Followup -->|depends_on| Callback
```

**Таймаут на звонок:** `Followup` с дедлайном на следующий день после `Callback` —
страховка от забывчивости. Уведомление сработает когда дедлайн `Callback` истечёт
без выполнения.

**OR-логика записи:** два пути к одному приёму (самостоятельно или через дежурного) —
это поведение приложения. Когда хотя бы один путь сработал, `Visit2` помечается
подтверждённым. В схеме не формализуется.

```surql
-- Все предстоящие приёмы у врачей
SELECT * FROM thing WHERE ->filed_with->thing.name CONTAINS "больниц"
  AND deadline > time::now() AND status != "выполнено";

-- Назначения и направления из последнего приёма
SELECT ->produces->thing.* FROM thing:visit_ivanov_may;

-- Незакрытые задачи по ожиданию обратного звонка
SELECT * FROM thing WHERE name CONTAINS "звонк" AND status = "ожидает"
  AND deadline < time::now() + 1d;

-- Все приёмы конкретного пациента
SELECT <-about<-thing[WHERE ->filed_with->thing != NONE].* FROM thing:dad;
```

---

## Сценарий: сложный трекинг доставки

Трекинг-номер — отдельный `thing` с `url` и `carrier`. Когда перевозчик меняется —
новый номер `about` старый (цепочка передачи). Контрольные точки — сообщения `about`
трекинг-номер. Если заказ разбивается — каждая посылка `part_of` заказа со своим трекингом.

```mermaid
graph TD
    Order[Заказ: аккумулятор + зарядник\nstatus: в пути]
    AliExpress[AliExpress]

    Pkg1[Посылка 1: аккумулятор\nstatus: доставлено]
    Pkg2[Посылка 2: зарядник\nstatus: на таможне]

    T1[LO123456CN\ncarrier: Почта Китая\nurl: track.ali.../]
    T2[RA987654RU\ncarrier: Почта России\nurl: pochta.ru/...]
    T3[1234567890\ncarrier: СДЭК\nurl: cdek.ru/...]

    Battery[Аккумулятор\nstatus: в наличии]
    Charger[Зарядник\nstatus: ожидается]

    E1[Принято в Шанхае\ncreated_at: 1 мая 08:00]
    E2[Вылет из Шанхая\ncreated_at: 3 мая 14:00]
    E3[Прибыло в Москву\ncreated_at: 9 мая 11:00]
    E4[Передано в Почту России\ncreated_at: 9 мая 15:00]
    E5[Доставлено\ncreated_at: 12 мая]

    Order -->|filed_with| AliExpress
    Pkg1 -->|part_of| Order
    Pkg2 -->|part_of| Order

    T1 -->|part_of| Pkg1
    T2 -->|part_of| Pkg1
    T2 -->|about| T1
    T3 -->|part_of| Pkg2

    Pkg1 -->|produces| Battery
    Pkg2 -->|produces| Charger

    E1 -->|about| T1
    E2 -->|about| T1
    E3 -->|about| T1
    E4 -->|about| T2
    E5 -->|about| T2
```

`T2 about T1` — передача от Почты Китая к Почте России: цепочка смены перевозчиков.  
Контрольные точки (события) — те же сообщения `about` трекинг-номер, упорядоченные по `created_at`.

**Поле `url`** полезно не только для трекинга: ссылки на товары, документы,
страницы в госпорталах, карточки во внешних системах.

```surql
-- Полная история пути посылки по всем перевозчикам
SELECT ->about->thing.name AS трекинг,
       ->about->thing.carrier AS перевозчик,
       text AS событие, created_at
FROM thing
WHERE ->about->thing->part_of->thing = thing:package_1
ORDER BY created_at ASC;

-- Текущий активный трекинг (последний в цепочке)
SELECT * FROM thing
  WHERE ->part_of->thing = thing:package_1
  AND carrier != NONE
  AND count(<-about<-thing) = 0;

-- Незакрытые посылки и сколько задач они блокируют
SELECT name, status,
  count(<-depends_on<-thing DEPTH 5) AS блокирует_задач
FROM thing
  WHERE ->part_of->thing->filed_with->thing != NONE
  AND status NOT IN ["доставлено", "возврат"]
ORDER BY блокирует_задач DESC;
```

---

## Сценарий: блокирующая зависимость и каскад ожидания

Один товар или событие держит весь каскад задач. Заказ — `thing` с `filed_with` поставщик,
`about` товар, `produces` товар при доставке. Каскад `depends_on` товар — не заказ.
Когда товар получен — всё разблокируется за один шаг.

```mermaid
graph TD
    AliExpress[AliExpress]
    Battery[Аккумулятор 18650\nstatus: ожидается]

    Order1[Заказ №1\nstatus: не доставлено\ndeadline: 1 марта]
    Order2[Заказ №2 повторный\nstatus: в пути\ndeadline: 25 мая\ntracking: LO123456CN]

    T1[Собрать фонарик\nstatus: ожидает]
    T2[Проверить схему\nstatus: ожидает]
    T3[Провести опыт с сыном\nstatus: ожидает]
    T4[Написать отчёт\nstatus: ожидает]

    Order1 -->|filed_with| AliExpress
    Order1 -->|about| Battery
    Order2 -->|filed_with| AliExpress
    Order2 -->|about| Order1
    Order2 -->|produces| Battery

    T1 -->|depends_on| Battery
    T2 -->|depends_on| Battery
    T3 -->|depends_on| T1
    T3 -->|depends_on| T2
    T4 -->|depends_on| T3
```

`Order2 about Order1` — история: повторный заказ взамен недоставленного.

**Когда товар приходит — три действия:**
1. `Order2 status` → `получено`
2. `Battery status` → `в наличии`, добавляется `contains` → место хранения
3. Все `depends_on battery` задачи уведомляют исполнителей

```surql
-- Весь каскад заблокированный одним товаром (любая глубина)
SELECT name, status FROM thing
  WHERE ->depends_on->thing CONTAINS thing:battery
  DEPTH 10;

-- Сколько задач разблокируется
SELECT count() AS разблокируется FROM thing
  WHERE ->depends_on->thing CONTAINS thing:battery DEPTH 10;

-- История заказов одного товара
SELECT name, status, deadline, tracking FROM thing
  WHERE ->about->thing = thing:battery
  AND ->filed_with->thing != NONE
  ORDER BY created_at ASC;

-- Все товары в ожидании доставки и их каскады
SELECT name,
  count(<-depends_on<-thing DEPTH 10) AS задач_ждёт
FROM thing WHERE status = "ожидается"
  AND ->produces->thing != NONE
ORDER BY задач_ждёт DESC;
```

---

## Сценарий: обучение и тестирование

### Структура курса

Курс → разделы → темы → занятия через `part_of`. Всё это шаблоны (`template: true`).
Запуски — конкретные занятия с датой и статусом. ОГЭ/ЕГЭ — `thing` с `deadline`.

```mermaid
graph TD
    Exam[ОГЭ по русскому\ndeadline: июнь 2025]
    Course[Курс: Русский ОГЭ\ntemplate: true\nassigned_to: Сын]
    S1[Раздел: Орфография\ntemplate: true]
    S2[Раздел: Пунктуация\ntemplate: true]
    S3[Раздел: Сочинение\ntemplate: true]
    T1[Тема: НН и Н\ntemplate: true]
    T2[Тема: Приставки\ntemplate: true]
    T3[Тема: Запятые в СПП\ntemplate: true]

    Session1[Занятие: орфография\ndate: 20 мая\nstatus: не начато\nassigned_to: Сын]

    S1 -->|part_of| Course
    S2 -->|part_of| Course
    S3 -->|part_of| Course
    T1 -->|part_of| S1
    T2 -->|part_of| S1
    T3 -->|part_of| S2
    Course -->|about| Exam
    Session1 -->|part_of| T1
```

---

### Структура квиза

Квиз — шаблон с вопросами. Попытка — запуск квиза. Ответы на вопросы — ребро `answered`.

```mermaid
graph TD
    Quiz[Квиз: тест по НН и Н\ntemplate: true]
    Q1[В каком слове НН?\ntype: multiple_choice\noptions: стеклянный,кожаный...\ncorrect: стеклянный\ndifficulty: средний]
    Q2[Вставьте букву: стекля__ый\ntype: fill_blank\ncorrect: НН\nexplanation: прил. на -янн- пишутся НН]
    Q3[НН пишется в отглагольных прил.?\ntype: true_false\ncorrect: false]

    Attempt[Попытка: Сын 19 мая\nscore: 7\nmax_score: 10\nstatus: выполнено]

    Q1 -->|part_of| Quiz
    Q2 -->|part_of| Quiz
    Q3 -->|part_of| Quiz
    Quiz -->|about| Topic1[Тема: НН и Н]

    Attempt -->|part_of| Quiz
    Attempt -->|answered, chosen: стеклянный, correct: true, points: 1| Q1
    Attempt -->|answered, chosen: Н, correct: false, points: 0| Q2
    Attempt -->|answered, chosen: true, correct: false, points: 0| Q3
```

---

### AI-интеграция: адаптивное обучение

AI смотрит на `answered` где `correct: false`, определяет слабые темы,
генерирует новые квизы и корректирует учебный план.

```mermaid
graph TD
    AI[AI-агент]
    Son[Сын]
    WeakTopic[Тема: Приставки\n70% ошибок]
    NewQuiz[Новый квиз по приставкам\nсгенерирован AI\ntemplate: true]
    NewPlan[Скорректированный план\nна следующую неделю]

    AI -->|produces| NewQuiz
    AI -->|produces| NewPlan
    NewQuiz -->|about| WeakTopic
    NewPlan -->|about| Son
    NewPlan -->|about| WeakTopic
```

```surql
-- Слабые темы сына (топ ошибок)
SELECT ->about->thing.name AS тема,
  count() AS всего_ответов,
  count(WHERE correct = false) AS ошибок,
  math::round(count(WHERE correct = false) / count() * 100) AS процент
FROM answered
WHERE <-part_of<-thing[WHERE assigned_to = thing:son] != NONE
GROUP BY ->about->thing.name
HAVING процент > 50
ORDER BY процент DESC;

-- Прогресс по курсу — динамика результатов
SELECT date, score, max_score,
  math::round(score / max_score * 100) AS процент
FROM thing WHERE ->part_of->thing = thing:quiz_nn
  AND assigned_to = thing:son
ORDER BY date ASC;

-- Все квизы по слабой теме (для AI-назначения)
SELECT * FROM thing WHERE template = true
  AND ->about->thing = thing:topic_pristavki;

-- Готовность к экзамену по разделам
SELECT ->part_of->thing.name AS раздел,
  math::round(count(WHERE correct = true) / count() * 100) AS готовность
FROM answered
WHERE <-part_of<-thing[WHERE assigned_to = thing:son] != NONE
GROUP BY ->part_of->thing[WHERE ->part_of->thing = thing:course_oge].name;
```

---

## Паттерны управления вниманием

### 1. Срок действия документов и подписок

Поле `expires_at` на любой вещи. Автоматическое напоминание за N дней.

```mermaid
graph TD
    Passport[Паспорт папы\nkind: физическое\nexpires_at: 2027-03-15]
    DL[Водительское удостоверение\nexpires_at: 2026-11-01]
    Insurance[Страховка ОСАГО\nexpires_at: 2026-06-30]
    Netflix[Подписка Netflix\nexpires_at: 2026-06-01\namount: 799р/мес]

    Passport -->|represents| PassportScan[Скан паспорта\nkind: цифровое]
```

```surql
-- Что истекает в ближайшие 30 дней
SELECT name, expires_at FROM thing
  WHERE expires_at > time::now()
  AND expires_at < time::now() + 30d
  ORDER BY expires_at ASC;
```

---

### 2. Одолжения — что у кого

```mermaid
graph TD
    Drill[Дрель Bosch\nkind: физическое]
    Ladder[Лестница соседа\nkind: физическое]
    Book[Книга Ильфа и Петрова]

    Alex[Алексей]
    Neighbor[Сосед Василий]
    Dad[Папа]

    Drill -->|lent_to, since: 15 марта| Alex
    Ladder -->|borrowed_from, since: 10 мая| Neighbor
    Book -->|lent_to, since: 1 апреля| Alex
```

```surql
-- Что я отдал и кому
SELECT ->lent_to->thing.name AS кому, name AS вещь, ->lent_to.since AS с
FROM thing WHERE ->lent_to->thing != NONE;

-- Что я взял у других
SELECT ->borrowed_from->thing.name AS у_кого, name AS вещь
FROM thing WHERE ->borrowed_from->thing != NONE;

-- Что давно не возвращают (больше 30 дней)
SELECT * FROM lent_to WHERE since < time::now() - 30d;
```

---

### 3. Контекстные задачи — сделать когда...

Задача активируется по контексту: место, человек, ситуация. Снижает нагрузку
на память — не нужно помнить когда, система подскажет.

```mermaid
graph TD
    T1[Купить саморезы\nstatus: не начато\nenergy: низкая]
    T2[Спросить про забор\nstatus: не начато]
    T3[Позвонить в страховую\nstatus: не начато\nenergy: высокая]
    T4[Забрать инструмент\nstatus: не начато]

    Store[Строительный магазин Леруа]
    Alex[Алексей]
    Car[В машине / в дороге]

    T1 -->|triggered_by| Store
    T2 -->|triggered_by| Alex
    T3 -->|triggered_by| Car
    T4 -->|triggered_by| Alex
```

```surql
-- Задачи которые можно сделать сейчас в магазине
SELECT <-triggered_by<-thing[WHERE status = "не начато"].*
FROM thing:store_lerua;

-- Задачи для встречи с Алексеем
SELECT <-triggered_by<-thing[WHERE status = "не начато"].*
FROM thing:alex;

-- Задачи с низкой энергией (можно делать уставшим)
SELECT * FROM thing WHERE energy = "низкая" AND status = "не начато";
```

---

### 4. Быстрая фиксация идей (braindump)

Мысль пришла — фиксируем мгновенно, разбираем потом. Сообщение `about` нужной
вещи или в общий inbox.

```mermaid
graph TD
    Inbox[Входящие\nкорневой контейнер]
    Idea1[Идея: сделать полку в гараже\ncreated_at: сегодня 8:32]
    Idea2[Идея: спросить у врача про прививки\ncreated_at: сегодня 9:15]
    Idea3[Наблюдение: кристаллы потемнели\ncreated_at: сегодня 14:00]
    Experiment[Опыт с кристаллами]

    Idea1 -->|part_of| Inbox
    Idea2 -->|part_of| Inbox
    Idea3 -->|about| Experiment
```

Периодический обзор Inbox → каждая идея превращается в задачу, вишлист, или удаляется.

---

### 5. Уровень энергии задач

Поле `energy` на задаче позволяет выбрать подходящую работу под текущее состояние.

| Энергия | Примеры задач |
|---------|--------------|
| `высокая` | Позвонить в налоговую, написать жалобу, разобрать сложную ситуацию |
| `средняя` | Съездить в магазин, приготовить ужин, сделать ТО |
| `низкая` | Долить воду в бочку, разобрать почту, навести порядок на полке |

---

### 6. Кто что умеет — к кому обращаться

```mermaid
graph TD
    Alex[Алексей]
    Neighbor[Василий сосед]
    Doctor[Доктор Смирнов]
    Lawyer[Юрист Петрова]

    Legal[Юриспруденция]
    Plumbing[Сантехника]
    Cardiology[Кардиология]
    Electronics[Электроника]

    Alex -->|expert_in| Legal
    Alex -->|expert_in| Electronics
    Neighbor -->|expert_in| Plumbing
    Doctor -->|expert_in| Cardiology
    Lawyer -->|expert_in| Legal
```

```surql
-- Кто может помочь с сантехникой
SELECT <-expert_in<-thing.* FROM thing:plumbing;

-- Все эксперты и их области
SELECT name, ->expert_in->thing.name AS области FROM thing
  WHERE ->expert_in->thing != NONE;
```

---

### 7. Вишлист — желания и мечты

Желания хранятся отдельно от реальных покупок. Флаг `wish: true`.
Когда желание становится реальным планом — флаг снимается, добавляется в список покупок.

```mermaid
graph TD
    Wishlist[Вишлист семьи\nконтейнер]
    W1[Nintendo Switch\nwish: true\nassigned_to: Сын]
    W2[Новый диван\nwish: true\nassigned_to: Мама]
    W3[Осциллограф\nwish: true\nassigned_to: Папа]

    W1 -->|part_of| Wishlist
    W2 -->|part_of| Wishlist
    W3 -->|part_of| Wishlist
```

---

### 8. Сезонные задачи

Шаблоны с `schedule: каждую осень / каждую весну`. Создаются один раз, работают годами.

| Шаблон | `schedule` |
|--------|------------|
| Поменять резину на зимнюю | каждый октябрь |
| Подготовить дачу к сезону | каждый апрель |
| Проверить аптечку | каждый январь |
| Слить воду из шлангов | перед первыми заморозками |
| Обработать сад от вредителей | каждый май |

---

### 9. Привычки и стрики

Привычка — периодическая задача с `streak` счётчиком. Каждый выполненный
запуск увеличивает стрик, пропуск сбрасывает.

```mermaid
graph TD
    H1[Привычка: поливать цветы\nperiod: каждые 3 дня\nstreak: 7\ntemplate: true]
    H2[Привычка: зарядка\nperiod: ежедневно\nstreak: 14\ntemplate: true]
    H3[Привычка: читать 20 минут\nperiod: ежедневно\nstreak: 0\ntemplate: true]

    R1[Полив 16 мая\nstatus: выполнено]
    R2[Полив 19 мая\nstatus: выполнено]

    R1 -->|part_of| H1
    R2 -->|part_of| H1
```

---

### Корневые контейнеры системы

```mermaid
graph TD
    Root[Домовой]
    Templates[Шаблоны]
    Wishlist[Вишлист]
    Inbox[Входящие]
    People[Люди]
    Family[Семья]
    Places[Места]

    Templates -->|part_of| Root
    Wishlist -->|part_of| Root
    Inbox -->|part_of| Root
    People -->|part_of| Root
    Family -->|part_of| People
    Places -->|part_of| Root
```

```surql
-- Полная сводка на сейчас: задачи + просроченные + истекающие + одолжения
LET $tasks = SELECT * FROM thing WHERE status = "не начато"
  AND template != true AND deadline < time::now() + 7d;
LET $expiring = SELECT name, expires_at FROM thing
  WHERE expires_at < time::now() + 30d;
LET $lent = SELECT name, ->lent_to->thing.name AS у FROM thing
  WHERE ->lent_to->thing != NONE;
RETURN { задачи: $tasks, истекает: $expiring, одолжено: $lent };
```

---

## Сценарий: контакты и социальный граф

Каждый человек — `thing`. Его контактные методы — тоже `thing`, связанные с человеком
через `part_of`. Социальные связи между людьми — `related_to` с понятной меткой.
Группы и сообщества — контейнеры, люди `part_of` них.

### Контактные методы

```mermaid
graph TD
    Alexey[Алексей\npart_of: Люди]
    Marina[Марина\nжена Алексея]
    Peter[Пётр\nдруг]

    Phone1["+7-900-123-45-67\ntype: phone\nlabel: личный"]
    Phone2["+7-495-111-22-33\ntype: phone\nlabel: рабочий"]
    Email1["alex@firm.ru\ntype: email\nlabel: рабочий"]
    TG["alexey_iv\ntype: messenger\nplatform: Telegram"]
    WA["+7-900-123-45-67\ntype: messenger\nplatform: WhatsApp"]
    Addr["ул. Садовая 5 кв. 12\ntype: address\nlabel: домашний"]

    Phone1 -->|part_of| Alexey
    Phone2 -->|part_of| Alexey
    Email1 -->|part_of| Alexey
    TG     -->|part_of| Alexey
    WA     -->|part_of| Alexey
    Addr   -->|part_of| Alexey

    Alexey -->|related_to, label: жена| Marina
    Alexey -->|related_to, label: друг| Peter
    Marina -->|related_to, label: муж| Alexey
```

Поля контактного метода:

| Поле | Примеры |
|------|---------|
| `type` | `phone` / `email` / `messenger` / `address` / `website` / `social` |
| `value` | `+79001234567`, `alex@firm.ru`, `@alexey_iv` |
| `platform` | для мессенджеров: `Telegram` / `WhatsApp` / `Signal` / `ВКонтакте` |
| `label` | `личный` / `рабочий` / `домашний` |
| `preferred` | `true` — предпочтительный способ связи |

Контакт устарел — `status: отменено`. Чужой контакт передан через задачу — отдельный `thing`
с `about` → нужная задача, `produces` → контакт в базе.

### Социальные связи

`related_to` с метками уже есть в модели — здесь он раскрывается полностью:

| `label` | Значение |
|---------|----------|
| `жена` / `муж` | Супруги |
| `партнёр` | Гражданский партнёр |
| `сын` / `дочь` / `родитель` | Родственники |
| `брат` / `сестра` | Братья и сёстры |
| `друг` | Дружеская связь |
| `коллега` | Общая работа |
| `сосед` | Живут рядом |
| `знакомый` | Слабая связь |
| `познакомил` | Кто свёл двух людей |

Связь двунаправленна в жизни, но ребро `related_to` — однонаправленное в SurrealDB.
Создавай оба направления сразу: Алексей → Марина и Марина → Алексей.

### Как Пётр вошёл в круг

Если важно сохранить контекст знакомства — событие-знакомство `thing` с `participant`:

```mermaid
graph TD
    Meet[Встреча на выставке\ndate: 2024-03-10\nstatus: выполнено]
    Dad[Папа]
    Alexey[Алексей]
    Peter[Пётр]

    Meet -->|participant, role: участник| Dad
    Meet -->|participant, role: участник| Alexey
    Meet -->|participant, role: участник| Peter
    Alexey -->|related_to, label: познакомил| Peter
```

Теперь можно ответить: "откуда я знаю Петра" — запросом по `related_to` и `participant`.

### Группы и сообщества

```mermaid
graph TD
    People[Люди\nкорневой контейнер]
    Family[Семья]
    WorkGroup[Рабочая группа по проекту]
    FriendsGroup[Компания друзей]

    Dad[Папа]
    Mom[Мама]
    Alexey[Алексей]
    Peter[Пётр]
    Marina[Марина]

    Dad -->|part_of| Family
    Mom -->|part_of| Family
    Family -->|part_of| People

    Alexey -->|part_of| People
    Peter  -->|part_of| People
    Marina -->|part_of| People

    Alexey -->|part_of| WorkGroup
    Dad    -->|part_of| WorkGroup

    Alexey -->|part_of| FriendsGroup
    Peter  -->|part_of| FriendsGroup
    Dad    -->|part_of| FriendsGroup
```

Временное членство в группе — `part_of` с `until`. Постоянное — без `until`.

### Общий доступ к контактам

Контакт — `thing`, к нему применяется та же логика доступа:

```mermaid
graph TD
    Alexey[Алексей]
    Phone1[Личный телефон\ntype: phone]
    Phone2[Рабочий телефон\ntype: phone]
    Email1[Рабочий email\ntype: email]

    Son[Сын]
    Dad[Папа]
    Lawyer[Юрист Петрова]

    Phone1 -->|part_of| Alexey
    Phone2 -->|part_of| Alexey
    Email1 -->|part_of| Alexey

    Son    -->|can_access| Phone1
    Dad    -->|can_access| Alexey
    Lawyer -->|can_access| Email1
```

Сын видит только личный номер. Юрист видит только рабочий email. Папа — все контакты
(доступ к человеку каскадно открывает всё `part_of` него).

```surql
-- Все контакты Алексея
SELECT * FROM thing WHERE ->part_of->thing = thing:alexey
  AND type IN ["phone", "email", "messenger", "address"];

-- Предпочтительный способ связи
SELECT * FROM thing WHERE ->part_of->thing = thing:alexey
  AND preferred = true;

-- С кем я связан и как
SELECT ->related_to->thing.name AS кто, ->related_to.label AS связь
FROM thing:dad;

-- Общие связи — через кого я знаю Петра
SELECT <-related_to<-thing[WHERE ->related_to->thing = thing:dad].*
FROM thing:peter;

-- Кто в рабочей группе и их контакты
LET $members = SELECT <-part_of<-thing.* FROM thing:work_group;
SELECT name, (SELECT * FROM thing WHERE ->part_of->thing = $parent.id
  AND type = "phone") AS телефоны
FROM $members AS $parent;

-- Все мессенджеры человека
SELECT value, platform FROM thing
  WHERE ->part_of->thing = thing:alexey AND type = "messenger";

-- Люди без контактов (только имя в базе)
SELECT * FROM thing WHERE ->part_of->thing = thing:people
  AND (SELECT * FROM thing WHERE ->part_of->thing = $parent.id
    AND type IN ["phone", "email"]) IS EMPTY;

-- Все люди связанные с юридическим делом (assigned + participant)
SELECT DISTINCT
  (SELECT ->assigned_to->thing.* FROM thing WHERE ->about->thing = thing:case_1),
  (SELECT ->participant->thing.* FROM thing WHERE ->about->thing = thing:case_1);
```

---

## Сценарий: блочные документы и трансклюзия

Весь контент хранится в БД. Блоки — `thing`-узлы с `text`. Документ — `thing`-контейнер,
блоки упорядочены через `order` на ребре `part_of`. Vault-директория — только для
бинарных файлов (изображения, PDF, видео). Редактирование — только во внутреннем редакторе.

### Типы блоков

Поле `type` на блоке:

| `type` | Описание |
|--------|---------|
| `paragraph` | Обычный текст |
| `heading` | Заголовок (+ поле `level`: 1/2/3) |
| `figure` | Изображение из vault (`filename` + `caption`) |
| `formula` | Математическая формула |
| `code` | Блок кода (+ поле `language`) |
| `callout` | Выноска / предупреждение |
| `citation` | Ссылка на источник |

### Структура документа

```mermaid
graph TD
    Article[Статья: Кристаллизация\nkind: document\nstatus: черновик]

    Abs[Абстракт\ntype: paragraph\ntext: Данная работа...\norder: 1]
    S1[Введение\ntype: heading\nlevel: 1\norder: 2]
    P1[Параграф введения\ntype: paragraph\norder: 1]
    S2[Методология\ntype: heading\nlevel: 1\norder: 3]
    ProtoBlock[Протокол\ntype: paragraph\ntext: Растворить 50г...\norder: 1]
    S3[Результаты\ntype: heading\nlevel: 1\norder: 4]
    Fig1[Рис. 1\ntype: figure\nfilename: figure1.png\ncaption: График зависимости\norder: 1]
    ResultBlock[Таблица измерений\ntype: paragraph\norder: 2]

    Abs  -->|part_of, order:1| Article
    S1   -->|part_of, order:2| Article
    S2   -->|part_of, order:3| Article
    S3   -->|part_of, order:4| Article

    P1         -->|part_of, order:1| S1
    ProtoBlock -->|part_of, order:1| S2
    Fig1       -->|part_of, order:1| S3
    ResultBlock -->|part_of, order:2| S3

    Article -->|about| Experiment[Опыт №3]
    Article -->|produces| Publication[Публикация в журнале]
    ProtoBlock -->|part_of| Experiment
```

Протокол — один узел. В статье он `part_of` раздела "Методология". Он же `part_of` Опыта №3.
Один блок — несколько родителей через `part_of`. Изменился в одном месте — изменился везде.

### Три режима ребра `references`

`references` нужен когда блок включается **только для чтения** — не редактируется на месте,
а отображается как вставка из другого контекста.

| `mode` | Поведение | Когда использовать |
|--------|-----------|-------------------|
| `live` | Рендерить актуальный `text` цели | Блок из другого документа — всегда актуален |
| `snapshot` | Рендерить `snapshot_text` с ребра | Данные зафиксированы на дату публикации |
| `link` | Кликабельная ссылка | Ссылка на источник, навигация |

**Разница `part_of` vs `references`:**  
`part_of` — блок полноправно принадлежит документу, редактируется там.  
`references` — блок отображается, но редактируется в другом месте.

### Изображения

Файл лежит в vault-директории документа-владельца. Блок типа `figure` хранит `filename`:

```
thing:block_fig1
  type: figure
  filename: "figure1.png"     ← ~/domovoy/files/article_crystallization/figure1.png
  caption: "График зависимости температуры"
  → part_of → thing:section_results, order: 1
```

Рендерер строит путь: `filesDir(document_id) + "/" + filename`.

### Источники и цитаты

Источник — `thing` с полями `author`, `year`, `doi`, `url`.
Цитата в тексте — `references, mode: link` из блока на источник.

```mermaid
graph TD
    Article[Статья]
    P2[Параграф 2\ntype: paragraph]
    Src1[Smith 2020\nauthor: Smith J.\nyear: 2020\ndoi: 10.1234/...]
    Src2[Jones 2019\nauthor: Jones A.\nyear: 2019\nurl: ...]

    P2 -->|part_of| Article
    P2 -->|references, mode:link| Src1
    P2 -->|references, mode:link| Src2
```

### Снапшот: обновление вручную

Когда источник изменился после фиксации — приложение показывает предупреждение.
Пользователь нажимает "обновить": `snapshot_text` копируется из текущего `text` источника.

```surql
UPDATE references SET
  snapshot_text = (SELECT text FROM thing WHERE id = ->thing)[0].text,
  snapshot_at   = time::now()
WHERE id = references:snap_results_table;
```

```surql
-- Весь документ одним запросом (блоки + встроенные трансклюзии)
SELECT id, type, text, filename, caption, level,
  ->part_of.order AS pos,
  ->references[WHERE mode = "live"]->thing.text AS embed_live,
  ->references[WHERE mode = "snapshot"].snapshot_text AS embed_snap
FROM thing
WHERE ->part_of->thing = thing:article_crystallization
ORDER BY pos ASC;

-- Все места где используется блок
SELECT <-references<-thing[WHERE mode IN ["live","snapshot"]].*
FROM thing:block_protocol_3;

-- Снапшоты с устаревшим содержимым
SELECT * FROM references
  WHERE mode = "snapshot"
  AND ->thing.updated_at > snapshot_at;

-- Все источники статьи
SELECT ->references->thing[WHERE year != NONE].*
FROM thing WHERE ->part_of->thing = thing:article_crystallization;

-- Блоки одного уровня по порядку (для рендера раздела)
SELECT *, ->part_of.order AS pos
FROM thing WHERE ->part_of->thing = thing:section_methodology
ORDER BY pos ASC;
```

---

## Файловое хранилище: vault-паттерн

SurrealDB хранит только метаданные. Бинарные файлы лежат на диске в предсказуемой
структуре — "vault". Путь к файлам любого узла выводится детерминированно из его ID,
без дополнительных полей в БД.

### Структура на диске

```
~/.domovoy/
├── domovoy.db                  ← SurrealDB
└── files/
    ├── drill_bosch/            ← ID узла thing:drill_bosch
    │   ├── front.jpg
    │   ├── side.jpg
    │   └── receipt.pdf
    ├── case_fence/             ← thing:case_fence
    │   ├── complaint.pdf
    │   └── court_decision.docx
    └── passport_dad/           ← thing:passport_dad
        └── scan.pdf
```

**Правило:** директория узла = `{vault}/files/{id}`, где `id` — часть record ID после `thing:`.

```ts
const filesDir = (recordId: string) =>
  path.join(VAULT_ROOT, "files", recordId.replace("thing:", ""));

// thing:drill_bosch  →  ~/.domovoy/files/drill_bosch/
// thing:01j3kxyz     →  ~/.domovoy/files/01j3kxyz/
```

Директория создаётся при добавлении первого файла. Если директории нет — файлов нет.
Приложение проверяет директорию без запроса к БД.

### Два уровня привязки файлов

**Простое вложение** — файл лежит в директории узла, отдельного `thing`-узла не нужно.
Приложение читает директорию напрямую. Подходит для большинства случаев:
фото инвентаря, документы к делу, вложения к событию.

```mermaid
graph TD
    Drill[Дрель Bosch\nthing:drill_bosch]
    Dir["~/.domovoy/files/drill_bosch/\nfront.jpg · side.jpg · receipt.pdf"]
    Drill --- Dir
```

**Файл с отношениями** — нужен собственный `thing`-узел, когда файл участвует в графе:
цитируется из статьи, расшарен конкретному человеку, сам является источником для других узлов.

```mermaid
graph TD
    FileNode[thing:file_passport_scan\nfilename: scan.pdf\nmime_type: application/pdf\nsize: 512000]
    Passport[Паспорт папы\nthing:passport_dad]
    Notary[Нотариус Петрова]
    Share[Подборка для нотариуса]

    FileNode -->|represents| Passport
    FileNode -->|part_of| Share
    Notary -->|can_access| Share
```

Реальный путь файла: `filesDir("passport_dad") + "/" + filename`  
= `~/.domovoy/files/passport_dad/scan.pdf`

### Какое ребро использовать

| Ситуация | Ребро |
|----------|-------|
| Фото физической вещи | `represents` → вещь |
| Скан документа | `represents` → физический документ |
| Вложение в сообщение чата | `part_of` → сообщение |
| Рисунок в блоке статьи | `part_of` → блок-фигуру |
| Фото события | `about` → событие |

### Версионирование файлов

Новая версия документа — новый файл в той же директории, старая версия получает `status: архив`.
Если важна связь между версиями — отдельные `thing`-узлы с `about` → предыдущая версия:

```
thing:file_contract_v2 → about → thing:file_contract_v1
                                    status: архив
```

### Синхронизация без облака

Весь Домовой переносится копированием одной директории `~/.domovoy/`.

| Способ | Как работает |
|--------|-------------|
| Syncthing | P2P между устройствами по локальной сети, без сервера |
| rsync + NAS | push на домашний сетевой диск по SSH |
| USB / внешний диск | скопировал папку — всё перенёс |
| Любой backup-инструмент | Time Machine, Borg, restic — это просто папка |

```surql
-- Файловые узлы конкретного thing (с отношениями)
SELECT <-represents<-thing[WHERE filename != NONE].*
FROM thing:passport_dad;

-- Все файлы расшаренные нотариусу (через контейнер доступа)
SELECT ->can_access->thing<-part_of<-thing[WHERE filename != NONE].*
FROM thing:notary_petrova;

-- Файлы отсутствующие на диске (рассинхронизация)
-- логика на стороне приложения: пройтись по thing WHERE filename != NONE,
-- проверить существование filesDir(parent_id) + "/" + filename
```

---

## Сценарий: серверные AI-пайплайны

Общий паттерн: медиа-вход с телефона → очередь → сервер обрабатывает → результат
в граф. Телефон не тратит ресурсы на AI — только записывает и отправляет.

### Общая структура

```
thing:input (type: voice_note / photo / scan / document)
  filename: "..."           ← бинарник в vault целевого узла
  status: не начато         ← сервер мониторит это поле
  → about       → thing:target   ← куда прикрепить результат
  → assigned_to → Мама

↓ сервер забирает

thing:task_process
  → depends_on  → input
  → assigned_to → thing:ai_*     ← AI-инструмент как thing-узел
  → produces    → структурированный результат
```

`status` на входящем медиа: `не начато` → `в процессе` → `выполнено` / `ошибка`

### AI-инструменты как узлы

| Узел | Роль |
|------|------|
| `thing:ai_whisper` | Speech-to-text |
| `thing:ai_claude` | Разбор текста, структурирование, перевод |
| `thing:ai_vision` | Распознавание изображений, OCR |
| `thing:ai_tts` | Text-to-speech (ElevenLabs и др.) |
| `thing:service_barcode` | Lookup по штрихкоду / ISBN |

---

### 1. Голосовой ввод в список покупок

Жена диктует список — телефон только пишет аудио, сервер транскрибирует и парсит.

```mermaid
graph TD
    Mom[Мама]
    Voice[Голосовая заметка\ntype: voice_note\nstatus: не начато\nfilename: dictation.m4a]
    List[Список покупок\nмай 2026]
    Transcription[Расшифровка\ntext: молоко 2л хлеб яйца десяток]

    Milk[Молоко\nneeds qty:2 unit:л]
    Bread[Хлеб]
    Eggs[Яйца\nneeds qty:10]

    Mom -->|assigned_to| Voice
    Voice -->|about| List
    Voice -->|produces| Transcription
    Transcription -->|about| Voice
    List -->|needs| Milk
    List -->|needs| Bread
    List -->|needs| Eggs
```

---

### 2. Голосовая команда → задача

"Напомни купить масло для мотоцикла до пятницы" — AI разбирает намерение и создаёт задачу.

```
Voice command → ai_whisper → text
             → ai_claude  → thing:task
                              name: "Купить масло для мотоцикла"
                              deadline: 2026-05-22
                              → about → thing:motorcycle
                              → assigned_to → Папа
```

AI определяет: объект (`мотоцикл`), действие (`купить масло`), срок (`пятница`).
Если объект найден в графе — ставит `about`. Если нет — создаёт или оставляет в Inbox.

---

### 3. Голосовое в обсуждении → транскрипция

Голосовое сообщение в чате под задачей — транскрибируется на сервере, отображается
как обычное текстовое сообщение рядом с кнопкой воспроизведения.

```
thing:voice_msg
  type: voice_note
  filename: "msg_14-32.m4a"
  text: null                 ← до обработки
  → about → thing:task_motorcycle_service
  → assigned_to → Папа

после обработки:
  text: "фильтр уже купил, завтра сделаю ТО"
  status: выполнено
```

Сообщение становится частью обсуждения — поток `about` задачи, упорядоченный по `created_at`.

---

### 4. Фото чека → расходы

Сфотографировал чек в магазине — AI распознаёт позиции и цены, создаёт записи расходов.

```mermaid
graph TD
    Photo[Фото чека\ntype: photo\nfilename: receipt.jpg\nstatus: не начато]
    Vision[ai_vision: OCR чека]
    Claude[ai_claude: структурирование]

    Expense[Расход: Пятёрочка\ndate: 18 мая\ntotal: 1840р]
    I1[Молоко 2л — 98р]
    I2[Хлеб — 45р]
    I3[Яйца 10шт — 120р]

    Photo -->|produces| Expense
    Expense -->|part_of| I1
    Expense -->|part_of| I2
    Expense -->|part_of| I3
    Photo -->|about| Expense
```

Если позиция уже есть в инвентаре — `about` связывает расход с вещью. История трат
по любому продукту — запрос по `about` цепочке.

---

### 5. Скан документа / письма → задача

Пришло письмо из налоговой — сфотографировал, AI читает, выделяет срок и действие.

```
Photo → ai_vision (OCR) → text
      → ai_claude (разбор) → thing:task
                               name: "Подать декларацию 3-НДФЛ"
                               deadline: 2026-07-31
                               priority: высокий
                               → about → thing:file_letter_scan
                               → filed_with → thing:nalog_service
```

Скан письма остаётся в vault — `about` связывает задачу с источником.
Если в письме упомянута инстанция из графа — `filed_with` проставляется автоматически.

---

### 6. Штрихкод / QR → инвентарь

Отсканировал штрихкод на упаковке — приложение ищет товар в базе или через внешний API.

```
Scan event
  → thing:service_barcode (lookup by EAN-13)
  → produces → thing:item
                 name: "Масло моторное Castrol 5W-40"
                 quantity: 1
                 unit: л
                 price: 890
                 url: "https://..."
                 → contains → thing:garage   ← куда добавить
```

Если товар уже есть в базе — увеличивает `quantity`. Если нет — создаёт новый узел.
QR-код документа — открывает соответствующий `thing`-узел напрямую по ID.

---

### 7. Локализация видео (полный пайплайн)

Скачать иноязычное видео → субтитры (AI) → перевод (AI) → ручная правка → TTS → монтаж.

```mermaid
graph LR
    V[Исходное видео\nfilename: tutorial.mp4]
    S[Субтитры EN\ntype: paragraph\ntext: SRT-контент]
    R[Перевод RU draft\ntype: paragraph]
    F[Перевод RU final\ntype: paragraph]
    A[Аудиодорожка RU\nfilename: audio_ru.mp3]
    Out[Финальное видео\nfilename: tutorial_ru.mp4]
    Lesson[Урок: FreeCAD Эскизы\n→ about → Сын]

    V -->|produces| S
    S -->|produces| R
    R -->|produces| F
    F -->|produces| A
    V -->|produces| Out
    A -->|produces| Out
    Out -->|produces| Lesson
```

Каждый `produces` — задача с `depends_on` на предыдущий и `assigned_to` нужному AI-инструменту
или человеку (ручная правка → Папа).

---

```surql
-- Все необработанные медиа-входы (очередь для сервера)
SELECT * FROM thing
  WHERE type IN ["voice_note", "photo", "scan"]
  AND status = "не начато"
  ORDER BY created_at ASC;

-- Результаты конкретного пайплайна (что породил вход)
SELECT ->produces->thing.* FROM thing:voice_note_may18 DEPTH 5;

-- Расходы по конкретному продукту за последние 3 месяца
SELECT ->about<-thing[WHERE ->part_of->thing != NONE].* FROM thing:milk
  WHERE created_at > time::now() - 90d;

-- Задачи созданные из писем / сканов
SELECT * FROM thing WHERE status != "выполнено"
  AND ->about->thing[WHERE type IN ["photo","scan"]] != NONE;
```

---

### 8. QR-наклейка → фото → AI-идентификация

Наклеил QR на незнакомый компонент — приложение создаёт stub-узел. Фотографируешь —
AI заполняет имя, описание, находит производственные коды если они попали в кадр.

**Три стадии одного узла:**

```mermaid
graph LR
    S1[Стадия 1: stub\nname: null\nidentified: false\n→ identified_by → custom_qr]
    S2[Стадия 2: фото загружены\n5 фото → about → узел\nstatus: в процессе]
    S3[Стадия 3: идентифицирован\nname: STM32F103C8T6\ndescription: ...\nidentified: true]

    S1 -->|загрузил фото| S2
    S2 -->|AI обработал| S3
```

**Пайплайн:**

```
thing:stm32_stub
  name: null
  identified: false
  → identified_by, printed_at: 18 мая → thing:code_qr_001

Photos 1-6:
  type: photo, filename: "stm32_1.jpg" ... "stm32_6.jpg"
  → about → thing:stm32_stub           ← в vault stm32_stub/

thing:task_identify
  → depends_on → photos
  → assigned_to → thing:ai_vision
  → about → thing:stm32_stub
  → produces → identification

После обработки thing:stm32_stub:
  name: "STM32F103C8T6 Blue Pill"
  description: "ARM Cortex-M3, 72MHz, 64KB Flash, 20KB SRAM"
  quantity: 3
  unit: шт
  identified: true
  → identified_by → thing:code_ean_stm32   ← AI заметил на фото
```

AI видит все фото одновременно — определяет тип компонента, количество штук,
замечает маркировку производителя если она попала в кадр и добавляет её как
ещё один `identified_by` автоматически.

```surql
-- Все неидентифицированные вещи (нужно сфотографировать)
SELECT * FROM thing WHERE identified = false;

-- Stub-узлы без фото (наклейка есть, фото ещё нет)
SELECT * FROM thing WHERE identified = false
  AND (SELECT * FROM thing WHERE ->about->thing = $parent.id
    AND type = "photo") IS EMPTY;

-- Что AI нашёл при идентификации (все produced из задач идентификации)
SELECT ->produces->thing.* FROM thing
  WHERE ->assigned_to->thing = thing:ai_vision
  AND ->about->thing = thing:stm32_stub;
```

---

## Сценарий: маркировка физических вещей

Каждый код — отдельный `thing`-узел с `code_type`, `code_value`, `code_system`.
Физическая вещь связана со своими кодами через `identified_by`.
Одна вещь — сколько угодно кодов разных систем.

### Типы кодов

| `code_type` | Описание | Пример `code_value` |
|-------------|----------|---------------------|
| `ean13` | Штрихкод производителя | `4607082660271` |
| `ean8` | Короткий штрихкод | `12345678` |
| `qr` | QR-код производителя или магазина | URL или строка |
| `datamatrix` | 2D код (часто на лекарствах) | строка |
| `честный_знак` | Российская маркировка | `010460...` |
| `serial` | Серийный номер | `SN-2024-A1B2C3` |
| `imei` | Идентификатор телефона | `359876543210001` |
| `vin` | Идентификатор автомобиля | `XTA21099063185829` |
| `isbn` | Книжный идентификатор | `978-5-17-090965-3` |
| `rfid` | Радио-метка | hex-строка |
| `ozon` | Штрихкод посылки Ozon | строка |
| `wb` | Штрихкод посылки WB | строка |
| `артикул` | Артикул магазина / поставщика | `BOX-2024-BLK-L` |
| `custom_qr` | Собственная наклейка Домового | `domovoy://thing/drill_bosch` |

### Пример: дрель с несколькими кодами

```mermaid
graph TD
    Drill[Дрель Bosch GSB 21-2 RE\nkind: физическое]

    EAN[EAN-13: 3165140462037\ncode_system: производитель]
    Serial[Серийный: 2024-EU-447821\ncode_system: производитель]
    OzonBox[Ozon посылка: 84291043\ncode_system: ozon]
    Custom[custom_qr: domovoy://thing/drill_bosch\ncode_system: домовой\nprinted_at: 18 мая 2026]

    Drill -->|identified_by| EAN
    Drill -->|identified_by| Serial
    Drill -->|identified_by, printed_at: null| OzonBox
    Drill -->|identified_by, printed_at: 18 мая| Custom
```

`OzonBox` — код с коробки заказа. `printed_at: null` — наклейка не печаталась, код просто
занесён в систему при получении посылки. `Custom` — собственная наклейка распечатана
и наклеена на дрель.

### Ozon / WB: от кода коробки до заказа

Код на коробке Ozon идентифицирует **посылку**, не товар. Посылка `part_of` заказа.

```mermaid
graph TD
    Box[Ozon посылка 84291043\ncode_system: ozon]
    Order[Заказ Ozon #89234\nstatus: получено\ndate: 15 мая]
    Drill[Дрель Bosch GSB 21-2 RE]
    Receipt[Чек / накладная Ozon]

    Drill -->|identified_by| Box
    Order -->|produces| Drill
    Order -->|produces| Receipt
    Box -->|about| Order
```

Сканируешь штрихкод с коробки → находишь `Box` в графе → через `about` выходишь
на заказ → там накладная, дата, цена, гарантийный период.

### Собственная маркировка Домового

Custom QR кодирует ID узла напрямую: `domovoy://thing/{id}`.
При сканировании приложение открывает узел без запроса к БД — схема распознаётся немедленно.

`printed_at` на ребре `identified_by` фиксирует дату печати наклейки. По этому полю
можно найти все вещи у которых наклейка уже есть, и те которые ещё нужно промаркировать.

### DataMatrix и Честный знак дома

Дома верификация подлинности не нужна — достаточно уникального кода конкретной единицы
из DataMatrix для поштучного учёта. `url` не заполняется:

```
thing:code_dm_amoxicillin_unit1
  code_type: datamatrix
  code_value: "010460082100018921VmrTPVX92306"   ← уникален для каждой пачки
  code_system: честный_знак
  url: null   ← верификация опциональна, дома не нужна
```

Два пакета одного лекарства → два кода с разными `code_value`. Поштучный учёт:
списал одну пачку — удалил её код. Сколько кодов `datamatrix` у `thing:amoxicillin` — столько единиц в наличии.

```
thing:medicine_amoxicillin
  → identified_by → thing:code_dm_unit1   (пачка 1)
  → identified_by → thing:code_dm_unit2   (пачка 2)
  → identified_by → thing:code_ean_amox   (общий EAN на упаковке)
```

```surql
-- Найти вещь по любому коду (сканирование)
SELECT <-identified_by<-thing
FROM thing WHERE code_value = $scanned_value;

-- Все коды конкретной вещи
SELECT ->identified_by->thing.*
FROM thing:drill_bosch;

-- Вещи без собственной наклейки (custom_qr не наклеен)
SELECT * FROM thing WHERE kind = "физическое"
  AND ->identified_by->thing[WHERE code_type = "custom_qr"
    AND <-identified_by.printed_at != NONE] IS EMPTY;

-- Вещи которые нужно промаркировать (есть в системе, наклейки нет)
SELECT name FROM thing WHERE kind = "физическое"
  AND NOT (->identified_by->thing[WHERE code_type = "custom_qr"] != NONE);

-- От штрихкода посылки до заказа и чека
SELECT ->about->thing AS заказ,
       ->about->thing->produces->thing[WHERE filename != NONE] AS документы
FROM thing WHERE code_value = "84291043" AND code_system = "ozon";

-- Все лекарства с Честным знаком (для проверки сроков)
SELECT <-identified_by<-thing.*
FROM thing WHERE code_type = "честный_знак";
```

---

## Сценарий: ремонт, подряд, субподряд

Внешний заказ — `thing` с `filed_with` → исполнитель, `about` → объект работ.
Субподряд — такой же `thing`, но `part_of` родительского контракта. Глубина не ограничена.

### Ремонт вещи в мастерской

```mermaid
graph TD
    Dad[Папа]
    Shop[Мотосервис Иванова]
    Mechanic[Механик Сергей]
    Moto[Мотоцикл]

    Repair[Заказ: ТО + сцепление\nstatus: в процессе\ndeadline: 25 мая\namount: 8500\namount_actual: 9200]
    Invoice[Акт выполненных работ]
    Warranty[Гарантия на сцепление\nexpires_at: 25 ноя 2026]

    Repair -->|filed_with| Shop
    Repair -->|assigned_to| Mechanic
    Repair -->|about| Moto
    Repair -->|assigned_to| Dad
    Moto -->|contains, reason: ремонт| Shop
    Repair -->|produces| Invoice
    Repair -->|produces| Warranty
```

Когда мотоцикл забрали — `contains` переключается обратно на гараж.
`amount` — смета при сдаче. `amount_actual` — итог после выполнения.

### Подряд с этапами

```mermaid
graph TD
    Dad[Папа]
    Vasya[ИП Васильев\nподрядчик]

    Contract[Договор: забор 45 пог.м\namount: 45000\ndeadline: 1 июля]

    S1[Этап 1: фундамент\ndeadline: 10 июня\namount: 15000]
    S2[Этап 2: столбы\ndeadline: 20 июня\namount: 18000]
    S3[Этап 3: секции\ndeadline: 1 июля\namount: 12000]

    P1[Оплата этапа 1]
    P2[Оплата этапа 2]
    P3[Оплата этапа 3]

    Contract -->|filed_with| Vasya
    Contract -->|assigned_to| Vasya
    S1 -->|part_of| Contract
    S2 -->|part_of| Contract
    S3 -->|part_of| Contract
    S1 -->|produces| P1
    S2 -->|produces| P2
    S3 -->|produces| P3
    P1 -->|depends_on| S1
    P2 -->|depends_on| S2
    P3 -->|depends_on| S3
```

### Субподряд: произвольная глубина

Вася нанимает субподрядчиков — их контракты `part_of` основного. Папа видит
всю цепочку запросом, хотя напрямую работает только с Васей.

```mermaid
graph TD
    Dad[Папа]
    Vasya[Вася — подрядчик]
    Kolya[Коля — субподряд\nфундамент]
    Beton[БетонСтрой — субподряд\nзаливка]

    Contract[Договор: забор\nПапа ↔ Вася]
    Sub1[Субподряд: фундамент\nВася ↔ Коля\namount: 12000]
    Sub2[Субподряд: заливка\nКоля ↔ БетонСтрой\namount: 7000]

    Contract -->|filed_with| Vasya
    Sub1 -->|part_of| Contract
    Sub1 -->|filed_with| Kolya
    Sub1 -->|assigned_to| Kolya
    Sub1 -->|participant, role: заказчик| Vasya
    Sub2 -->|part_of| Sub1
    Sub2 -->|filed_with| Beton
    Sub2 -->|assigned_to| Beton
    Sub2 -->|participant, role: заказчик| Kolya
```

`participant, role: заказчик` явно указывает кто заказал у кого на каждом уровне.
Оплата — отдельные цепочки: Папа → Вася, Вася → Коля, Коля → БетонСтрой.

### Простое поручение

Разовое задание знакомому или мастеру без формального договора:

```
thing:commission_sink
  name: "Починить кран на кухне"
  amount: 1500
  deadline: 20 мая
  → assigned_to  → thing:plumber_nikolay
  → about        → thing:kitchen_sink
  → promised_to  → Папа                  ← если было устное обещание
  → produces     → thing:invoice_sink
```

### Ответственность при срыве субподряда

Если Коля срывает срок — `Sub1 status: задержка`. Это `part_of` основного контракта,
поэтому Вася видит проблему и несёт ответственность перед Папой:

```surql
-- Все просроченные субподряды по основному контракту
SELECT name, status, deadline, ->assigned_to->thing.name AS исполнитель
FROM thing WHERE ->part_of->thing = thing:contract_fence
  OR ->part_of->thing->part_of->thing = thing:contract_fence
  AND deadline < time::now() AND status != "выполнено";
```

```surql
-- Все исполнители по проекту на любой глубине
SELECT name AS контракт,
       ->assigned_to->thing.name AS исполнитель,
       amount AS сумма, amount_actual AS факт
FROM thing WHERE ->part_of->thing = thing:contract_fence DEPTH 5;

-- Суммарная стоимость всех субподрядов (риск Васи)
SELECT math::sum(amount) AS итого_субподряды
FROM thing WHERE ->part_of->thing = thing:contract_fence
  AND filed_with != thing:vasya;

-- Все активные внешние заказы и их статус
SELECT name, status, deadline, amount, amount_actual,
       ->filed_with->thing.name AS исполнитель,
       ->about->thing.name AS объект
FROM thing WHERE filed_with != NONE
  AND status NOT IN ["выполнено", "отменено"]
ORDER BY deadline ASC;

-- Вещи сейчас в ремонте
SELECT <-contains<-thing[WHERE reason = "ремонт"].*
FROM thing WHERE kind = "физическое";
```

### Перерасход и допсоглашения

Изначальная смета редко совпадает с финалом. Каждое допсоглашение — отдельный `thing part_of` контракта:

```
thing:change_order_1
  name: "Допсоглашение №1: грунтовка рамы"
  amount: 5000
  status: согласовано
  → part_of → thing:contract_fence
  → about   → thing:stage_painting
```

Итоговый бюджет проекта — сумма основного контракта и всех допсоглашений:

```surql
-- Актуальный бюджет с учётом перерасходов
SELECT
    ->part_of->thing[WHERE name = "Договор: забор"].amount AS смета_базовая,
    math::sum(amount) AS сумма_допсоглашений,
    ->part_of->thing[WHERE name = "Договор: забор"].amount
        + math::sum(amount) AS бюджет_итого
FROM thing
WHERE ->part_of->thing = thing:contract_fence
  AND name ~ "Допсоглашение";

-- Все изменения по контракту: что, почему, сколько
SELECT name, amount, status, ->about->thing.name AS касается
FROM thing
WHERE ->part_of->thing = thing:contract_fence
  AND name ~ "Допсоглашение"
ORDER BY created_at ASC;
```

### История счетов

Каждый счёт — отдельный `thing`. Один `about` контракт или конкретный этап,
`produces` — задачу на оплату.

```mermaid
graph TD
    Contract[Договор: забор]
    S1[Этап 1: фундамент\nstatus: выполнено]
    S2[Этап 2: столбы\nstatus: выполнено]

    Inv1[Счёт №1: аванс\namount: 13 500]
    Inv2[Счёт №2: этап 2\namount: 15 000]
    Inv3[Счёт №3: итоговый\namount: 21 500]

    Pay1[Оплата аванса]
    Pay2[Оплата этапа 2]
    Pay3[Финальная оплата]

    Inv1 -->|about| Contract
    Inv2 -->|about| S2
    Inv3 -->|about| Contract
    Inv1 -->|produces| Pay1
    Inv2 -->|produces| Pay2
    Inv3 -->|produces| Pay3
    S1 -->|part_of| Contract
    S2 -->|part_of| Contract
```

```surql
-- Все счета по контракту и их статус оплаты
SELECT name, amount,
       ->about->thing.name AS касается,
       ->produces->thing.name AS задача_оплаты,
       ->produces->thing.status AS статус_оплаты
FROM thing
WHERE ->about->thing = thing:contract_fence
  AND name ~ "Счёт"
ORDER BY created_at ASC;

-- Сколько уже оплачено, сколько осталось
SELECT
    math::sum(amount) AS выставлено_всего,
    math::sum(IF ->produces->thing.status = "выполнено" THEN amount ELSE 0 END) AS оплачено,
    math::sum(IF ->produces->thing.status != "выполнено" THEN amount ELSE 0 END) AS к_оплате
FROM thing
WHERE ->about->thing = thing:contract_fence AND name ~ "Счёт";
```

### Параллельные этапы

`depends_on` образует направленный ациклический граф (DAG).
Несколько `depends_on` у одного узла — AND-логика: этап стартует только когда выполнены **все** предшественники.

```mermaid
graph LR
    Geo[Геодезия]
    Found[Фундамент]
    Mat[Закупка материалов]
    Posts[Монтаж столбов]
    Weld[Сварка секций]
    Paint[Грунтовка / покраска]
    Final[Финальная сборка]

    Posts -->|depends_on| Found
    Posts -->|depends_on| Mat
    Weld -->|depends_on| Posts
    Paint -->|depends_on| Posts
    Final -->|depends_on| Weld
    Final -->|depends_on| Paint
```

`Фундамент` и `Закупка материалов` выполняются параллельно после `Геодезии`.
`Монтаж столбов` ждёт обоих. После него параллельно идут `Сварка` и `Покраска`.
`Финальная сборка` ждёт обоих.

```surql
-- Создать зависимости параллельных этапов
RELATE thing:stage_posts->depends_on->thing:stage_foundation;
RELATE thing:stage_posts->depends_on->thing:stage_materials;
RELATE thing:stage_final->depends_on->thing:stage_welding;
RELATE thing:stage_final->depends_on->thing:stage_painting;

-- Этапы, готовые к запуску (все предшественники выполнены)
SELECT name FROM thing
WHERE ->part_of->thing = thing:contract_fence
  AND status = "не начато"
  AND (
    -- нет входящих depends_on
    count(<-depends_on<-thing) = 0
    OR
    -- все предшественники выполнены
    count(<-depends_on<-thing[WHERE status != "выполнено"]) = 0
  );

-- Критический путь: самая длинная цепочка зависимостей
SELECT name, deadline,
       count(->depends_on->thing) AS зависит_от,
       count(<-depends_on<-thing) AS блокирует
FROM thing
WHERE ->part_of->thing = thing:contract_fence
ORDER BY deadline ASC;
```

## Сценарий: wiki и документация

Темы, страницы, блоки — всё `thing`. Иерархия и теги — через уже существующие рёбра.

### Иерархия тем

```mermaid
graph TD
    Root[Домовая wiki]
    Vehicles[Транспорт]
    Moto[Мотоцикл]
    House[Дом]
    Health[Здоровье]

    Vehicles -->|part_of| Root
    Moto -->|part_of| Vehicles
    House -->|part_of| Root
    Health -->|part_of| Root
```

Тема — просто `thing` с `name`. Вложенность — `part_of`. Глубина произвольная.

### Документ и его блоки

```
thing:doc_to_guide
  name: "Регламент ТО мотоцикла"
  kind: документ
  → part_of → thing:topic_moto       ← основная тема

thing:block_1  text: "Менять масло каждые 10 000 км"  → part_of → thing:doc_to_guide  (order: 1)
thing:block_2  text: "Фильтр воздушный — каждые 5 ТО" → part_of → thing:doc_to_guide  (order: 2)
thing:block_3  text: "Цепь: смазка каждые 500 км"     → part_of → thing:doc_to_guide  (order: 3)
```

Блок — минимальная единица переиспользования. Его можно транскюзировать в другой документ через ребро `references` (режим `live` или `snapshot`).

### Три роли связей от документа

| Ребро | Смысл |
|-------|-------|
| `part_of → тема` | документ принадлежит теме (основная иерархия) |
| `related_to → тема` | документ также про эту тему (дополнительный тег) |
| `about → вещь` | документ про конкретный объект системы |

```
thing:doc_winter_prep  name: "Подготовка мотоцикла к зиме"
  → part_of   → thing:topic_moto        ← основная тема
  → related_to → thing:topic_storage    ← дополнительная тема
  → about      → thing:moto_bmw         ← конкретная вещь
```

### Связь документации с объектами системы

Любой `thing` (мотоцикл, лекарство, договор, рецепт) может иметь прикреплённые документы через `about`:

```surql
-- Вся документация по мотоциклу
SELECT name FROM thing
WHERE ->about->thing = thing:moto_bmw;

-- Все документы в теме "Мотоцикл" включая подтемы
SELECT name FROM thing
WHERE ->part_of->thing = thing:topic_moto
  OR ->related_to->thing = thing:topic_moto;

-- Полное дерево тем с количеством документов
SELECT name,
       count(<-part_of<-thing[WHERE kind = "документ"]) AS документов
FROM thing
WHERE ->part_of->thing = thing:wiki_root
ORDER BY name ASC;
```

### Перекрёстные ссылки между документами

```
thing:block_oil_tip  text: "Масло 10W-40, не менее 3.5 л"
  → part_of → thing:doc_to_guide      ← живёт в регламенте ТО

-- В инструкции по зимнему хранению тот же блок транскюзирован:
thing:ref_oil  → references → thing:block_oil_tip  (mode: live)
thing:ref_oil  → part_of    → thing:doc_winter_prep  (order: 4)
```

Блок редактируется в одном месте, отображается везде где транскюзирован.

### Корневые контейнеры wiki

```
thing:wiki_root    name: "Wiki"        ← корень всего дерева
thing:topic_moto   name: "Мотоцикл"   → part_of → thing:wiki_root
thing:topic_house  name: "Дом"        → part_of → thing:wiki_root
thing:topic_health name: "Здоровье"   → part_of → thing:wiki_root
thing:topic_family name: "Семья"      → part_of → thing:wiki_root
```

## Сценарий: исполняемый код в документах (Jupyter / Quarto-стиль)

Документы могут содержать ячейки с кодом — они исполняются и хранят вывод прямо в графе.
Никаких новых рёбер не нужно: `part_of`, `requires`, `produces`, `represents`, `expert_in`.

### Ячейка кода

Это обычный блок (`part_of` документ), но с `kind: код`:

```
thing:cell_describe
  kind: код
  language: python
  source: "df[['цена', 'количество']].describe()"
  status: выполнено
  executed_at: 2026-05-18T10:00:00Z
  → part_of  → thing:doc_analysis   (order: 5)
  → requires → thing:runtime_python
  → produces → thing:output_describe
```

Поле `status` — тот же набор, что у задач: `не выполнено` / `в процессе` / `выполнено` / `ошибка`.

### Входные данные: единый протокол

Все модули получают данные одинаково — через именованные SurrealQL-запросы в поле `inputs`.
Рантайм выполняет запросы перед запуском ячейки и передаёт результаты как именованные аргументы.
Граф — это и есть шина. Никакой отдельной инфраструктуры не нужно.

```
thing:cell_analysis
  kind: код
  language: python
  inputs:
    расходы:
      query:  "SELECT name, amount, date FROM thing WHERE ->part_of->thing = thing:budget_march"
      format: table
    категории:
      query:  "SELECT name FROM thing WHERE kind = 'категория'"
      format: table
  source: "analyze(расходы, категории)"
  → part_of  → thing:doc_analysis  (order: 3)
  → requires → thing:runtime_python
  → produces → thing:output_analysis
```

Поле `format` — подсказка рантайму как сериализовать результат запроса:

| `format` | Что получает модуль | Типичное применение |
|----------|--------------------|--------------------|
| `table`  | JSON-массив объектов / датафрейм | Python, R, визуализация |
| `text`   | Узлы склеены в markdown-текст | Промпт для AI |
| `graph`  | Узлы + рёбра как вложенный объект | Анализ связей |
| `scalar` | Первое поле первой строки | Одно значение в шаблон |

Это работает одинаково для всех типов модулей:

| Модуль | `format` | Что делает с данными |
|--------|----------|----------------------|
| Python / R | `table` | датафрейм |
| AI (Claude и др.) | `text` | чанки в системный промпт |
| Визуализация | `table` | серии графика |
| SQL-рендер | `table` | HTML-таблица |
| Экспорт (CSV/PDF) | `table` | строки файла |
| Уведомление | `text` | тело сообщения |
| Mermaid / диаграмма | `text` | DSL-код |

### Передача данных между ячейками

Ячейка B читает вывод ячейки A через обычный запрос — вывод уже узел в графе.
`depends_on` гарантирует порядок выполнения:

```
thing:cell_load
  inputs:
    сырые_данные:
      query:  "SELECT * FROM thing WHERE ->about->thing = thing:budget_march"
      format: table
  → produces → thing:output_clean_data    ← результат попадает в граф

thing:cell_chart
  inputs:
    данные:
      query:  "SELECT * FROM thing:output_clean_data"
      format: table
  → depends_on → thing:cell_load          ← ждёт выполнения
  → produces   → thing:output_chart
```

### Контекст для AI-модулей

AI-ячейка — частный случай общего протокола. Запросы формируют контекст (RAG),
граф даёт семантически богатый retrieval без отдельного векторного хранилища:

```
thing:cell_ai_advisor
  kind: код
  language: ai
  inputs:
    контекст:
      query: |
        SELECT name, description, notes,
               ->about->thing.name AS объект,
               ->assigned_to->thing.name AS кому
        FROM thing
        WHERE ->part_of->thing = thing:topic_health
           OR ->about->thing->part_of->thing = thing:topic_health
        ORDER BY created_at DESC LIMIT 20
      format: text        ← склеить узлы в markdown-чанки
    вопрос:
      query:  "SELECT text FROM thing WHERE id = $user_input_id"
      format: scalar
  → requires → thing:ai_claude
  → produces → thing:output_response
```

Три стратегии нарезки чанков (`format: text`):

| Стратегия | Что в чанке |
|-----------|-------------|
| `по-блокам` | один текстовый блок — минимальная единица |
| `по-узлам` | name + description + ключевые поля одного `thing` |
| `по-подграфу` | узел + его соседи (1–2 перехода по рёбрам) |

Граф позволяет точно задать область знаний запросом — не "похожие чанки по вектору",
а "все узлы в теме Здоровье с глубиной 2":

```surql
SELECT name, description, notes,
       ->assigned_to->thing.name AS исполнитель,
       ->about->thing.name AS объект,
       ->filed_with->thing.name AS инстанция
FROM thing
WHERE ->part_of->thing = thing:topic_health DEPTH 2
ORDER BY created_at DESC;
```

### Реактивные ячейки через LIVE SELECT

SurrealDB поддерживает push-уведомления при изменении данных. Ячейка может подписаться
на часть графа и перевыполниться автоматически — без ручного триггера:

```surql
LIVE SELECT * FROM thing
WHERE ->part_of->thing = thing:budget_march;
```

Когда добавляется новый расход — ячейка графика получает событие и перерисовывает вывод.
Это мощнее Jupyter (ручной запуск) и Observable (реактивность только внутри браузера):
данные живут в графе, реакция — на стороне сервера.

### Типы вывода

| `output_type` | Хранение |
|---------------|----------|
| `текст` | поле `text` на узле вывода |
| `таблица` | поле `text` (JSON/CSV) или vault-файл |
| `изображение` | vault-файл через `represents` |
| `ошибка` | поле `text` (traceback) |
| `html` | поле `text` |

```
thing:output_describe
  kind: вывод
  output_type: текст
  status: актуально
  text: "count   100\nmean    42.3\nstd     7.1\n..."
  → part_of → thing:cell_describe

thing:output_plot
  kind: вывод
  output_type: изображение
  status: актуально
  → part_of    → thing:cell_plot
  → represents → thing:file_plot_png    ← vault: ~/.domovoy/files/{id}/plot.png
```

### Рантайм (ядро)

```
thing:runtime_python
  name: "Python 3.11"
  kind: рантайм
  endpoint: "ws://localhost:8888/kernel/abc123"

thing:runtime_r
  name: "R 4.3"
  kind: рантайм
  endpoint: "ws://localhost:8889/kernel/def456"

thing:runtime_deno
  name: "Deno / Observable JS"
  kind: рантайм
  endpoint: "http://localhost:8890"
```

### Пакеты как узлы

Установленные пакеты — `thing part_of рантайм`. Это позволяет проверять совместимость:

```
thing:pkg_pandas   name: "pandas"   version: "2.2.1"  → part_of → thing:runtime_python
thing:pkg_plotly   name: "plotly"   version: "5.20"   → part_of → thing:runtime_python
thing:pkg_ggplot2  name: "ggplot2"  version: "3.5.0"  → part_of → thing:runtime_r
```

```surql
-- Все пакеты в рантайме Python
SELECT name, version FROM thing
WHERE ->part_of->thing = thing:runtime_python AND kind = "пакет"
ORDER BY name ASC;

-- Документы, которые требуют конкретный пакет (транзитивно через ячейки)
SELECT DISTINCT ->part_of->thing.name AS документ
FROM thing
WHERE kind = "код"
  AND ->requires->thing->part_of->thing = thing:pkg_pandas;
```

### Внешние модули рендера

Расширения, которые добавляют поддержку новых языков или источников данных:

```
thing:renderer_sql
  name: "SQL renderer"
  kind: модуль-рендера
  handles: sql
  → filed_with → thing:db_surrealdb   ← к какой БД подключается
  → expert_in  → thing:lang_sql

thing:renderer_observable
  name: "Observable JS"
  kind: модуль-рендера
  handles: javascript
  → expert_in → thing:lang_javascript

thing:renderer_mermaid
  name: "Mermaid диаграммы"
  kind: модуль-рендера
  handles: mermaid
  → expert_in → thing:lang_mermaid
```

Ячейка `requires` модуль рендера так же, как рантайм:

```
thing:cell_diagram
  kind: код
  language: mermaid
  source: "graph TD\n  A-->B"
  → part_of  → thing:doc_architecture  (order: 2)
  → requires → thing:renderer_mermaid
```

### Переисполнение и история выводов

При повторном запуске старый вывод помечается `status: устарело`, создаётся новый:

```surql
-- Пометить старые выводы ячейки устаревшими
UPDATE thing SET status = "устарело"
WHERE ->part_of->thing = thing:cell_describe AND kind = "вывод";

-- Создать новый вывод
CREATE thing SET
  kind = "вывод",
  output_type = "текст",
  status = "актуально",
  text = "...",
  created_at = time::now();
RELATE thing:cell_describe->produces->$new_output;
```

История всех выводов ячейки хранится в графе — можно откатиться или сравнить.

### Документ с кодом: полная картина

```mermaid
graph TD
    Doc[Документ: анализ расходов]
    B1[Блок: заголовок\nkind: текст]
    B2[Блок: загрузка данных\nkind: код, python]
    B3[Блок: описание\nkind: текст]
    B4[Блок: график\nkind: код, python]
    B5[Блок: вывод\nkind: текст]

    Out2[Вывод: таблица]
    Out4[Вывод: изображение]
    File[Файл: chart.png\nвault]
    Runtime[Python 3.11\nрантайм]

    B1 -->|part_of, order 1| Doc
    B2 -->|part_of, order 2| Doc
    B3 -->|part_of, order 3| Doc
    B4 -->|part_of, order 4| Doc
    B5 -->|part_of, order 5| Doc
    B2 -->|produces| Out2
    B4 -->|produces| Out4
    Out4 -->|represents| File
    B2 -->|requires| Runtime
    B4 -->|requires| Runtime
```

```surql
-- Все исполняемые ячейки документа и их статус
SELECT name, language, status, executed_at,
       ->produces->thing[WHERE status = "актуально"].output_type AS тип_вывода
FROM thing
WHERE ->part_of->thing = thing:doc_analysis AND kind = "код"
ORDER BY ->part_of.order ASC;

-- Ячейки с устаревшим выводом (нужно переисполнить)
SELECT name, language FROM thing
WHERE kind = "код"
  AND (
    count(->produces->thing[WHERE status = "актуально"]) = 0
    OR status = "ошибка"
  );
```

## Сценарий: триггеры, оркестрация и управление ресурсами

### Два слоя

```
DB-уровень   — SurrealDB DEFINE EVENT: наблюдает за изменениями таблиц
Граф-уровень — thing-узлы: триггеры, расписания, очереди, воркеры
```

`DEFINE EVENT` замечает изменение → создаёт `thing:job` (задание) → очередь →
воркер забирает задание → запускает внешний модуль → результат попадает обратно в граф.

### Триггер как узел

```
thing:trigger_new_media
  kind: триггер
  event_type: create                                   ← create / update / delete
  condition: "status = 'не начато' AND kind IN ['voice_note','photo','scan']"
  → produces → thing:queue_ai_light                    ← в какую очередь класть задание
```

SurrealDB-уровень, который это активирует:

```surql
DEFINE EVENT fire_trigger ON TABLE thing
  WHEN $event = "CREATE"
    AND $value.status = "не начато"
    AND $value.kind IN ["voice_note", "photo", "scan"]
  THEN {
    CREATE thing SET
      kind        = "задание",
      status      = "ожидает",
      priority    = 5,
      queued_at   = time::now(),
      payload_id  = $value.id
    ;
    RELATE $last->part_of->thing:queue_ai_light;
  };
```

Триггер сам не выполняет работу — только создаёт задание в нужной очереди.

### Расписание как узел

```
thing:schedule_budget_report
  kind: расписание
  cron: "0 9 * * MON"                 ← каждый понедельник в 09:00
  enabled: true
  → produces → thing:queue_reports    ← создаёт задание в очереди
```

Приложение читает активные расписания и создаёт задания по наступлению времени.

### Пайплайн и шаги с обработкой ошибок

Пайплайн — именованный DAG шагов. Шаги — `thing`, связаны `depends_on` и `part_of`:

```
thing:pipeline_ocr_receipt
  kind: пайплайн

thing:step_vision
  kind: шаг
  on_error: retry          ← retry / skip / fail / fallback
  retry_count: 3
  retry_delay: 30          ← секунд между попытками
  → part_of    → thing:pipeline_ocr_receipt  (order: 1)
  → assigned_to → thing:ai_vision            ← внешний модуль

thing:step_parse
  kind: шаг
  on_error: fallback
  → part_of    → thing:pipeline_ocr_receipt  (order: 2)
  → depends_on → thing:step_vision
  → assigned_to → thing:ai_claude
  → produces   → thing:step_parse_fallback   ← альтернативная ветка при ошибке

thing:step_save
  kind: шаг
  on_error: fail
  → part_of    → thing:pipeline_ocr_receipt  (order: 3)
  → depends_on → thing:step_parse
```

### Очереди и воркеры

Ключевой механизм защиты от перегрузки. Тяжёлые и лёгкие задачи — в разных очередях:

```
thing:queue_ai_heavy
  kind: очередь
  max_concurrent: 1          ← не более одного тяжёлого AI одновременно
  priority_strategy: fifo    ← fifo / priority / deadline

thing:queue_ai_light
  kind: очередь
  max_concurrent: 4          ← лёгкие задачи идут параллельно

thing:queue_reports
  kind: очередь
  max_concurrent: 1
  priority_strategy: deadline
```

Воркер — процесс или машина, которая обслуживает очередь:

```
thing:worker_local_cpu
  kind: воркер
  status: свободен           ← свободен / занят / офлайн
  resources: {cpu: 4, ram_gb: 8}
  → part_of → thing:queue_ai_light

thing:worker_gpu_server
  kind: воркер
  status: свободен
  resources: {gpu: 1, vram_gb: 8, ram_gb: 32}
  → part_of → thing:queue_ai_heavy
```

```mermaid
graph TD
    Trigger[Триггер:\nновое фото чека]
    JobQ[Задание\nstatus: ожидает]
    QL[Очередь ai_light\nmax_concurrent: 4]
    QH[Очередь ai_heavy\nmax_concurrent: 1]
    WL[Воркер CPU\nстатус: свободен]
    WH[Воркер GPU\nстатус: занят]
    P[Пайплайн: OCR чека]
    Out[Результат в графе]

    Trigger -->|CREATE задание| JobQ
    JobQ -->|part_of| QL
    QL -->|воркер забирает| WL
    WL -->|запускает| P
    P -->|produces| Out
    QH -->|ждёт| WH
```

### Бюджет ресурсов

Защита от перерасхода API-токенов или локальных ресурсов:

```
thing:budget_claude_daily
  kind: бюджет-ресурса
  resource: claude_tokens
  limit: 100000
  used: 47000
  period: день
  reset_at: 2026-05-19T00:00:00Z

thing:budget_whisper_hourly
  kind: бюджет-ресурса
  resource: whisper_minutes
  limit: 60
  used: 12
  period: час
```

Воркер проверяет бюджет перед запуском задания. Если лимит исчерпан — задание остаётся
в очереди до сброса счётчика.

### Автоматический выключатель (circuit breaker)

Если внешний модуль начинает падать — перестаём его дёргать:

```
thing:breaker_ai_claude
  kind: автовыключатель
  status: закрыт             ← закрыт (норма) / открыт (стоп) / полуоткрыт (проверка)
  error_count: 0
  error_threshold: 5         ← N ошибок подряд → открыть
  recovery_timeout: 120      ← сек до следующей попытки
  → about → thing:ai_claude
```

```surql
-- Все задания в очереди, упорядоченные по приоритету и времени
SELECT name, priority, queued_at, ->part_of->thing.name AS очередь
FROM thing
WHERE kind = "задание" AND status = "ожидает"
ORDER BY priority DESC, queued_at ASC;

-- Нагрузка по воркерам
SELECT name, status,
       count(<-part_of<-thing[WHERE kind = "задание" AND status = "выполняется"]) AS активных
FROM thing WHERE kind = "воркер";

-- Бюджеты ресурсов: что близко к лимиту
SELECT name, resource, used, limit,
       math::round((used / limit) * 100) AS процент
FROM thing
WHERE kind = "бюджет-ресурса"
ORDER BY процент DESC;

-- Открытые автовыключатели (модули с проблемами)
SELECT name, error_count, ->about->thing.name AS модуль
FROM thing
WHERE kind = "автовыключатель" AND status = "открыт";
```

## Сценарий: внешние модули через REST API и источники данных

### REST API контракт модуля

Любой внешний модуль — это HTTP-сервис с единым контрактом.
Рантайм вызывает его POST-запросом, передаёт готовые данные, получает результат:

```
POST http://module-host/execute
Content-Type: application/json

{
  "inputs": {
    "расходы": [                      ← результат SurrealQL-запроса
      {"name": "Молоко", "amount": 98},
      {"name": "Хлеб",   "amount": 45}
    ],
    "порог": 500                      ← scalar
  },
  "output_node": "thing:output_123",  ← куда записать результат
  "job_id": "thing:job_456"           ← для статуса и логов
}

→ 200 OK
{
  "status": "ok",
  "result": { ... }                   ← рантайм запишет в output_node
}
```

Модуль не знает про SurrealDB — он получает готовые данные и возвращает результат.
Язык реализации, рантайм, платформа — произвольные.

```
thing:module_budget_analyzer
  kind: внешний-модуль
  endpoint: "http://localhost:7001/execute"
  handles: [python]
  → expert_in → thing:lang_python

thing:module_chart_renderer
  kind: внешний-модуль
  endpoint: "http://chart-service.local/execute"
  handles: [vega, plotly]
```

### DataSource: универсальный источник данных

`datasource` расширяет протокол `inputs` — вместо SurrealQL-запроса к локальному графу
можно обратиться к любому внешнему источнику через единый системный модуль-коннектор.

```
thing:ds_home_assistant
  kind: источник-данных
  type: rest
  base_url: "http://homeassistant.local:8123/api"
  auth_type: bearer
  → can_access → thing:secret_ha_token

thing:ds_postgres
  kind: источник-данных
  type: sql
  driver: postgresql
  endpoint: "postgresql://localhost:5432/home_db"
  → can_access → thing:secret_pg_creds

thing:ds_granny_domovoy
  kind: источник-данных
  type: domovoy
  endpoint: "https://granny.local/api"
  → can_access → thing:secret_granny_key
```

Поддерживаемые типы:

| `type` | Протокол | Формат запроса |
|--------|----------|----------------|
| `domovoy` | SurrealQL over HTTP | SurrealQL строка |
| `rest` | HTTP REST | path + method + params |
| `sql` | SQL (postgres/sqlite/mysql) | SQL строка |
| `graphql` | GraphQL | GraphQL query |
| `surreal` | SurrealDB напрямую | SurrealQL строка |
| `file` | Локальный/remote файл | путь + формат |
| `mqtt` | MQTT subscribe | topic-паттерн |

### Расширенный протокол inputs

Ячейка может смешивать локальные запросы и внешние источники:

```
thing:cell_ha_report
  kind: код
  language: python
  inputs:
    температура:
      datasource: thing:ds_home_assistant    ← внешний REST
      path: "/states/sensor.living_room_temperature"
      method: GET
      format: scalar

    движение:
      datasource: thing:ds_home_assistant
      path: "/states/binary_sensor.motion_hall"
      method: GET
      format: scalar

    задачи_дома:
      query: "SELECT name, status FROM thing WHERE kind = 'задача' AND status != 'выполнено'"
      format: table                          ← локальный граф

    норма_температуры:
      datasource: thing:ds_postgres          ← внешняя SQL БД
      sql: "SELECT value FROM settings WHERE key = 'temp_norm'"
      format: scalar

  source: "make_report(температура, движение, задачи_дома, норма_температуры)"
  → requires → thing:runtime_python
  → produces → thing:output_ha_report
```

Если указан `datasource` — рантайм маршрутизирует запрос через системный коннектор.
Если указан `query` — выполняет локально в SurrealDB. Результат всегда одинаковый.

### Системный модуль-коннектор

Встроенный модуль, который знает как говорить с каждым типом источника:

```
thing:module_datasource_connector
  kind: системный-модуль
  name: "DataSource Connector"
  endpoint: "http://localhost:9000/execute"
  handles: [domovoy, rest, sql, graphql, file, mqtt]
```

Коннектор:
1. Читает определение `datasource` из графа
2. Забирает credentials через `can_access` → secrets
3. Выполняет запрос в нужном протоколе
4. Возвращает результат в унифицированном формате
5. Кэширует если указан `cache_ttl`

### Пример: Home Assistant → задача по температуре

Триггер по расписанию — раз в 5 минут проверяет датчики и создаёт задачу при отклонении:

```
thing:trigger_temp_check
  kind: расписание
  cron: "*/5 * * * *"
  → produces → thing:queue_ai_light

-- Пайплайн:
thing:step_fetch_temp
  kind: шаг
  inputs:
    temp:
      datasource: thing:ds_home_assistant
      path: "/states/sensor.boiler_temperature"
      format: scalar
  → assigned_to → thing:module_datasource_connector

thing:step_decide
  kind: шаг
  inputs:
    temp:
      query: "SELECT result.temp FROM thing:step_fetch_temp->produces->thing"
      format: scalar
    threshold:
      query: "SELECT value FROM thing WHERE name = 'Порог температуры котла'"
      format: scalar
  source: "if temp < threshold: create_task('Проверить котёл')"
  → assigned_to → thing:ai_claude
  → depends_on  → thing:step_fetch_temp
```

### Федерация между инстанциями Домового

Несколько домов — каждый со своим Домовым, данные объединяются по запросу:

```mermaid
graph TD
    Home[Домовой: наш дом]
    Granny[Домовой: бабушка\ngranny.local]
    Dacha[Домовой: дача\ndacha.local]

    DS_G[ds_granny_domovoy\ntype: domovoy]
    DS_D[ds_dacha_domovoy\ntype: domovoy]

    Home -->|can_access| DS_G
    Home -->|can_access| DS_D
```

```
thing:cell_family_health
  inputs:
    наши_визиты:
      query: "SELECT name, date FROM thing WHERE kind = 'приём' ORDER BY date DESC LIMIT 5"
      format: table

    бабушкины_визиты:
      datasource: thing:ds_granny_domovoy
      query: "SELECT name, date FROM thing WHERE kind = 'приём' ORDER BY date DESC LIMIT 5"
      format: table
```

Данные бабушки остаются у неё. Мы запрашиваем только то, на что есть `can_access`.

```surql
-- Все зарегистрированные источники данных
SELECT name, type, endpoint FROM thing
WHERE kind = "источник-данных"
ORDER BY type, name;

-- Источники с истёкшими или отсутствующими credentials
SELECT name, type, endpoint
FROM thing
WHERE kind = "источник-данных"
  AND count(->can_access->thing) = 0;

-- Все ячейки, использующие внешние источники (не только локальный граф)
SELECT name, language,
       ->part_of->thing.name AS документ
FROM thing
WHERE kind = "код"
  AND inputs[*].datasource != NONE;
```

## Сценарий: федерация и репликация между инстанциями

### Два режима

| Режим | Пример | Синхронизация |
|-------|--------|---------------|
| **Свои дома** | главный дом ↔ дача | двусторонняя, один граф в двух местах |
| **Чужой Домовой** | Домовой друга | изолированное теневое пространство |

### Инстанция Домового как узел

```
thing:domovoy_main
  kind: домовой-инстанция
  name: "Главный дом"
  instance_id: "a1b2c3d4"         ← глобально уникальный UUID
  endpoint: "https://home.local/api"
  public_key: "ed25519:..."        ← для аутентификации при синхронизации
  last_sync_at: datetime

thing:domovoy_dacha
  kind: домовой-инстанция
  name: "Дача"
  instance_id: "e5f6g7h8"
  endpoint: "https://dacha.local/api"
  public_key: "ed25519:..."
  last_sync_at: datetime
```

### Лог изменений

Каждое изменение поля — отдельная запись. Основа всей репликации:

```surql
DEFINE TABLE change_log SCHEMALESS;
-- node_id:    запись-источник (thing:*)
-- operation:  create | update | delete
-- field:      имя поля (для update)
-- old_value:  предыдущее значение
-- new_value:  новое значение
-- hlc:        Hybrid Logical Clock — строка "физическое_время-счётчик-instance_id"
-- origin:     thing:domovoy_* — кто сделал изменение
-- synced_to:  set<record<thing>> — каким инстанциям уже отправлено

DEFINE INDEX idx_log_hlc    ON change_log FIELDS hlc;
DEFINE INDEX idx_log_origin ON change_log FIELDS origin, hlc;
DEFINE INDEX idx_log_node   ON change_log FIELDS node_id, field;
```

**Hybrid Logical Clock (HLC)** — не wall clock, а логические часы с физическим компонентом.
Устойчивы к расхождению системного времени между домами. Формат:
`"2026-05-19T10:00:00.000Z-0003-a1b2c3d4"` — время + счётчик + instance_id.

При создании/изменении любого узла — запись в `change_log` автоматически:

```surql
DEFINE EVENT log_changes ON TABLE thing
  WHEN $event IN ["CREATE", "UPDATE", "DELETE"]
  THEN {
    CREATE change_log SET
      node_id   = $value.id,
      operation = $event,
      hlc       = hlc::now(),           -- функция рантайма
      origin    = $session.instance_id,
      new_value = $value,
      old_value = $before
    ;
  };
```

### Протокол синхронизации (своих домов)

Работает при любом порядке подключения — дача, дом, дача снова:

```
1. A → B: "мой последний known HLC от тебя: T_last"
2. B → A: change_log WHERE origin = B AND hlc > T_last
3. A применяет изменения (merge)
4. A → B: то же самое в обратную сторону
5. Оба обновляют last_sync_at
```

```surql
-- Изменения которые нужно отправить инстанции thing:domovoy_dacha
SELECT * FROM change_log
WHERE hlc > (SELECT last_sync_hlc FROM sync_state WHERE peer = thing:domovoy_dacha)
  AND origin = thing:domovoy_main
  AND thing:domovoy_dacha NOT INSIDE synced_to
ORDER BY hlc ASC;
```

### Разрешение конфликтов

Конфликт = оба изменили одно поле `node:field` пока были офлайн.

| Ситуация | Правило | Причина |
|----------|---------|---------|
| Оба записали одинаковое значение | Нет конфликта, применить | Идемпотентно |
| Поля разные (разные fields одного node) | Нет конфликта, применить оба | Не пересекаются |
| `status`: оба продвинули вперёд | Применить наибольший по шкале | Выполнено > в процессе > не начато |
| `status`: один продвинул, другой откатил | Применить продвинутый (необратимость) | Выполненное не отменяется автоматически |
| Текстовое поле: оба изменили | LWW по HLC + флаг `has_conflict: true` | Требует внимания |
| Set-поле (теги, права): оба добавляли | Union (объединение) | Нет конфликта возможно |
| Set-поле: один добавил, другой удалил | Удаление побеждает (CRDT OR-Set) | Явное действие приоритетнее |
| Узел удалён на одной, изменён на другой | Сохранить + `deletion_attempted: true` | Пользователь решает |

```surql
-- Все узлы с неразрешёнными конфликтами
SELECT id, name, kind, conflict_fields FROM thing
WHERE has_conflict = true
ORDER BY updated_at DESC;

-- Детали конфликта по полю
SELECT field, old_value, new_value, hlc, origin.name AS источник
FROM change_log
WHERE node_id = thing:task_1 AND field = "status"
ORDER BY hlc DESC LIMIT 5;
```

### Scope репликации

Не всё должно реплицироваться везде:

```
thing:task_dacha_garden
  name: "Посадить картошку"
  replicate_to: [thing:domovoy_dacha]    ← только на дачу

thing:family_budget
  replicate_to: [thing:domovoy_dacha, thing:domovoy_main]  ← оба дома

thing:personal_diary
  replicate_to: []                        ← только локально
```

Контейнер наследует scope дочерним узлам:
```
thing:dacha_container
  replicate_to: [thing:domovoy_dacha]
  -- все part_of этого контейнера реплицируются на дачу
```

### Теневое пространство: Домовой друга

Друг дал доступ к части своего графа. Его узлы реплицируются в **изолированное пространство** — не смешиваются с твоими:

```
thing:shadow__e5f6g7h8__task_abc
  name: "Починить мотоцикл"              ← данные из графа друга
  _shadow: true
  _origin_instance: thing:domovoy_friend
  _origin_id: "thing:task_abc"           ← оригинальный ID у друга
  _read_only: true                       ← если доступ только view
  _synced_at: datetime
```

Префикс `shadow__<instance_id>__` гарантирует отсутствие коллизий ID.

Ты можешь связывать свои узлы с теневыми через обычные рёбра:

```
thing:my_task_help_friend
  name: "Помочь Максу с мотоциклом"
  → related_to → thing:shadow__e5f6g7h8__task_abc   ← ссылка на его задачу
  → assigned_to → Папа
```

```mermaid
graph TD
    subgraph Мой граф
        MyTask[Помочь Максу\nмой узел]
        MyContact[Макс\nмой контакт]
    end

    subgraph Теневое пространство Макса
        ShadowTask[Починить мотоцикл\n_shadow: true\n_read_only: true]
        ShadowBike[Мотоцикл Макса\n_shadow: true]
    end

    MyTask -->|related_to| ShadowTask
    MyTask -->|assigned_to| MyContact
    ShadowTask -->|about| ShadowBike
```

**Если друг дал право `edit`** — изменения в теневых узлах пишутся в `change_log`
с `origin: my_instance` и отправляются другу при следующей синхронизации.
Друг применяет их с теми же LWW-правилами.

```surql
-- Все теневые пространства и когда последний раз синхронизировались
SELECT _origin_instance.name AS домовой,
       count() AS узлов,
       max(_synced_at) AS последняя_синхр
FROM thing
WHERE _shadow = true
GROUP BY _origin_instance;

-- Теневые узлы которые изменились у друга с последней синхронизации
SELECT _origin_id, name, _synced_at FROM thing
WHERE _shadow = true
  AND _origin_instance = thing:domovoy_friend
  AND _synced_at < thing:domovoy_friend.last_sync_at;

-- Мои узлы, связанные с теневыми (зависимости от чужого графа)
SELECT name, ->related_to->thing[WHERE _shadow = true].name AS теневые_связи
FROM thing
WHERE _shadow != true
  AND count(->related_to->thing[WHERE _shadow = true]) > 0;
```

### Офлайн-устойчивость

```
Нет связи между домами:
  → каждый работает независимо
  → change_log накапливается локально
  → при появлении связи: exchange logs, merge, resolve conflicts

Нет интернета совсем:
  → локальный Домовой работает полностью
  → теневые пространства не обновляются (данные freeze на момент последней синхр)
  → datasource с type: domovoy недоступен → fallback на кэш или пустой результат
```

## Сценарий: публичный граф

### Принципал thing:public

Специальный узел-группа. Неаутентифицированный HTTP-запрос трактуется как этот принципал.
Не нужно создавать отдельных пользователей — достаточно `can_access`:

```
thing:public
  kind: группа
  name: "Все (без аутентификации)"
```

Любой контейнер или узел становится публичным одним ребром:

```surql
RELATE thing:catalog_electronics->can_access->thing:public
  SET permissions = ["view"], granted_by = thing:owner, status = "active";
```

### Публикация как узел

Обёртка с метаданными — slug для URL, режим live или snapshot:

```
thing:pub_electronics
  kind: публикация
  slug: "electronics-catalog"
  published_at: 2026-05-19T10:00:00Z
  live: true              ← true = всегда текущее состояние контейнера
                          ← false = snapshot на момент публикации
  → about → thing:catalog_electronics   ← что публикуется
  → can_access ← thing:public           ← доступно всем
```

URL вида `https://домовой.local/pub/electronics-catalog` → резолвится в `thing:pub_electronics`
→ отдаёт дерево `thing:catalog_electronics` с его `part_of`-потомками.

### Каталог магазина

```mermaid
graph TD
    Pub[Публикация: каталог\nslug: electronics-catalog\nlive: true]
    Cat[Каталог: Электроника]
    C1[Категория: Телефоны]
    C2[Категория: Ноутбуки]

    P1[Смартфон XYZ\nprice: 25000\nstock: 14]
    P2[Смартфон ABC\nprice: 18000\nstock: 0]
    P3[Ноутбук DEF\nprice: 65000\nstock: 3]

    QR1[QR-код\ncode_value: SKU-001]
    QR2[QR-код\ncode_value: SKU-002]

    Pub -->|about| Cat
    C1 -->|part_of| Cat
    C2 -->|part_of| Cat
    P1 -->|part_of| C1
    P2 -->|part_of| C1
    P3 -->|part_of| C2
    P1 -->|identified_by| QR1
    P2 -->|identified_by| QR2
```

Поля товара — обычные поля `thing`:

```
thing:product_phone_xyz
  name: "Смартфон XYZ 256GB"
  description: "..."
  price: 25000
  stock: 14
  sku: "SKU-001"
  images: ["file_id_1", "file_id_2"]   ← ID файлов в vault
  → part_of      → thing:cat_phones
  → identified_by → thing:qr_sku001    ← физический QR на товаре
  → can_access   ← thing:public        ← карточка публична
```

Покупатель сканирует QR в магазине → `identified_by` → `thing:product_phone_xyz` →
публичная карточка с описанием, ценой, наличием.

### Публичный квиз

Вопросы публичны, попытки хранятся в Домовом участника:

```
-- У автора квиза (его Домовой):
thing:quiz_geography
  kind: квиз
  name: "География мира"
  → can_access ← thing:public           ← квиз публичен

thing:q1  text: "Столица Бразилии?"
  → part_of → thing:quiz_geography
  → can_access ← thing:public           ← вопросы публичны

-- У участника (его собственный Домовой):
thing:my_attempt_geo
  kind: попытка
  started_at: 2026-05-19T11:00:00Z
  score: 7
  → about → thing:shadow__abc123__quiz_geography   ← теневая копия квиза

thing:my_ans_1
  chosen: "Бразилиа"
  correct: true
  points_earned: 1
  → answered → thing:shadow__abc123__q1            ← теневая копия вопроса
  → part_of  → thing:my_attempt_geo
```

Автор видит агрегированную статистику только если участники дали явный `can_access` на попытки.

### Взаимодействия: где хранятся

| Действие | Где живёт |
|----------|-----------|
| Карточка товара | Домовой продавца, публична |
| Корзина покупателя | Домовой покупателя |
| Попытка квиза | Домовой участника |
| Ссылка на публичный узел | Теневая копия в Домовом участника |
| Рейтинг / отзыв | Домовой автора отзыва, `about` → теневой узел |

Публичный граф остаётся read-only для посетителей. Взаимодействия — в своём графе,
связанные с теневыми копиями через обычные рёбра.

### Подписка на чужой публичный каталог

Публичный Домовой — частный случай `datasource` без токена аутентификации:

```
thing:ds_shop_electronics
  kind: источник-данных
  type: domovoy
  endpoint: "https://shop.example.com/pub/electronics-catalog"
  auth_type: none                         ← публичный, без токена
```

Использование в ячейке или триггере:

```
inputs:
  новые_товары:
    datasource: thing:ds_shop_electronics
    query: "SELECT name, price, stock FROM thing WHERE part_of = thing:cat_phones AND stock > 0"
    format: table
```

Можно настроить расписание — раз в час синхронизировать публичный каталог в теневое
пространство и отправлять уведомление если появился интересующий товар.

### Частично публичный граф

Один контейнер публичен, остальное приватно:

```
thing:домовой_пользователя
  ├── thing:personal_stuff        ← приватно (нет can_access ← public)
  ├── thing:work_projects         ← приватно
  └── thing:pub_container         ← can_access ← thing:public
        ├── thing:quiz_public     ← наследует публичность контейнера
        └── thing:catalog_public  ← наследует публичность контейнера
```

Публичность контейнера не распространяется автоматически — она применяется явно
к нужным дочерним узлам при выдаче `can_access`. Контейнер как точка входа:
запрос возвращает только узлы с явным `can_access ← thing:public`.

```surql
-- Все публичные публикации этого Домового
SELECT slug, published_at, live,
       ->about->thing.name AS контент
FROM thing
WHERE kind = "публикация"
  AND ->can_access->thing = thing:public
ORDER BY published_at DESC;

-- Публичные узлы конкретного контейнера (что видит посетитель)
SELECT name, kind, price, stock, description
FROM thing
WHERE ->part_of->thing = thing:catalog_electronics
  AND <-can_access<-thing[WHERE id = thing:public] != NONE;

-- Статистика: сколько теневых копий этого каталога у других
SELECT count() AS реплик
FROM thing
WHERE _shadow = true
  AND _origin_id INSIDE (
    SELECT id FROM thing WHERE ->part_of->thing = thing:catalog_electronics
  );
```

### Локальная копия публичного графа

Два режима: синхронизируемая тень и независимый клон. Выбор зависит от намерения.

**Синхронизируемая тень** — узлы живут в теневом пространстве, обновляются при каждой синхронизации. Источник изменился — у тебя тоже. Уже описана в разделе федерации.

**Независимый клон** — одноразовый импорт. Связь с источником обрывается, ты владеешь копией и можешь её редактировать. Источник больше не влияет.

```
-- Клон публичного квиза для кастомизации
thing:my_quiz_geography
  name: "География мира"          ← скопированные данные
  _cloned_from: "thing:quiz_geo"  ← аудит: откуда взят оригинал
  _cloned_instance: "abc123"      ← instance_id источника
  _cloned_at: 2026-05-19
  -- нет _shadow, нет _read_only — полноценный твой узел
```

Дочерние узлы (вопросы квиза, товары каталога) клонируются рекурсивно по `part_of`:

```surql
-- Импорт: создать клоны всего дерева публичного контейнера
LET $source = (SELECT id, * FROM thing WHERE ->part_of->thing = thing:pub_quiz_geo DEPTH 5);
FOR $node IN $source {
  CREATE thing CONTENT {
    ...$node,
    id: rand::uuid(),              -- новый локальный ID
    _cloned_from: $node.id,
    _cloned_instance: $node._origin_instance OR "abc123",
    _cloned_at: time::now()
  };
};
```

Сравнение двух режимов:

| | Тень (`_shadow`) | Клон (`_cloned_from`) |
|-|------------------|-----------------------|
| Источник обновился → у тебя тоже | да | нет |
| Можешь редактировать | только при `edit`-доступе | да, полностью |
| Источник исчез — данные остались | да | да |
| Хочешь форкнуть и кастомизировать | нет | да |
| Каталог с актуальными ценами | ✓ | |
| Квиз для правки и адаптации | | ✓ |
| Шаблон документа — взять за основу | | ✓ |

```surql
-- Все клоны и их источники
SELECT _cloned_from AS оригинал, _cloned_instance AS откуда,
       _cloned_at, name
FROM thing
WHERE _cloned_from != NONE
ORDER BY _cloned_at DESC;
```

### Синхронизация клона с источником

Клон может подписаться на обновления из источника. Три поля управляют поведением:

```
thing:my_quiz_geography
  _cloned_from:         "thing:quiz_geo"
  _cloned_instance:     "abc123"
  _cloned_at:           2026-05-19T10:00:00Z
  _sync_upstream:       true                   ← подписан на обновления
  _last_upstream_sync:  2026-05-19T10:00:00Z   ← водяной знак — откуда тянуть
  _sync_policy:         merge                  ← merge | upstream-wins | local-wins
```

**Три политики синхронизации:**

| Политика | Поведение | Когда использовать |
|----------|-----------|-------------------|
| `upstream-wins` | источник всегда перезаписывает | каталог цен, справочник |
| `local-wins` | применять только новые поля, пропускать отредактированные | кастомизированный шаблон |
| `merge` | LWW по HLC + флаг конфликта при истинных столкновениях | совместный квиз |

**Алгоритм синхронизации клона:**

```
1. Запросить у источника change_log WHERE hlc > _last_upstream_sync
2. Для каждого изменения найти локальный клон по _cloned_from = original_id
3. Применить по политике:
     upstream-wins → UPDATE local SET field = new_value
     local-wins    → UPDATE local SET field = new_value
                       только если поле не менялось локально после _cloned_at
     merge         → если local.field не менялось → apply
                     если оба менялись → LWW по HLC, при равенстве → has_conflict: true
4. Обновить _last_upstream_sync = max(hlc обработанных изменений)
```

```surql
-- Изменения в источнике после последней синхронизации клона
-- (выполняется через datasource к источнику)
SELECT node_id, field, new_value, hlc FROM change_log
WHERE hlc > $last_upstream_sync
  AND node_id INSIDE $cloned_origin_ids
ORDER BY hlc ASC;

-- Клоны с подпиской, у которых источник обновился
SELECT name, _cloned_instance, _last_upstream_sync,
       _sync_policy
FROM thing
WHERE _sync_upstream = true
  AND _cloned_from != NONE
ORDER BY _last_upstream_sync ASC;

-- Клоны с неразрешёнными конфликтами после merge
SELECT name, conflict_fields FROM thing
WHERE _cloned_from != NONE AND has_conflict = true;
```

**Автоматическая синхронизация по расписанию:**

```
thing:schedule_clone_sync
  kind: расписание
  cron: "0 * * * *"          ← каждый час
  → produces → thing:queue_sync_clones

-- Пайплайн для каждого подписанного клона:
-- 1. Получить change_log из источника (datasource)
-- 2. Применить по политике
-- 3. Обновить _last_upstream_sync
-- 4. Если merge + конфликт → создать задачу для пользователя
```

**Уведомление о значимых обновлениях:**

Не все изменения в источнике одинаково важны. Можно подписаться на конкретные поля:

```
thing:my_quiz_geography
  _watch_fields: ["questions", "correct_answer"]   ← только эти поля триггерят уведомление
  _ignore_fields: ["view_count", "updated_at"]     ← эти пропускать тихо
```

---

## Сценарий: небольшая коммерция

Жена продаёт поделки, семена, саженцы и БУ-вещи. Всё это уже вещи в инвентаре —
нужны только объявления, заказы и связи между ними.

### Объявление (листинг)

```
thing:listing_tomato_seeds
  kind: объявление
  price: 100
  price_unit: "за 10 шт"
  quantity_available: 150
  status: активно            ← активно | снято | распродано
  → about       → thing:seeds_tomato_own   ← что продаётся (из инвентаря)
  → assigned_to → thing:mom                ← продавец
  → can_access  ← thing:public             ← видно всем
```

Типы листингов:

| Тип | Признак | Пример |
|-----|---------|--------|
| Готовый товар | `quantity_available > 1` | пакеты семян |
| Уникальный | `quantity_available: 1` | конкретная поделка |
| Предзаказ | `available_from: дата` | саженцы осенью |
| Кастомный | нет листинга, заказ напрямую | "сделай вот такой венок" |

### Заказ

Покупатель — `participant, role: заказчик`. Роль уже есть в модели.

```
thing:order_001
  kind: заказ
  status: новый              ← новый | подтверждён | оплачен | собирается | отправлен | выполнен | отменён
  amount: 300
  notes: "3 пакета помидоров черри"
  created_at: 2026-05-19
  → about       → thing:listing_tomato_seeds   ← что заказали
  → assigned_to → thing:mom                    ← исполнитель
  → participant[role: заказчик] → thing:customer_anna
  → produces    → thing:payment_001
  → produces    → thing:shipment_001
```

При выполнении заказа — инвентарь уменьшается через `used`:

```surql
RELATE thing:order_001->used->thing:seeds_tomato_own SET quantity = 30, unit = "шт";
UPDATE thing:listing_tomato_seeds SET quantity_available -= 30;
```

### Предзаказ: саженцы осенью

Покупатель заказывает весной — доставка в октябре. Заказ сразу создаёт задачу в будущем:

```mermaid
graph TD
    Customer[Пётр\nпокупатель]
    Order[Заказ: саженцы антоновки 2шт\nstatus: подтверждён\ndeadline: 1 октября]
    Task[Задача: выкопать саженцы\ndeadline: 1 октября\nstatus: не начато]
    Payment[Оплата: 500р\nstatus: ожидает]
    Shipment[Отправка\nstatus: не начато]
    Sapling[Яблоня Антоновка\nиз сада]

    Customer -->|participant, заказчик| Order
    Order -->|about| Sapling
    Order -->|produces| Task
    Order -->|produces| Payment
    Task -->|produces| Shipment
    Task -->|assigned_to| Mom[Мама]
    Task -->|about| Sapling
```

```
thing:order_sapling_apple
  kind: заказ
  status: подтверждён
  amount: 500
  deadline: 2026-10-01
  notes: "антоновка, 2 штуки, самовывоз или СДЭК"
  → about                      → thing:apple_tree_antonovka
  → participant[role: заказчик] → thing:customer_petr
  → assigned_to                → thing:mom
  → produces                   → thing:task_dig_saplings
  → produces                   → thing:payment_sapling

thing:task_dig_saplings
  name: "Выкопать саженцы антоновки — Пётр"
  deadline: 2026-10-01
  status: не начато
  → assigned_to → thing:mom
  → about       → thing:order_sapling_apple
  → produces    → thing:shipment_sapling
```

Задача появится в планировщике на октябрь. Когда выполнена — `produces` создаёт отправку,
отправка трекается как обычная доставка (уже в модели).

### БУ-вещи

Вещь уже в инвентаре — достаточно повесить листинг:

```
thing:listing_blender_old
  kind: объявление
  price: 1500
  quantity_available: 1       ← уникальный товар
  status: активно
  → about → thing:blender_phillips   ← вещь из инвентаря
  → can_access ← thing:public

-- При продаже:
UPDATE thing:listing_blender_old SET status = "распродано";
RELATE thing:blender_phillips->lent_to->thing:customer_maria
  SET since = time::now();    ← временно, пока не передали физически
-- После передачи:
-- contains переключается, lent_to убирается
```

### Кастомный заказ (без листинга)

Клиент пишет напрямую: "сделай венок из сухоцветов, диаметр 30см":

```
thing:order_custom_wreath
  kind: заказ
  status: новый
  amount: 800
  notes: "венок из сухоцветов, D=30см, цвета: бежевый, терракотовый"
  deadline: 2026-06-01
  → participant[role: заказчик] → thing:customer_lena
  → assigned_to                → thing:mom
  → produces                   → thing:task_make_wreath
  → produces                   → thing:payment_wreath

thing:task_make_wreath
  name: "Сделать венок для Лены"
  deadline: 2026-05-28        ← раньше дедлайна заказа
  → produces → thing:wreath_result   ← готовое изделие
  → requires → thing:dried_flowers   ← расход материалов
  → requires → thing:wire_frame
```

### Публичный магазин

```
thing:pub_moms_shop
  kind: публикация
  slug: "moms-garden"
  live: true
  → about → thing:shop_container
  → can_access ← thing:public

thing:shop_container
  ├── thing:listing_tomato_seeds      (активно)
  ├── thing:listing_cucumber_seeds    (активно)
  ├── thing:listing_saplings_apple    (активно, available_from: сентябрь)
  ├── thing:listing_bracelet_blue     (активно)
  └── thing:listing_blender_old       (распродано)
```

### Аналитика

```surql
-- Выручка за месяц
SELECT math::sum(amount) AS выручка
FROM thing
WHERE kind = "заказ"
  AND status IN ["оплачен", "выполнен"]
  AND created_at > time::now() - 30d;

-- Что продаётся лучше
SELECT ->about->thing.name AS товар, count() AS заказов,
       math::sum(amount) AS выручка
FROM thing
WHERE kind = "заказ" AND status != "отменён"
GROUP BY ->about->thing
ORDER BY заказов DESC;

-- Ожидающие заказы с дедлайном
SELECT name, status, deadline, amount,
       ->participant[role = "заказчик"]->thing.name AS покупатель
FROM thing
WHERE kind = "заказ"
  AND status NOT IN ["выполнен", "отменён"]
ORDER BY deadline ASC;

-- Запас: что заканчивается
SELECT ->about->thing.name AS товар, quantity_available
FROM thing
WHERE kind = "объявление" AND status = "активно"
  AND quantity_available < 10
ORDER BY quantity_available ASC;

-- Будущие задачи из предзаказов
SELECT name, deadline, ->about->thing.name AS заказ,
       ->participant[role = "заказчик"]->thing.name AS покупатель
FROM thing
WHERE kind = "задача" AND status = "не начато"
  AND <-produces<-thing.kind = "заказ"
ORDER BY deadline ASC;
```

## Сценарий: интернет-магазин

Расширение небольшой коммерции: варианты товара, корзина, платёжный шлюз, возвраты,
витрина как публичный граф. Новых рёбер не нужно.

### Структура товара с вариантами

Базовый товар — контейнер. Варианты (цвет, размер, фасовка) — `part_of` него:

```mermaid
graph TD
    Product[Браслет макраме\nkind: товар]
    V1[Вариант: красный\nkind: вариант\nprice: 650\nqty_total: 10\nqty_reserved: 2\nqty_available: 8\nsku: BRC-RED]
    V2[Вариант: синий\nkind: вариант\nprice: 650\nqty_total: 5\nqty_reserved: 0\nqty_available: 5\nsku: BRC-BLU]
    V3[Вариант: зелёный\nkind: вариант\nprice: 700\nqty_total: 3\nqty_reserved: 3\nqty_available: 0\nsku: BRC-GRN\nstatus: нет в наличии]

    V1 -->|part_of| Product
    V2 -->|part_of| Product
    V3 -->|part_of| Product
```

Три состояния остатка на каждом варианте:

| Поле | Смысл |
|------|-------|
| `quantity_total` | физически есть на складе |
| `quantity_reserved` | лежат в корзинах (ещё не заказаны) |
| `quantity_available` | можно купить = total − reserved |

При добавлении в корзину → `quantity_reserved += N`, `quantity_available -= N`.
При истечении корзины → откат. При оформлении заказа → `used` уменьшает `quantity_total`.

### Корзина

Сессия с позициями. Истекает если не оформлена:

```
thing:cart_abc123
  kind: корзина
  session_id: "abc123"
  created_at: 2026-05-19T11:00:00Z
  expires_at: 2026-05-20T11:00:00Z
  → participant[role: заказчик] → thing:customer_anna   ← если авторизован

thing:cart_item_1
  kind: позиция-корзины
  quantity: 2
  price_snapshot: 650             ← цена зафиксирована в момент добавления
  → part_of → thing:cart_abc123
  → about   → thing:variant_bracelet_red

thing:cart_item_2
  kind: позиция-корзины
  quantity: 1
  price_snapshot: 850
  → part_of → thing:cart_abc123
  → about   → thing:listing_tomato_seeds
```

```surql
-- Освободить резервы истёкших корзин (запускать по расписанию)
FOR $cart IN (SELECT id FROM thing WHERE kind = "корзина" AND expires_at < time::now()) {
  FOR $item IN (SELECT * FROM thing WHERE ->part_of->thing = $cart.id) {
    UPDATE ($item.about) SET
      quantity_reserved -= $item.quantity,
      quantity_available += $item.quantity;
  };
  DELETE $cart;
};
```

### Оформление заказа

Корзина → заказ. Позиции переносятся, корзина удаляется:

```
thing:order_shop_001
  kind: заказ
  status: новый
  amount: 2150
  → participant[role: заказчик] → thing:customer_anna
  → assigned_to                → thing:mom
  → produces                   → thing:payment_shop_001
  → produces                   → thing:shipment_shop_001

thing:order_item_1
  kind: позиция-заказа
  quantity: 2
  price: 650
  → part_of → thing:order_shop_001
  → about   → thing:variant_bracelet_red

thing:order_item_2
  kind: позиция-заказа
  quantity: 1
  price: 850
  → part_of → thing:order_shop_001
  → about   → thing:listing_tomato_seeds
```

При создании заказа → `quantity_reserved -= N`, `quantity_total` уменьшается через `used` при отправке.

### Платёжный шлюз

```
thing:payment_shop_001
  kind: платёж
  amount: 2150
  status: ожидает           ← ожидает | оплачен | ошибка | возврат
  method: СБП               ← СБП | карта | наличные | перевод
  gateway: тинькофф         ← тинькофф | юкасса | stripe | robokassa
  gateway_id: "pay_abc123"  ← ID транзакции для сверки в ЛК банка
  paid_at: datetime
  → about → thing:order_shop_001
```

`DEFINE EVENT` при смене `status` на `оплачен` → автоматически переводит заказ в `подтверждён`:

```surql
DEFINE EVENT payment_confirmed ON TABLE thing
  WHEN $event = "UPDATE"
    AND $before.status = "ожидает"
    AND $value.status = "оплачен"
    AND $value.kind = "платёж"
  THEN {
    UPDATE ($value->about->thing) SET status = "подтверждён";
  };
```

### Цикл выполнения заказа

```
thing:order_shop_001
  статусы: новый → подтверждён → оплачен → собирается → готов → отправлен → доставлен → выполнен

  → produces → thing:task_pick_001     ← комплектация (assigned_to: мама)
  → produces → thing:task_pack_001     ← упаковка (depends_on: task_pick)
  → produces → thing:task_ship_001     ← отправка (depends_on: task_pack)
  → produces → thing:shipment_001      ← трекинг доставки
```

При переходе в `отправлен` → `used` списывает товар с остатка:

```surql
FOR $item IN (SELECT * FROM thing WHERE ->part_of->thing = thing:order_shop_001
                AND kind = "позиция-заказа") {
  RELATE thing:order_shop_001->used->($item.about)
    SET quantity = $item.quantity, unit = "шт";
  UPDATE ($item.about) SET quantity_total -= $item.quantity;
};
```

### Возвраты

```
thing:return_001
  kind: возврат
  status: запрошен          ← запрошен | одобрен | получен | завершён | отклонён
  reason: "не подошёл цвет"
  → about   → thing:order_shop_001
  → about   → thing:order_item_1       ← конкретная позиция
  → produces → thing:refund_001

thing:refund_001
  kind: возврат-платежа
  amount: 650
  status: ожидает | выполнен
  gateway_id: "refund_xyz"
  → about → thing:payment_shop_001
```

При получении возврата → `quantity_total += N` (товар вернулся на склад).

### Адрес доставки покупателя

```
thing:address_anna_home
  kind: адрес
  city: "Москва"
  street: "ул. Ленина, 42, кв. 7"
  postal_code: "101000"
  → part_of → thing:customer_anna     ← адресная книга покупателя

-- Адрес фиксируется на отправке:
thing:shipment_shop_001
  → located_at → thing:address_anna_home   ← адрес доставки
  carrier: СДЭК
  tracking_number: "1234567890"
```

### Витрина: публичный граф магазина

```
thing:pub_moms_shop
  kind: публикация
  slug: "moms-shop"
  live: true
  → about → thing:shop_root
  → can_access ← thing:public

thing:shop_root
  ├── thing:cat_crafts       name: "Поделки"
  │     ├── thing:product_bracelet
  │     └── thing:product_wreath
  ├── thing:cat_seeds        name: "Семена и саженцы"
  │     ├── thing:listing_tomato_seeds
  │     └── thing:listing_saplings_apple
  └── thing:cat_secondhand   name: "Б/У"
        └── thing:listing_blender_old
```

Посетитель без аккаунта видит витрину. При оформлении заказа — создаёт аккаунт
или оформляет как гость (корзина без `participant`).

### Аналитика магазина

```surql
-- Выручка по периодам
SELECT
  time::floor(created_at, 1w) AS неделя,
  count() AS заказов,
  math::sum(amount) AS выручка
FROM thing
WHERE kind = "заказ" AND status NOT IN ["отменён", "новый"]
GROUP BY неделя ORDER BY неделя DESC;

-- Топ товаров по продажам
SELECT ->about->thing.name AS товар,
       math::sum(quantity) AS продано,
       math::sum(quantity * price) AS выручка
FROM thing
WHERE kind = "позиция-заказа"
  AND <-part_of<-thing.status NOT IN ["отменён"]
GROUP BY ->about->thing
ORDER BY продано DESC LIMIT 10;

-- Товары с низким остатком
SELECT name, quantity_total, quantity_reserved, quantity_available,
       ->part_of->thing.name AS товар
FROM thing
WHERE kind = "вариант" AND quantity_available < 3
ORDER BY quantity_available ASC;

-- Корзины с зависшими резервами (скоро истекут)
SELECT id, expires_at,
       math::sum(<-part_of<-thing.quantity) AS позиций
FROM thing
WHERE kind = "корзина"
  AND expires_at < time::now() + 2h
ORDER BY expires_at ASC;

-- Заказы ожидающие отправки
SELECT name, status, created_at, amount,
       ->participant[role = "заказчик"]->thing.name AS покупатель
FROM thing
WHERE kind = "заказ" AND status IN ["оплачен", "собирается", "готов"]
ORDER BY created_at ASC;

-- Открытые возвраты
SELECT ->about->thing[WHERE kind = "заказ"].name AS заказ,
       reason, status, created_at
FROM thing
WHERE kind = "возврат" AND status NOT IN ["завершён", "отклонён"]
ORDER BY created_at ASC;
```

## Сценарий: мессенджеры, email и коммуникационные шлюзы

Шлюз — `thing`. Уведомление — `thing`. Входящее сообщение — `thing`.
Вся инфраструктура очередей, воркеров, триггеров и datasource уже есть — добавляются только новые `kind`.

### Шлюз как узел

```
thing:gateway_telegram
  kind: шлюз
  type: telegram              ← telegram | whatsapp | email | sms | push | slack
  name: "Telegram-бот магазина"
  bot_username: "@moms_shop_bot"
  → can_access → thing:secret_tg_token

thing:gateway_email_shop
  kind: шлюз
  type: email
  smtp_host: "smtp.gmail.com"
  smtp_port: 587
  from_address: "shop@example.com"
  from_name: "Мамин магазин"
  → can_access → thing:secret_smtp_creds

thing:gateway_sms
  kind: шлюз
  type: sms
  provider: sms_ru
  → can_access → thing:secret_sms_key

thing:gateway_push
  kind: шлюз
  type: push                  ← PWA web push
  vapid_public: "..."
  → can_access → thing:secret_vapid_private
```

### Контактные методы: маршрутизация

Контактные методы покупателя (уже в модели, раздел контакты) управляют выбором шлюза:

```
thing:customer_anna
  name: "Анна Козлова"

thing:cm_anna_telegram
  kind: контакт-метод
  type: telegram
  value: "123456789"          ← chat_id для отправки
  preferred: true             ← предпочтительный канал
  → part_of → thing:customer_anna

thing:cm_anna_email
  kind: контакт-метод
  type: email
  value: "anna@mail.ru"
  preferred: false
  → part_of → thing:customer_anna
```

Алгоритм маршрутизации: взять `preferred: true`, при ошибке — следующий по порядку.
Несколько каналов одновременно — если `broadcast: true` на уведомлении.

### Исходящее уведомление

```
thing:notif_order_shipped_001
  kind: уведомление
  text: "Ваш заказ «Браслет красный × 2» отправлен. Трекинг СДЭК: 1234567890"
  status: ожидает             ← ожидает | отправлено | ошибка | прочитано
  sent_at: datetime
  error: null                 ← текст ошибки если status: ошибка
  broadcast: false
  → assigned_to → thing:gateway_telegram         ← через какой шлюз
  → participant[role: получатель] → thing:customer_anna
  → about       → thing:order_shop_001           ← контекст
```

Шлюз-модуль берёт `text` + находит `chat_id` по `participant[role: получатель]` → контакт-метод → `value`.

### Шаблоны уведомлений

```
thing:tmpl_order_shipped
  kind: шаблон-уведомления
  channels: [telegram, email]                    ← по каким шлюзам
  subject: "Заказ отправлен"                     ← для email
  template_text: |
    Ваш заказ «{{order.name}}» отправлен.
    Трекинг {{shipment.carrier}}: {{shipment.tracking_number}}
    Ожидаемая доставка: {{shipment.estimated_at}}
  template_html: "<p>...</p>"                    ← для email
```

Шаблон — входные данные для модуля отправки. Переменные резолвятся через `inputs`-запрос:

```
inputs:
  order:    "SELECT name, amount FROM thing WHERE id = $order_id"
  shipment: "SELECT carrier, tracking_number, estimated_at FROM thing
             WHERE <-produces<-thing = $order_id AND kind = 'отправка'"
```

### DEFINE EVENT: автоматическая отправка

```surql
-- Заказ перешёл в статус "отправлен" → уведомить покупателя
DEFINE EVENT notify_on_ship ON TABLE thing
  WHEN $event = "UPDATE"
    AND $before.status != "отправлен"
    AND $value.status  =  "отправлен"
    AND $value.kind    =  "заказ"
  THEN {
    LET $customer = (SELECT ->participant[role = "заказчик"]->thing FROM $value.id);
    CREATE thing SET
      kind        = "уведомление",
      status      = "ожидает",
      created_at  = time::now()
    ;
    RELATE $last->about->$value.id;
    RELATE $last->participant[role = "получатель"]->$customer;
    RELATE $last->part_of->thing:queue_notifications;
  };

-- Задача просрочена → уведомить ответственного
DEFINE EVENT notify_overdue ON TABLE thing
  WHEN $event = "UPDATE"
    AND $value.kind     = "задача"
    AND $value.status  != "выполнено"
    AND $value.deadline < time::now()
    AND $before.deadline >= time::now()
  THEN {
    LET $assignee = (SELECT ->assigned_to->thing FROM $value.id);
    CREATE thing SET kind = "уведомление", status = "ожидает",
      text = string::concat("Задача просрочена: ", $value.name)
    ;
    RELATE $last->participant[role = "получатель"]->$assignee;
    RELATE $last->part_of->thing:queue_notifications;
  };
```

### Вебхук: входящие от внешних сервисов

```
thing:webhook_telegram
  kind: вебхук
  path: "/webhooks/telegram"
  secret_header: "X-Telegram-Bot-Api-Secret-Token"
  → about   → thing:gateway_telegram
  → produces → thing:queue_inbound_telegram      ← входящие в очередь

thing:webhook_payment_tinkoff
  kind: вебхук
  path: "/webhooks/tinkoff"
  → about   → thing:gateway_payment_tinkoff
  → produces → thing:queue_payment_callbacks
```

Воркер читает очередь, создаёт `kind: входящее-сообщение` и передаёт в AI-пайплайн.

### Входящее сообщение

```
thing:inbound_tg_001
  kind: входящее-сообщение
  source_type: telegram
  source_chat_id: "123456789"       ← для идентификации отправителя
  source_message_id: "9876"
  text: "хочу 2 красных браслета"
  received_at: 2026-05-19T12:00:00Z
  → about   → thing:gateway_telegram
  → produces → thing:task_parse_intent_001

thing:task_parse_intent_001
  kind: задача
  status: не начато
  → assigned_to → thing:ai_claude
  → about       → thing:inbound_tg_001
  → produces    → thing:order_draft_001         ← AI создаёт черновик заказа
```

При получении сообщения — определить отправителя по `source_chat_id` → `контакт-метод` → `покупатель`. Если не найден — создать нового или попросить представиться.

### Email как источник данных (IMAP)

Письма-триггеры обрабатываются как datasource:

```
thing:ds_email_cdek
  kind: источник-данных
  type: imap
  host: "imap.gmail.com"
  folder: "INBOX"
  filter: "from:noreply@cdek.ru OR from:pochta@russianpost.ru"
  poll_interval: 300            ← секунд между проверками
  → can_access → thing:secret_imap_creds

thing:trigger_tracking_email
  kind: триггер
  event_type: new_message
  → about   → thing:ds_email_cdek
  → produces → thing:queue_ai_light             ← AI парсит письмо → обновляет трекинг
```

### Conversational bot: диалог через мессенджер

Полный цикл: пользователь пишет → AI разбирает → отвечает через тот же шлюз:

```mermaid
graph TD
    User[Покупатель в Telegram]
    Inbound[Входящее сообщение\ntext: где мой заказ]
    Q[Очередь inbound_tg]
    AI[ai_claude\nклассификация намерения]
    Order[Заказ #001\nstatus: отправлен]
    Notif[Уведомление-ответ\nТрекинг: 12345...]
    GW[gateway_telegram]
    User2[Пользователь получает ответ]

    User -->|пишет| Inbound
    Inbound -->|part_of| Q
    Q -->|воркер| AI
    AI -->|about| Order
    AI -->|produces| Notif
    Notif -->|assigned_to| GW
    GW -->|отправляет| User2
```

Состояние диалога — цепочка `входящее → ответ → входящее`:

```
thing:dialog_anna_001
  kind: диалог
  → part_of → thing:customer_anna

thing:inbound_tg_001  → part_of → thing:dialog_anna_001  (order: 1)
thing:notif_reply_001 → part_of → thing:dialog_anna_001  (order: 2)
thing:inbound_tg_002  → part_of → thing:dialog_anna_001  (order: 3)
```

### SurrealQL: мониторинг коммуникаций

```surql
-- Уведомления в очереди (ожидают отправки)
SELECT text, ->participant[role = "получатель"]->thing.name AS кому,
       ->assigned_to->thing.name AS шлюз,
       created_at
FROM thing
WHERE kind = "уведомление" AND status = "ожидает"
ORDER BY created_at ASC;

-- Ошибки доставки за последние 24 часа
SELECT text, error,
       ->participant[role = "получатель"]->thing.name AS кому,
       ->assigned_to->thing.name AS шлюз
FROM thing
WHERE kind = "уведомление" AND status = "ошибка"
  AND created_at > time::now() - 24h;

-- Необработанные входящие сообщения
SELECT source_type, source_chat_id, text, received_at
FROM thing
WHERE kind = "входящее-сообщение"
  AND count(->produces->thing[WHERE status != "выполнено"]) > 0
ORDER BY received_at ASC;

-- Статистика по шлюзам: сколько отправлено / ошибок
SELECT ->assigned_to->thing.name AS шлюз,
       count() AS всего,
       count(status = "отправлено") AS успешно,
       count(status = "ошибка") AS ошибок
FROM thing
WHERE kind = "уведомление"
  AND created_at > time::now() - 7d
GROUP BY ->assigned_to->thing;
```

## Сценарий: дневник, блог и веб-сайт

Дневник — приватный граф без `can_access ← thing:public`.
Блог — документы с SEO-полями и публичным доступом.
Сайт — `kind: сайт` со страницами, навигацией и динамическими блоками.
Рендеринг читает граф и отдаёт HTML — тот же Next.js, что и для Домового.

### Дневник

Контейнер без публичного доступа. Записи — стандартные блоковые документы:

```
thing:diary_mom
  kind: дневник
  name: "Личный дневник"
  -- нет can_access ← thing:public → только владелец

thing:diary_entry_20260519
  kind: запись-дневника
  created_at: 2026-05-19T09:00:00Z
  mood: радостно               ← произвольные поля настроения
  weather: солнечно
  → part_of   → thing:diary_mom
  → related_to → thing:tag_garden   (label: тег)
  → related_to → thing:tag_spring

-- Текст — обычные блоки внутри записи:
thing:block_diary_1  text: "Сегодня посадила первую рассаду..."
  → part_of → thing:diary_entry_20260519  (order: 1)
thing:block_diary_2  text: "Антоновка дала первые почки."
  → part_of → thing:diary_entry_20260519  (order: 2)
```

Записи связываются с любыми узлами графа через `about`:

```
thing:diary_entry_20261001
  → about → thing:order_sapling_apple   ← запись в день отправки саженцев
  → about → thing:customer_petr
```

Хронология и поиск:

```surql
-- Записи за последний месяц
SELECT name, created_at, mood,
       array::group(->related_to->thing.name) AS теги
FROM thing
WHERE kind = "запись-дневника"
  AND created_at > time::now() - 30d
ORDER BY created_at DESC;

-- Записи связанные с конкретным объектом
SELECT created_at, ->part_of->thing[WHERE kind != "запись-дневника"].text AS фрагмент
FROM thing
WHERE kind = "блок" AND ->part_of->thing->about->thing = thing:apple_tree_antonovka
ORDER BY created_at DESC;
```

### Блог

Пост — документ с дополнительными полями для веба. `can_access ← thing:public` делает его публичным:

```
thing:blog_section
  kind: блог
  name: "Блог о саде и рукоделии"
  slug: "blog"
  → part_of → thing:site_moms_shop

thing:post_tomato_seeds
  kind: пост
  title: "Как сохранить семена томатов до весны"
  slug: "kak-sohranit-semena-tomatov"
  published_at: 2026-05-01T10:00:00Z
  status: черновик | опубликован | архив
  featured_image: "file_id_cover"       ← ID файла в vault
  excerpt: "Правильное хранение семян — залог хорошего урожая..."
  seo_title: "Как сохранить семена томатов | Мамин сад"
  seo_description: "Подробное руководство по сбору и хранению..."
  seo_image: "file_id_og"
  → part_of   → thing:blog_section
  → related_to → thing:tag_seeds    (label: тег)
  → related_to → thing:tag_tomatoes
  → about      → thing:listing_tomato_seeds   ← ссылка на товар в магазине
  → can_access ← thing:public

-- Блоки поста — обычная блоковая структура:
thing:block_post_1  kind: заголовок  text: "Когда собирать семена"
  → part_of → thing:post_tomato_seeds  (order: 1)
thing:block_post_2  kind: текст  text: "Дождитесь полного созревания..."
  → part_of → thing:post_tomato_seeds  (order: 2)
thing:block_post_3  kind: изображение  → represents → thing:file_photo_seeds
  → part_of → thing:post_tomato_seeds  (order: 3)
```

Комментарии — уже в модели (раздел "Обсуждения"):

```
thing:comment_vasya
  text: "Спасибо! А как долго хранятся?"
  → about → thing:post_tomato_seeds
  → assigned_to → thing:person_vasya
```

### Сайт

```
thing:site_moms_shop
  kind: сайт
  name: "Мамин магазин и сад"
  domain: "moms-shop.ru"
  lang: ru
  → can_access ← thing:public
```

Страницы — `part_of` сайта:

```
thing:page_home
  kind: страница
  slug: ""               ← корень
  title: "Главная"
  layout: fullwidth
  seo_title: "Мамин магазин — поделки, семена, саженцы"
  seo_description: "..."
  → part_of → thing:site_moms_shop
  → can_access ← thing:public

thing:page_catalog
  kind: страница
  slug: "catalog"
  title: "Каталог"
  layout: sidebar
  → part_of → thing:site_moms_shop
  → can_access ← thing:public

thing:page_about
  kind: страница
  slug: "about"
  title: "О нас"
  layout: article
  → part_of → thing:site_moms_shop
  → can_access ← thing:public
```

### Навигация

```
thing:nav_main
  kind: навигация
  name: "Основное меню"
  → part_of → thing:site_moms_shop

thing:nav_home     name: "Главная"   order: 1  → about → thing:page_home
thing:nav_catalog  name: "Магазин"   order: 2  → about → thing:page_catalog
thing:nav_blog     name: "Блог"      order: 3  → about → thing:blog_section
thing:nav_about    name: "О нас"     order: 4  → about → thing:page_about

-- Всё part_of thing:nav_main (order уже на узле)
```

### Динамические блоки на странице

Страница сочетает статические текстовые блоки и динамические — с запросом к графу.
Динамический блок = код-ячейка (уже в модели) с `template` вместо `source`:

```
-- Главная страница:
thing:block_hero       kind: текст       text: "Привет! Я делаю поделки..."
  → part_of → thing:page_home  (order: 1)

thing:block_featured   kind: блок-динамический
  template: "product-grid"
  inputs:
    товары:
      query: "SELECT name, price, featured_image, slug FROM thing
              WHERE kind = 'товар' AND featured = true
              ORDER BY updated_at DESC LIMIT 6"
      format: table
  → part_of → thing:page_home  (order: 2)

thing:block_latest_posts  kind: блок-динамический
  template: "post-list"
  inputs:
    посты:
      query: "SELECT title, slug, excerpt, published_at, featured_image
              FROM thing WHERE kind = 'пост' AND status = 'опубликован'
              ORDER BY published_at DESC LIMIT 3"
      format: table
  → part_of → thing:page_home  (order: 3)
```

Рендерер читает `template` → вызывает модуль-рендера → получает HTML-фрагмент.
Тот же протокол, что у Mermaid/Observable/SQL-рендеров (уже в модели).

### SSG vs SSR

| Режим | Как | Когда |
|-------|-----|-------|
| **SSG** (статика) | при публикации выполнить все динамические блоки, сохранить HTML в vault | редко меняющийся контент |
| **SSR** | запрос к графу при каждом HTTP-запросе | цены, остатки, живой каталог |
| **ISR** | SSG + фоновое обновление по расписанию | блог, каталог с умеренным трафиком |

```
thing:page_catalog
  render_mode: ssr             ← цены и остатки всегда актуальны

thing:page_about
  render_mode: ssg
  built_at: 2026-05-19T10:00:00Z
  built_file: "file_id_html"   ← готовый HTML в vault
```

### Полная картина: дневник + блог + магазин на одном графе

```mermaid
graph TD
    Site[Сайт: moms-shop.ru]

    PHome[Страница: Главная]
    PCat[Страница: Каталог]
    PAbout[Страница: О нас]
    Blog[Блог\nкind: блог]

    Post1[Пост: Семена томатов\nопубликован\npublic]
    Post2[Пост: Осенние саженцы\nчерновик]

    Shop[Каталог магазина\nkind: публикация]
    Product[Браслет макраме\nkind: товар]

    Diary[Дневник\nприватно]
    Entry1[Запись 19 мая]

    PHome -->|part_of| Site
    PCat  -->|part_of| Site
    PAbout -->|part_of| Site
    Blog  -->|part_of| Site
    Post1 -->|part_of| Blog
    Post2 -->|part_of| Blog
    Post1 -->|about| Product
    Shop  -->|about| Product
    Entry1 -->|part_of| Diary
    Entry1 -->|about| Product
```

```surql
-- Все опубликованные посты с тегами
SELECT title, slug, published_at, excerpt,
       array::group(->related_to->thing.name) AS теги
FROM thing
WHERE kind = "пост" AND status = "опубликован"
ORDER BY published_at DESC;

-- Страницы сайта с режимом рендера
SELECT title, slug, render_mode, built_at,
       count(<-part_of<-thing[WHERE kind = "блок-динамический"]) AS динамических_блоков
FROM thing
WHERE kind = "страница" AND ->part_of->thing = thing:site_moms_shop
ORDER BY slug;

-- Посты связанные с товарами (для перелинковки)
SELECT p.title AS пост, t.name AS товар, t.slug AS slug_товара
FROM thing AS p, thing AS t
WHERE p.kind = "пост" AND p->about->thing = t AND t.kind = "товар";
```

## Сценарий: SMM-менеджер

Аккаунты, посты, контент-план, кросс-постинг, согласование, аналитика —
всё `thing`. Шлюзы и datasource для платформ уже в модели.

### Аккаунты соцсетей

```
thing:acc_instagram
  kind: аккаунт-соцсети
  platform: instagram       ← instagram | vk | telegram | tiktok | youtube | pinterest
  handle: "@moms_shop"
  followers: 1240
  → filed_with  → thing:platform_instagram   ← платформа как инстанция
  → assigned_to → thing:mom
  → can_access  ← thing:gateway_instagram    ← через какой шлюз публикуем

thing:acc_telegram_channel
  kind: аккаунт-соцсети
  platform: telegram
  handle: "@moms_garden_channel"
  subscribers: 380
  → can_access ← thing:gateway_telegram
```

### Пост

```
thing:post_smm_001
  kind: smm-пост
  caption: "🌱 Томаты Черри — собрала семена с лучших плодов. Ограниченный запас!"
  status: идея              ← идея | черновик | на_согласовании | одобрен |
                               запланирован | опубликован | архив
  scheduled_at: 2026-05-20T10:00:00Z
  published_at: datetime
  platform_post_id: "17896..."   ← ID поста на платформе после публикации
  → about      → thing:acc_instagram           ← в какой аккаунт
  → about      → thing:listing_tomato_seeds    ← товар в посте (перелинковка)
  → assigned_to → thing:mom
  → produces   → thing:analytics_post_001
```

Медиафайлы поста — vault-файлы через `part_of` или `represents`:

```
thing:media_post_001_photo1  → part_of → thing:post_smm_001  (order: 1)
thing:media_post_001_photo2  → part_of → thing:post_smm_001  (order: 2)
```

### Контент-план

```
thing:plan_may_2026
  kind: контент-план
  period: "2026-05"
  → part_of → thing:smm_workspace

-- Посты входят в план:
thing:post_smm_001 → part_of → thing:plan_may_2026  (order: 3, planned_date: 2026-05-20)
thing:post_smm_002 → part_of → thing:plan_may_2026  (order: 5, planned_date: 2026-05-22)
```

### Кросс-постинг и рерайт

Одна идея — несколько адаптаций под разные платформы. Или блог-пост порождает SMM-посты:

```mermaid
graph TD
    Idea[Контент-идея:\nВесенние семена томатов]
    IG[SMM-пост Instagram\ncaption: короткий + эмодзи\nstatus: запланирован]
    VK[SMM-пост ВКонтакте\ncaption: длинный текст\nstatus: черновик]
    TG[SMM-пост Telegram\ncaption: с ссылкой на магазин]
    Blog[Пост блога:\nКак сохранить семена томатов]

    IG -->|part_of| Idea
    VK -->|part_of| Idea
    TG -->|part_of| Idea
    Blog -->|produces| Idea
```

```
thing:content_idea_spring_seeds
  kind: контент-идея
  brief: "Томаты Черри — новый урожай семян, ограниченное количество"

thing:post_ig_001   → part_of → thing:content_idea_spring_seeds
thing:post_vk_001   → part_of → thing:content_idea_spring_seeds
thing:post_tg_001   → part_of → thing:content_idea_spring_seeds

-- Блог-пост как источник:
thing:post_blog_seeds → produces → thing:content_idea_spring_seeds
```

### Согласование с клиентом

Пост переходит в статус `на_согласовании` → создаётся задача для клиента:

```
thing:post_smm_001
  status: на_согласовании
  → produces → thing:task_approve_smm_001

thing:task_approve_smm_001
  kind: задача
  name: "Согласовать пост 20 мая"
  deadline: 2026-05-18
  → assigned_to → thing:client_ivanova
  → about       → thing:post_smm_001
```

Клиент одобряет — `status: одобрен`. Отклоняет с комментарием — `status: черновик` +
сообщение в обсуждении под постом.

### Хэштеги

Наборы хэштегов для разных тем — `thing` с массивом тегов:

```
thing:hashtags_garden
  kind: набор-хэштегов
  name: "Огород и сад"
  tags: ["#огород", "#семена", "#дача", "#рассада", "#садовод", "#огородник"]

thing:hashtags_crafts
  kind: набор-хэштегов
  name: "Рукоделие"
  tags: ["#макраме", "#поделки", "#хэндмейд", "#ручнаяработа", "#braceletsofinstagram"]

-- Пост использует набор:
thing:post_smm_001 → requires → thing:hashtags_garden
```

### Аналитика постов

```
thing:analytics_post_001
  kind: аналитика-поста
  recorded_at: 2026-05-21T10:00:00Z   ← снапшот метрик
  likes: 234
  comments: 18
  saves: 45
  shares: 7
  reach: 1240
  impressions: 1890
  clicks: 56                           ← клики по ссылке в bio
  → about → thing:post_smm_001
```

Метрики снимаются расписанием через datasource платформы:

```
thing:ds_instagram_api
  kind: источник-данных
  type: rest
  base_url: "https://graph.facebook.com/v18.0"
  → can_access → thing:secret_instagram_token

thing:schedule_pull_analytics
  kind: расписание
  cron: "0 9 * * *"           ← каждое утро обновлять метрики
  → produces → thing:queue_analytics_pull
```

### Кампании

```
thing:campaign_spring_seeds
  kind: smm-кампания
  name: "Весенние семена 2026"
  goal: "Продать 100 пакетов томатов до 1 июня"
  budget: 3000                 ← рекламный бюджет
  spent: 1200
  start_date: 2026-04-15
  end_date: 2026-05-31
  → part_of → thing:smm_workspace

-- Посты кампании:
thing:post_smm_001 → part_of → thing:campaign_spring_seeds
thing:post_smm_002 → part_of → thing:campaign_spring_seeds
```

### Link in bio

```
thing:linkinbio_moms
  kind: link-in-bio
  slug: "moms-garden"
  → part_of    → thing:acc_instagram
  → can_access ← thing:public

thing:lb_item_shop   name: "🛍 Магазин"   order: 1  → about → thing:page_catalog
thing:lb_item_seeds  name: "🌱 Семена"    order: 2  → about → thing:listing_tomato_seeds
thing:lb_item_blog   name: "📝 Блог"      order: 3  → about → thing:blog_section
thing:lb_item_tg     name: "📢 Telegram"  order: 4  url: "t.me/moms_garden_channel"

-- Все part_of thing:linkinbio_moms
```

### Автопубликация через шлюз

Когда `scheduled_at` наступает — `DEFINE EVENT` кладёт задание в очередь:

```surql
DEFINE EVENT auto_publish ON TABLE thing
  WHEN $event = "UPDATE"
    AND $value.kind        = "smm-пост"
    AND $value.status      = "запланирован"
    AND $value.scheduled_at <= time::now()
    AND $before.status     != "опубликован"
  THEN {
    CREATE thing SET kind = "задание", status = "ожидает",
      payload_id = $value.id, created_at = time::now()
    ;
    RELATE $last->part_of->thing:queue_smm_publish;
  };
```

Воркер берёт задание → вызывает модуль-шлюз (`gateway_instagram` / `gateway_vk` / `gateway_telegram`) → публикует → записывает `platform_post_id` + `published_at` + меняет `status: опубликован`.

### Работа с несколькими клиентами (SMM-агентство)

```
thing:smm_workspace_ivanova
  kind: smm-клиент
  → about       → thing:business_ivanova_bakery
  → assigned_to → thing:smm_manager_masha

thing:plan_ivanova_may → part_of → thing:smm_workspace_ivanova
thing:acc_ig_bakery    → part_of → thing:smm_workspace_ivanova
```

Доступ: `can_access[permissions: view, edit]` клиенту — только к своему workspace.

### SurrealQL: рабочий дашборд SMM

```surql
-- Контент-план: что запланировано на неделю
SELECT title, scheduled_at, status,
       ->about->thing[WHERE kind = "аккаунт-соцсети"].platform AS платформа,
       ->assigned_to->thing.name AS автор
FROM thing
WHERE kind = "smm-пост"
  AND scheduled_at BETWEEN time::now() AND time::now() + 7d
ORDER BY scheduled_at ASC;

-- Посты ожидающие согласования
SELECT caption[0..80] AS превью, scheduled_at,
       ->about->thing[WHERE kind = "аккаунт-соцсети"].handle AS аккаунт,
       ->produces->thing[WHERE kind = "задача"].assigned_to.name AS согласует
FROM thing
WHERE kind = "smm-пост" AND status = "на_согласовании"
ORDER BY scheduled_at ASC;

-- Топ постов по охвату за месяц
SELECT ->about->thing.caption[0..60] AS пост,
       reach, likes, saves,
       math::round((saves / reach) * 100, 2) AS save_rate
FROM thing
WHERE kind = "аналитика-поста"
  AND recorded_at > time::now() - 30d
ORDER BY reach DESC LIMIT 10;

-- Эффективность кампании
SELECT name, goal, budget, spent,
       count(<-part_of<-thing[WHERE kind = "smm-пост" AND status = "опубликован"]) AS постов,
       math::sum(<-part_of<-thing->produces->thing[WHERE kind = "аналитика-поста"].reach)
         AS суммарный_охват
FROM thing
WHERE kind = "smm-кампания" AND end_date > time::now() - 90d;

-- Идеи без реализации (контент-идеи без ни одного поста)
SELECT name, brief, created_at
FROM thing
WHERE kind = "контент-идея"
  AND count(<-part_of<-thing[WHERE kind = "smm-пост"]) = 0
ORDER BY created_at ASC;
```

## Сценарий: граф как контент Telegram-канала

Граф — источник истины. Telegram-канал — живая проекция поддерева.
Редактируешь узел → сообщение в канале обновляется. Добавляешь дочерний узел → новое сообщение в треде.

### Канал и сообщение как узлы

```
thing:tg_channel_cooking
  kind: telegram-канал
  chat_id: "-1001234567890"
  name: "Кулинарный блог Марины"
  topics_enabled: true         ← Telegram supergroup с топиками (форум-режим)
  → can_access ← thing:gateway_telegram

thing:tg_msg_borsch_main
  kind: telegram-сообщение
  message_id: 142              ← ID сообщения в Telegram (нужен для edit/delete)
  thread_id: 98                ← ID топика (если topics_enabled)
  reply_to_message_id: null    ← null = корневое сообщение в треде
  sent_at: 2026-05-19T10:00:00Z
  edited_at: 2026-05-19T12:30:00Z
  → part_of → thing:tg_channel_cooking
  → about   → thing:recipe_borsch     ← исходный узел графа
```

### Дерево графа → дерево тредов

Иерархия `part_of` в графе отображается в цепочку ответов в Telegram:

```mermaid
graph TD
    subgraph Граф
        R[Рецепт: Борщ классический]
        I[Ингредиенты\npart_of Рецепт, order 1]
        S[Шаги приготовления\npart_of Рецепт, order 2]
        T[Советы и вариации\npart_of Рецепт, order 3]
        S1[Шаг 1: нарезать свёклу\npart_of Шаги, order 1]
        S2[Шаг 2: пассеровать\npart_of Шаги, order 2]
    end

    subgraph Telegram-тред
        M1[Сообщение: Борщ классический\nmessage_id: 142]
        M2[Ответ: Ингредиенты\nmessage_id: 143\nreply_to: 142]
        M3[Ответ: Шаги\nmessage_id: 144\nreply_to: 142]
        M4[Ответ: Советы\nmessage_id: 145\nreply_to: 142]
        M5[Ответ: Шаг 1\nmessage_id: 146\nreply_to: 144]
        M6[Ответ: Шаг 2\nmessage_id: 147\nreply_to: 144]
    end

    R --> M1
    I --> M2
    S --> M3
    T --> M4
    S1 --> M5
    S2 --> M6
```

Каждый узел графа `produces` своё сообщение:

```
thing:recipe_borsch      → produces → thing:tg_msg_142
thing:section_ingr       → produces → thing:tg_msg_143
thing:section_steps      → produces → thing:tg_msg_144
thing:section_tips       → produces → thing:tg_msg_145
thing:step_1_beet        → produces → thing:tg_msg_146
```

### Шаблон рендера

Каждый `kind` узла рендерится по своему шаблону:

```
thing:tmpl_recipe_tg
  kind: шаблон-публикации
  platform: telegram
  applies_to_kind: рецепт
  template: |
    {{emoji}} **{{name}}**
    {{#if description}}
    {{description}}
    {{/if}}
    ⏱ {{cook_time}} мин  |  👥 {{servings}} порций
    {{#each tags}}#{{this}} {{/each}}

thing:tmpl_ingredients_tg
  kind: шаблон-публикации
  applies_to_kind: раздел-ингредиентов
  template: |
    **Ингредиенты:**
    {{#each items}}• {{quantity}} {{unit}} — {{name}}
    {{/each}}

thing:tmpl_step_tg
  kind: шаблон-публикации
  applies_to_kind: шаг-рецепта
  template: "{{order}}. {{text}}"
```

Шаблон — тот же модуль с `inputs`-запросом (уже в модели):

```
inputs:
  рецепт:
    query: "SELECT name, description, cook_time, servings FROM thing WHERE id = $node_id"
    format: table
  теги:
    query: "SELECT name FROM thing WHERE <-related_to<-thing = $node_id"
    format: table
```

### Синхронизация: граф изменился → Telegram обновился

```surql
DEFINE EVENT sync_node_to_telegram ON TABLE thing
  WHEN $event = "UPDATE"
    AND count(->produces->thing[WHERE kind = "telegram-сообщение"]) > 0
  THEN {
    LET $msgs = SELECT * FROM ->produces->thing WHERE kind = "telegram-сообщение";
    FOR $msg IN $msgs {
      CREATE thing SET
        kind       = "задание",
        operation  = "edit_message",
        node_id    = $value.id,
        message_id = $msg.message_id,
        chat_id    = $msg.chat_id,
        created_at = time::now()
      ;
      RELATE $last->part_of->thing:queue_tg_sync;
    };
  };
```

Воркер берёт задание → рендерит узел по шаблону → вызывает `editMessageText` через gateway → обновляет `tg_msg.edited_at`.

### Таблица: действие в графе → действие в Telegram

| Действие в графе | Telegram Bot API |
|------------------|-----------------|
| Изменить текст/поля узла | `editMessageText` |
| Добавить дочерний узел | `sendMessage` с `reply_to_message_id` родителя |
| Удалить узел | `deleteMessage` + убрать `produces` |
| Переместить (новый `part_of`) | `deleteMessage` + `sendMessage` в новом треде |
| Изменить `order` | нельзя переупорядочить в TG — `pin` важного |
| Добавить изображение | `editMessageMedia` или новый `sendPhoto` |
| Опубликовать новое поддерево | рекурсивный обход `part_of`, `sendMessage` в порядке `order` |

### Пример: кулинарный канал с топиками

```
thing:tg_channel_cooking            ← канал с topics_enabled

├── topic: Супы  (thread_id: 10)
│     ├── thing:tg_msg_borsch        ← about → thing:recipe_borsch
│     │     ├── thing:tg_msg_ingr    ← about → thing:section_ingredients
│     │     └── thing:tg_msg_steps   ← about → thing:section_steps
│     └── thing:tg_msg_solyanka      ← about → thing:recipe_solyanka
│
├── topic: Выпечка  (thread_id: 20)
│     └── thing:tg_msg_bread         ← about → thing:recipe_bread
│
└── topic: Советы  (thread_id: 30)
      └── thing:tg_msg_tip_salt      ← about → thing:tip_salt_properly
```

Топик = `kind: telegram-топик` с `thread_id`, `part_of` канала:

```
thing:topic_soups
  kind: telegram-топик
  thread_id: 10
  name: "Супы"
  → part_of → thing:tg_channel_cooking
  → about   → thing:category_soups    ← категория в графе рецептов
```

### Публикация нового поддерева

Рекурсивный обход дерева по `part_of` → отправить сообщения в порядке `order`,
каждый следующий уровень — `reply_to_message_id` родителя:

```surql
-- Все узлы поддерева рецепта в порядке обхода
SELECT id, name, kind,
       ->part_of.order AS порядок,
       count(<-part_of<-thing) AS дочерних
FROM thing
WHERE id INSIDE (
  SELECT id FROM thing WHERE id = thing:recipe_borsch
  UNION
  SELECT id FROM thing WHERE ->part_of->thing = thing:recipe_borsch DEPTH 5
)
ORDER BY порядок ASC;

-- Узлы графа без Telegram-сообщения (ещё не опубликованы)
SELECT name, kind FROM thing
WHERE ->part_of->thing = thing:recipe_borsch
  AND count(->produces->thing[WHERE kind = "telegram-сообщение"]) = 0;

-- Все сообщения канала и когда последний раз обновлялись
SELECT ->about->thing.name AS узел, message_id, sent_at, edited_at,
       (edited_at - sent_at) AS задержка_правки
FROM thing
WHERE kind = "telegram-сообщение"
  AND ->part_of->thing = thing:tg_channel_cooking
ORDER BY sent_at DESC;
```

## Сценарий: граф как источник истины для веб-сайта

Тот же паттерн что и Telegram-канал: граф — источник, сайт — живая проекция.
Редактируешь узел → страница пересобирается автоматически.

### Параллель с Telegram

| Telegram | Веб-сайт |
|----------|----------|
| `kind: telegram-сообщение` + `message_id` | `kind: страница` + `slug` |
| `reply_to_message_id` | вложенная секция / дочерняя страница |
| `editMessageText` | перезаписать HTML в vault / сбросить кэш |
| `sendMessage` | создать новую страницу |
| `deleteMessage` | убрать страницу, вернуть 404 или редирект |
| топик (`thread_id`) | раздел сайта / категория |
| шаблон публикации | layout + шаблон рендера |

### Привязка: узел `produces` страницу

```
thing:recipe_borsch
  → produces → thing:page_borsch

thing:page_borsch
  kind: страница
  slug: "recipes/borsch"
  render_mode: ssg
  built_file: "file_id_html"         ← готовый HTML в vault
  built_at: 2026-05-19T10:00:00Z
  cache_key: "recipe_borsch_v3"
  seo_title: "Борщ классический | Кулинарный блог"
  seo_description: "Настоящий украинский борщ..."
  → about → thing:recipe_borsch      ← обратная ссылка
  → part_of → thing:site_cooking
```

Один узел может питать несколько проекций одновременно:

```
thing:recipe_borsch
  → produces → thing:page_borsch          ← страница сайта
  → produces → thing:tg_msg_borsch_main   ← пост в Telegram
  → produces → thing:post_ig_borsch       ← пост в Instagram
```

Изменил рецепт — все три проекции обновляются из одного источника.

### DEFINE EVENT: автопересборка

```surql
DEFINE EVENT sync_to_web ON TABLE thing
  WHEN $event = "UPDATE"
    AND count(->produces->thing[WHERE kind = "страница"]) > 0
  THEN {
    LET $pages = SELECT * FROM ->produces->thing WHERE kind = "страница";
    FOR $page IN $pages {
      CREATE thing SET
        kind       = "задание",
        operation  = "rebuild_page",
        node_id    = $value.id,
        page_id    = $page.id,
        slug       = $page.slug,
        created_at = time::now()
      ;
      RELATE $last->part_of->thing:queue_web_rebuild;
    };
  };
```

Воркер берёт задание → рендерит узел по шаблону через `inputs`-запрос →
записывает HTML в vault → сбрасывает CDN-кэш по `cache_key`.

### Инкрементальная пересборка: только изменённое поддерево

Главное преимущество перед статическим генератором: не пересобирать весь сайт.
Изменился один рецепт → пересобирается только его страница.

```
thing:recipe_borsch  (изменён)
  → produces → thing:page_borsch              ← пересобрать
  → part_of  → thing:category_soups
               → produces → thing:page_soups  ← пересобрать список (изменился дочерний)

НЕ пересобирать:
  thing:page_home         (если нет блока "последние рецепты")
  thing:page_about
  все остальные рецепты
```

Зависимости пересборки — отдельный граф `invalidates`:

```
thing:page_borsch →invalidates→ thing:page_soups   ← список категории
thing:page_borsch →invalidates→ thing:page_sitemap  ← карта сайта
```

```surql
-- Все страницы которые нужно пересобрать при изменении узла
SELECT id, slug FROM thing
WHERE kind = "страница"
  AND (
    <-produces<-thing = thing:recipe_borsch
    OR <-invalidates<-thing = thing:page_borsch
  );
```

### Иерархия: граф → структура страницы

`part_of` в графе → секции и подсекции на странице в порядке `order`:

```
thing:recipe_borsch                          ← страница целиком
  ├── thing:section_intro    (order: 1)      ← секция "Введение"
  ├── thing:section_ingr     (order: 2)      ← секция "Ингредиенты"
  │     ├── thing:ingr_beet  (order: 1)      ← строка таблицы
  │     └── thing:ingr_beef  (order: 2)
  ├── thing:section_steps    (order: 3)      ← секция "Шаги"
  │     ├── thing:step_1     (order: 1)
  │     └── thing:step_2     (order: 2)
  └── thing:section_tips     (order: 4)      ← секция "Советы"
```

Каждый `kind` рендерится по своему шаблону — те же `kind: шаблон-публикации`
что и для Telegram, но выводят HTML вместо Markdown.

### Шаблон рендера (HTML)

```
thing:tmpl_recipe_html
  kind: шаблон-публикации
  platform: web
  applies_to_kind: рецепт
  layout: article-wide
  inputs:
    рецепт:
      query: "SELECT name, description, cook_time, servings FROM thing WHERE id = $node_id"
      format: table
    секции:
      query: "SELECT id, kind, name FROM thing WHERE ->part_of->thing = $node_id ORDER BY ->part_of.order"
      format: table
    теги:
      query: "SELECT name FROM thing WHERE <-related_to<-thing = $node_id"
      format: table
  template_file: "file_id_recipe_html_tmpl"  ← Jinja2 / Handlebars в vault
```

### Один граф — много проекций одновременно

```mermaid
graph TD
    Graph[Граф рецептов\nтип исины]

    Web[Веб-сайт\nSSG/ISR]
    TG[Telegram-канал\nтреды]
    IG[Instagram\nпосты + reels]
    PDF[PDF-книга\nэкспорт]
    RSS[RSS-лента\nподписчики]

    Graph -->|produces + rebuild| Web
    Graph -->|produces + editMessage| TG
    Graph -->|produces + update| IG
    Graph -->|produces + re-export| PDF
    Graph -->|produces + ping| RSS
```

Каждая проекция — воркер со своим шаблоном и протоколом вывода.
Новый канал распространения = новый воркер, граф не меняется.

### SurrealQL: мониторинг состояния сайта

```surql
-- Страницы устаревшие после изменений в графе (built_at < updated_at источника)
SELECT slug, built_at,
       ->about->thing.updated_at AS источник_изменён,
       built_at < ->about->thing.updated_at AS устарела
FROM thing
WHERE kind = "страница"
ORDER BY устарела DESC, ->about->thing.updated_at DESC;

-- Очередь пересборки: что ждёт
SELECT slug, created_at,
       time::now() - created_at AS ожидает
FROM thing
WHERE kind = "задание" AND operation = "rebuild_page" AND status = "ожидает"
ORDER BY created_at ASC;

-- Узлы без веб-проекции (не опубликованы на сайте)
SELECT name, kind FROM thing
WHERE kind IN ["рецепт", "пост", "страница-контента"]
  AND count(->produces->thing[WHERE kind = "страница"]) = 0;

-- Все проекции одного узла (куда опубликован)
SELECT ->produces->thing.kind AS тип, ->produces->thing.slug AS slug,
       ->produces->thing.built_at AS обновлено
FROM thing WHERE id = thing:recipe_borsch;
```

## Сценарий: протокол работы в консоли

Три слоя: **захват** (команды + вывод) → **анализ AI** (аннотации, изменения) → **документация** (живые доки сервера).
Работает как для изучения Linux сыном, так и для аудита серверной работы.

### Сессия и команда как узлы

```
thing:session_20260519_srv1
  kind: терминал-сессия
  host: "server1.home"
  user: "admin"
  started_at: 2026-05-19T14:00:00Z
  ended_at:   2026-05-19T15:30:00Z
  status: активна | завершена | прервана
  goal: "Настройка nginx для moms-shop.ru"   ← опционально, задаётся при старте
  via_jump: "bastion.home"                   ← через какой хост зашли
  raw_recording: "file_id_cast"              ← asciinema/script в vault
  → about      → thing:server_home1          ← сервер в инвентаре
  → assigned_to → thing:dad

thing:cmd_042
  kind: команда
  text: "apt install nginx"
  stdout: "Reading package lists... Done\nSetting up nginx (1.24.0)..."
  stderr: ""
  exit_code: 0
  cwd: "/root"
  executed_at: 2026-05-19T14:07:23Z
  → part_of → thing:session_20260519_srv1  (order: 42)
  → produces → thing:annotation_cmd_042    ← AI-аннотация
```

### Сервер как узел инвентаря

```
thing:server_home1
  kind: сервер
  hostname: "server1.home"
  ip_local: "192.168.1.10"
  os: "Ubuntu 24.04 LTS"
  role: "web"                    ← web | db | bastion | storage | dev
  cpu: "4 cores"
  ram_gb: 8
  → part_of    → thing:homelab
  → located_at → thing:rack_home
  → produces   → thing:doc_server_home1    ← живая документация
```

### Захват данных: три источника

**1. Shell-интеграция** — лёгкий агент в `.bashrc`/`.zshrc`:

```bash
# При старте сессии — создать узел сессии
domovoy session start --host "$(hostname)" --user "$(whoami)"

# PROMPT_COMMAND — перехват каждой команды после выполнения
__domovoy_log() {
  local exit_code=$?
  domovoy cmd log \
    --exit   "$exit_code" \
    --cwd    "$PWD" \
    --cmd    "$(history 1 | sed 's/^ *[0-9]* *//')"
}
PROMPT_COMMAND="__domovoy_log;$PROMPT_COMMAND"

# При завершении
trap 'domovoy session end' EXIT
```

**2. `script` / `asciinema`** — полный PTY-вывод в vault:

```bash
# Обёртка для записи сессии:
domovoy record -- ssh admin@server1.home
# Внутри: script -q -c "ssh ..." | tee $VAULT/session_$(date +%s).cast
```

**3. Bastion / jump-host** — PTY-лог уже пишется на стороне бастиона:

```
thing:ds_bastion_logs
  kind: источник-данных
  type: file
  path: "/var/log/bastion/sessions/"
  format: asciinema               ← или ttyrec, raw text
  poll_interval: 60
  → about      → thing:bastion_home
  → can_access → thing:secret_bastion_ssh
```

Триггер: новый файл в папке → парсер создаёт `kind: терминал-сессия` + команды.

### AI-анализ сессии

После завершения (или по требованию) — пайплайн разбора:

```
thing:pipeline_analyze_session
  kind: пайплайн

thing:step_parse
  kind: шаг
  inputs:
    запись:
      datasource: thing:ds_vault
      path: "$session.raw_recording"
      format: text                   ← raw terminal output
  → assigned_to → thing:ai_claude
  → produces    → thing:step_annotate

thing:step_annotate
  kind: шаг
  inputs:
    команды:
      query: "SELECT text, stdout, stderr, exit_code, cwd
              FROM thing WHERE ->part_of->thing = $session_id
              AND kind = 'команда' ORDER BY ->part_of.order"
      format: table
    контекст_сервера:
      query: "SELECT * FROM thing WHERE id = $server_id"
      format: table
  → assigned_to → thing:ai_claude
  → produces    → thing:step_document
```

### Аннотация команды

AI создаёт `kind: аннотация` для каждой команды:

```
thing:annotation_cmd_042
  kind: аннотация
  explanation: "Устанавливает веб-сервер nginx из официального репозитория Ubuntu"
  effect: "Добавлен systemd-сервис nginx, автозапуск включён"
  severity: безопасно           ← безопасно | внимание | опасно | критично
  better_alternative: null
  → about → thing:cmd_042

-- Опасная команда:
thing:annotation_cmd_007
  kind: аннотация
  explanation: "Рекурсивное удаление /var/log без подтверждения"
  severity: опасно
  better_alternative: "rm -ri /var/log — интерактивный режим с подтверждением"
  → about → thing:cmd_007
```

### Изменения состояния сервера

AI выделяет значимые изменения из сессии:

```
thing:change_nginx_installed
  kind: изменение-сервера
  what: "Установлен nginx 1.24.0"
  why: "Веб-сервер для moms-shop.ru"
  how: "apt install nginx"
  reversible: true
  reverse_cmd: "apt remove nginx"
  → about   → thing:server_home1
  → part_of → thing:session_20260519_srv1
  → produces → thing:doc_block_nginx       ← блок в документации сервера

thing:change_nginx_config
  kind: изменение-сервера
  what: "Создан /etc/nginx/sites-available/moms-shop.conf"
  → about   → thing:server_home1
  → part_of → thing:session_20260519_srv1
  → about   → thing:site_moms_shop         ← связь с сайтом в графе
```

### Живая документация сервера

Формируется автоматически из изменений. Блоки обновляются при каждой сессии:

```
thing:doc_server_home1
  kind: документ
  name: "Документация: server1.home"
  → about → thing:server_home1

-- Блоки (обновляются AI после каждой сессии):
thing:block_services   text: "**Сервисы:** nginx 1.24, postgresql 16, docker 25"
thing:block_ports      text: "**Порты:** 80 (nginx), 443 (nginx), 5432 (pg local)"
thing:block_sites      text: "**Сайты:** moms-shop.ru → /var/www/moms-shop"
thing:block_crons      text: "**Cron:** бэкап БД в 03:00, certbot renew в 04:00"
thing:block_history    text: "**История:** 2026-05-19 установлен nginx..."
```

### Для сына: обучающий режим

Дополнительный слой поверх аннотаций — прогресс обучения:

```
thing:learning_profile_son
  kind: профиль-обучения
  subject: linux
  → about → thing:son

-- После анализа сессии:
thing:mistake_rm_rf
  kind: ошибка-обучения
  pattern: "rm -rf без проверки пути"
  count: 3                          ← сколько раз допустил
  last_seen: datetime
  → about      → thing:learning_profile_son
  → related_to → thing:annotation_cmd_007

thing:skill_package_mgmt
  kind: навык
  name: "Управление пакетами apt"
  confidence: 0.7                   ← 0..1 на основе успешных команд
  → about → thing:learning_profile_son
```

```surql
-- Прогресс сына: частые ошибки
SELECT pattern, count, last_seen FROM thing
WHERE kind = "ошибка-обучения"
  AND ->about->thing = thing:learning_profile_son
ORDER BY count DESC;

-- Опасные команды за последний месяц
SELECT text, cwd, executed_at,
       ->produces->thing.explanation AS пояснение
FROM thing
WHERE kind = "команда"
  AND ->produces->thing.severity IN ["опасно", "критично"]
  AND executed_at > time::now() - 30d
ORDER BY executed_at DESC;
```

### Полная схема потока

```mermaid
graph TD
    Shell[Shell / Bastion PTY]
    Vault[Vault: session.cast]
    Session[Сессия\nkind: терминал-сессия]
    Cmds[Команды\nkind: команда]
    AI[AI-пайплайн\nанализ сессии]
    Ann[Аннотации\nkind: аннотация]
    Changes[Изменения\nkind: изменение-сервера]
    Doc[Документация сервера\nобновляется]
    Learn[Профиль обучения\nсына]

    Shell -->|script/agent| Vault
    Shell -->|shell hook| Cmds
    Cmds -->|part_of| Session
    Vault -->|represents| Session
    Session -->|триггер| AI
    AI -->|produces| Ann
    AI -->|produces| Changes
    Changes -->|updates| Doc
    Ann -->|about| Cmds
    Ann -->|updates| Learn
```

### SurrealQL: аудит и статистика

```surql
-- Все сессии на сервере с итогом
SELECT host, goal, started_at,
       time::duration(ended_at - started_at) AS длительность,
       count(<-part_of<-thing[WHERE kind = "команда"]) AS команд,
       count(<-part_of<-thing->produces->thing[WHERE severity = "опасно"]) AS опасных
FROM thing
WHERE kind = "терминал-сессия" AND ->about->thing = thing:server_home1
ORDER BY started_at DESC;

-- Что изменилось на сервере за последние 30 дней
SELECT what, why, ->part_of->thing.started_at AS когда,
       ->part_of->thing.user AS кто
FROM thing
WHERE kind = "изменение-сервера"
  AND ->about->thing = thing:server_home1
  AND ->part_of->thing.started_at > time::now() - 30d
ORDER BY ->part_of->thing.started_at DESC;

-- Команды которые завершились с ошибкой
SELECT text, stderr, exit_code, cwd, executed_at,
       ->part_of->thing.host AS хост
FROM thing
WHERE kind = "команда" AND exit_code != 0
ORDER BY executed_at DESC LIMIT 50;

-- Серверы без актуальной документации (давно не было сессий)
SELECT name, hostname,
       max(<-about<-thing[WHERE kind = "терминал-сессия"].ended_at) AS последняя_сессия
FROM thing
WHERE kind = "сервер"
ORDER BY последняя_сессия ASC;
```

---

## IT-инфраструктура: сети, серверы, сервисы

Сеть — это граф. Топология, зависимости сервисов, инциденты, мультитенант — всё ложится на нашу модель без новых таблиц. Единственное добавление — ребро `linked_to` для симметричных физических и логических линков.

### Три уровня

```
Физический    — железо, стойки, кабели, порты
Сетевой       — IP, VLAN, VPN, DNS, TLS
Сервисный     — VM, контейнеры, процессы и их зависимости
```

### Новое ребро: linked_to

Симметричный линк между двумя точками: порт↔порт, VPN-endpoint↔VPN-endpoint, пиринг↔пиринг.

```surql
DEFINE TABLE linked_to TYPE RELATION FROM thing TO thing SCHEMALESS;
```

Поля не фиксированы — на медном линке пишем `speed`, `duplex`, на VPN-туннеле — `protocol`, `cipher`, `endpoint`. Схема не мешает.

### Виды узлов

| kind | что это |
|------|---------|
| `сайт` | точка присутствия — дом, офис, ЦОД |
| `стойка` | серверная стойка / шкаф |
| `сервер` | физический сервер / NAS |
| `вм` | виртуальная машина (Proxmox, VMware) |
| `контейнер` | Docker / LXC контейнер |
| `маршрутизатор` | L3-устройство |
| `коммутатор` | L2-устройство |
| `точка-доступа` | Wi-Fi AP |
| `упс` | источник бесперебойного питания |
| `интерфейс` | сетевой интерфейс (eth0, bond0, wg0) |
| `порт` | физический порт на коммутаторе / патч-панели |
| `подсеть` | IP-подсеть / VLAN |
| `dns-зона` | зона DNS |
| `dns-запись` | A / CNAME / MX / TXT запись |
| `сертификат` | TLS-сертификат |
| `впн` | VPN-туннель / оверлей |
| `сервис` | запущенный процесс / приложение (nginx, postgres) |
| `мониторинг-правило` | check / alert rule |
| `алерт` | сработавшее правило мониторинга |
| `инцидент` | авария / деградация |
| `плановое-обслуживание` | maintenance window |
| `резервная-копия` | backup job / snapshot |

### Физический уровень

```
kind: сайт (дом / офис)
  contains → kind: стойка
    contains → kind: сервер
      contains → kind: интерфейс
        linked_to ←→ kind: порт (на коммутаторе)
    contains → kind: коммутатор
      contains → kind: порт
    contains → kind: маршрутизатор
    contains → kind: упс
  located_at → kind: адрес
```

```mermaid
graph TD
    Site["kind: сайт\nname: Домашняя сеть"]
    Rack["kind: стойка\nname: 12U под столом"]
    Router["kind: маршрутизатор\nname: MikroTik RB4011"]
    Switch["kind: коммутатор\nname: CSS326-24G"]
    Server["kind: сервер\nname: Proxmox-home"]
    UPS["kind: упс\nname: APC 1500"]
    ISP["kind: маршрутизатор\nname: Роутер провайдера"]

    Site -->|contains| Rack
    Rack -->|contains| Router
    Rack -->|contains| Switch
    Rack -->|contains| Server
    Rack -->|contains| UPS
    Router ---|"linked_to\nmedium: copper"| ISP
    Router ---|"linked_to\nspeed: 1G"| Switch
    Server ---|"linked_to\nspeed: 1G"| Switch
```

### Сетевой уровень

```
kind: подсеть  (name: "LAN", cidr: "192.168.1.0/24")
  part_of → kind: маршрутизатор

kind: подсеть  (name: "IoT VLAN", cidr: "10.10.20.0/24", vlan_id: 20)
  part_of → kind: коммутатор

kind: впн  (name: "WireGuard road-warrior")
  part_of → kind: сервер
  linked_to ←→ kind: впн  (клиент на телефоне)

kind: dns-зона  (name: "home.lan")
  contains → kind: dns-запись  (type: A, name: proxmox, value: 192.168.1.10)
    about → kind: сервер

kind: сертификат  (name: "*.home.lan", expires_at: ...)
  about → kind: сервис  (name: Nextcloud)
```

### Сервисный уровень и зависимости

`depends_on` строит граф зависимостей сервисов. Обход в обратном направлении даёт blast radius — «что упадёт, если этот сервер ляжет».

```
kind: вм  (name: Nextcloud-VM)
  part_of → kind: сервер

kind: сервис  (name: Nextcloud)
  part_of → kind: вм
  depends_on → kind: сервис  (name: PostgreSQL)
  depends_on → kind: сервис  (name: Redis)

kind: сервис  (name: PostgreSQL)
  part_of → kind: вм  (name: DB-VM)

kind: сервис  (name: Pi-hole)
  part_of → kind: контейнер
  depends_on → kind: подсеть  (DNS-трафик идёт через него)
```

```mermaid
graph LR
    NC["kind: сервис\nname: Nextcloud"]
    PG["kind: сервис\nname: PostgreSQL"]
    RD["kind: сервис\nname: Redis"]
    PH["kind: сервис\nname: Pi-hole"]
    VM1["kind: вм\nname: App VM"]
    VM2["kind: вм\nname: DB VM"]
    CT["kind: контейнер\nname: pihole-ct"]
    SRV["kind: сервер\nname: Proxmox-home"]

    NC -->|depends_on| PG
    NC -->|depends_on| RD
    NC -->|part_of| VM1
    PG -->|part_of| VM2
    RD -->|part_of| VM1
    PH -->|part_of| CT
    VM1 -->|part_of| SRV
    VM2 -->|part_of| SRV
    CT -->|part_of| SRV
```

### IPAM: адреса как узлы

IP-адрес можно хранить прямо в полях `интерфейса` (просто, достаточно для большинства случаев) или выделить в отдельный узел `kind: ip-адрес` для IPAM с историей назначений.

```
kind: интерфейс
  name: eth0
  ip: "192.168.1.10/24"
  mac: "aa:bb:cc:dd:ee:ff"
  part_of → kind: сервер
  linked_to ←→ kind: порт
```

Для полноценного IPAM:
```
kind: ip-адрес  (address: "192.168.1.10", allocated_at: ...)
  part_of → kind: подсеть
  about → kind: интерфейс
```

### Мониторинг и инциденты

```
kind: мониторинг-правило  (name: "SSL expiry check", interval: "1d")
  about → kind: сертификат
  produces → kind: алерт  (при срабатывании через DEFINE EVENT)

kind: алерт  (severity: "critical", fired_at: ...)
  about → kind: сервис  (name: Nextcloud)
  produces → kind: инцидент

kind: инцидент  (name: "Nextcloud недоступен", started_at: ...)
  about → kind: сервис
  assigned_to → kind: пользователь  (я)
  produces → kind: плановое-обслуживание  (когда инцидент закрыт)
```

```mermaid
graph LR
    Rule["kind: мониторинг-правило\nname: cert expiry"]
    Cert["kind: сертификат\nexpires_at: 2025-07-01"]
    Alert["kind: алерт\nseverity: warning"]
    Inc["kind: инцидент\nname: Срок сертификата"]
    Me["kind: пользователь\nname: Я"]

    Rule -->|about| Cert
    Rule -->|produces| Alert
    Alert -->|produces| Inc
    Inc -->|assigned_to| Me
```

### Мультитенант: чужие сети

Каждая сеть — отдельный корневой узел `kind: сайт`. Пользователь получает `can_access` с нужными правами. Работает поверх нашей уже разработанной модели доступа.

```
kind: сайт  (name: "Сеть офиса ООО Ромашка")
  ← can_access ← kind: пользователь  (Я, permissions: ["admin", "view"])

kind: сайт  (name: "Домашняя сеть друга Коли")
  ← can_access ← kind: пользователь  (Я, permissions: ["view", "edit"])
```

Если друг тоже использует Домовой — подключается через федерацию (shadow namespace). Если нет — узлы просто живут в нашем инстансе.

**Аренда оборудования** органично вписывается:
```
kind: маршрутизатор  (name: "MikroTik запасной")
  lent_to → kind: пользователь  (name: Коля, since: 2024-03-10)
```

### Связь с терминальными сессиями

Уже спроектированный протокол терминальных сессий замыкается на IT-инфраструктуру через `about`:

```
kind: терминал-сессия
  about → kind: сервер  (name: Proxmox-home)

kind: изменение-сервера
  part_of → kind: терминал-сессия
  about → kind: сервис  (name: nginx)
```

Это даёт полную историю: кто, когда, на каком сервере, что сделал с каким сервисом.

### SurrealQL: типовые запросы

```surql
-- Blast radius: что зависит от этого сервера (транзитивно)
SELECT name, kind FROM thing
WHERE ->depends_on->thing->part_of->thing = thing:server_proxmox
   OR ->depends_on->thing->part_of->thing->part_of->thing = thing:server_proxmox;

-- Сертификаты, истекающие через 30 дней
SELECT name, expires_at,
       ->about->thing.name AS сервис
FROM thing
WHERE kind = "сертификат"
  AND expires_at < time::now() + 30d
ORDER BY expires_at ASC;

-- Топология: все устройства в сайте с их линками
SELECT name, kind,
       <->linked_to<->thing.{ name, kind } AS соседи
FROM thing
WHERE ->part_of->thing = thing:site_home
  AND kind IN ["сервер", "коммутатор", "маршрутизатор", "точка-доступа"];

-- Сервисы без мониторингового правила
SELECT name, kind FROM thing
WHERE kind = "сервис"
  AND count(<-about<-thing[WHERE kind = "мониторинг-правило"]) = 0;

-- Все инциденты по чужим сетям, где я администратор
SELECT name, started_at, ->about->thing.name AS объект,
       ->about->thing->part_of->thing->part_of->thing.name AS сайт
FROM thing
WHERE kind = "инцидент"
  AND ->about->thing->part_of->thing->part_of->thing IN (
    SELECT id FROM thing
    WHERE kind = "сайт"
      AND <-can_access<-thing[WHERE id = $auth AND "admin" IN permissions]
  )
ORDER BY started_at DESC;

-- История обслуживания конкретного сервера
SELECT name, started_at, ended_at, ->assigned_to->thing.name AS кто
FROM thing
WHERE kind IN ["инцидент", "плановое-обслуживание"]
  AND ->about->thing = thing:server_proxmox
ORDER BY started_at DESC;

-- Что я одолжил друзьям из железа
SELECT name, kind,
       ->lent_to->thing.name AS кому,
       ->lent_to.since AS с_какого
FROM thing
WHERE kind IN ["сервер", "маршрутизатор", "коммутатор", "упс"]
  AND ->lent_to->thing != NONE;
```

---

## Дашборды, виджеты и отчёты

Дашборд — это граф-узел, который содержит виджеты. Виджет — исполняемый модуль с chart-выводом. Архитектура `inputs` (named SurrealQL queries) уже спроектирована; здесь мы добавляем chart-типы, layout и внешние datasource для телеметрии.

### Новые виды узлов

| kind | что это |
|------|---------|
| `дашборд` | коллекция виджетов с layout |
| `виджет` | единица визуализации — chart, таблица, скаляр |
| `отчёт` | шаблонный документ с именованными inputs |
| `снимок-отчёта` | сгенерированный артефакт (produces от отчёта) |

### Виджет как исполняемый модуль

Виджет — это тот же исполняемый модуль из экосистемы notebook/quarto, только с chart-выводом. `inputs` работают ровно так же: named SurrealQL queries или запросы к внешнему datasource.

```yaml
kind: виджет
name: "Задачи по статусам"
chart_type: echarts        # echarts | mermaid | table | scalar | text | map
position: { x: 0, y: 0, w: 6, h: 4 }   # grid-координаты на дашборде
config:
  xAxis: { type: category, data: "{{labels}}" }
  series:
    - type: bar
      data: "{{values}}"
inputs:
  labels:
    source: surreal
    query: "SELECT status FROM thing WHERE kind='задача' GROUP BY status"
    format: scalar
  values:
    source: surreal
    query: "SELECT count() AS n FROM thing WHERE kind='задача' GROUP BY status"
    format: scalar
```

### Типы chart_type

| chart_type | рендерер | описание |
|-----------|---------|---------|
| `echarts` | Apache ECharts | любой chart: bar, line, pie, scatter, heatmap, sankey, graph |
| `mermaid` | Mermaid.js | flowchart, sequence, gantt, ER — генерируется из SurrealQL |
| `table` | встроенный | табличные данные с сортировкой и пагинацией |
| `scalar` | встроенный | одно число / строка (stat panel) с threshold-цветом |
| `text` | Markdown | статичный или шаблонный текст |
| `map` | Leaflet / MapLibre | геоданные из `located_at` |

### Телеметрия во внешний datasource

Временны́е ряды (метрики, логи, трейсы) хранятся снаружи — в специализированных хранилищах. Домовой их не дублирует, только ссылается через `kind: источник-данных`.

Новые подтипы `kind: источник-данных`:

| subtype | система |
|---------|---------|
| `prometheus` | метрики, PromQL |
| `victoria-metrics` | метрики, MetricsQL |
| `influxdb` | метрики, Flux / InfluxQL |
| `clickhouse` | аналитика, SQL |
| `loki` | логи, LogQL |
| `elasticsearch` | поиск / логи, Lucene |

```surql
-- Узел datasource для Prometheus
CREATE thing SET
  kind = "источник-данных",
  name = "Prometheus home",
  subtype = "prometheus",
  url = "http://prometheus.home:9090",
  about = thing:site_home;
```

### Мультисource: микс SurrealQL и телеметрии в одном виджете

Виджет может получать данные из разных источников в одном `inputs` — граф и метрики рядом:

```yaml
kind: виджет
name: "Нагрузка Proxmox vs активные задачи"
chart_type: echarts
inputs:
  cpu_load:
    source: thing:ds_prometheus_home
    query: 'rate(node_cpu_seconds_total{mode!="idle"}[5m]) * 100'
    format: table
  active_tasks:
    source: surreal
    query: >
      SELECT time::group(created_at, "1h") AS t, count() AS n
      FROM thing WHERE kind = "задача" AND status = "активна"
      GROUP BY t ORDER BY t
    format: table
```

### Дашборд

```
kind: дашборд
  name: "Инфраструктура дома"
  contains → kind: виджет  (CPU load)
  contains → kind: виджет  (Disk usage)
  contains → kind: виджет  (Активные задачи)
  contains → kind: виджет  (Инциденты за 30 дней)
  can_access ← kind: пользователь
```

```mermaid
graph TD
    DB["kind: дашборд\nname: Инфраструктура дома"]
    W1["kind: виджет\nchart_type: echarts\nname: CPU load"]
    W2["kind: виджет\nchart_type: scalar\nname: Disk free"]
    W3["kind: виджет\nchart_type: table\nname: Инциденты"]
    W4["kind: виджет\nchart_type: mermaid\nname: Топология сети"]
    DS["kind: источник-данных\nsubtype: prometheus"]
    SDB[("SurrealDB")]

    DB -->|contains| W1
    DB -->|contains| W2
    DB -->|contains| W3
    DB -->|contains| W4
    W1 -->|input: cpu_load| DS
    W2 -->|input: disk| DS
    W3 -->|input: incidents| SDB
    W4 -->|input: topology| SDB
```

### Mermaid из графа

Mermaid-диаграмму можно генерировать прямо из SurrealQL — граф зависимостей задач, сервисов, юридических обжалований:

```surql
-- Генерация Mermaid flowchart из зависимостей задач
LET $lines = SELECT
    in.name + ' --> ' + out.name AS line
FROM depends_on
WHERE in.kind = 'задача' AND in ->part_of->thing = thing:project_home;

RETURN "graph TD\n" + array::join($lines.line, "\n");
```

### Отчёт

```
kind: отчёт
  name: "Ежемесячный семейный отчёт"
  template: |
    ## {{month}}
    Задач выполнено: {{done_count}}
    Расходы: {{expenses}}
    {{task_chart}}
  format: pdf           # pdf | html | markdown
  inputs:
    done_count: { source: surreal, query: "..." }
    expenses:   { source: surreal, query: "..." }
    task_chart: { source: surreal, query: "...", format: echarts }
  triggered_by → kind: расписание  (monthly)
  produces → kind: файл             (PDF в vault)
  about → kind: пользователь        (для кого отчёт)
```

Снимок отчёта:
```
kind: снимок-отчёта
  generated_at: "2025-05-01T00:00:00Z"
  format: pdf
  represents → kind: файл   (физический файл в vault)
  part_of → kind: отчёт     (шаблон, из которого сгенерирован)
```

### Дашборд как страница сайта

Дашборд — частный случай `kind: страница` с виджетами вместо текстового контента. Публикуется, шарится и встраивается в любой сайт через уже существующую модель:

```
kind: страница
  kind: виджет  (через contains, не через секции)
  part_of → kind: сайт
  can_access ← thing:public   ← публичный дашборд
```

### SurrealQL: типовые запросы

```surql
-- Все дашборды, доступные текущему пользователю
SELECT name, created_at,
       count(<-contains<-thing) AS виджетов
FROM thing
WHERE kind = "дашборд"
  AND (<-can_access<-thing = $auth
    OR <-can_access<-thing = thing:public)
ORDER BY created_at DESC;

-- Виджеты дашборда с их источниками
SELECT name, chart_type, position, inputs
FROM thing
WHERE kind = "виджет"
  AND <-contains<-thing = thing:dashboard_infra;

-- Все отчёты с расписанием и датой последней генерации
SELECT name, format,
       ->triggered_by->thing.cron AS расписание,
       max(->produces->thing.generated_at) AS последний_снимок
FROM thing
WHERE kind = "отчёт"
ORDER BY последний_снимок DESC;

-- Снимки конкретного отчёта
SELECT generated_at, format,
       ->represents->thing.path AS файл
FROM thing
WHERE kind = "снимок-отчёта"
  AND ->part_of->thing = thing:report_monthly
ORDER BY generated_at DESC;
```

---

## AI-чаты, промпты и агенты

Единый хаб для всех AI-инструментов. Чаты живут в графе как узлы, обогащаются данными из графа через `inputs` (RAG), ветвятся, запускаются параллельно, ссылаются друг на друга. Провайдер абстрагирован через `kind: источник-данных` — поменял один узел, все чаты переключились.

### Новые виды узлов

| kind | что это |
|------|---------|
| `чат` | conversation thread |
| `сообщение` | одно сообщение в чате |
| `модель-ai` | конфигурация AI-модели |
| `промпт` | переиспользуемый шаблон промпта |
| `коллекция-промптов` | библиотека промптов |
| `запуск-ai` | параллельный запуск одного промпта через несколько моделей |
| `агент-ai` | автономный AI-агент с триггерами и доступом к графу |

### Провайдеры и прокси

Домовой не знает, где физически живёт модель. Он знает только datasource — URL и auth. Всё, что говорит OpenAI-совместимый API, работает без изменений.

Новые subtypes `kind: источник-данных`:

| subtype | что это |
|---------|---------|
| `openai-compatible` | универсальный — LM Studio, LocalAI, vLLM, Ollama |
| `anthropic` | Anthropic API напрямую |
| `openai` | OpenAI API напрямую |
| `google-ai` | Google AI (Gemini) |
| `openrouter` | мета-прокси: один ключ → все провайдеры |
| `litellm` | self-hosted прокси с учётом стоимости и маршрутизацией |
| `groq` | быстрый inference |
| `mistral` | Mistral AI |
| `vision-local` | локальная vision-модель через Ollama (llava, minicpm-v, qwen2-vl) |
| `vision-api` | облачная vision-модель (GPT-4o, Claude 3.5 Sonnet, Gemini Flash) |

**Позднее связывание провайдера** — ключевой паттерн. Когда ещё не определился с провайдером, указываешь на прокси или LM Studio. Чаты ссылаются на этот datasource-узел. Когда определился — меняешь один узел, все чаты переключаются автоматически.

```surql
-- Пока экспериментируем с LM Studio локально
CREATE thing:ds_local_ai SET
  kind = "источник-данных",
  subtype = "openai-compatible",
  url = "http://localhost:1234/v1",
  name = "LM Studio (эксперимент)",
  fallback_to = thing:ds_openrouter;  -- если локальный недоступен

-- Определились — переключаем на Anthropic
UPDATE thing:ds_local_ai SET
  subtype = "anthropic",
  url = "https://api.anthropic.com";
-- Все чаты, ссылающиеся на thing:ds_local_ai, теперь идут к Anthropic
```

Поле `fallback_to` (record<thing>) указывает на резервный datasource — воркер пробует его если основной вернул ошибку.

### Чат

```yaml
kind: чат
name: "Разбор инцидента на Proxmox"
model_default: "claude-opus-4-7"
provider: thing:ds_anthropic
system_prompt: thing:prompt_devops_assistant   # поле, не ребро
about: thing:server_proxmox                    # о чём чат
part_of: thing:collection_devops_chats         # группировка
inputs:
  recent_incidents:
    source: surreal
    query: >
      SELECT name, started_at, ->about->thing.name AS объект
      FROM thing WHERE kind = 'инцидент'
      ORDER BY started_at DESC LIMIT 5
    format: text
  server_services:
    source: surreal
    query: >
      SELECT name, ->part_of->thing.name AS хост
      FROM thing WHERE kind = 'сервис'
        AND ->part_of->thing->part_of->thing = thing:server_proxmox
    format: table
```

`inputs` вставляются в system message перед каждым запросом — это нативный RAG из графа без дополнительной инфраструктуры.

### Сообщение

```yaml
kind: сообщение
role: "user"          # user | assistant | system | tool
content: "Посмотри на этот скриншот ошибки..."
model: "gpt-4o"       # override, если переключили модель внутри чата
tokens_in: 1842
tokens_out: 512
latency_ms: 2300
cost_usd: 0.0031
part_of: thing:chat_incident_proxmox
# вложения (мультимодальность)
attachments:
  - type: image
    vault_id: "file:screenshot_error"
```

Рёбра сообщения:
```
kind: сообщение
  part_of → kind: чат
  references → kind: сообщение   ← цитата из другого чата
  references → kind: thing        ← RAG-узел, который был в контексте
```

### Ветвление чатов

Ветвление — дерево через `part_of`. Поле `branch_point` ссылается на ID сообщения-развилки.

```
kind: чат  (родитель, сообщения 1–N)
  ← part_of ← kind: чат  (ветка А, branch_point: "message:N")
  ← part_of ← kind: чат  (ветка Б, branch_point: "message:N")
```

```mermaid
graph TD
    Root["kind: чат\nОсновной"]
    M1["сообщение 1"]
    M2["сообщение 2"]
    M3["сообщение 3\n← развилка"]
    BrA["kind: чат\nВетка А\nbranch_point: M3"]
    BrB["kind: чат\nВетка Б\nbranch_point: M3"]
    MA1["сообщение A1"]
    MB1["сообщение B1"]

    Root -->|contains| M1
    Root -->|contains| M2
    Root -->|contains| M3
    BrA -->|part_of| Root
    BrB -->|part_of| Root
    BrA -->|contains| MA1
    BrB -->|contains| MB1
```

### Параллельный запуск: сравнение моделей

`kind: запуск-ai` — fan-out одного промпта через несколько моделей/провайдеров. Тот же паттерн, что юридические обжалования по инстанциям.

```
kind: запуск-ai
  name: "Сравнение: анализ инцидента"
  about → kind: промпт
  produces → kind: чат  (Claude Opus, via ds_anthropic)
  produces → kind: чат  (GPT-4o, via ds_openai)
  produces → kind: чат  (Llama-3.3-70b, via ds_lmstudio)
  produces → kind: чат  (Mistral Large, via ds_openrouter)
```

После завершения — виджет сравнивает `tokens_out`, `latency_ms`, `cost_usd`. Видно, кто быстрее, дешевле, качественнее для конкретной задачи.

```mermaid
graph TD
    Run["kind: запуск-ai\nАнализ инцидента"]
    Pr["kind: промпт\nDevOps-анализ"]
    C1["kind: чат\nClaude Opus"]
    C2["kind: чат\nGPT-4o"]
    C3["kind: чат\nLlama local"]
    C4["kind: чат\nMistral Large"]
    W["kind: виджет\nchart_type: table\nСравнение результатов"]

    Run -->|about| Pr
    Run -->|produces| C1
    Run -->|produces| C2
    Run -->|produces| C3
    Run -->|produces| C4
    C1 -->|part_of| W
    C2 -->|part_of| W
    C3 -->|part_of| W
    C4 -->|part_of| W
```

### Обогащение чата из другого чата

```
kind: чат  (Б)
  references → kind: чат  (А)
    mode: "context"
    snapshot_text: "Краткое резюме чата А..."

kind: сообщение  (в чате Б)
  references → kind: сообщение  (из чата А)
    mode: "quoted"
    snapshot_text: "..."
```

Снапшот текста хранится в ребре — чат А может быть удалён или переехать, контекст сохраняется.

### Библиотека промптов

```
kind: коллекция-промптов
  name: "IT и DevOps"
  can_access ← kind: пользователь

kind: промпт
  name: "Анализ инцидента"
  text: "Ты опытный DevOps-инженер. Проанализируй инцидент и предложи решение..."
  tags: ["devops", "incident", "debug"]
  part_of → kind: коллекция-промптов
  language: "ru"
  model_hint: "claude-opus-4-7"   # рекомендованная модель
```

Промпты — те же `thing`-узлы: версионируются через `produces`, шарятся через `can_access`, привязываются к чату через поле `system_prompt`.

### Агент

```
kind: агент-ai
  name: "Мониторинг инфраструктуры"
  model: "claude-haiku-4-5"
  system_prompt: thing:prompt_infra_monitor
  inputs:
    alerts:
      source: surreal
      query: "SELECT * FROM thing WHERE kind='алерт' AND status='новый'"
      format: text
  triggered_by → kind: расписание  (каждые 15 минут)
  about → kind: сайт               (следит за конкретной сетью)
  produces → kind: чат             (лог работы агента)
  produces → kind: инцидент        (если нашёл проблему)
```

### SurrealQL: типовые запросы

```surql
-- Все чаты с суммарной стоимостью и количеством сообщений
SELECT name, model_default,
       count(<-part_of<-thing[WHERE kind = "сообщение"]) AS сообщений,
       math::sum(<-part_of<-thing[WHERE kind = "сообщение"].cost_usd) AS стоимость_usd,
       ->about->thing.name AS контекст
FROM thing
WHERE kind = "чат"
ORDER BY стоимость_usd DESC;

-- Сравнение результатов запуска-ai
SELECT ->produces->thing.{ name, model_default,
         math::sum(<-part_of<-thing.tokens_out) AS токенов,
         math::sum(<-part_of<-thing.cost_usd) AS стоимость,
         math::mean(<-part_of<-thing.latency_ms) AS латентность_мс
       } AS модели
FROM thing
WHERE kind = "запуск-ai" AND id = thing:run_incident_analysis;

-- Все ветки чата (дерево)
SELECT id, name, branch_point,
       count(<-part_of<-thing[WHERE kind = "сообщение"]) AS сообщений
FROM thing
WHERE kind = "чат" AND ->part_of->thing = thing:chat_main;

-- Промпты, которые я использую чаще всего
SELECT ->about->thing.name AS промпт, count() AS использований
FROM thing
WHERE kind = "чат" AND ->about->thing.kind = "промпт"
GROUP BY промпт
ORDER BY использований DESC;

-- Стоимость AI за последние 30 дней по провайдерам
SELECT ->part_of->thing->provider->thing.name AS провайдер,
       math::sum(cost_usd) AS стоимость,
       count() AS запросов
FROM thing
WHERE kind = "сообщение"
  AND ->part_of->thing.created_at > time::now() - 30d
GROUP BY провайдер
ORDER BY стоимость DESC;

-- Найти чаты, где обсуждался конкретный сервер
SELECT name, created_at,
       count(<-part_of<-thing[WHERE kind = "сообщение"]) AS сообщений
FROM thing
WHERE kind = "чат" AND ->about->thing = thing:server_proxmox
ORDER BY created_at DESC;
```

---

## Блокировки (locking)

Лок — операционное состояние, а не граф-отношение. Хранится как поля на `thing` (schemaless — без изменений схемы и без миграций). Два сценария: пользователь явно блокирует каскад для редактирования, или AI/воркер генерирует каскад и узлы ещё не готовы.

### Поля блокировки

```
-- Пользовательский лок
locked_by:          record<thing>   ← пользователь, агент или воркер
lock_type:          string          ← "редактирование" | "публикация" | "ревью" | "генерация"
lock_scope:         string          ← "узел" | "каскад"
lock_expires_at:    datetime
lock_reason:        string

-- Генерация AI или внешнего модуля
status:                  "генерируется"
generating_by:           record<thing>   ← агент-ai или воркер
generation_started_at:   datetime
generation_timeout_at:   datetime        ← дедлайн, после которого лок сбрасывается
```

### Каскадный лок

`lock_scope: "каскад"` означает, что блокировка распространяется на всё поддерево через `part_of`. При проверке обходим предков:

```surql
-- Заблокирован ли узел или любой его предок?
SELECT id FROM thing
WHERE id = $node_id
  AND (
       locked_by != NONE
    OR ->part_of->thing.locked_by != NONE
    OR ->part_of->thing->part_of->thing.locked_by != NONE
  );

-- Все узлы под заблокированным каскадом
SELECT id, name, kind FROM thing
WHERE ->part_of->thing[WHERE locked_by != NONE AND lock_scope = "каскад"] != NONE;
```

### Автосброс зависших локов

Если пользователь закрыл браузер или воркер упал — лок не должен висеть вечно. DEFINE EVENT сбрасывает просроченные блокировки:

```surql
-- Сброс пользовательского лока по истечении времени
DEFINE EVENT unlock_expired ON TABLE thing
  WHEN $after.lock_expires_at != NONE
    AND $after.lock_expires_at < time::now()
THEN {
  UPDATE $after.id SET
    locked_by         = NONE,
    lock_type         = NONE,
    lock_scope        = NONE,
    lock_expires_at   = NONE,
    lock_reason       = NONE;
};

-- Сброс генерации по таймауту (воркер завис)
DEFINE EVENT generation_timeout ON TABLE thing
  WHEN $after.generation_timeout_at != NONE
    AND $after.generation_timeout_at < time::now()
    AND $after.status = "генерируется"
THEN {
  UPDATE $after.id SET
    status                 = "ошибка-генерации",
    generating_by          = NONE,
    generation_started_at  = NONE,
    generation_timeout_at  = NONE;
};
```

### Типовые запросы

```surql
-- Все активные блокировки в системе
SELECT name, kind, locked_by.name AS кто, lock_type, lock_scope,
       lock_expires_at, lock_reason
FROM thing
WHERE locked_by != NONE
ORDER BY lock_expires_at ASC;

-- Все узлы, которые сейчас генерируются
SELECT name, kind, generating_by.name AS агент,
       generation_started_at,
       generation_timeout_at
FROM thing
WHERE status = "генерируется"
ORDER BY generation_started_at ASC;

-- Мои активные блокировки
SELECT name, kind, lock_type, lock_scope, lock_expires_at
FROM thing
WHERE locked_by = $auth AND locked_by != NONE;

-- Снять все мои блокировки
UPDATE thing SET
  locked_by = NONE, lock_type = NONE,
  lock_scope = NONE, lock_expires_at = NONE, lock_reason = NONE
WHERE locked_by = $auth;
```

---

## UI-слой

Ключевой принцип: **не создавай UI для каждой фичи — создай UI для графа**. Все экраны приложения — это один generic-рендерер плюс view-определения, хранящиеся в самом графе.

### Три уровня

```
Граф (данные)          — SurrealDB: thing + edges
Виды (что показывать)  — тоже в SurrealDB: kind: вид
Рендерер (как)         — generic React-компоненты, читают виды из графа
```

Добавить поддержку нового `kind` в UI = создать узел `kind: вид`. Код не трогаешь.

### Новые виды узлов

| kind | что это |
|------|---------|
| `вид` | описание того, как рендерить конкретный kind |
| `умный-список` | сохранённый SurrealQL-запрос как навигационный экран |
| `рабочее-пространство` | персональная сборка из списков, дашбордов и пинов |
| `действие` | доступная операция для kind (complete, delegate, split…) |

### kind: вид

Определяет рендеринг конкретного `kind` в трёх режимах: карточка в списке, полная страница, inline внутри родителя.

```yaml
kind: вид
for_kind: "задача"
modes:
  card:
    fields: [name, status, due_date]
    badge: status
    color_by: priority
  detail:
    fields: [name, status, due_date, description, energy, context]
    edges:
      - depends_on:   "Блокируется"
      - part_of:      "Проект"
      - assigned_to:  "Исполнитель"
      - about:        "О чём"
      - produces:     "Результат"
    sections:
      - kind: умный-список   # подзадачи
        query: "SELECT * FROM thing WHERE ->part_of->thing = $id"
  inline:
    fields: [name, status]
    compact: true
actions:
  - name: "Выполнить"
    sets: { status: "выполнена" }
  - name: "Делегировать"
    opens: "assigned_to"
  - name: "Разбить"
    creates: { kind: "задача", part_of: "$id" }
```

```surql
-- Создать вид для задачи
CREATE thing SET
  kind = "вид",
  for_kind = "задача",
  modes = { ... },
  actions = [ ... ];

-- Получить вид для рендеринга
SELECT * FROM thing WHERE kind = "вид" AND for_kind = $target_kind;
```

### Три режима рендеринга

Один generic React-компонент на каждый режим. Kind-специфичные компоненты — только для сложных UX (Kanban, граф, чат).

```
card    — карточка в списке
         название, статус, пара полей, badge
         клик → открывает detail

detail  — полная страница
         все поля из вида, все рёбра как секции
         история изменений, actions

inline  — встроен в контекст родителя
         подзадача внутри задачи, сообщение внутри чата
         компактно, без переходов
```

```mermaid
graph LR
    Thing["thing (данные)"]
    View["kind: вид\nfor_kind: задача"]
    Renderer["Generic Renderer\n(React)"]
    Card["Card mode"]
    Detail["Detail mode"]
    Inline["Inline mode"]

    Thing -->|данные| Renderer
    View -->|layout + fields + actions| Renderer
    Renderer --> Card
    Renderer --> Detail
    Renderer --> Inline
```

### kind: умный-список

Все «экраны» приложения — умные списки. Inbox, сегодня, мои задачи, истекающие сертификаты — один компонент `<SmartList>`, разные SurrealQL-запросы.

```yaml
kind: умный-список
name: "Сегодня"
query: >
  SELECT * FROM thing
  WHERE status != "выполнена"
    AND (due_date < time::now() + 1d OR due_date = NONE)
    AND ->assigned_to->thing = $auth
ORDER BY priority DESC, due_date ASC
view_mode: "card"      # как рендерить элементы списка
group_by: "kind"       # опциональная группировка
```

```yaml
kind: умный-список
name: "Истекающие сертификаты"
query: >
  SELECT * FROM thing
  WHERE kind = "сертификат"
    AND expires_at < time::now() + 30d
ORDER BY expires_at ASC
view_mode: "card"
```

```yaml
kind: умный-список
name: "Инфраструктура — открытые инциденты"
query: >
  SELECT * FROM thing
  WHERE kind = "инцидент" AND status = "открыт"
    AND ->about->thing->part_of->thing->part_of->thing IN (
      SELECT id FROM thing WHERE kind = "сайт"
    )
ORDER BY started_at DESC
view_mode: "list-row"
```

Умные списки — это те же `thing`-узлы: шарятся через `can_access`, пинятся в рабочее пространство, встраиваются в дашборды как виджеты с `chart_type: table`.

### kind: рабочее-пространство

Персональная сборка: навигация слева, дашборд сверху, пины на часто используемые узлы.

```yaml
kind: рабочее-пространство
name: "Моя главная"
owner: thing:user_me
sidebar:
  - thing:list_today          # умный-список "Сегодня"
  - thing:list_inbox          # умный-список "Входящие"
  - thing:list_infra_alerts   # умный-список "Алерты"
dashboard: thing:dashboard_home
pinned:
  - thing:project_home_repair
  - thing:site_home_network
  - thing:chat_ai_devops
```

У каждого члена семьи — своё рабочее пространство. Общие умные списки шарятся через `can_access`.

### Навигация = граф

Основной способ навигации — следование по рёбрам. Кликнул на `assigned_to` → открылся профиль пользователя. Кликнул на `part_of` → открылся проект. Кликнул на `about` → открылся сервер.

Хлебные крошки формируются из пути по графу, а не из URL-иерархии.

```
Инциденты → Proxmox недоступен → О: сервер Proxmox-home → Сервисы → Nextcloud
```

### Kanban, Calendar, Graph — специализированные виды

Для часто используемых сценариев — специализированные React-компоненты поверх той же модели данных:

| Компонент | Источник данных |
|-----------|----------------|
| `<Kanban>` | умный-список, сгруппированный по `status` |
| `<Calendar>` | умный-список с полем `due_date` или `started_at` |
| `<GraphView>` | SurrealQL-запрос с рёбрами, рендер через D3 / Cytoscape |
| `<Chat>` | `kind: чат` + `kind: сообщение` через `part_of` |
| `<Dashboard>` | `kind: дашборд` + `kind: виджет` |

Каждый компонент — это просто другой способ отрендерить тот же набор `thing`-узлов.

### SurrealQL: запросы для UI

```surql
-- Получить вид для kind
SELECT * FROM thing WHERE kind = "вид" AND for_kind = $target_kind LIMIT 1;

-- Умные списки текущего пользователя (свои + расшаренные)
SELECT name, query, view_mode, group_by
FROM thing
WHERE kind = "умный-список"
  AND (<-can_access<-thing = $auth OR <-can_access<-thing = thing:public);

-- Рабочее пространство пользователя
SELECT *, sidebar.{ name, kind, query } AS nav,
       dashboard.{ name } AS доска
FROM thing
WHERE kind = "рабочее-пространство" AND owner = $auth
LIMIT 1;

-- Breadcrumb: путь от узла до корня через part_of
SELECT id, name, kind FROM thing
WHERE id = $node_id
  FETCH ->part_of->thing, ->part_of->thing->part_of->thing;

-- Все доступные действия для kind
SELECT actions FROM thing
WHERE kind = "вид" AND for_kind = $target_kind;
```

---

## Голосовые помощники и чат-боты

Чат-бот — это `kind: агент-ai`, подключённый к `kind: шлюз`. Голосовой помощник — тот же агент, другой шлюз с STT/TTS модулями. Лог разговора — `kind: чат` (уже спроектирован). Новых kinds не нужно.

### Архитектура

```
Пользователь
  ↓ голос / текст
kind: шлюз  (telegram-bot | web-chat | voice-local | алиса)
  ↓ нормализованный текст + метаданные автора
kind: агент-ai  (мозг бота)
  ↓ читает контекст через inputs
  ↓ вызывает граф-операции через tool use
  ↓ генерирует ответ
kind: шлюз  (отправляет ответ обратно)
  ↓ текст / голос
Пользователь
```

Весь разговор пишется в `kind: чат` → `kind: сообщение`.

### Новые subtypes шлюза

| subtype | платформа |
|---------|-----------|
| `telegram-bot` | Telegram Bot API |
| `web-chat` | встроенный виджет на сайте/PWA |
| `voice-local` | локальный голосовой ассистент (Home Assistant, custom) |
| `алиса` | Яндекс Алиса (навык) |
| `home-assistant` | Home Assistant conversation agent |
| `whatsapp-bot` | WhatsApp Business API |

### Tool use: граф как инструменты LLM

Агент не генерирует сырой SurrealQL — вызывает структурированные граф-операции через LLM tool use / function calling. Бэкенд транслирует в SurrealQL с проверкой прав `can_access` текущего пользователя.

```json
// Создать задачу
{ "tool": "create",
  "kind": "задача",
  "fields": { "name": "Купить молоко", "status": "активна", "due_date": "2025-05-20" },
  "edges": [{ "type": "part_of", "to": "thing:list_shopping" },
             { "type": "assigned_to", "to": "thing:user_me" }] }

// Найти по смыслу
{ "tool": "search",
  "query": "задачи на сегодня",
  "limit": 10 }

// Обновить узел
{ "tool": "update",
  "id": "thing:task_milk",
  "fields": { "status": "выполнена" } }

// Создать ребро
{ "tool": "relate",
  "from": "thing:task_abc",
  "edge": "assigned_to",
  "to": "thing:user_wife" }

// Выполнить сохранённый умный список
{ "tool": "run_list",
  "id": "thing:list_today" }
```

Агент никогда не видит сырую схему БД — только предоставленные инструменты. Все операции проходят через слой прав доступа.

### Конфигурация агента-бота

```yaml
kind: агент-ai
name: "Домовой Ассистент"
model: "claude-haiku-4-5"      # быстрый и дешёвый для бытовых запросов
provider: thing:ds_anthropic
system_prompt: thing:prompt_домовой_bot
tools:
  - create
  - update
  - search
  - relate
  - run_list
max_tool_calls: 5              # защита от зацикливания
inputs:
  user_tasks:
    source: surreal
    query: >
      SELECT name, status, due_date FROM thing
      WHERE kind = 'задача' AND ->assigned_to->thing = $auth
        AND status != 'выполнена'
      ORDER BY due_date ASC LIMIT 10
    format: text
  shopping_list:
    source: surreal
    query: >
      SELECT name, quantity FROM thing
      WHERE kind = 'товар' AND status = 'нужен'
    format: text
  recent_context:
    source: surreal
    query: >
      SELECT name, kind, updated_at FROM thing
      WHERE updated_at > time::now() - 1h
      ORDER BY updated_at DESC LIMIT 5
    format: text
triggered_by: thing:gateway_telegram_bot
produces: thing:chat_bot_log    # лог разговора
```

### Голосовой помощник

Отличие от чат-бота — только входной и выходной канал. Мозг (`kind: агент-ai`) одинаков.

```
kind: шлюз  (subtype: voice-local)
  stt_provider: thing:ds_whisper      ← speech-to-text
  tts_provider: thing:ds_yandex_tts  ← text-to-speech
  wake_word: "Домовой"
  device: thing:device_kitchen_speaker
```

STT, TTS и Vision — `kind: источник-данных`:

| subtype | сервис |
|---------|--------|
| `whisper-local` | OpenAI Whisper локально (faster-whisper) |
| `whisper-api` | OpenAI Whisper API |
| `google-stt` | Google Speech-to-Text |
| `yandex-stt` | Яндекс SpeechKit STT |
| `yandex-tts` | Яндекс SpeechKit TTS |
| `edge-tts` | Microsoft Edge TTS (бесплатный) |
| `piper` | Piper TTS локально |
| `vision-local` | Ollama: llava, minicpm-v, qwen2-vl — локально на GPU |
| `vision-api` | GPT-4o, Claude 3.5 Sonnet, Gemini Flash — облако |

### Vision: распознавание изображений

Vision-модель — такой же `kind: источник-данных`, шаг плейбука отправляет ей изображение
и получает структурированный ответ.

```yaml
# Локальная vision-модель на RTX 3090
kind: источник-данных
name: "Qwen2-VL local"
subtype: vision-local
endpoint: "http://gpu-server.home:11434"
model: "qwen2-vl:7b"
role: vision

# Облачная — для сложных случаев
kind: источник-данных
name: "GPT-4o vision"
subtype: vision-api
endpoint: "https://api.openai.com/v1"
model: "gpt-4o"
role: vision
fallback_to: thing:ds_vision_local
```

### Сценарий: фото одометра → показание → триггер ТО

Пользователь отправляет фото в Telegram-бот или голосовой интерфейс.
Плейбук из четырёх шагов обрабатывает его полностью автономно:

```mermaid
graph TD
    Photo["Фото одометра\n(Telegram / камера)"]
    S1["Шаг 1: Vision\nизвлечь число"]
    S2["Шаг 2: Resolve\nопределить транспорт"]
    S3["Шаг 3: Update\nобновить показание"]
    S4["Шаг 4: Check\nпроверить счётчики"]
    Bot["Бот: «Записал: 53 420 км\nДо ТО осталось 580 км»"]
    TO["CREATE run\n«ТО — сезонное»"]

    Photo --> S1
    S1 --> S2
    S2 -->|один транспорт| S3
    S2 -->|несколько| Bot2["Бот уточняет:\n«Это BMW или Lada?»"]
    Bot2 --> S3
    S3 --> S4
    S4 -->|порог превышен| TO
    S4 --> Bot
```

**Шаг 1 — Vision:** извлечь показание из фото

```yaml
kind: шаг
name: "Распознать одометр"
order: 1
assigned_to: thing:ds_vision_local
prompt: |
  На фото — приборная панель автомобиля или мотоцикла.
  Найди показание одометра (пробег в км или милях).
  Верни JSON: {"value": <число>, "unit": "km"|"mi", "confidence": 0..1}
  Если не можешь определить однозначно — {"value": null, "error": "причина"}
input_image: $trigger.attachment     # фото из сообщения
output_field: odometer_reading       # результат для следующих шагов
on_error: ask_user                   # если null — попросить переснять
```

**Шаг 2 — Resolve:** определить транспортное средство

```yaml
kind: шаг
name: "Определить транспорт"
order: 2
depends_on: thing:step_vision
on_success: |
  -- Транспорт пользователя с одометром
  SELECT id, name, odometer_km, odometer_mi
  FROM thing
  WHERE kind IN ["транспорт", "мотоцикл"]
    AND ->can_access<-thing = $auth.user
```

Если найден один — автоматически выбирается. Если несколько — бот спрашивает:

```
«Для какого транспорта записать 53 420 км?
  1. BMW R1250GS (последнее: 43 200 км)
  2. Lada Vesta (последнее: 87 450 км)»
```

**Шаг 3 — Update:** записать показание

```surql
UPDATE $resolved_vehicle SET
  odometer_km    = $steps.odometer_reading.value,
  odometer_at    = time::now(),
  odometer_by    = $auth.user;

-- Сохранить историческую запись
CREATE thing SET
  kind           = "показание",
  value          = $steps.odometer_reading.value,
  unit           = $steps.odometer_reading.unit,
  recorded_at    = time::now(),
  source         = "фото",
  confidence     = $steps.odometer_reading.confidence,
  ->about->       $resolved_vehicle,
  ->represents->  $trigger.attachment;   -- фото как доказательство
```

**Шаг 4 — Check:** проверить counter-based шаблоны

```surql
-- Найти шаблоны задач привязанные к этому транспорту
SELECT id, name, trigger_threshold, last_trigger_value
FROM thing
WHERE template = true
  AND period   = "счётчик"
  AND trigger_source = $resolved_vehicle
  AND ($steps.odometer_reading.value - last_trigger_value) >= trigger_threshold;
```

Для каждого сработавшего шаблона — создаётся `run`, пользователь получает уведомление.

**Итог:** одно фото → распознавание → уточнение если нужно → запись показания с фото-доказательством → автоматическое создание задач ТО. Всё в графе, без внешних сервисов.

Голосовой запрос сохраняется в `kind: сообщение` как текст (транскрипт) с вложением аудио:

```yaml
kind: сообщение
role: "user"
content: "Добавь молоко в список покупок"    ← транскрипт от STT
model_transcript_confidence: 0.97
attachments:
  - type: audio
    vault_id: "file:voice_2025-05-19_kitchen"
    duration_sec: 3.2
part_of: thing:chat_bot_log
```

### Контекст: устройство → пользователь

Голосовой запрос приходит с устройства. Устройство привязано к пользователю — так определяется `$auth` без явной аутентификации:

```
kind: устройство
  name: "Колонка на кухне"
  owned_by → kind: пользователь  (Папа)

kind: устройство
  name: "Планшет в детской"
  owned_by → kind: пользователь  (Сын)
```

Если устройство шарится (семейный планшет) — бот уточняет: «Кто говорит?» или распознаёт по голосовому профилю.

### Потоки данных

```mermaid
graph TD
    Voice["Голос пользователя"]
    TG["Telegram сообщение"]
    GW_V["kind: шлюз\nsubtype: voice-local"]
    GW_T["kind: шлюз\nsubtype: telegram-bot"]
    STT["kind: источник-данных\nsubtype: whisper-local"]
    Agent["kind: агент-ai\nДомовой Ассистент"]
    Graph[("SurrealDB\nграф")]
    Chat["kind: чат\nЛог разговора"]
    TTS["kind: источник-данных\nsubtype: edge-tts"]
    Out_V["Голосовой ответ"]
    Out_T["Telegram ответ"]

    Voice --> GW_V
    GW_V -->|audio| STT
    STT -->|transcript| Agent
    TG --> GW_T
    GW_T -->|text| Agent
    Agent -->|tool use| Graph
    Graph -->|результат| Agent
    Agent -->|лог| Chat
    Agent -->|response text| GW_V
    Agent -->|response text| GW_T
    GW_V --> TTS
    TTS --> Out_V
    GW_T --> Out_T
```

### Промпт бота

```yaml
kind: промпт
name: "Домовой Ассистент — системный промпт"
text: |
  Ты голосовой ассистент для семейной системы Домовой.
  Отвечай кратко — ответ будет прочитан вслух.
  Используй инструменты для чтения и изменения данных.
  Перед изменением данных — уточни если не уверен.
  Обращайся к пользователю по имени из контекста.
  Текущий пользователь: {{user_name}}.
  Задачи на сегодня: {{user_tasks}}.
  Список покупок: {{shopping_list}}.
part_of: thing:collection_bot_prompts
```

### SurrealQL: типовые запросы

```surql
-- Последние разговоры с ботом
SELECT name, created_at,
       count(<-part_of<-thing[WHERE kind = "сообщение"]) AS реплик,
       ->about->thing.name AS контекст
FROM thing
WHERE kind = "чат"
  AND ->triggered_by->thing.kind = "шлюз"
ORDER BY created_at DESC LIMIT 20;

-- Что бот делал: все граф-операции за сегодня
SELECT content, role, created_at,
       ->part_of->thing.name AS чат
FROM thing
WHERE kind = "сообщение"
  AND role = "tool"
  AND created_at > time::now() - 1d
ORDER BY created_at DESC;

-- Самые частые запросы к боту (по intent из content)
SELECT content, count() AS раз
FROM thing
WHERE kind = "сообщение" AND role = "user"
  AND ->part_of->thing->triggered_by->thing.kind = "шлюз"
GROUP BY content
ORDER BY раз DESC LIMIT 20;

-- Устройства и их пользователи
SELECT name, ->owned_by->thing.name AS владелец,
       max(<-part_of<-thing[WHERE kind = "сообщение"].created_at) AS последний_запрос
FROM thing
WHERE kind = "устройство"
ORDER BY последний_запрос DESC;
```

---

## Плейбуки (workflows)

Плейбук — это граф шагов. Каждый шаг оборачивает любой существующий модуль: воркер, агент-ai, шлюз, источник-данных. Шаги связаны явными путями `on_success` / `on_failure`. Runtime-состояние одного запуска живёт в `kind: запуск-плейбука`. Новых рёбер не нужно.

### Новые виды узлов

| kind | что это |
|------|---------|
| `плейбук` | определение workflow — DAG шагов |
| `шаг` | один шаг: обёртка над модулем + маршрутизация |
| `запуск-плейбука` | runtime-состояние одного исполнения |

### Сравнение с n8n

| n8n | Домовой |
|-----|---------|
| Workflow | `kind: плейбук` |
| Node | `kind: шаг` |
| Connection | `on_success` / `on_failure` (поля шага) |
| Trigger | `triggered_by` (уже есть) |
| Execution | `kind: запуск-плейбука` |
| Credentials | `kind: источник-данных` (уже есть) |
| HTTP Request | `kind: воркер` subtype: http |
| Code | `kind: воркер` subtype: python \| js |
| AI Agent | `kind: агент-ai` (уже есть) |
| Send Email | `kind: шлюз` subtype: smtp |
| Telegram | `kind: шлюз` subtype: telegram |
| Database | `kind: источник-данных` |
| Wait | `kind: шаг` с condition на внешнее событие |
| Manual trigger | `kind: запуск-плейбука` создаётся вручную |

### kind: плейбук

```yaml
kind: плейбук
name: "Обработка нового заказа"
description: "Валидация → склад → письмо → уведомление менеджера"
first_step: thing:step_check_payment    # точка входа
triggered_by: thing:event_new_order     # или расписание, или шлюз
about: thing:shop_main                  # к какому контексту привязан
max_concurrent_runs: 10                 # защита от перегрузки
timeout_sec: 300                        # дедлайн на весь запуск
```

### kind: шаг

```yaml
kind: шаг
name: "Проверить оплату"
part_of: thing:playbook_new_order       # принадлежит плейбуку
order: 1                                # порядок (для UI)
module: thing:worker_check_payment      # воркер | агент-ai | шлюз | источник-данных

# маршрутизация
on_success: thing:step_update_stock     # следующий шаг при успехе
on_failure: thing:step_notify_support   # шаг при ошибке
condition: "$.output.status == 'paid'"  # guard-выражение (JSONPath)
retry_count: 3                          # количество повторов при ошибке
retry_delay_sec: 10

# данные из триггера и предыдущих шагов
inputs:
  order_id:  "$trigger.id"
  amount:    "$steps.step_validate.output.total"
  user_name: "$trigger.user.name"
```

Модуль в поле `module` — любой существующий kind: `воркер`, `агент-ai`, `шлюз`, `источник-данных`. Шаг — только обёртка с маршрутизацией и маппингом данных.

### kind: запуск-плейбука

Живёт только во время исполнения и сохраняется как история после завершения.

```yaml
kind: запуск-плейбука
status: "ожидание" | "запущен" | "завершён" | "ошибка" | "отменён"
started_at: datetime
finished_at: datetime
part_of: thing:playbook_new_order
triggered_by: thing:event_order_12345

# runtime-состояние (обновляется воркером по мере выполнения)
context:
  trigger:
    id: "thing:order_12345"
    user: { name: "Иван", email: "ivan@example.com" }
  steps:
    step_check_payment:
      status: completed
      started_at: "2025-05-19T10:00:01Z"
      finished_at: "2025-05-19T10:00:03Z"
      output: { status: "paid", amount: 2500 }
    step_update_stock:
      status: running
      started_at: "2025-05-19T10:00:03Z"
    step_notify_support:
      status: skipped
```

### Пример: заказ в интернет-магазине

```mermaid
graph TD
    T["triggered_by\nНовый заказ"]
    S1["kind: шаг\nПроверить оплату\nmodule: HTTP воркер"]
    S2["kind: шаг\nОбновить остатки\nmodule: SurrealQL воркер"]
    S3["kind: шаг\nОтправить письмо\nmodule: шлюз smtp"]
    S4["kind: шаг\nУведомить менеджера\nmodule: шлюз telegram"]
    S5["kind: шаг\nСоздать задачу для поддержки\nmodule: SurrealQL воркер"]
    END["завершён"]
    ERR["ошибка"]

    T --> S1
    S1 -->|on_success| S2
    S1 -->|on_failure| S5
    S2 -->|on_success| S3
    S2 -->|on_failure| S5
    S3 -->|on_success| S4
    S4 -->|on_success| END
    S5 --> ERR
```

```surql
-- Создать плейбук
CREATE thing:playbook_new_order SET
  kind = "плейбук",
  name = "Обработка нового заказа",
  first_step = thing:step_check_payment,
  max_concurrent_runs = 10,
  timeout_sec = 300;

-- Создать шаги
CREATE thing:step_check_payment SET
  kind = "шаг",
  name = "Проверить оплату",
  part_of = thing:playbook_new_order,
  order = 1,
  module = thing:worker_http_payment,
  on_success = thing:step_update_stock,
  on_failure = thing:step_notify_support,
  retry_count = 3,
  inputs = {
    order_id: "$trigger.id",
    amount:   "$trigger.amount"
  };

-- Запустить плейбук вручную
CREATE thing SET
  kind = "запуск-плейбука",
  status = "ожидание",
  part_of = thing:playbook_new_order,
  context = { trigger: { id: "thing:order_999", amount: 1500 } };
```

### Ветвление и условия

`condition` — JSONPath-выражение над `$.output` текущего шага. Если выражение ложно — идём по `on_failure`. Если нужно несколько путей — шаг-роутер:

```yaml
kind: шаг
name: "Роутер по сумме заказа"
module: thing:worker_router        # встроенный роутер-воркер
condition_routes:
  - condition: "$.output.amount > 10000"
    next: thing:step_vip_flow
  - condition: "$.output.amount > 1000"
    next: thing:step_standard_flow
  - default: thing:step_small_order_flow
```

### Цикл (loop)

Шаг ссылается на себя через `on_success` с guard-условием выхода:

```yaml
kind: шаг
name: "Опросить API пока не готово"
module: thing:worker_poll_status
on_success: thing:step_self          # сам на себя
on_failure: thing:step_continue      # выход из цикла когда ready
condition: "$.output.status != 'ready'"  # продолжать если не готово
retry_count: 20
retry_delay_sec: 15
```

### Параллельные шаги

Шаг-разветвитель запускает несколько шагов одновременно, шаг-слияние ждёт всех:

```yaml
kind: шаг
name: "Запустить параллельно"
module: thing:worker_fan_out
parallel_steps:
  - thing:step_send_email
  - thing:step_update_crm
  - thing:step_notify_telegram
merge_step: thing:step_after_all    # продолжить когда все завершились
```

### Связь с оркестратором и очередями

Плейбуки работают поверх уже спроектированных очередей и воркеров:

```
kind: запуск-плейбука (status: ожидание)
  → помещается в kind: очередь
    → kind: воркер (оркестратор плейбуков)
      → читает шаги, запускает модули, обновляет context
      → при ошибке: retry или on_failure-путь
      → при таймауте: status = "ошибка", lock сбрасывается
```

Оркестратор — отдельный `kind: воркер` с `kind: очередь` для запусков. Масштабирование через `max_concurrent` очереди.

### SurrealQL: типовые запросы

```surql
-- Все плейбуки с количеством шагов и последним запуском
SELECT name,
       count(<-part_of<-thing[WHERE kind = "шаг"]) AS шагов,
       max(<-part_of<-thing[WHERE kind = "запуск-плейбука"].started_at) AS последний_запуск,
       count(<-part_of<-thing[WHERE kind = "запуск-плейбука" AND status = "ошибка"]) AS ошибок
FROM thing
WHERE kind = "плейбук";

-- Активные запуски прямо сейчас
SELECT ->part_of->thing.name AS плейбук,
       started_at, status,
       context.steps AS шаги
FROM thing
WHERE kind = "запуск-плейбука" AND status = "запущен"
ORDER BY started_at ASC;

-- История запусков с длительностью
SELECT ->part_of->thing.name AS плейбук,
       started_at, finished_at, status,
       time::duration(finished_at - started_at) AS длительность
FROM thing
WHERE kind = "запуск-плейбука"
ORDER BY started_at DESC LIMIT 50;

-- Шаги с наибольшим числом ошибок
SELECT name, ->part_of->thing.name AS плейбук,
       count() AS запусков,
       count(context.steps[$parent.name].status = "failed") AS ошибок
FROM thing
WHERE kind = "шаг"
ORDER BY ошибок DESC LIMIT 10;

-- Граф плейбука: все шаги и переходы
SELECT name, order, module.name AS модуль,
       on_success.name AS при_успехе,
       on_failure.name AS при_ошибке,
       condition
FROM thing
WHERE kind = "шаг" AND ->part_of->thing = thing:playbook_new_order
ORDER BY order ASC;
```

---

## Масштабируемость: внешние воркеры и app-серверы

Схема изначально рассчитана на горизонтальное масштабирование. Всё состояние — в SurrealDB. Воркеры и app-серверы stateless: читают job, исполняют, пишут результат. Число подов меняется без изменений схемы.

### Архитектура

```
SurrealDB  (единый source of truth, stateful)
    ↑↓ LIVE SELECT / HTTP API / WebSocket
┌──────────────────────────────────────────────┐
│  Stateless слой (горизонтально масштабируем) │
│                                              │
│  Next.js API      ×N   UI + REST API         │
│  Оркестратор      ×M   запуски плейбуков     │
│  Worker-HTTP      ×K   HTTP-модули           │
│  Worker-AI        ×L   AI-шаги              │
│  Worker-Python    ×P   код-модули            │
│  Worker-Шлюз      ×Q   gateway-интеграции   │
└──────────────────────────────────────────────┘
   Kubernetes / bare-metal / serverless functions
```

Каждый тип воркера — отдельный Deployment в Kubernetes. Масштабируется независимо по нагрузке.

### Конкурентный захват задачи

Несколько подов конкурируют за jobs через атомарный UPDATE. Классический competing consumers — без внешней очереди (Redis, RabbitMQ): SurrealDB сам является очередью.

```surql
-- Атомарный захват задачи (optimistic locking)
-- 0 затронутых строк = другой под успел первым, берём следующую
UPDATE thing SET
  status         = "запущен",
  locked_by      = $worker_instance_id,
  locked_at      = time::now(),
  lock_expires_at = time::now() + 5m
WHERE id = $job_id
  AND status   = "ожидание"
  AND locked_by = NONE;
```

### LIVE SELECT вместо поллинга

SurrealDB поддерживает push-уведомления нативно. Воркер подписывается один раз — и получает события при появлении новых задач без поллинга.

```surql
-- Воркер подписывается на свои очереди
LIVE SELECT id, kind, context FROM thing
WHERE kind = "запуск-плейбука"
  AND status = "ожидание"
  AND ->part_of->thing->triggered_by->thing IN $my_queues;
```

Новый `kind: запуск-плейбука` создан → все подписанные воркеры получают событие → первый атомарно захватывает через UPDATE выше → остальные получают 0 строк и ждут следующего.

### kind: воркер-инстанс

Регистрация живых подов в графе — для observability, мониторинга и управления мёртвыми локами.

```yaml
kind: воркер-инстанс
pod_name:       "domovoy-worker-ai-7f8d9c-xkp2q"
node:           "k8s-node-3"
namespace:      "domovoy-prod"
capabilities:   ["ai", "surreal"]          # типы задач, которые умеет
started_at:     datetime
last_heartbeat: datetime                   # обновляется каждые 10 сек
status:         "активен" | "завершает" | "мёртв"
current_job:    record<thing>              # текущий запуск-плейбука или NONE
jobs_completed: int
jobs_failed:    int
part_of: thing:worker_ai_def              # ← определение воркера
```

```surql
DEFINE TABLE воркер-инстанс SCHEMALESS;
DEFINE INDEX idx_heartbeat ON thing FIELDS kind, status, last_heartbeat;
```

**Heartbeat от пода** (каждые 10 секунд):
```surql
UPDATE thing:worker_inst_xyz SET last_heartbeat = time::now()
WHERE kind = "воркер-инстанс";
```

**Оркестратор находит мёртвые поды и снимает их локи:**
```surql
-- Поды без heartbeat > 30 сек считаются мёртвыми
LET $dead = SELECT id FROM thing
  WHERE kind = "воркер-инстанс"
    AND last_heartbeat < time::now() - 30s
    AND status = "активен";

UPDATE $dead SET status = "мёртв";

-- Освободить задачи, захваченные мёртвыми подами
UPDATE thing SET
  status    = "ожидание",
  locked_by = NONE,
  lock_expires_at = NONE
WHERE kind IN ["запуск-плейбука", "запуск-воркера"]
  AND status = "запущен"
  AND locked_by IN $dead.id;
```

### Приоритеты и шардирование очередей

Разные типы воркеров подписываются на разные очереди. Воркер объявляет `capabilities` при старте — оркестратор направляет задачу в подходящую очередь.

```
kind: очередь  (name: "ai-tasks",    max_concurrent: 5)  ← только Worker-AI
kind: очередь  (name: "http-tasks",  max_concurrent: 20) ← Worker-HTTP
kind: очередь  (name: "python-tasks",max_concurrent: 10) ← Worker-Python
kind: очередь  (name: "priority",    max_concurrent: 3)  ← быстрая очередь
```

```surql
-- Взять следующую задачу с учётом приоритета
SELECT id FROM thing
WHERE kind = "запуск-плейбука"
  AND status = "ожидание"
  AND ->part_of->thing->triggered_by->thing IN $my_queues
ORDER BY priority DESC, created_at ASC
LIMIT 1;
```

### Деплой в Kubernetes

```yaml
# Пример: Deployment для AI-воркеров
apiVersion: apps/v1
kind: Deployment
metadata:
  name: domovoy-worker-ai
spec:
  replicas: 3                    # начальное число подов
  selector:
    matchLabels:
      app: domovoy-worker-ai
  template:
    spec:
      containers:
        - name: worker
          image: domovoy/worker-ai:latest
          env:
            - name: SURREALDB_URL
              value: "ws://surrealdb:8000/rpc"
            - name: WORKER_CAPABILITIES
              value: "ai,surreal"
            - name: WORKER_QUEUES
              value: "ai-tasks,priority"
---
# HorizontalPodAutoscaler по глубине очереди
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
spec:
  scaleTargetRef:
    name: domovoy-worker-ai
  minReplicas: 1
  maxReplicas: 20
  metrics:
    - type: External
      external:
        metric:
          name: domovoy_queue_depth   # метрика из Prometheus
        target:
          averageValue: "5"           # 5 задач на под
```

### Мультирегиональность

Наша федерация + HLC уже описаны. Воркеры в разных регионах подключаются к ближайшему инстансу SurrealDB. Jobs реплицируются через change_log при необходимости.

```
Регион EU: SurrealDB-EU ←→ SurrealDB-RU :Регион RU
              ↑                    ↑
         Workers-EU           Workers-RU
```

### SurrealQL: observability

```surql
-- Живые воркер-инстансы прямо сейчас
SELECT pod_name, node, capabilities, last_heartbeat,
       current_job.name AS выполняет,
       jobs_completed, jobs_failed,
       time::duration(time::now() - started_at) AS uptime
FROM thing
WHERE kind = "воркер-инстанс" AND status = "активен"
ORDER BY last_heartbeat DESC;

-- Глубина очередей
SELECT ->triggered_by->thing.name AS очередь,
       count() AS ожидает
FROM thing
WHERE kind = "запуск-плейбука" AND status = "ожидание"
GROUP BY очередь
ORDER BY ожидает DESC;

-- Throughput воркеров за последний час
SELECT ->part_of->thing.name AS воркер,
       count() AS завершено,
       math::mean(
         time::duration(finished_at - started_at)
       ) AS среднее_время
FROM thing
WHERE kind = "запуск-плейбука"
  AND status = "завершён"
  AND finished_at > time::now() - 1h
GROUP BY воркер;

-- Мёртвые поды и их незавершённые задачи
SELECT pod_name, last_heartbeat,
       count(<-locked_by<-thing[WHERE status = "запущен"]) AS брошенных_задач
FROM thing
WHERE kind = "воркер-инстанс"
  AND last_heartbeat < time::now() - 30s
  AND status != "мёртв";
```

---

## История: перемещения, изменения, корзина

### История перемещений

Рёбра `contains` и `located_at` получают временны́е метки. Активная позиция — `ended_at = NONE`. История — все записи с заполненным `ended_at`. Полная цепочка хранится в одной таблице без дополнительных структур.

```surql
DEFINE FIELD started_at ON contains TYPE datetime DEFAULT time::now();
DEFINE FIELD ended_at   ON contains TYPE option<datetime>;
DEFINE FIELD moved_by   ON contains TYPE option<record<thing>>;

DEFINE FIELD started_at ON located_at TYPE datetime DEFAULT time::now();
DEFINE FIELD ended_at   ON located_at TYPE option<datetime>;
DEFINE FIELD moved_by   ON located_at TYPE option<record<thing>>;
```

**Переместить вещь:**
```surql
-- Закрыть текущую позицию
UPDATE (
  SELECT id FROM contains WHERE out = $thing AND ended_at = NONE
) SET ended_at = time::now(), moved_by = $auth;

-- Открыть новую
RELATE $new_location->contains->$thing SET
  started_at = time::now(),
  moved_by   = $auth;
```

**Текущее местонахождение:**
```surql
SELECT <-contains<-thing[WHERE ended_at = NONE] AS где
FROM thing WHERE id = $thing;
```

**Вся история перемещений вещи:**
```surql
SELECT in.name AS откуда, out.name AS что,
       started_at, ended_at,
       moved_by.name AS кто
FROM contains
WHERE out = $thing
ORDER BY started_at ASC;
```

**Что сейчас находится в этом месте (рекурсивно):**
```surql
SELECT name, kind,
       <-contains[WHERE ended_at = NONE].started_at AS здесь_с
FROM thing
WHERE <-contains<-thing[WHERE ended_at = NONE] = $location;
```

### История изменений

`DEFINE EVENT` фиксирует каждое изменение поля. Хранится только diff — не полный снимок — чтобы не раздувать базу. `kind: снимок` создаётся вручную или по расписанию для важных точек (публикация, архивация, до удаления).

```surql
-- Новый kind для записи изменения
-- (schemaless, живёт в той же таблице thing)

DEFINE EVENT audit ON TABLE thing
  WHEN $event = "UPDATE"
THEN {
  -- считаем изменённые поля
  LET $diff = object::keys($after).filter(|$k| $before[$k] != $after[$k])
    .reduce(|$acc, $k| object::add($acc, $k, {
        before: $before[$k],
        after:  $after[$k]
      }), {});

  -- не пишем если изменилось только служебное
  LET $skip = ["updated_at", "last_heartbeat", "lock_expires_at"];
  LET $real = object::keys($diff).filter(|$k| !$skip.contains($k));

  IF array::len($real) > 0 THEN {
    CREATE thing SET
      kind       = "изменение",
      about      = $after.id,
      changed_by = $auth,
      changed_at = time::now(),
      event      = $event,
      diff       = $diff;
  };
};
```

**`kind: снимок`** — полное состояние в момент времени:
```surql
-- Создать снимок вручную (перед удалением, публикацией, архивацией)
CREATE thing SET
  kind     = "снимок",
  about    = $target_id,
  state    = (SELECT * FROM thing WHERE id = $target_id),
  taken_at = time::now(),
  taken_by = $auth,
  reason   = "перед удалением";   -- или "публикация v2", "архив"
```

**История изменений узла:**
```surql
SELECT changed_at, changed_by.name AS кто, diff
FROM thing
WHERE kind = "изменение" AND about = $target_id
ORDER BY changed_at DESC;
```

**Кто и когда менял статус задачи:**
```surql
SELECT changed_at, changed_by.name AS кто,
       diff.status.before AS было,
       diff.status.after  AS стало
FROM thing
WHERE kind = "изменение"
  AND about = $task_id
  AND diff.status != NONE
ORDER BY changed_at ASC;
```

**Все изменения пользователя за день:**
```surql
SELECT about.name AS объект, about.kind AS тип,
       changed_at, diff
FROM thing
WHERE kind = "изменение"
  AND changed_by = $auth
  AND changed_at > time::now() - 1d
ORDER BY changed_at DESC;
```

### Корзина (soft delete)

Удаление не стирает запись — переводит в статус `"удалён"`. Все обычные запросы фильтруют этот статус. Через 30 дней — авто-очистка через DEFINE EVENT.

**Поля на `thing` (schemaless, не требуют миграции):**
```
deleted_at:         datetime
deleted_by:         record<thing>
previous_status:    string          ← для восстановления
delete_reason:      string
scheduled_purge_at: datetime        ← когда удалить физически
```

**Удалить в корзину:**
```surql
UPDATE thing SET
  previous_status    = status,
  status             = "удалён",
  deleted_at         = time::now(),
  deleted_by         = $auth,
  delete_reason      = $reason,
  scheduled_purge_at = time::now() + 30d
WHERE id = $id;
```

**Восстановить из корзины:**
```surql
UPDATE thing SET
  status             = previous_status,
  deleted_at         = NONE,
  deleted_by         = NONE,
  delete_reason      = NONE,
  previous_status    = NONE,
  scheduled_purge_at = NONE
WHERE id = $id AND status = "удалён";
```

**Содержимое корзины:**
```surql
SELECT name, kind, deleted_at, deleted_by.name AS кто,
       delete_reason, scheduled_purge_at
FROM thing
WHERE status = "удалён"
  AND (<-can_access<-thing = $auth OR deleted_by = $auth)
ORDER BY deleted_at DESC;
```

**Авто-очистка по расписанию (DEFINE EVENT):**
```surql
DEFINE EVENT purge_deleted ON TABLE thing
  WHEN $after.scheduled_purge_at != NONE
    AND $after.scheduled_purge_at < time::now()
    AND $after.status = "удалён"
THEN {
  -- снимок перед удалением (опционально, для архива)
  CREATE thing SET
    kind     = "снимок",
    about    = $after.id,
    state    = $after,
    taken_at = time::now(),
    reason   = "авто-архив перед удалением";

  -- физическое удаление
  DELETE $after.id;
};
```

**Стандартный фильтр во всех запросах:**
```surql
-- Везде добавляем: AND (status = NONE OR status != "удалён")
-- Или через вспомогательный параметр сессии:
DEFINE PARAM $show_deleted VALUE false;

SELECT * FROM thing
WHERE kind = "задача"
  AND ($show_deleted OR status != "удалён");
```

### Связь между тремя механизмами

При удалении создаётся снимок + запись в истории изменений:
```
Пользователь удаляет thing:item_vase
  → UPDATE status = "удалён"
  → DEFINE EVENT audit     → kind: изменение  (status: активен → удалён)
  → CREATE kind: снимок    (полное состояние до удаления)
  → через 30 дней: DEFINE EVENT purge → DELETE
```

При перемещении фиксируется в истории рёбер:
```
contains (in: шкаф, out: ваза) ended_at = now()
contains (in: кладовка, out: ваза) started_at = now()
  → DEFINE EVENT audit → kind: изменение (перемещение)
```

---

## Версии и совместимость

Версионирование в модели — не одна сущность, а несколько ортогональных осей. История полей (`kind: изменение`), снимки (`kind: снимок`), корзина и история перемещений описаны выше. Этот раздел — про **версии-вехи как самостоятельные узлы** и **совместимость потребителей с версиями**: когда одни модули/плейбуки работают только со старой версией артефакта, а другие — уже с новой.

### Семь осей версионирования

| Ось | Вопрос | Примитив |
|-----|--------|----------|
| История полей узла | кто и когда менял поля | `kind: изменение` (diff) через `DEFINE EVENT audit` |
| Снимок состояния | как узел выглядел в момент X | `kind: снимок` (полное состояние) |
| Версии-вехи артефакта | v1 → v2 → v3 как отдельные объекты | узлы-версии + ребро `supersedes` |
| История связей | где вещь лежала раньше | темпоральные рёбра (`started_at`/`ended_at`) |
| Заморозка ссылки | что было в цитате на дату | `references {mode: snapshot}` |
| Жизненный цикл / корзина | удалено, но восстановимо | soft-delete поля |
| Версии между инстансами | чьё изменение новее | HLC + `change_log` (LWW/CRDT) |

Этот раздел детализирует третью ось (версии-вехи) и совместимость потребителей.

### Версия — это узел

Чтобы потребитель мог привязаться к конкретной версии, версия должна быть адресуемым `thing` — рёбра не входят внутрь embedded-поля (поэтому `_i18n`-стиль здесь не годится). Версии группируются под стабильным узлом-семейством через `part_of`:

```surql
CREATE thing:`model_x`   SET kind = 'модель-семейство', name = 'Detector X', version_policy = 'coexist';
CREATE thing:`model_x@1` SET kind = 'модель', version = '1.4.0', status = 'active';
CREATE thing:`model_x@2` SET kind = 'модель', version = '2.1.0', status = 'active';
RELATE thing:`model_x@1`->part_of->thing:`model_x`;
RELATE thing:`model_x@2`->part_of->thing:`model_x`;
```

Семейство — стабильная идентичность: живые связи («дашборд показывает текущую модель») указывают на него; провенанс и пины — на конкретную версию-узел.

### Два факта — два носителя

Ключевой инвариант: **«заменена» (superseded) ≠ «снята» (retired)**. Версию можно обогнать новой, но оставить живой для старых потребителей. Поэтому порядок версий и их живость разнесены на разные носители:

| Факт | Носитель | Значения |
|------|----------|----------|
| рекомендуемый порядок | ребро `supersedes` | `v_new → v_old` |
| живость | поле `status` | `active` / `deprecated` / `retired` |

`supersedes` — новое ребро (26-е в модели), вводится здесь так же, как `linked_to` в IT-разделе:

```surql
DEFINE TABLE supersedes TYPE RELATION FROM thing TO thing SCHEMALESS;
-- свободные поля: reason, at, и опционально diff между версиями
```

«Текущая/рекомендуемая» = голова цепочки, та версия, которую никто не заменяет. `status` отвечает отдельно — резолвится ли версия ещё. `supersedes` несёт порядок и опционально diff между версиями (в том же формате `{поле: {before, after}}`, что и `kind: изменение`):

```surql
RELATE thing:`model_x@2`->supersedes->thing:`model_x@1`
  SET reason = '+recall', at = time::now(),
      diff = { val_acc: { before: 0.89, after: 0.93 } };
UPDATE thing:`model_x@1` SET status = 'deprecated';   -- обогнана, но ещё жива
```

`supersedes` **не ставит** старой версии `archived`/`retired` — иначе сломается сосуществование. Снятие версии — отдельное решение (см. ниже).

### Привязка потребителей: requires (план) + used (факт)

Совместимость ложится на уже существующую дуальность «план vs факт» (рецепт `requires` ингредиент / запуск `used` фактически):

- `requires {constraint}` → **семейство** = декларация совместимости («умею с 1.x»). Аналог `package.json`.
- `used` → **конкретная версия** = разрешённая привязка / лок. Аналог `package-lock`.

```surql
DEFINE FIELD constraint ON requires TYPE option<string>;   -- semver-диапазон

RELATE thing:`playbook_old`->requires->thing:`model_x` SET constraint = '>=1,<2';
RELATE thing:`playbook_new`->requires->thing:`model_x` SET constraint = '>=2,<3';
-- разрешили диапазон в точную версию (факт):
RELATE thing:`run_77`->used->thing:`model_x@2` SET resolved_at = time::now();
```

Старый плейбук и новый указывают на разные версии одновременно — обе живые, обе валидные. Выбор версии закодирован в рёбрах потребителя, а не в глобальном предикате.

### Два режима — одна модель, кнопка version_policy

«Замещение» (одна текущая, остальные быстро снимаются) и «сосуществование» (много живых версий) — не разные структуры, а разная **каденция снятия**. Семейство объявляет политику; на схему она не влияет:

```surql
UPDATE thing:`model_x` SET version_policy = 'coexist';   -- или 'replace'
```

| | `replace` | `coexist` |
|---|-----------|-----------|
| живых версий | одна текущая | много сразу |
| обогнанная версия | быстро `retired` | держим `deprecated`, пока кто-то завязан |
| «какая версия» решает | голова `supersedes` | ребро потребителя (`used` / `requires`) |
| аналог | git HEAD, архив документа | npm / cargo, мультиверсионный API |

Режимы можно мешать на одном графе: prod-модель в `replace`, рантаймы и датасеты в `coexist`.

### Видимость и проход по графу

Версионирование **не добавляет универсального условия в обход** — при одном инварианте: дефолтный фильтр видимости несёт только `retired` / `удалён` / `архив`, но **не** `superseded`. Тогда обогнанные-но-живые версии остаются видимыми, а «текущая» вычисляется opt-in (голова цепочки), не на каждом хопе.

```surql
-- дефолтный рабочий набор (тот же фильтр, что у корзины; superseded сюда НЕ входит)
SELECT * FROM thing WHERE kind = 'модель' AND status NOT IN ['retired', 'удалён', 'архив'];
```

### Канонические запросы

```surql
-- текущая / рекомендуемая (голова цепочки supersedes)
SELECT * FROM thing WHERE ->part_of->thing = thing:`model_x`
  AND count(<-supersedes<-thing) = 0;

-- живые версии (для старых потребителей)
SELECT version, status FROM thing WHERE ->part_of->thing = thing:`model_x`
  AND status != 'retired';

-- версия конкретного потребителя (просто ребро, статус неважен)
SELECT ->used->thing.version FROM thing:`playbook_old`;

-- история версий одной цепочкой
SELECT ->supersedes->thing.* FROM thing:`model_x@2` DEPTH 20;

-- range-резолв: лучшая совместимая не-снятая версия (разовый, кэшируется в used)
LET $c = (SELECT VALUE constraint FROM requires
          WHERE in = thing:`playbook_old` AND out = thing:`model_x`)[0];
SELECT * FROM thing WHERE ->part_of->thing = thing:`model_x`
  AND status != 'retired'
  AND fn::semver_match(version, $c)
ORDER BY version DESC LIMIT 1;

-- версии-сироты (кандидаты на снятие / GC)
SELECT version FROM thing WHERE ->part_of->thing = thing:`model_x`
  AND count(<-used<-thing[WHERE status = 'active']) = 0
  AND count(<-requires<-thing) = 0;
```

### Диаграмма

```mermaid
graph TD
    Fam["model_x\nkind: модель-семейство\nversion_policy: coexist"]
    V1["model_x@1\nversion: 1.4.0\nstatus: deprecated"]
    V2["model_x@2\nversion: 2.1.0\nstatus: active ← текущая"]
    POld["playbook_old"]
    PNew["playbook_new"]

    V1 -->|part_of| Fam
    V2 -->|part_of| Fam
    V2 -->|supersedes| V1
    POld -->|"requires {>=1,<2}"| Fam
    POld -->|used| V1
    PNew -->|"requires {>=2,<3}"| Fam
    PNew -->|used| V2
```

### Связь с историей изменений (diff)

Версии-вехи (copy-on-write) и diff-лог (mutable-in-place) не конфликтуют — это разные режимы изменчивости одного узла, граница задаётся полем `stage` / `status`:

- **mutable** (черновик, конфиг-в-работе) → правки на месте, история = `kind: изменение`.
- **immutable** (релизнутая версия) → новые версии через `supersedes`, на месте не правится.

На иммутабельной версии audit-diff превращается из истории в **сигнализацию подмены** — правка `released` / `deprecated` версии помечается как подозрительная. Межверсионный diff живёт на ребре `supersedes` в том же формате, что и `kind: изменение`, — два механизма делят представление, а не спорят.

### Инварианты

- `superseded ≠ retired` — обгон версии не снимает её с обслуживания.
- `supersedes` не ставит `archived` / `retired` — максимум (опционально) `deprecated`.
- фильтр видимости несёт `retired` / `удалён` / `архив`, **не** `superseded`.
- «текущая» — opt-in (голова цепочки), не дефолтный предикат обхода.
- живые связи указывают на семейство-узел; провенанс и пины — на версию-узел.
- снятие (`retired`) — только когда версия осиротела (никто не `used` / `requires`).

---

## Происхождение артефактов (lineage)

Ребро `derived_from` фиксирует **генеалогию артефактов**: `B → derived_from → A` читается «**B получено из A**». Стрелка идёт от производного к источнику; голова цепочки (`derived_from = NONE`) — первоисточник. Это прямая калька W3C PROV `wasDerivedFrom` — связь **узел→узел между сущностями**, без обязательного посредника-процесса.

Отвечает на два вопроса: «откуда это взялось» (вперёд по ребру) и «что из этого наделали» (назад) — обходом графа, а не реконструкцией.

### Граница с соседними рёбрами

| Ребро | Отношение | Чем отличается от `derived_from` |
|---|---|---|
| `part_of` | B — *часть* A | thumbnail не часть оригинала, он *из* него получен; производное — самостоятельный узел, а не компонент целого. |
| `represents` | B — *копия* A | скан = та же сущность в цифре; саммари — **не копия** документа, а новый объект, выведенный из него. |
| `produces` | *активность* → результат | слева запуск/процесс (PROV Activity), а не артефакт. |
| `used` | активность ← вход | требует узла-процесса; `derived_from` соединяет вход и выход напрямую. |
| `references` | B *ссылается* на A | ссылка — указатель (убери — B не изменится); производность генетическая (без A узла B бы не было). |

### Поля

```surql
DEFINE TABLE derived_from TYPE RELATION FROM thing TO thing SCHEMALESS;
DEFINE FIELD method ON derived_from TYPE option<string>;        -- chunk|embed|thumbnail|translate|summarize|train|extract
DEFINE FIELD run    ON derived_from TYPE option<record<thing>>; -- узел kind:запуск, если был оркестрован
DEFINE FIELD at     ON derived_from TYPE option<datetime>;
```

`run` — мост к тяжёлому провенансу: если за производной стоял настоящий прогон пайплайна, ребро ссылается на узел `kind:запуск`; для дешёвых массовых производных (thumbnail, чанк) `run = NONE`, и хватает лёгкого ярлыка.

### Примеры по доменам

```
thumbnail   → derived_from → original_image      (method: thumbnail)
chunk_007   → derived_from → contract.pdf        (method: chunk)
embedding   → derived_from → chunk_007           (method: embed)
перевод_RU  → derived_from → субтитры_EN         (method: translate)
саммари     → derived_from → инцидент_отчёт      (method: summarize)
модель_v3   → derived_from → датасет_2026        (method: train, run: thing:run_...)
ответ_бота  → derived_from → chunk_007, chunk_012 (grounding: чем обоснован ответ)
```

Последняя строка — почему это попадает в ML-сценарий: «какие именно чанки обосновали ответ» становится **рёбрами графа**, а не теряется внутри `inputs`-запроса. Воспроизводимость и аудит цитат — обходом по рёбрам.

### Обход

```surql
-- происхождение: из чего в конечном счёте сделан артефакт
SELECT ->derived_from->thing.* FROM thing:модель_v3;          -- на один шаг
SELECT * FROM thing:модель_v3 DEPTH 5 FETCH ->derived_from;   -- вся родословная

-- влияние: что унаследует пересборку, если переразметить датасет (impact analysis)
SELECT <-derived_from<-thing.* FROM thing:датасет_2026;
```

### `derived_from` vs run-as-hub

Полное происхождение собирается и через узел `kind:запуск` ←`used`/`produces`→. Но это требует узла-процесса на *каждую* трансформацию — оправдано для оркестрованных прогонов (аудируемая активность), абсурдно для массовых дешёвых производных. `derived_from` — статический генетический ярлык «откуда», `produces`/`used` — динамический протокол «что прогон сделал». Поле `run` сшивает их, когда уместны оба. Они дополняют друг друга, а не конкурируют.

> `invalidates` (см. раздел «Публикации») — соседнее, но иное: оно про **распространение пересборки** вперёд («изменение A инвалидирует кэш B»), тогда как `derived_from` про **происхождение** назад («B сделано из A»). Часто это одни и те же пары узлов, прочитанные в разные стороны и с разной целью.

---

## Файлы, медиа и бинарные данные

Бинарные данные никогда не хранятся в SurrealDB — только метаданные. Файлы живут в отдельном хранилище; граф содержит указатели, производные варианты и извлечённый контент.

### Новые виды узлов

| kind | что это |
|------|---------|
| `файл` | метаданные файла: тип, размер, checksum, где лежит, варианты |
| `чанк` | фрагмент текста из файла с embedding для RAG |
| `хранилище-файлов` | конфигурация storage-бэкенда |

### kind: хранилище-файлов

MinIO — рекомендуемый primary-бэкенд: S3-совместимый API, self-hosted, работает на одной машине и в кластере без изменений кода. Переключение на настоящий S3 или Backblaze B2 — смена одной строки endpoint.

```yaml
# Primary — MinIO (self-hosted, рекомендуется)
kind: хранилище-файлов
name: "MinIO home"
subtype: minio
endpoint: "http://minio.home:9000"
bucket: "domovoy"
access_key: "..."           # хранится в vault, не в графе
is_primary: true
is_cdn: false
quota_bytes: 107374182400   # 100 GB

# Резервный — Backblaze B2 (облако, S3-совместимый)
kind: хранилище-файлов
name: "Backblaze B2 backup"
subtype: backblaze-b2
endpoint: "https://s3.us-west-004.backblazeb2.com"
bucket: "domovoy-backup"
is_primary: false
is_cdn: true
cdn_url: "https://files.example.com"

# Только для разработки — локальная папка
kind: хранилище-файлов
name: "Local dev"
subtype: local
path: "/tmp/domovoy-dev"
is_primary: false
```

| subtype | когда использовать |
|---------|-------------------|
| `minio` | **primary** — self-hosted, S3 API, домашний сервер / NAS |
| `s3` | production в облаке, AWS |
| `backblaze-b2` | дешёвый резервный бэкенд |
| `nextcloud` | если уже есть Nextcloud |
| `sftp` | legacy NAS без S3 |
| `local` | только для разработки |

### kind: файл

```yaml
kind: файл
name: "Договор аренды 2024.pdf"
mime_type: "application/pdf"
size_bytes: 1240320
checksum_sha256: "a3f1b2c4..."
original_filename: "contract_rent_2024.pdf"
uploaded_at: datetime
uploaded_by: thing:user_me

# где физически лежит (несколько бэкендов для надёжности)
storage_locations:
  - backend: thing:storage_local
    path: "a3/a3f1b2c4/original.pdf"
    verified_at: datetime
  - backend: thing:storage_b2
    key: "files/a3f1b2c4/original.pdf"
    verified_at: datetime

# производные варианты (ссылки на дочерние kind: файл)
variants:
  thumbnail: thing:file_a3f1_thumb    # первая страница, 200×200
  preview:   thing:file_a3f1_prev     # первая страница, 800px

# для изображений
width_px: ~
height_px: ~
exif: {}

# для аудио/видео
duration_sec: ~
codec: ~

# статус обработки воркером
processing_status: "готов" | "обрабатывается" | "ошибка"

# рёбра
about: thing:doc_lease_agreement   # к чему относится
represents: thing:doc_original     # физический оригинал (если скан)
part_of: thing:file_a3f1_original  # если это производный вариант
```

### Детерминированный путь в хранилище

```
{storage_root}/{checksum[0:2]}/{checksum}/original.{ext}
{storage_root}/{checksum[0:2]}/{checksum}/thumbnail.webp
{storage_root}/{checksum[0:2]}/{checksum}/preview.webp
{storage_root}/{checksum[0:2]}/{checksum}/page_{n}.webp
```

Путь выводится из checksum — дедупликация автоматическая. Два пользователя загрузили одинаковый файл → один физический объект на диске, два `kind: файл` узла в графе с разными `about`.

### kind: чанк (для RAG и полнотекстового поиска)

Воркер разбивает текстовые файлы (PDF, DOCX, TXT, MD) на чанки и вычисляет embeddings:

```yaml
kind: чанк
text: "Арендатор обязан вносить плату не позднее 5-го числа..."
page: 3
chunk_index: 7
token_count: 128
embedding: [0.12, -0.34, 0.87, ...]   # 1536-мерный вектор, MTREE-индекс
language: "ru"
part_of: thing:file_a3f1b2c4          # из какого файла
about: thing:doc_lease_agreement       # наследует контекст
```

Существующий индекс покрывает чанки без изменений:
```surql
DEFINE INDEX idx_embedding ON thing FIELDS embedding MTREE DIMENSION 1536;
DEFINE INDEX idx_text      ON thing FIELDS text SEARCH ANALYZER ascii BM25;
```

### Пайплайн обработки файла

```mermaid
graph LR
    Upload["Загрузка файла\n(multipart/form-data)"]
    AppSrv["App Server\n(Next.js API)"]
    Storage["Хранилище\n(local / S3)"]
    DB["SurrealDB\nkind: файл"]
    Queue["kind: очередь\nfile-processing"]
    Worker["kind: воркер\nfile-processor"]
    Thumb["kind: файл\nthumbnail"]
    Chunks["kind: чанк\n×N"]
    Idx["Поиск\n(BM25 + MTREE)"]

    Upload --> AppSrv
    AppSrv -->|stream| Storage
    AppSrv -->|метаданные| DB
    DB -->|DEFINE EVENT| Queue
    Queue --> Worker
    Worker -->|generate| Thumb
    Worker -->|extract + split| Chunks
    Chunks --> Idx
```

```surql
-- DEFINE EVENT: запустить обработку при создании файла
DEFINE EVENT process_file ON TABLE thing
  WHEN $event = "CREATE" AND $after.kind = "файл"
    AND $after.processing_status = NONE
THEN {
  UPDATE $after.id SET processing_status = "обрабатывается";
  CREATE thing SET
    kind     = "запуск-плейбука",
    status   = "ожидание",
    part_of  = thing:playbook_process_file,
    context  = { trigger: $after };
};
```

### Варианты по типу файла

| mime_type | варианты | чанки |
|-----------|---------|-------|
| `image/*` | thumbnail, preview | нет (только EXIF) |
| `application/pdf` | thumbnail, preview, page\_N | да (по страницам) |
| `text/*`, `*.md` | нет | да |
| `application/msword` | thumbnail | да |
| `audio/*` | waveform | да (транскрипт через STT) |
| `video/*` | keyframes, thumbnail | да (транскрипт через STT) |

Для аудио и видео транскрипт создаётся через STT-модуль (`kind: источник-данных`, subtype: whisper-local) и разбивается на чанки.

### Доступ к файлам

Права наследуются от `about`: есть `can_access` на thing → есть доступ ко всем его файлам. Явные права на конкретный файл через `can_access` переопределяют.

```surql
-- Проверить доступ к файлу
SELECT id FROM thing
WHERE id = $file_id
  AND (
    -- явный доступ к файлу
    <-can_access<-thing[WHERE id = $auth AND status = "active"] != []
    -- или доступ к тому, о чём файл
    OR ->about->thing<-can_access<-thing[WHERE id = $auth AND status = "active"] != []
    -- или публичный
    OR <-can_access<-thing[WHERE id = thing:public] != []
  );
```

Раздача файлов через Next.js API route (проверка доступа) или прямой CDN URL для публичных.

### Квоты и дедупликация

```surql
-- Место, занятое пользователем
SELECT math::sum(size_bytes) AS использовано,
       count() AS файлов
FROM thing
WHERE kind = "файл" AND uploaded_by = $auth;

-- Дедупликация: найти дубли по checksum
SELECT checksum_sha256, count() AS копий,
       array::group(uploaded_by.name) AS у_кого
FROM thing
WHERE kind = "файл"
GROUP BY checksum_sha256
HAVING копий > 1;
```

### SurrealQL: типовые запросы

```surql
-- Все файлы, связанные с узлом (и его дочерними)
SELECT name, mime_type, size_bytes, uploaded_at,
       uploaded_by.name AS кто,
       variants.thumbnail AS превью
FROM thing
WHERE kind = "файл"
  AND (about = $node_id
    OR about->part_of->thing = $node_id)
ORDER BY uploaded_at DESC;

-- Семантический поиск по чанкам (vector search)
SELECT text, page,
       part_of.name AS файл,
       about.name AS контекст,
       vector::similarity::cosine(embedding, $query_embedding) AS score
FROM thing
WHERE kind = "чанк"
ORDER BY score DESC LIMIT 10;

-- Файлы без обработки (застряли в очереди)
SELECT name, mime_type, uploaded_at, processing_status
FROM thing
WHERE kind = "файл"
  AND processing_status = "обрабатывается"
  AND uploaded_at < time::now() - 10m;

-- Самые большие файлы в системе
SELECT name, mime_type,
       math::round(size_bytes / 1048576) AS мб,
       uploaded_by.name AS кто,
       about.name AS контекст
FROM thing
WHERE kind = "файл" AND part_of = NONE   -- только оригиналы, не варианты
ORDER BY size_bytes DESC LIMIT 20;

-- Файлы, у которых нет бэкапа во втором хранилище
SELECT name, size_bytes, storage_locations
FROM thing
WHERE kind = "файл"
  AND array::len(storage_locations) < 2;
```

---

## Расширенный обучающий слой

Домовой строит обучение вокруг трёх идей, которых нет в существующих LMS:

1. **Личный контекст** — квиз про Kubernetes задаёт вопросы о ТВОЁМ реальном кластере из графа.
2. **Одноразовые среды** — реальный сервер/БД на время лабы, provisioned плейбуком.
3. **Единое состояние** — SM-2 карточки накапливают знания поверх всех попыток и курсов.

### Разделение «что учить» и «состояние обучения»

```
SHARED — ноль копий на студента (контент курса)
  kind: учебный-путь
  kind: курс
  kind: модуль
  kind: урок
  kind: контент-блок
  kind: вопрос
  kind: лаборатория
  kind: достижение

PER-STUDENT — одна на студента на курс
  kind: прохождение-курса   ← enrollment, stable node
  kind: карточка-повторения ← SM-2 state, не сбрасывается при перепрохождении

PER-ATTEMPT — одна на каждое прохождение
  kind: попытка-курса
    → kind: попытка-урока
      → kind: попытка-вопроса
      → kind: попытка-лабы
```

Несколько студентов на одном курсе не дублируют контент. Перепрохождение создаёт новую `попытка-курса`, enrollment не трогается.

### Структура контента

```
kind: учебный-путь
  name: "Стать DevOps-инженером"
  contains → kind: курс  (ordered, depends_on для prerequisites)

kind: курс
  name: "Kubernetes для администраторов"
  level: "beginner" | "intermediate" | "advanced"
  language: "ru"
  estimated_hours: 12
  depends_on → kind: курс  (prerequisite)
  contains → kind: модуль

kind: модуль
  name: "Pods и Deployments"
  order: 2
  part_of → kind: курс
  contains → kind: урок

kind: урок
  name: "Жизненный цикл пода"
  order: 1
  part_of → kind: модуль
  contains → kind: контент-блок  (ordered)
  produces → kind: вопрос  (автогенерация AI)
```

### kind: контент-блок

Атомарная единица урока. Блоки идут последовательно, каждый с типом:

```yaml
kind: контент-блок
order: 3
block_type: текст | видео | аудио | задание | квиз | лаб | карточки
part_of: thing:lesson_pod_lifecycle

# для текста
content: "## Фазы пода\n\nPending → Running → Succeeded..."
format: markdown

# для видео (YouTube-клип)
source: youtube
youtube_id: "dQw4w9WgXcQ"
start_sec: 120
end_sec: 340
transcript: "..."   ← сгенерирован Whisper или YouTube API
caption_lang: ru

# для аудио (аудирование, языки)
audio_file: thing:file_audio_xyz
transcript: "The pod is in a Pending state"
```

### Расширенные типы вопросов

```yaml
kind: вопрос
type: выбор | множественный-выбор | текстовый-ввод | код |
      sql | bash | аудирование | произношение | соответствие

# общие поля
text: "Что произойдёт если liveness probe падает 3 раза подряд?"
points: 10
difficulty: 1-5         ← влияет на SM-2 ease_factor
hint: "Проверь параметр failureThreshold"
explanation: "Kubelet перезапустит контейнер..."
tags: ["kubernetes", "probes"]

# для выбор / множественный-выбор
options:
  - { text: "Pod удаляется", correct: false }
  - { text: "Контейнер перезапускается", correct: true }
  - { text: "Node перезагружается", correct: false }

# для текстовый-ввод (AI-проверка)
model_answer: "Kubelet перезапустит контейнер согласно restartPolicy"
rubric: "Упомянуть: kubelet, перезапуск, restartPolicy"
check_method: ai-rubric | exact-match | regex | similarity

# для код / sql / bash
starter_code: "SELECT * FROM ..."
expected_output: "42"
check_method: run-and-compare | schema-check | test-suite
language: python | sql | bash | javascript | surreal

# для аудирование (языки)
audio_file: thing:file_audio_sentence
correct_transcript: "The weather is nice today"
acceptable_variants: ["The weather's nice today"]
tolerance_pct: 90       ← similarity threshold

# для произношение
prompt_text: "Скажите: 'Pronunciation practice'"
check_method: stt-similarity
target_phonemes: [...]

# для соответствие
pairs:
  - { left: "Pod", right: "Минимальная единица деплоя" }
  - { left: "Node", right: "Физическая или виртуальная машина" }
```

### Одноразовые лабораторные среды

```yaml
kind: лаборатория
name: "SQL: агрегации и GROUP BY"
lab_type: sql | bash | kubernetes | docker | surreal | python | git
environment:
  image: "postgres:16"
  cpu: "0.5"
  memory: "512m"
  lifetime_min: 60

# начальное состояние (DDL + данные)
setup_script: |
  CREATE TABLE orders (id SERIAL, amount DECIMAL, status TEXT);
  INSERT INTO orders VALUES (1, 150.00, 'paid'), (2, 200.00, 'pending');

# задание для студента
tasks:
  - "Посчитайте сумму заказов по каждому статусу"
  - "Выведите только статусы с суммой > 100"

# проверочный скрипт (запускается после submit)
check_script: |
  SELECT status, SUM(amount) FROM orders GROUP BY status HAVING SUM(amount) > 100;
expected_result_hash: "abc123"   ← или check_method: semantic (AI сравнивает)

# для bash/k8s лаб
check_method: script | ai-review | both
```

**Provisioning среды через плейбук:**

```mermaid
graph LR
    Student["Студент\nнажал Start Lab"]
    PB["kind: плейбук\nЗапустить учебную среду"]
    S1["kind: шаг\nСоздать pod/container"]
    S2["kind: шаг\nПрименить setup_script"]
    S3["kind: шаг\nОбновить учебную-среду\nstatus: готова"]
    S4["kind: шаг\nЗапустить таймер истечения"]
    Env["kind: учебная-среда\nstatus: готова\nconnection_url: ..."]

    Student --> PB
    PB --> S1 --> S2 --> S3 --> S4
    S3 --> Env
```

```yaml
kind: учебная-среда
status: запускается | готова | завершена | истекла | ошибка
connection_url: "postgres://student:pwd@lab-xyz.home:5432/lab"
web_terminal_url: "https://домовой.home/lab/xyz/terminal"
expires_at: datetime
part_of: thing:attempt_lab_sql_001    ← привязана к попытке
about: thing:lab_sql_aggregations     ← какая лаба
assigned_to: thing:user_me
```

Истечение через уже спроектированный DEFINE EVENT → статус `"истекла"` → плейбук удаляет контейнер/pod.

### Автогенерация контента из YouTube

```
Плейбук "YouTube → Курс":
  шаг 1: YouTube Data API → метаданные, транскрипт
  шаг 2: Whisper (если нет транскрипта) → текст
  шаг 3: AI-агент → summary, ключевые концепции, вопросы ×10, карточки ×20
  шаг 4: Создать контент-блок (видео) + вопросы + карточки в графе
  шаг 5: Уведомить пользователя
```

Весь процесс — один плейбук, запускается по URL YouTube-клипа.

### Прогресс и перепрохождение

```yaml
kind: прохождение-курса          # enrollment — stable, один на студента на курс
student: thing:user_me
course: thing:course_k8s_admin
enrolled_at: datetime
best_score: 85
best_attempt: thing:attempt_course_2
total_attempts: 3
current_attempt: thing:attempt_course_3   # активная попытка

kind: попытка-курса              # одна на каждое прохождение
attempt_number: 3
status: в-процессе | завершена | заброшена
started_at: datetime
completed_at: datetime
score: 72
xp_earned: 340
part_of: thing:enrollment_k8s_me    # ← прохождение-курса
# дочерние попытки уроков через part_of ↓

kind: попытка-урока
lesson: thing:lesson_pod_lifecycle
status: завершён | пропущен
score: 90
time_spent_sec: 420
part_of: thing:attempt_course_3

kind: попытка-вопроса
answer: "Контейнер перезапускается kubelet-ом"
is_correct: true
score: 10
time_spent_sec: 23
part_of: thing:attempt_lesson_xyz
answered → kind: вопрос           # ← уже существующее ребро

kind: попытка-лабы
submitted_at: datetime
result: passed | failed | timeout
check_output: "Expected: 42, Got: 42 ✓"
part_of: thing:attempt_lesson_xyz
about: thing:lab_sql_aggregations
```

**Перепрохождение** — только новая `попытка-курса`, enrollment не трогается:

```surql
-- Начать новое прохождение
LET $new_attempt = CREATE thing SET
  kind = "попытка-курса",
  attempt_number = $enrollment.total_attempts + 1,
  status = "в-процессе",
  started_at = time::now(),
  part_of = $enrollment_id;

UPDATE $enrollment_id SET
  total_attempts += 1,
  current_attempt = $new_attempt.id;
```

Карточки SM-2 (`kind: карточка-повторения`) при перепрохождении **не сбрасываются** — они накапливают знания поверх всей истории попыток и курсов.

### Интервальное повторение (SM-2)

```yaml
kind: карточка-повторения
question: thing:question_xyz      # shared вопрос
student: thing:user_me
next_review: datetime
interval_days: 7
ease_factor: 2.5                  # 1.3–2.5, снижается при ошибках
review_count: 12
last_result: снова | плохо | хорошо | легко
```

SM-2 обновляется при каждом `попытка-вопроса.is_correct`. AI-агент может дополнительно снижать `ease_factor` для вопросов, где студент даёт правильный ответ но медленно.

Расписание повторений создаётся как `kind: расписание` → `triggered_by` → сессия повторения.

### Адаптивность и личный контекст

**Адаптивная сложность** — AI-агент анализирует все `попытки-вопроса` студента и:
- Генерирует дополнительные вопросы по слабым темам
- Снижает difficulty следующей попытки
- Рекомендует дополнительные уроки через `related_to`

**Личный контекст** — квиз может задавать вопросы о данных студента из графа:

```yaml
kind: вопрос
type: sql
text: "Напишите запрос для получения всех инцидентов на ваших серверах за 30 дней"
context_query: >         ← подгружается в условие задачи
  SELECT name FROM thing WHERE kind = 'сервер'
    AND <-can_access<-thing = $auth
check_against: student_graph   ← проверка на реальных данных студента
```

### Достижения и сертификаты

```yaml
kind: достижение
name: "Первый SQL-запрос"
xp: 50
condition: { completed_lab_type: "sql" }
icon: "trophy"

kind: выдача-достижения
achievement: thing:achievement_first_sql
student: thing:user_me
earned_at: datetime
part_of: thing:attempt_course_xyz

kind: сертификат-курса
student: thing:user_me
course: thing:course_k8s_admin
issued_at: datetime
score: 92
attempt: thing:attempt_course_2
produces → kind: файл   ← PDF-сертификат в vault
```

### SurrealQL: типовые запросы

```surql
-- Прогресс студента по всем курсам
SELECT ->about->thing.name AS курс,
       best_score, total_attempts,
       time::duration(enrolled_at - time::now()) AS учится,
       current_attempt.status AS статус
FROM thing
WHERE kind = "прохождение-курса" AND student = $auth;

-- Слабые темы по тегам вопросов (все попытки)
SELECT ->answered->thing.tags AS тема,
       count() AS попыток,
       math::sum(score) / count() AS точность
FROM thing
WHERE kind = "попытка-вопроса"
  AND ->part_of->thing->part_of->thing->part_of->thing.student = $auth
  AND is_correct = false
GROUP BY тема
ORDER BY точность ASC LIMIT 10;

-- Карточки к повторению сегодня
SELECT ->question->thing.{ text, type, difficulty } AS вопрос,
       next_review, interval_days, ease_factor
FROM thing
WHERE kind = "карточка-повторения"
  AND student = $auth
  AND next_review <= time::now()
ORDER BY next_review ASC;

-- Активные лабораторные среды
SELECT ->about->thing.name AS лаба,
       status, connection_url,
       time::duration(expires_at - time::now()) AS осталось
FROM thing
WHERE kind = "учебная-среда"
  AND assigned_to = $auth
  AND status = "готова";

-- Сравнение попыток курса
SELECT attempt_number, score, xp_earned,
       time::duration(completed_at - started_at) AS затрачено,
       count(<-part_of<-thing[WHERE kind = "попытка-урока" AND status = "завершён"]) AS уроков
FROM thing
WHERE kind = "попытка-курса"
  AND ->part_of->thing.student = $auth
  AND ->part_of->thing.course = $course_id
ORDER BY attempt_number ASC;
```

---

## Мультиязычность (i18n)

Три уровня — три подхода:

| Уровень | Где хранится | Подход |
|---------|-------------|--------|
| UI-строки (кнопки, лейблы) | JSON-файлы по локалям | `next-intl`, не в SurrealDB |
| Контент узлов (name, content, description) | В самом `thing` | Embedded `_i18n` объект |
| Системные промпты, шаблоны сообщений | В самом `thing` | Тот же `_i18n` |

### Два поля на каждом thing

```surql
DEFINE FIELD _lang ON thing TYPE option<string>;   -- язык оригинала: "ru", "en", "de"
DEFINE FIELD _i18n ON thing TYPE option<object>;   -- переводы + метаданные
```

Поля опциональны — узлы без `_lang` считаются на системном языке инстанса.

```yaml
# Пример: урок с переводами
kind: урок
name: "Жизненный цикл пода"
content: "## Фазы пода\n\nPending → Running → Succeeded..."
_lang: "ru"

_i18n:
  en:
    name: "Pod Lifecycle"
    content: "## Pod Phases\n\nPending → Running → Succeeded..."
    status: "проверен"       # черновик | ai | проверен | опубликован | устарел
    translated_at: "2025-05-19T10:00:00Z"
    translated_by: "thing:agent_ai"
    reviewed_by: "thing:user_john"
    reviewed_at: "2025-05-19T12:00:00Z"
    source_hash: "a3f1b2"    # hash от оригинальных полей
  de:
    name: "Pod-Lebenszyklus"
    content: "## Pod-Phasen..."
    status: "ai"
    translated_at: "2025-05-19T11:00:00Z"
    translated_by: "thing:agent_ai"
    source_hash: "a3f1b2"
  zh:
    name: "Pod 生命周期"
    status: "черновик"
```

### Почему embedded, а не отдельные узлы

Узел путешествует вместе с переводами **атомарно**. При федерации shadow-копия несёт весь `_i18n` блок без дополнительных запросов. Пользователь из другой страны берёт граф — получает оригинал плюс все готовые переводы сразу. Можно добавить свой язык локально, не трогая оригинальный инстанс.

### Language fallback при отдаче контента

```surql
-- Получить поле name на языке пользователя, fallback на оригинал
SELECT
  IF _i18n[$lang].name != NONE
    AND _i18n[$lang].status IN ["проверен", "опубликован", "ai"]
  THEN _i18n[$lang].name
  ELSE name
  END AS display_name,
  _lang AS source_lang,
  _i18n[$lang].status AS translation_status
FROM thing WHERE id = $id;
```

Цепочка fallback: запрошенный язык → `_lang` (оригинал) → язык инстанса.

### Обнаружение устаревших переводов

При изменении оригинального контента DEFINE EVENT сравнивает `source_hash`:

```surql
DEFINE EVENT i18n_stale ON TABLE thing
  WHEN $event = "UPDATE"
    AND ($before.name != $after.name OR $before.content != $after.content)
    AND $after._i18n != NONE
THEN {
  LET $new_hash = crypto::md5(string::concat($after.name ?? "", $after.content ?? ""));

  -- Пометить переводы с несовпадающим хешем как устаревшие
  UPDATE $after.id SET _i18n = object::map($after._i18n, |$lang, $tr| {
    IF $tr.source_hash != $new_hash
    THEN object::add($tr, "status", "устарел")
    ELSE $tr
    END
  });
};
```

### Workflow перевода

```mermaid
graph LR
    Src["Оригинальный\nконтент (_lang: ru)"]
    PB["Плейбук\nАI-перевод"]
    AI["kind: агент-ai\n(GPT-4o / Claude)"]
    Draft["_i18n.en.status:\nai"]
    Review["Человек-ревьюер\nредактирует / одобряет"]
    Done["_i18n.en.status:\nпроверен"]
    Stale["Источник изменился\nstatus: устарел"]

    Src -->|создан / изменён| PB
    PB --> AI
    AI --> Draft
    Draft --> Review
    Review --> Done
    Src -->|DEFINE EVENT| Stale
    Stale -->|триггер| PB
```

**Плейбук AI-перевода:**

```surql
-- Запустить перевод конкретного узла на язык
CREATE thing SET
  kind = "запуск-плейбука",
  status = "ожидание",
  part_of = thing:playbook_ai_translate,
  context = {
    trigger: { node_id: $node_id, target_lang: "en", source_lang: $source_lang }
  };
```

```yaml
kind: плейбук
name: "AI-перевод узла"
steps:
  - шаг: получить поля для перевода (SurrealQL)
  - шаг: агент-ai переводит (с контекстом домена)
  - шаг: UPDATE _i18n[target_lang] = { ..., status: "ai" }
  - шаг: уведомить ревьюера (если нужна проверка)
```

Агент-ai получает в промпте контекст: домен узла (`kind`), соседние узлы, глоссарий проекта — чтобы терминология была согласованной.

### Глоссарий (согласованность терминов)

```yaml
kind: глоссарий
name: "IT-термины"
entries:
  pod:
    ru: "под"
    en: "pod"
    de: "Pod"
  deployment:
    ru: "деплоймент"
    en: "deployment"
about: thing:course_k8s_admin    # к какому курсу/домену относится
```

При переводе агент получает `глоссарий` в контекст — термины переводятся единообразно.

### Мультиязычность в федерации

```
Инстанс RU  →  граф с _lang: "ru", _i18n: { en: {...}, de: {...} }
    ↓ федерация (shadow namespace)
Инстанс DE  →  shadow-копия несёт весь _i18n атомарно
              пользователь видит de если есть, иначе ru
              может добавить _i18n.fr локально — не влияет на RU-инстанс
```

### Какие поля переводить

Не все поля имеет смысл переводить. Конвенция:

| Поле | Переводить? | Причина |
|------|------------|---------|
| `name` | да | отображается везде |
| `content`, `text`, `description` | да | основной контент |
| `status` | нет | enum, переводится на уровне UI |
| `kind` | нет | системное |
| `cron`, `url`, даты | нет | технические |
| `tags` | опционально | зависит от использования |
| Личные данные (задачи, инвентарь) | нет | персональный контекст |

Переводить имеет смысл прежде всего системный контент: курсы, wiki, промпты ботов, шаблоны уведомлений.

### SurrealQL: типовые запросы

```surql
-- Все узлы без английского перевода (для очереди перевода)
SELECT id, name, kind, _lang FROM thing
WHERE _i18n.en = NONE
  AND _lang != "en"
  AND kind IN ["урок", "вопрос", "контент-блок", "промпт"]
ORDER BY kind, name;

-- Все устаревшие переводы
SELECT id, name, _lang,
       object::keys(_i18n) AS языки,
       array::filter(object::keys(_i18n), |$l| _i18n[$l].status = "устарел") AS устарели
FROM thing
WHERE _i18n != NONE
  AND array::any(object::values(_i18n), |$tr| $tr.status = "устарел");

-- Прогресс перевода по языкам
SELECT _i18n.*.status AS статус, count() AS узлов
FROM thing
WHERE _i18n != NONE
GROUP BY статус;

-- Узлы ожидающие ревью (переведены AI, не проверены человеком)
SELECT id, name, kind, _lang,
       array::filter(object::keys(_i18n), |$l| _i18n[$l].status = "ai") AS ждут_ревью
FROM thing
WHERE array::any(object::values(_i18n), |$tr| $tr.status = "ai")
ORDER BY kind, name;

-- Получить курс целиком на нужном языке
SELECT
  IF _i18n[$lang].name != NONE THEN _i18n[$lang].name ELSE name END AS name,
  IF _i18n[$lang].content != NONE THEN _i18n[$lang].content ELSE content END AS content,
  _lang AS original_lang,
  _i18n[$lang].status AS translation_status
FROM thing
WHERE ->part_of->thing = thing:course_k8s_admin
  OR id = thing:course_k8s_admin
ORDER BY kind, order;
```

---

## Локальный GPU-стек и векторизация

Домовой рассчитан на self-hosted деплой с локальным GPU. Сервер с RTX 3090 (24 GB VRAM)
закрывает все AI-задачи без внешних API: LLM-инференс, embeddings, reranking, STT.

### Рекомендуемый стек

| Задача | Модель | VRAM | Инструмент |
|--------|--------|------|-----------|
| LLM (основной) | Qwen2.5 32B Q4_K_M | ~20 GB | Ollama |
| или | Gemma 3 27B Q4 | ~18 GB | Ollama |
| Embeddings | BGE-M3 | ~0.6 GB | Ollama / FlagEmbedding |
| Reranker | BGE-Reranker-v2-m3 | ~0.6 GB | FlagEmbedding |
| STT | Whisper large-v3 | ~3 GB | faster-whisper |

Одновременный стек: **Qwen2.5 32B + BGE-M3 + Reranker ≈ 21 GB** — помещается.
Whisper грузится по требованию (голосовой ввод нечастый).

**Почему BGE-M3:** мультиязычная модель (100+ языков), хорошо работает с русским.
Поддерживает dense + sparse + colbert — три поисковых сигнала из одной модели.
`nomic-embed-text` — английский first, для русских текстов заметно хуже.

### Источники данных для локального GPU

```yaml
# LLM
kind: источник-данных
name: "Ollama — Qwen2.5 32B"
subtype: ollama
endpoint: "http://gpu-server.home:11434"
model: "qwen2.5:32b-instruct-q4_K_M"
is_default: true
context_window: 32768

# Embeddings
kind: источник-данных
name: "BGE-M3 local"
subtype: ollama
endpoint: "http://gpu-server.home:11434"
model: "bge-m3"
role: embedding
dimension: 1024

# Reranker (отдельный HTTP-сервис на FlagEmbedding)
kind: источник-данных
name: "BGE-Reranker-v2-m3"
subtype: http
endpoint: "http://gpu-server.home:8001/rerank"
role: reranker

# STT
kind: источник-данных
name: "Whisper large-v3"
subtype: whisper
endpoint: "http://gpu-server.home:9000"
language: auto
```

Переключение на OpenAI — смена одного узла `kind: источник-данных`. Остальная система не меняется.

### MTREE-индекс под BGE-M3

BGE-M3 возвращает 1024-мерные векторы. Индекс объявляется под конкретную размерность:

```surql
-- BGE-M3 (рекомендуется, multilingual)
DEFINE INDEX idx_embedding ON thing FIELDS embedding MTREE DIMENSION 1024;

-- OpenAI text-embedding-3-small / ada-002
-- DEFINE INDEX idx_embedding ON thing FIELDS embedding MTREE DIMENSION 1536;

-- nomic-embed-text / all-MiniLM (лёгкий вариант)
-- DEFINE INDEX idx_embedding ON thing FIELDS embedding MTREE DIMENSION 768;
```

### Что векторизуется

Embedding вычисляется не только для файловых чанков, но и для любого узла с текстом:

| kind | поля для embedding |
|------|--------------------|
| `чанк` | `text` |
| `блок` | `text` |
| `задача` | `name + description + notes` |
| `сообщение` | `text` |
| `инцидент` | `name + description + resolution` |
| `курс`, `урок` | `name + content` |
| `документ` | `name + description` |

Поле `embedding_status` отслеживает актуальность вектора:

```surql
DEFINE FIELD embedding        ON thing TYPE option<array<float>>;
DEFINE FIELD embedding_status ON thing TYPE option<string>;
-- значения: "актуален" | "нужно-обновить" | "отсутствует"
DEFINE FIELD embedding_model  ON thing TYPE option<string>;
-- фиксируем какой моделью считали (при смене модели → ре-векторизация)
```

### DEFINE EVENT: ре-векторизация при изменении текста

```surql
DEFINE EVENT embed_on_change ON TABLE thing
  WHEN $event IN ["CREATE", "UPDATE"]
    AND $after.kind IN [
      "блок", "задача", "сообщение", "инцидент",
      "курс", "урок", "документ", "чанк"
    ]
    AND (
      $after.text        != $before.text        OR
      $after.description != $before.description OR
      $after.notes       != $before.notes       OR
      $after.content     != $before.content
    )
THEN {
  UPDATE $after.id SET embedding_status = "нужно-обновить";
};
```

Воркер `embedding-worker` подписывается через LIVE SELECT:

```surql
LIVE SELECT id, kind, text, description, notes, content
FROM thing
WHERE embedding_status = "нужно-обновить";
```

Получает узел → формирует строку для embedding → POST в Ollama/BGE-M3 → обновляет поля:

```surql
UPDATE thing:xyz SET
  embedding        = $vector,
  embedding_status = "актуален",
  embedding_model  = "bge-m3";
```

### Пайплайн гибридного поиска (Hybrid RAG)

```
Запрос пользователя
  ↓
embedding-worker векторизует запрос → $query_vec  (BGE-M3)
  ↓
┌─────────────────────────────┐   ┌──────────────────────────────┐
│  Vector search (MTREE)      │   │  BM25 search (SEARCH ANALYZER)│
│  top-20 по cosine similarity│   │  top-20 по keyword relevance  │
└─────────────────────────────┘   └──────────────────────────────┘
  ↓                                  ↓
  └──────────── RRF merge ───────────┘
                  ↓
          объединённый top-40
                  ↓
      BGE-Reranker-v2-m3
      (cross-encoder, точный скоринг)
                  ↓
          финальный top-5..10
                  ↓
    вставить в system message → LLM (Qwen2.5 32B)
```

**RRF (Reciprocal Rank Fusion):** `score = 1/(k + rank_vec) + 1/(k + rank_bm25)`, где `k=60`.

```surql
-- Vector search
SELECT id, text, kind, about, part_of,
       vector::similarity::cosine(embedding, $query_vec) AS vec_score
FROM thing
WHERE embedding_status = "актуален"
ORDER BY vec_score DESC LIMIT 20;

-- BM25 search
SELECT id, text, kind, about, part_of,
       search::score(1) AS bm25_score
FROM thing
WHERE text @1@ $query_text
   OR description @1@ $query_text
ORDER BY bm25_score DESC LIMIT 20;
```

Слияние и reranking выполняет App Server / воркер на Python (FlagEmbedding API).

### Управление памятью GPU

При нехватке VRAM для одновременного LLM + embedding + reranker — модели грузятся по очереди.
Ollama поддерживает `keep_alive` параметр: модель выгружается через N секунд простоя.

```yaml
# в конфиге источника данных
keep_alive: "5m"     # держать LLM в памяти 5 минут после последнего запроса
```

Embedding и reranker — лёгкие (< 1 GB каждый), держать постоянно.
LLM — тяжёлый, выгружать при простое если нужна VRAM для других задач.

### Диаграмма: локальный GPU-узел

```mermaid
graph TD
    SDB["SurrealDB\n(граф + очереди)"]
    AppSrv["App Server\n(Next.js)"]
    EmbWorker["embedding-worker\n(Python)"]
    Ollama["Ollama\ngpu-server:11434"]
    FlagEmb["FlagEmbedding\ngpu-server:8001"]
    Whisper["faster-whisper\ngpu-server:9000"]
    GPU["RTX 3090 24GB"]

    SDB -->|LIVE SELECT embed_queue| EmbWorker
    AppSrv -->|hybrid search| EmbWorker
    EmbWorker -->|embed text| Ollama
    EmbWorker -->|rerank chunks| FlagEmb
    AppSrv -->|LLM inference| Ollama
    AppSrv -->|transcribe audio| Whisper
    Ollama --> GPU
    FlagEmb --> GPU
    Whisper --> GPU
```

---

## Открытые вопросы

- [x] История перемещений вещей? → временны́е метки на рёбрах contains / located_at
- [x] Повторяющиеся задачи — шаблон с расписанием (каждую субботу, каждые 10000 км)? → `template: true` + `cron` / `trigger_field`; планировщик-воркер создаёт `run` через `part_of`
- [x] Уведомления — push или только в приложении? → шлюз `kind: push` + другие каналы
