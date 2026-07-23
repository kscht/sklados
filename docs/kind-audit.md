# Аудит `kind` в seed — план миграции

Аналитический документ перед фактической миграцией. Решает четыре задачи сразу:

1. зафиксировать **строгий тест на отдельный `kind`** — чтобы будущие кандидаты прогонялись единообразно;
2. зафиксировать **принципы категоризации** — чтобы `category` была деревом, а не плоским мусором;
3. инвентаризация русских `kind`-значений и переход на ASCII-канонические;
4. унификация реестров под SKOS-шаблон `vocabulary` + `concept` с внешними якорями (Wikidata / ISO / IANA / WHO / NCBI / CPE) — структура закладывается сразу.

Контекст:
- ASCII snake_case как канонический язык — диалог по типизации шины;
- 4 класса бытия (item / device / content / living) — там же;
- модель типизации связей — [`relation-typing.md`](relation-typing.md);
- глобальный таксономический словарь — раздел ниже.

## Тест: что заслуживает отдельного `kind`

Чтобы новая сущность X получила отдельный `kind`, должно выполняться **хотя бы одно** из трёх:

| # | Критерий | Пример |
|---|----------|--------|
| 1 | **Эксклюзивное ребро или ребро меняет семантику** | `can_access` на `device` обретает PAM-смысл (login/sudo), а не «видеть запись» |
| 2 | **Отдельный state machine** с переходами, которых нет у соседнего класса | `appeal`: filed→review→decided→appealed; `incident`: reported→triage→mitigating→resolved→post-mortem |
| 3 | **Отдельный способ существования** | `device`: кибер+физика; `living`: биология; `content`: чистая цифра |

**Недостаточно для отдельного `kind`:**
- «у меня свой UI-экран» — это фильтр в UI, не структура данных;
- «много полей и анкета» — это поля на узле;
- «развитый workflow» — это `category` + поля + шаблоны (`triggered_by`, `log_entry`);
- «концептуально другое» — UX-аргумент в маске структурного.

Каждое предложение нового `kind` должно явно отвечать «по какому из трёх критериев». Если ни по одному — это `category` или поле.

## Принципы категоризации (`category`)

1. **Категория — это одна метка, не вся таксономия.** Узел несёт **один** `category`-slug удобного уровня. Полное место в иерархии — в графе словаря через `part_of` между концептами. Запрос «всё агрохимия» обходит иерархию, даже если айтем тегирован как `fertilizer`.

2. **Категоризация — по workflow, не по химии.** Айтемы попадают в один бакет, если **в одну выборку по делу** — общий список покупок, общая полка, общие задачи ухода. Молекулярное родство не важно.

3. **Wikidata делает работу за тебя.** Не нужно изобретать 200 ручных категорий. Айтем несёт `wikidata` Q-id максимально специфичной сущности; глубокая таксономия (классы Wikidata через `wd:P279`) приходит бесплатно.

4. **Многомерность — через теги, не через несколько категорий.** Категория **одна**; «органическое», «импортное», «опасное», «новое» — это `tag`-узлы через `related_to {label:'тег'}`.

5. **Начинай широко, дроби только при плотности.** 15 широких бакетов на старте. Когда в `chemistry` накопилось 80 реактивов и появился осмысленный workflow — заводим подконцепты в словаре, у части айтемов уточняем `category`. **Граф ничего не ломает**, принимает любую глубину уточнения.

## Исходные числа

- **56 уникальных** значений `kind` в `scripts/seed.surql`
- **1004 узла** с проставленным `kind`
- мигрируем в **27 канонических** `kind`

## 4 класса бытия

| Класс | Канонические `kind` | Признак |
|---|---|---|
| **item** (пассивная физика) | `item` | хранится / одалживается / расходуется; включает транспорт (через category) |
| **device** (физика + сеть) | `device` | hostname, IP, креды, удалённый доступ (PAM) |
| **content** (чистая цифра) | `document`, `file`, `chunk`, `embedding`, `note`, `page`, `message`, `log_entry` | байты / семантика |
| **living** (биологический агент) | `person`, `animal`, `plant` | здоровье, лайфсайкл, забота, неотчуждаемая идентичность |
| места / события / workflow | `location`, `task`, `appeal`, `payment`, `event`, `incident`, `listing`, `diagnosis` | — |
| сущности / группы | `group`, `org` | — |
| шаблоны / теги | `template`, `tag` | — |
| таксономия (мета) | `vocabulary`, `concept` | SKOS-словари + термины |

## Канонический список `kind` (27 значений)

```
Физика:           item, device, location                                            (3)
Контент:          document, file, chunk, embedding, note, page, message, log_entry  (8)
Живое:            person, animal, plant                                              (3)
Workflow/события: task, appeal, payment, event, incident, listing, diagnosis        (7)
Сущности:         group, org                                                         (2)
Шаблоны/теги:     template, tag                                                      (2)
Таксономия:       vocabulary, concept                                                (2)
                                                                              итого: 27
```

Каждый прошёл тест:

| `kind` | Прошёл по критерию |
|---|---|
| `item` | базовый класс физики |
| `device` | 1, 3 — `can_access` = PAM-семантика; кибер-физическая двойственность |
| `location` | 1 — `contains` исходит отсюда, нет `lent_to` |
| `document` / `file` / `chunk` / `embedding` | 1 — специфические рёбра (`represents`, `derived_from`, MTREE-индекс) |
| `note` / `page` / `message` / `log_entry` | 1, 2 — разные state machines (draft→published; append-only счётчики; ветвление сообщений) |
| `person` / `animal` / `plant` | 3 — разные природы существования |
| `task` / `appeal` / `payment` / `event` / `incident` / `listing` / `diagnosis` | 2 — разные state machines |
| `org` / `group` | 1 — `filed_with` принимает только `org`; членство через `part_of` |
| `template` | 1 — порождает экземпляры через `part_of` |
| `tag` | 2 — ad-hoc метки, не курируемый словарь |
| `vocabulary` / `concept` | 1 — мета-уровень, рёбра SKOS-семантики |

**Что не получило `kind` и почему:**
- `vehicle` — нет эксклюзивных рёбер, state machine как у `item`, природа физическая → `item` + `category` с иерархией;
- `document_family` — это `document` с флагом `is_family=true` (тот же state machine, нет эксклюзивных рёбер).

Конвенция слагов: **snake_case ASCII** (единообразие с предикатами).

## Глобальный таксономический словарь

Все контролируемые перечисления (типы узлов/рёбер, категории, статусы, роли, валюты, языки, MIME, ICD, виды и т.п.) унифицированы под W3C SKOS:

- `kind = 'vocabulary'` — узел словаря (ConceptScheme)
- `kind = 'concept'` — узел термина (Concept)
- `concept → part_of → vocabulary` — членство
- `concept → part_of → concept` — иерархия (broader/narrower)
- `concept → related_to → concept` — sameAs / related
- `concept → references → external` — авторитативный URL
- `_i18n` на концепте — prefLabel + переводы
- `supersedes` — устаревший термин

Никаких новых рёбер не нужно — все 27 покрывают SKOS-семантику.

### Свои словари

| Словарь | Цель | ≈ Размер |
|---|---|---|
| `vocab:domovoy_kind` | 27 канонических `kind` | 27 |
| `vocab:domovoy_edge` | 27 типов рёбер | 27 |
| `vocab:domovoy_category` | категории для `item` (иерархия — см. ниже) | ~65 |
| `vocab:domovoy_brand` | бренды | растёт |
| `vocab:domovoy_status` | enum статусов | ~10 |
| `vocab:domovoy_role` | `role` на `device` | ~8 |
| `vocab:domovoy_permission` | права на `can_access` | ~10 |
| `vocab:domovoy_family_role` | роли в семье | ~6 |
| `vocab:domovoy_lifecycle` | стадии для living | ~10 |
| `vocab:domovoy_derived_method` | значения `derived_from.method` | ~7 |

### Внешние словари (минимальный набор сразу)

| Внешний словарь | Заводить сейчас? | Где используется |
|---|---|---|
| **Wikidata** (`vocab:wikidata`) | **да**, universal-anchor | поле `wikidata` на любом узле |
| **ISO 4217** валюты | **да**, минимально (RUB+) | `payment.currency` |
| **ISO 639** языки | **да**, минимально (ru, en) | `_lang`, ключи `_i18n` |
| **IANA MIME** | **да**, по факту | `file.mime` |
| **ISO 3166** страны | нет, по запросу | адреса |
| **WHO ICD-10/11** | нет, при первом `diagnosis` | `diagnosis.icd` |
| **WHO ATC** | нет, при первом medicine | `item.atc` |
| **NCBI Taxonomy** | нет, при первом `animal`/`plant` | `animal.taxon_id` |
| **GS1 GTIN** | нет, при первом скане | `item.gtin` |
| **NIST CPE** | нет, при первом IT-incident | `device.cpe`, `incident.cpe` |
| **schema.org** | нет | внешние якоря через `references` |

## Соглашение о внешних якорях: поля на узлах

Поля **денормализуют** идентификаторы для скорости. Авторитет — в графе через `concept` в соответствующем `vocabulary`.

### Универсальное поле `wikidata`

Любой узел может нести **`wikidata`** — Q-id максимально специфичной сущности:

```surql
-- модель есть в Wikidata — указываем модель
CREATE thing:`moto_bmw` SET kind='item', category='motorcycle',
  wikidata='Q57821567', name='BMW R 1250 GS';

-- модели нет, есть семейство
CREATE thing:`laptop_dad` SET kind='device', wikidata='Q861126', ...;

-- только категория
CREATE thing:`fridge_kitchen` SET kind='item', category='refrigerator',
  wikidata='Q37828', ...;
```

### Доменно-специфичные идентификаторы

| Поле | Класс/контекст | Стандарт |
|---|---|---|
| `gtin` | `item` (покупное) | GS1 GTIN-13 (штрих-код) |
| `isbn` | `item` категории `book` или `document` | ISBN |
| `vin` | `item` категории `vehicle/*` | ISO 3779 |
| `license_plate` | `item` категории `vehicle/*` | гос. номер |
| `mac` | `device` | IEEE 802 |
| `hostname` | `device` | DNS |
| `imei` | `device` (телефон) | 3GPP |
| `cpe` | `device` (OS/софт), `incident` | NIST CPE |
| `taxon_id` | `animal`, `plant` | NCBI Taxonomy |
| `microchip` | `animal` | ISO 11784/11785 |
| `cultivar` | `plant` | ICRA |
| `atc` | `item` категории `medicine/*` | WHO ATC |
| `icd` | `diagnosis` | WHO ICD-10/11 |
| `snomed` | `diagnosis` | SNOMED CT |
| `doi` | `document` (научный) | DOI |
| `cve` | `incident` | MITRE CVE |
| `inn`, `ogrn` | `org` (РФ) | ФНС |

### Что несут разные классы

| Класс | Обязательно | Типичные внешние якоря |
|---|---|---|
| `item` | `name`, `category` | `wikidata`, `gtin`, `brand`; **`vin`/`license_plate` если транспорт; `atc` если medicine** |
| `device` | `name`, `role` | `wikidata`, `mac`, `hostname`, `cpe`, `imei`, `gtin` |
| `person` | `name` | `wikidata` (если общественный), `birth_date` |
| `animal` | `name`, `species` | `wikidata`, `taxon_id`, `microchip` |
| `plant` | `name`, `species`, `stage` | `wikidata`, `taxon_id`, `cultivar` |
| `document` | `name`, `mime` | `isbn`, `doi`, `wikidata`; `is_family=true` для head-узла версионирования |
| `payment` | `amount`, `currency` (ISO 4217) | `wikidata` (для редких) |
| `diagnosis` | `code` | `icd`, `snomed`, `wikidata` |
| `incident` | `name` | `cve`, `cpe` |
| `org` | `name` | `wikidata`, `inn` / `ogrn` |
| `concept` | `identifier` | `wikidata` (sameAs) |

### `brand` — поле + концепт

```surql
CREATE thing:`concept_brand_bosch` SET
  kind='concept', identifier='bosch', wikidata='Q234021',
  _i18n={ ru:{label:'Bosch'}, en:{label:'Bosch'} };
RELATE thing:`concept_brand_bosch`->part_of->thing:`vocab_domovoy_brand`;
```

На айтеме `brand='bosch'` — slug в реестр.

## Иерархия категорий в `vocab:domovoy_category`

Закладываем дерево сразу для очевидных кластеров; плоско — для остального до появления плотности. Все категории — `kind='concept'`, иерархия через `part_of` между ними.

```
РАСХОДНИКИ
  food                       продукты, напитки, специи
  personal_care              косметика, гигиена, парфюм, бритьё
  ├── hygiene
  ├── cosmetics
  ├── dental
  ├── fragrance
  ├── shaving
  └── hair_care
  cleaning                   бытовая химия (для поверхностей, не тела)
  medicine                   аптечка
  reagent                    хим. реактивы (мастерская/гараж)

ДОЛГОВРЕМЕННЫЕ ПРЕДМЕТЫ
  furniture                  стол, стул, кровать, шкаф, диван
  kitchenware                посуда, кастрюли, ножи, доски
  linens                     постельное, полотенца, скатерти
  clothing                   одежда (footwear/outerwear/accessories — позже)
  book                       бумажные книги (контент → kind='document')
  office                     канцелярка (ручки, бумага, картриджи)
  toys                       детские игрушки, конструкторы
  pet_supplies               корм, наполнитель, поводки, лежанки
  art_supplies               краски, кисти, нитки, ткани, выкройки
  music                      инструменты, медиаторы, струны, ноты
  decorations                ёлочные игрушки, гирлянды, сезонные
  paperwork                  физические оригиналы документов (паспорта,
                             договоры) — отдельно от kind='document'

ЭЛЕКТРОНИКА / МЕДИА (без сети — иначе → kind='device')
  electronics                в коробке, платы, датчики
  electrical                 розетки, провода, выключатели
  audio                      bluetooth-наушники/колонки
  storage_media              флешки, SSD, HDD на полке
  peripheral                 мониторы, клавы, мыши
  navigation                 бумажные карты, компас
  media_archive              винил, кассеты, VHS, CD/DVD, фотоальбомы
  photography_gear           фотоаппарат, объектив, штатив, вспышка

ИНСТРУМЕНТЫ
  tool
  ├── hand_tool
  └── power_tool
      └── rotary_hammer

ТРАНСПОРТ
  vehicle                    бывшая kind, теперь концепт-категория
  ├── car
  ├── motorcycle
  ├── boat
  ├── snowmobile
  └── bicycle
  vehicle_supplies
  ├── auto_part
  ├── auto_accessory
  └── moto_accessory

ДОМ И СТРОЙКА
  construction               стройматериалы
  plumbing                   сантехника
  household_supplies
  ├── household              хозтовары
  ├── consumable             расходники
  ├── container              тара
  └── fastener               крепёж

САД И СПОРТ
  garden_supplies
  ├── garden_tool
  ├── seeds
  ├── sapling
  ├── substrate
  └── agrochemistry
      ├── fertilizer
      ├── growth_regulator
      └── pesticide
  sports
  ├── fishing
  ├── marine_gear
  └── tourism                outdoor (мангалы, шатры, термосы)

ОБЩЕЕ
  misc                       честное "не классифицировал"
```

**~65 концептов** в `vocab:domovoy_category` после миграции.

Принцип «начинай широко» применяется *внутри* кластеров. Если у тебя пять реактивов в шкафу — `reagent` без подкатегорий. Когда наберётся 80 и захочется отдельно фильтровать кислоты/основания/растворители — заводишь подконцепты, переразмечаешь часть айтемов. **Закладываем сейчас только те поддеревья, где парент-чайлд очевиден** (vehicle/*, tool/*, agrochemistry/*, household_supplies/*, garden_supplies/*, sports/*, personal_care/*) — остальное плоско.

**Кандидаты на будущее дробление** (когда вырастет плотность):
- `clothing` → `footwear` / `outerwear` / `accessories`
- `food` → `beverage` / `condiment`
- `medicine` → `medical_equipment` (для не-сетевого тонометра/глюкометра)
- `office` → `stationery` vs `office_consumables`

## Стартовый набор концептов с Wikidata Q-id (верифицировано)

Q-id подтверждены через `wbsearchentities`. Заводим в seed с привязкой к нашим `concept`-узлам.

### Категории (`vocab:domovoy_category` → Wikidata)

| Наш `category` | Wikidata Q-id | Wikidata label |
|---|---|---|
| `laptop` (под `electronics` или верхний уровень?) | Q3962 | laptop |
| `refrigerator` | Q37828 | refrigerator |
| `washing_machine` | Q124441 | washing machine |
| `dishwasher` | Q186263 | dishwasher |
| `microwave` | Q127956 | microwave oven |
| `air_conditioner` | Q1265533 | air conditioner |
| `electric_kettle` | Q1364042 | electric kettle |
| `oven` | Q36539 | oven |
| `coffeemaker` | Q211841 | coffeemaker |
| `vacuum_cleaner` | Q101674 | vacuum cleaner |
| `power_tool` | Q1327701 | power tool |
| `rotary_hammer` | Q1932875 | rotary hammer |
| `fertilizer` | Q83323 | fertilizer |
| `bicycle` | Q11442 | bicycle |
| `motorcycle` | Q34493 | motorcycle |
| `car` | Q1420 | car |

### Бренды (`vocab:domovoy_brand` → Wikidata)

| Наш `brand` | Wikidata Q-id |
|---|---|
| `apple` | Q312 |
| `bmw` | Q26678 |
| `bosch` | Q234021 |
| `lenovo` | Q14799 |
| `makita` | Q691508 |

### Конкретные модели в seed (поле `wikidata` прямо на узле)

| Узел seed | Wikidata Q-id | Что |
|---|---|---|
| `moto_bmw` | **Q57821567** | BMW R 1250 GS |
| `car_vesta` | **Q17376334** | Lada Vesta |

### Внешний словарь Wikidata — как выглядит

```surql
CREATE thing:`vocab_wikidata` SET
  kind='vocabulary', identifier='wikidata', source='external',
  authority='Wikimedia Foundation', version='live',
  _i18n={ ru:{label:'Wikidata'}, en:{label:'Wikidata'} };

-- Наш концепт ↔ Wikidata концепт
CREATE thing:`concept_dom_laptop` SET
  kind='concept', identifier='laptop', wikidata='Q3962',
  _i18n={ ru:{label:'Ноутбук'}, en:{label:'Laptop'} };
RELATE thing:`concept_dom_laptop`->part_of->thing:`vocab_domovoy_category`;
```

Материализация Wikidata-концептов — **лениво**: только когда нужна иерархия (broader/narrower) или прямая ссылка на URL.

## Полная таблица миграции 56 → 27

Сортировка по убыванию количества.

| Сейчас (`kind`) | # | Куда (`kind`) | category | Класс |
|---|---:|---|---|---|
| `инструмент` | 79 | `item` | `tool` (или `hand_tool`/`power_tool` по факту) | item |
| `место` | 63 | **split** (см. особые случаи) | — | item / location |
| `крепёж` | 62 | `item` | `fastener` | item |
| `автозапчасть` | 49 | `item` | `auto_part` | item |
| `книга` | 44 | `item` | `book` | item |
| `разное` | 42 | `item` | `misc` | item |
| `одежда` | 42 | `item` | `clothing` | item |
| `человек` | 41 | `person` | — | living |
| `электроника` | 40 | **split** | `electronics` / device | item / device |
| `электрика` | 40 | `item` | `electrical` | item |
| `хозтовар` | 38 | `item` | `household` | item |
| `спортинвентарь` | 38 | `item` | `sports` (велосипед → `bicycle` если ведётся учёт) | item |
| `садовый инвентарь` | 38 | `item` | `garden_tool` | item |
| `медикамент` | 38 | `item` | `medicine` | item |
| `документ` | 38 | `document` | — | content |
| `платёж` | 37 | `payment` | — | workflow |
| `стройматериал` | 31 | `item` | `construction` | item |
| `электроинструмент` | 25 | `item` | `power_tool` | item |
| `сантехника` | 23 | `item` | `plumbing` | item |
| `задача` | 23 | `task` | — | workflow |
| `семена` | 21 | `item` | `seeds` | item |
| `автопринадлежность` | 14 | `item` | `auto_accessory` | item |
| `организация` | 13 | `org` | — | сущность |
| `снаряжение` | 9 | `item` | `sports` (или `tourism` для outdoor) | item |
| `мотопринадлежность` | 9 | `item` | `moto_accessory` | item |
| `морское снаряжение` | 9 | `item` | `marine_gear` | item |
| `страница` | 7 | `page` | — | content |
| `объявление` | 7 | `listing` | — | workflow |
| `контакт` | 7 | `person` | — (различие через `participant {role:'contact'}`) | living |
| `расходник` | 6 | `item` | `consumable` | item |
| `заметка` | 6 | `note` | — | content |
| `саженец` | 5 | `item` | `sapling` | item |
| `рыболовное` | 5 | `item` | `fishing` | item |
| `периферия` | 5 | `item` | `peripheral` | item |
| `навигация` | 5 | **split** | `navigation` / device | item / device |
| `диагноз` | 5 | `diagnosis` | — | мед |
| `запись` | 4 | `log_entry` | — | content |
| `гаджет` | 4 | `device` | — | device |
| `аудио` | 4 | `item` | `audio` | item |
| `фото/видео` | 3 | `item` | `media_archive` (или `photography_gear` пер-айтем) | item |
| `тара` | 3 | `item` | `container` | item |
| `носитель` | 3 | `item` | `storage_media` | item |
| `компьютер` | 3 | `device` | — | device |
| `файл` | 2 | `file` | — | content |
| `туризм` | 2 | `item` | `tourism` | item |
| `субстрат` | 2 | `item` | `substrate` | item |
| `запчасть` | 2 | `item` | `auto_part` (по контексту) | item |
| `чанк` | 1 | `chunk` | — | content |
| `удобрение` | 1 | `item` | `fertilizer` | item |
| `событие` | 1 | `event` | — | workflow |
| `сеть` | 1 | `device` | — (`role='router'`) | device |
| `мотор` | 1 | `item` | `auto_part` (мотор катера) | item |
| `документ-семейство` | 1 | `document` | — (поле `is_family=true`) | content |
| `агрохимия` | 1 | `item` | `growth_regulator` (если Эпин) | item |
| `embedding` | 1 | `embedding` | — | content |

## Особые случаи: что разделяется

### `место` → 4 транспорта + 59 локаций

4 узла транспорта становятся `item` с категорией из иерархии `vehicle/*` и полями `vin`/`license_plate`/`brand`/`model`/`wikidata`:

```surql
-- было: CREATE thing:`moto_bmw` SET kind='место', name='BMW R1250GS'
-- стало:
CREATE thing:`moto_bmw` SET
  kind='item', category='motorcycle',
  brand='bmw', model='R 1250 GS',
  wikidata='Q57821567',
  name='BMW R 1250 GS';
```

- `car_vesta` → `item` + `category='car'` + `wikidata='Q17376334'`
- `boat_viking` → `item` + `category='boat'`
- `snowmobile_arctic` → `item` + `category='snowmobile'`

59 локаций (полки, шкафы, помещения, контейнеры внутри транспорта) → `kind='location'`.

«Все транспортные средства» — обход иерархии `category` через `part_of` концепт `vehicle`.

### `электроника` и `навигация` → `item` (большинство) + `device` (немногие)

Решение пер-узел: hostname/IP/WiFi-учётка → `device`, иначе → `item`. Список приложу при миграции.

### `документ-семейство` → `document` + флаг

```surql
-- было: CREATE thing:`reglament_to_bmw` SET kind='документ-семейство', version_policy='coexist'
-- стало:
CREATE thing:`reglament_to_bmw` SET
  kind='document', is_family=true, version_policy='coexist',
  name='Регламент ТО BMW';
```

Тот же state machine, что и у обычного документа; флаг — для версионирующей логики.

### `разное` → пер-айтем split

42 узла под `kind='разное'` — на самом деле смесь:
- фотоальбомы / VHS / CD-DVD / винил → `category='media_archive'` (~5–8 айтемов)
- старые игрушки в коробке → `toys` (если найдутся)
- канцелярка → `office`
- декорации/гирлянды → `decorations`
- остальное → `misc` (честно)

Конкретное распределение разберу пер-айтем при миграции и приложу мини-таблицу.

### `контакт` → `person` + роль

```surql
CREATE thing:`contact_mechanic_igor` SET kind='person', name='Игорь — моторист катера';
RELATE thing:`family_main`->participant->thing:`contact_mechanic_igor`
  SET role='contact', note='чинит мотор по звонку';
```

## Что добавляется (новые `kind`, не было в seed)

| Новый `kind` | Источник |
|---|---|
| `device` | сборка из гаджет/компьютер/сеть + split электроника/навигация |
| `location` | переименование `место` (без транспорта) |
| `animal` | новый класс (примеры: кот Murka) |
| `plant` | новый класс (примеры: грядка томатов) |
| `log_entry` | переименование `запись` |
| `listing` | переименование `объявление` |
| `diagnosis` | переименование `диагноз` |
| `vocabulary` | новый мета — SKOS-словари |
| `concept` | новый мета — термины |

**Не добавляются (несмотря на план в прошлом аудите):**
- `vehicle` — не прошёл тест (см. выше), сложен в `item + category`;
- `document_family` — не прошёл тест, сложен в `document + is_family`.

## Что не входит в этот аудит

- `kind`-значения, упоминаемые только в `docs/database.md` (нет узлов в seed): ~~`server`, `service`, `incident`, `event`, `chat`, `question`, `attempt`, `template`, `tag` — добавим при расширениях~~. **Поправка:** полный инвентарь database.md — 118 значений; строгий тест по ним прогнан в [`kind-audit-domains.md`](kind-audit-domains.md) → канон 27 → ~40.
- Поле `status` — отдельная миграция, после `kind`; станет `vocab:domovoy_status`.
- Bulk-импорт внешних словарей — лениво, по факту использования.

## Чек-лист миграции (после одобрения)

1. **seed.surql — основной массив (1004 узла)**:
   - заменить все `kind = 'X'` по таблице;
   - для `item`-узлов добавить `category` (slug);
   - для транспорта (4 узла из `место`): `category=motorcycle/car/boat/snowmobile`, поля `brand`/`model`/`vin`/`license_plate`/`wikidata`;
   - для `device`-узлов: `role` (workstation/tablet/phone/reader/router/iot), опц. `mac`/`hostname`/`wikidata`;
   - 13 узлов `контакт` → `person` + `participant {role:'contact'}`;
   - 1 узел `документ-семейство` → `document` + `is_family=true`;
   - шапку seed обновить.

2. **seed.surql — словари (новый блок в начале)**:
   - **Свои**: `vocab:domovoy_kind` (27 концептов), `vocab:domovoy_edge` (27), `vocab:domovoy_category` (~50 концептов с иерархией `part_of`), `vocab:domovoy_brand` (5 стартовых).
   - **Внешние стартовые**: `vocab:wikidata` (узел + ~20 концептов из таблицы), `vocab:iso_4217` (RUB+), `vocab:iso_639` (ru, en), `vocab:iana_mime` (по факту).
   - **Cross-links**: на каждом `concept` в `vocab:domovoy_category` поле `wikidata=Q...` (где есть).

3. **seed.surql — примеры living**:
   - `pet_murka` (`animal`, кошка, `wikidata='Q146'`) + `located_at`;
   - `tomato_bed_3` (`plant`, `wikidata='Q23501'`) + `located_at`;
   - 1 `appointment` для демонстрации reuse мед-паттерна.

4. **docs/relation-typing.md** — ASCII-`kind` + SKOS-унификация в примерах.

5. **docs/database.md** — точечно:
   - короткая таблица «4 класса бытия» и **тест на отдельный `kind`** в начало;
   - раздел «Внешние якоря: соглашение о полях»;
   - подменить русские `kind` в примерах кода (выборочно).

6. **scripts/generate_seed.py** — обновить генератор (отдельным коммитом).

Объём: ~1000 строк правок в seed, ~400 новых строк (словари + концепты + иерархия + living), ~150 строк правок в docs. Один проход.

## Открытые вопросы

> Сведены в [`decisions.md`](decisions.md) как D-01…D-09 — актуальные статусы и рекомендации там.

1. **`server` и `service`** — `server` → `device` с `role='server'` (рекомендация: схлопнуть).

2. **`book`** — `item` (как сейчас) или собственный `kind`? Тест: нет эксклюзивных рёбер, нет отдельного state machine. **Вердикт: `item` + `category='book'`**. Содержимое книги, если появится — отдельный `document` + `represents` к item-книге.

3. **`device`-кандидаты в `электроника` и `навигация`** — конкретный список приложу при миграции.

4. **`role` на `device`** — финальный список: `server`, `workstation`, `tablet`, `phone`, `reader`, `router`, `iot`, `appliance`. Дополнить?

5. **`animal`/`plant` примеры** — кошка + грядка томатов, или реальные твои?

6. **`tag`** — отдельный `kind` (рекомендация) или концепт в `vocab:domovoy_tag`?

7. **`wikidata` поле — на каждом узле?** Optional, заводим где есть Q-id. Денормализация для скорости; авторитет в графе через концепт.

8. **Стратегия материализации Wikidata-концептов** — лениво (рекомендация: поле `wikidata` достаточно для 95% запросов; материализуем `concept`-узел только при необходимости иерархии/URL).

9. **Иерархия категорий — глубина на старте.** Закладываем дерево (см. выше) или начинаем плоско? **Рекомендация: дерево для очевидных пар (`vehicle/*`, `tool/*`, `agrochemistry/*`, `garden_supplies/*`, `vehicle_supplies/*`), остальное плоско до плотности.**

## Резюме

> Введён **строгий тест** на отдельный `kind` (эксклюзивные рёбра / разный state machine / разная природа) и **пять принципов категоризации** (одна метка, workflow > химии, Wikidata за тебя, многомерность через теги, начинай широко). По этому тесту `vehicle` и `document_family` **не прошли** и сложены в `item + category` и `document + флаг`. Итог: 56 русских `kind` → **27** ASCII-канонических; **~65 концептов категорий** деревом по 9 кластерам (расходники, долговременные, электроника/медиа, инструменты, транспорт, дом/стройка, сад, спорт, общее); контролируемые перечисления унифицированы под SKOS (`vocabulary` + `concept`) без новых рёбер; внешние якоря (Wikidata Q-id, ISO коды, GTIN/ISBN/VIN/CVE/…) — денормализованные поля на узлах с парным концептом в графе; верифицированный стартовый набор Wikidata Q-id заложен сразу.

Жду одобрения и ответов на 9 вопросов — после этого миграция одним коммитом.
