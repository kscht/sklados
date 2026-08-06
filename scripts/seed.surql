-- Домовой: тестовый датасет — МИГРАЦИЯ ФАЗЫ 1 (канон kind = 41)
-- Перегенерирован: 2026-07-23 из seed 2026-05-19
-- kind: 56 кириллических → канон 41; категории проставлены из таблицы миграции (legacy_kind удалён)
-- статусы → слаги (status-audit.md); словари SKOS в начале файла; ~45 категорий с иерархией

-- ═══ СЛОВАРИ (SKOS: vocabulary + concept + part_of) ══════════════════════
-- Канон kind = 41 (docs/kind-audit-domains.md), статусы (docs/status-audit.md),
-- категории: ~45 концептов с иерархией (D-33 пересмотрен — dev-старт наполненный).

CREATE thing:`vocab_domovoy_kind` SET kind = 'vocabulary', identifier = 'domovoy_kind', source = 'internal', name = 'Типы узлов', _i18n = { ru: { label: 'Типы узлов' }, en: { label: 'Node kinds' } }, created_at = time::now();
CREATE thing:`kind_item` SET kind = 'concept', identifier = 'item', _i18n = { ru: { label: 'Вещь' }, en: { label: 'Item' } }, created_at = time::now();
RELATE thing:`kind_item`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_device` SET kind = 'concept', identifier = 'device', _i18n = { ru: { label: 'Устройство' }, en: { label: 'Device' } }, created_at = time::now();
RELATE thing:`kind_device`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_location` SET kind = 'concept', identifier = 'location', _i18n = { ru: { label: 'Место' }, en: { label: 'Location' } }, created_at = time::now();
RELATE thing:`kind_location`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_document` SET kind = 'concept', identifier = 'document', _i18n = { ru: { label: 'Документ' }, en: { label: 'Document' } }, created_at = time::now();
RELATE thing:`kind_document`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_file` SET kind = 'concept', identifier = 'file', _i18n = { ru: { label: 'Файл' }, en: { label: 'File' } }, created_at = time::now();
RELATE thing:`kind_file`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_chunk` SET kind = 'concept', identifier = 'chunk', _i18n = { ru: { label: 'Чанк' }, en: { label: 'Chunk' } }, created_at = time::now();
RELATE thing:`kind_chunk`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_embedding` SET kind = 'concept', identifier = 'embedding', _i18n = { ru: { label: 'Эмбеддинг' }, en: { label: 'Embedding' } }, created_at = time::now();
RELATE thing:`kind_embedding`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_note` SET kind = 'concept', identifier = 'note', _i18n = { ru: { label: 'Заметка' }, en: { label: 'Note' } }, created_at = time::now();
RELATE thing:`kind_note`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_page` SET kind = 'concept', identifier = 'page', _i18n = { ru: { label: 'Страница' }, en: { label: 'Page' } }, created_at = time::now();
RELATE thing:`kind_page`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_message` SET kind = 'concept', identifier = 'message', _i18n = { ru: { label: 'Сообщение' }, en: { label: 'Message' } }, created_at = time::now();
RELATE thing:`kind_message`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_log_entry` SET kind = 'concept', identifier = 'log_entry', _i18n = { ru: { label: 'Запись журнала' }, en: { label: 'Log entry' } }, created_at = time::now();
RELATE thing:`kind_log_entry`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_block` SET kind = 'concept', identifier = 'block', _i18n = { ru: { label: 'Блок' }, en: { label: 'Block' } }, created_at = time::now();
RELATE thing:`kind_block`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_person` SET kind = 'concept', identifier = 'person', _i18n = { ru: { label: 'Человек' }, en: { label: 'Person' } }, created_at = time::now();
RELATE thing:`kind_person`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_animal` SET kind = 'concept', identifier = 'animal', _i18n = { ru: { label: 'Животное' }, en: { label: 'Animal' } }, created_at = time::now();
RELATE thing:`kind_animal`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_plant` SET kind = 'concept', identifier = 'plant', _i18n = { ru: { label: 'Растение' }, en: { label: 'Plant' } }, created_at = time::now();
RELATE thing:`kind_plant`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_task` SET kind = 'concept', identifier = 'task', _i18n = { ru: { label: 'Задача' }, en: { label: 'Task' } }, created_at = time::now();
RELATE thing:`kind_task`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_appeal` SET kind = 'concept', identifier = 'appeal', _i18n = { ru: { label: 'Обращение' }, en: { label: 'Appeal' } }, created_at = time::now();
RELATE thing:`kind_appeal`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_payment` SET kind = 'concept', identifier = 'payment', _i18n = { ru: { label: 'Платёж' }, en: { label: 'Payment' } }, created_at = time::now();
RELATE thing:`kind_payment`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_event` SET kind = 'concept', identifier = 'event', _i18n = { ru: { label: 'Событие' }, en: { label: 'Event' } }, created_at = time::now();
RELATE thing:`kind_event`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_incident` SET kind = 'concept', identifier = 'incident', _i18n = { ru: { label: 'Инцидент' }, en: { label: 'Incident' } }, created_at = time::now();
RELATE thing:`kind_incident`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_listing` SET kind = 'concept', identifier = 'listing', _i18n = { ru: { label: 'Объявление' }, en: { label: 'Listing' } }, created_at = time::now();
RELATE thing:`kind_listing`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_diagnosis` SET kind = 'concept', identifier = 'diagnosis', _i18n = { ru: { label: 'Диагноз' }, en: { label: 'Diagnosis' } }, created_at = time::now();
RELATE thing:`kind_diagnosis`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_order` SET kind = 'concept', identifier = 'order', _i18n = { ru: { label: 'Заказ' }, en: { label: 'Order' } }, created_at = time::now();
RELATE thing:`kind_order`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_group` SET kind = 'concept', identifier = 'group', _i18n = { ru: { label: 'Группа' }, en: { label: 'Group' } }, created_at = time::now();
RELATE thing:`kind_group`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_org` SET kind = 'concept', identifier = 'org', _i18n = { ru: { label: 'Организация' }, en: { label: 'Organization' } }, created_at = time::now();
RELATE thing:`kind_org`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_template` SET kind = 'concept', identifier = 'template', _i18n = { ru: { label: 'Шаблон' }, en: { label: 'Template' } }, created_at = time::now();
RELATE thing:`kind_template`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_tag` SET kind = 'concept', identifier = 'tag', _i18n = { ru: { label: 'Тег' }, en: { label: 'Tag' } }, created_at = time::now();
RELATE thing:`kind_tag`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_vocabulary` SET kind = 'concept', identifier = 'vocabulary', _i18n = { ru: { label: 'Словарь' }, en: { label: 'Vocabulary' } }, created_at = time::now();
RELATE thing:`kind_vocabulary`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_concept` SET kind = 'concept', identifier = 'concept', _i18n = { ru: { label: 'Концепт' }, en: { label: 'Concept' } }, created_at = time::now();
RELATE thing:`kind_concept`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_job` SET kind = 'concept', identifier = 'job', _i18n = { ru: { label: 'Задание' }, en: { label: 'Job' } }, created_at = time::now();
RELATE thing:`kind_job`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_rule` SET kind = 'concept', identifier = 'rule', _i18n = { ru: { label: 'Правило' }, en: { label: 'Rule' } }, created_at = time::now();
RELATE thing:`kind_rule`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_worker` SET kind = 'concept', identifier = 'worker', _i18n = { ru: { label: 'Воркер' }, en: { label: 'Worker' } }, created_at = time::now();
RELATE thing:`kind_worker`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_datasource` SET kind = 'concept', identifier = 'datasource', _i18n = { ru: { label: 'Источник данных' }, en: { label: 'Data source' } }, created_at = time::now();
RELATE thing:`kind_datasource`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_gateway` SET kind = 'concept', identifier = 'gateway', _i18n = { ru: { label: 'Шлюз' }, en: { label: 'Gateway' } }, created_at = time::now();
RELATE thing:`kind_gateway`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_agent` SET kind = 'concept', identifier = 'agent', _i18n = { ru: { label: 'Агент' }, en: { label: 'Agent' } }, created_at = time::now();
RELATE thing:`kind_agent`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_service` SET kind = 'concept', identifier = 'service', _i18n = { ru: { label: 'Сервис' }, en: { label: 'Service' } }, created_at = time::now();
RELATE thing:`kind_service`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_chat` SET kind = 'concept', identifier = 'chat', _i18n = { ru: { label: 'Чат' }, en: { label: 'Chat' } }, created_at = time::now();
RELATE thing:`kind_chat`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_step` SET kind = 'concept', identifier = 'step', _i18n = { ru: { label: 'Шаг' }, en: { label: 'Step' } }, created_at = time::now();
RELATE thing:`kind_step`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_view` SET kind = 'concept', identifier = 'view', _i18n = { ru: { label: 'Вид' }, en: { label: 'View' } }, created_at = time::now();
RELATE thing:`kind_view`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_question` SET kind = 'concept', identifier = 'question', _i18n = { ru: { label: 'Вопрос' }, en: { label: 'Question' } }, created_at = time::now();
RELATE thing:`kind_question`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`kind_attempt` SET kind = 'concept', identifier = 'attempt', _i18n = { ru: { label: 'Попытка' }, en: { label: 'Attempt' } }, created_at = time::now();
RELATE thing:`kind_attempt`->part_of->thing:`vocab_domovoy_kind`;

CREATE thing:`vocab_domovoy_edge` SET kind = 'vocabulary', identifier = 'domovoy_edge', source = 'internal', name = 'Типы рёбер', _i18n = { ru: { label: 'Типы рёбер' }, en: { label: 'Edge types' } }, created_at = time::now();
CREATE thing:`edge_contains` SET kind = 'concept', identifier = 'contains', _i18n = { ru: { label: 'Содержит' }, en: { label: 'Contains' } }, created_at = time::now();
RELATE thing:`edge_contains`->part_of->thing:`vocab_domovoy_edge`;
CREATE thing:`edge_part_of` SET kind = 'concept', identifier = 'part_of', _i18n = { ru: { label: 'Часть' }, en: { label: 'Part of' } }, created_at = time::now();
RELATE thing:`edge_part_of`->part_of->thing:`vocab_domovoy_edge`;
CREATE thing:`edge_assigned_to` SET kind = 'concept', identifier = 'assigned_to', _i18n = { ru: { label: 'Ответственный' }, en: { label: 'Assigned to' } }, created_at = time::now();
RELATE thing:`edge_assigned_to`->part_of->thing:`vocab_domovoy_edge`;
CREATE thing:`edge_depends_on` SET kind = 'concept', identifier = 'depends_on', _i18n = { ru: { label: 'Зависит от' }, en: { label: 'Depends on' } }, created_at = time::now();
RELATE thing:`edge_depends_on`->part_of->thing:`vocab_domovoy_edge`;
CREATE thing:`edge_about` SET kind = 'concept', identifier = 'about', _i18n = { ru: { label: 'Касается' }, en: { label: 'About' } }, created_at = time::now();
RELATE thing:`edge_about`->part_of->thing:`vocab_domovoy_edge`;
CREATE thing:`edge_filed_with` SET kind = 'concept', identifier = 'filed_with', _i18n = { ru: { label: 'Подано в' }, en: { label: 'Filed with' } }, created_at = time::now();
RELATE thing:`edge_filed_with`->part_of->thing:`vocab_domovoy_edge`;
CREATE thing:`edge_needs` SET kind = 'concept', identifier = 'needs', _i18n = { ru: { label: 'Нужно купить' }, en: { label: 'Needs' } }, created_at = time::now();
RELATE thing:`edge_needs`->part_of->thing:`vocab_domovoy_edge`;
CREATE thing:`edge_requires` SET kind = 'concept', identifier = 'requires', _i18n = { ru: { label: 'Требует' }, en: { label: 'Requires' } }, created_at = time::now();
RELATE thing:`edge_requires`->part_of->thing:`vocab_domovoy_edge`;
CREATE thing:`edge_produces` SET kind = 'concept', identifier = 'produces', _i18n = { ru: { label: 'Производит' }, en: { label: 'Produces' } }, created_at = time::now();
RELATE thing:`edge_produces`->part_of->thing:`vocab_domovoy_edge`;
CREATE thing:`edge_used` SET kind = 'concept', identifier = 'used', _i18n = { ru: { label: 'Израсходовано' }, en: { label: 'Used' } }, created_at = time::now();
RELATE thing:`edge_used`->part_of->thing:`vocab_domovoy_edge`;
CREATE thing:`edge_participant` SET kind = 'concept', identifier = 'participant', _i18n = { ru: { label: 'Участник' }, en: { label: 'Participant' } }, created_at = time::now();
RELATE thing:`edge_participant`->part_of->thing:`vocab_domovoy_edge`;
CREATE thing:`edge_located_at` SET kind = 'concept', identifier = 'located_at', _i18n = { ru: { label: 'Находится в' }, en: { label: 'Located at' } }, created_at = time::now();
RELATE thing:`edge_located_at`->part_of->thing:`vocab_domovoy_edge`;
CREATE thing:`edge_lent_to` SET kind = 'concept', identifier = 'lent_to', _i18n = { ru: { label: 'Одолжено' }, en: { label: 'Lent to' } }, created_at = time::now();
RELATE thing:`edge_lent_to`->part_of->thing:`vocab_domovoy_edge`;
CREATE thing:`edge_borrowed_from` SET kind = 'concept', identifier = 'borrowed_from', _i18n = { ru: { label: 'Взято у' }, en: { label: 'Borrowed from' } }, created_at = time::now();
RELATE thing:`edge_borrowed_from`->part_of->thing:`vocab_domovoy_edge`;
CREATE thing:`edge_triggered_by` SET kind = 'concept', identifier = 'triggered_by', _i18n = { ru: { label: 'Активируется' }, en: { label: 'Triggered by' } }, created_at = time::now();
RELATE thing:`edge_triggered_by`->part_of->thing:`vocab_domovoy_edge`;
CREATE thing:`edge_expert_in` SET kind = 'concept', identifier = 'expert_in', _i18n = { ru: { label: 'Эксперт в' }, en: { label: 'Expert in' } }, created_at = time::now();
RELATE thing:`edge_expert_in`->part_of->thing:`vocab_domovoy_edge`;
CREATE thing:`edge_answered` SET kind = 'concept', identifier = 'answered', _i18n = { ru: { label: 'Ответ на' }, en: { label: 'Answered' } }, created_at = time::now();
RELATE thing:`edge_answered`->part_of->thing:`vocab_domovoy_edge`;
CREATE thing:`edge_promised_to` SET kind = 'concept', identifier = 'promised_to', _i18n = { ru: { label: 'Обещано' }, en: { label: 'Promised to' } }, created_at = time::now();
RELATE thing:`edge_promised_to`->part_of->thing:`vocab_domovoy_edge`;
CREATE thing:`edge_represents` SET kind = 'concept', identifier = 'represents', _i18n = { ru: { label: 'Представляет' }, en: { label: 'Represents' } }, created_at = time::now();
RELATE thing:`edge_represents`->part_of->thing:`vocab_domovoy_edge`;
CREATE thing:`edge_can_access` SET kind = 'concept', identifier = 'can_access', _i18n = { ru: { label: 'Доступ' }, en: { label: 'Can access' } }, created_at = time::now();
RELATE thing:`edge_can_access`->part_of->thing:`vocab_domovoy_edge`;
CREATE thing:`edge_related_to` SET kind = 'concept', identifier = 'related_to', _i18n = { ru: { label: 'Связано с' }, en: { label: 'Related to' } }, created_at = time::now();
RELATE thing:`edge_related_to`->part_of->thing:`vocab_domovoy_edge`;
CREATE thing:`edge_references` SET kind = 'concept', identifier = 'references', _i18n = { ru: { label: 'Ссылается на' }, en: { label: 'References' } }, created_at = time::now();
RELATE thing:`edge_references`->part_of->thing:`vocab_domovoy_edge`;
CREATE thing:`edge_identified_by` SET kind = 'concept', identifier = 'identified_by', _i18n = { ru: { label: 'Идентифицируется' }, en: { label: 'Identified by' } }, created_at = time::now();
RELATE thing:`edge_identified_by`->part_of->thing:`vocab_domovoy_edge`;
CREATE thing:`edge_linked_to` SET kind = 'concept', identifier = 'linked_to', _i18n = { ru: { label: 'Сетевой линк' }, en: { label: 'Linked to' } }, created_at = time::now();
RELATE thing:`edge_linked_to`->part_of->thing:`vocab_domovoy_edge`;
CREATE thing:`edge_invalidates` SET kind = 'concept', identifier = 'invalidates', _i18n = { ru: { label: 'Инвалидирует' }, en: { label: 'Invalidates' } }, created_at = time::now();
RELATE thing:`edge_invalidates`->part_of->thing:`vocab_domovoy_edge`;
CREATE thing:`edge_supersedes` SET kind = 'concept', identifier = 'supersedes', _i18n = { ru: { label: 'Заменяет' }, en: { label: 'Supersedes' } }, created_at = time::now();
RELATE thing:`edge_supersedes`->part_of->thing:`vocab_domovoy_edge`;
CREATE thing:`edge_derived_from` SET kind = 'concept', identifier = 'derived_from', _i18n = { ru: { label: 'Получено из' }, en: { label: 'Derived from' } }, created_at = time::now();
RELATE thing:`edge_derived_from`->part_of->thing:`vocab_domovoy_edge`;

CREATE thing:`vocab_domovoy_status` SET kind = 'vocabulary', identifier = 'domovoy_status', source = 'internal', name = 'Статусы', _i18n = { ru: { label: 'Статусы' }, en: { label: 'Statuses' } }, created_at = time::now();
CREATE thing:`status_set_task` SET kind = 'concept', identifier = 'status_set_task', _i18n = { ru: { label: 'Статусы: task' }, en: { label: 'Statuses: task' } }, created_at = time::now();
RELATE thing:`status_set_task`->part_of->thing:`vocab_domovoy_status`;
CREATE thing:`status_set_job` SET kind = 'concept', identifier = 'status_set_job', _i18n = { ru: { label: 'Статусы: job' }, en: { label: 'Statuses: job' } }, created_at = time::now();
RELATE thing:`status_set_job`->part_of->thing:`vocab_domovoy_status`;
CREATE thing:`status_set_worker` SET kind = 'concept', identifier = 'status_set_worker', _i18n = { ru: { label: 'Статусы: worker' }, en: { label: 'Statuses: worker' } }, created_at = time::now();
RELATE thing:`status_set_worker`->part_of->thing:`vocab_domovoy_status`;
CREATE thing:`status_set_order` SET kind = 'concept', identifier = 'status_set_order', _i18n = { ru: { label: 'Статусы: order' }, en: { label: 'Statuses: order' } }, created_at = time::now();
RELATE thing:`status_set_order`->part_of->thing:`vocab_domovoy_status`;
CREATE thing:`status_set_order_return` SET kind = 'concept', identifier = 'status_set_order_return', _i18n = { ru: { label: 'Статусы: order_return' }, en: { label: 'Statuses: order_return' } }, created_at = time::now();
RELATE thing:`status_set_order_return`->part_of->thing:`vocab_domovoy_status`;
CREATE thing:`status_set_payment` SET kind = 'concept', identifier = 'status_set_payment', _i18n = { ru: { label: 'Статусы: payment' }, en: { label: 'Statuses: payment' } }, created_at = time::now();
RELATE thing:`status_set_payment`->part_of->thing:`vocab_domovoy_status`;
CREATE thing:`status_set_delivery` SET kind = 'concept', identifier = 'status_set_delivery', _i18n = { ru: { label: 'Статусы: delivery' }, en: { label: 'Statuses: delivery' } }, created_at = time::now();
RELATE thing:`status_set_delivery`->part_of->thing:`vocab_domovoy_status`;
CREATE thing:`status_set_listing` SET kind = 'concept', identifier = 'status_set_listing', _i18n = { ru: { label: 'Статусы: listing' }, en: { label: 'Statuses: listing' } }, created_at = time::now();
RELATE thing:`status_set_listing`->part_of->thing:`vocab_domovoy_status`;
CREATE thing:`status_set_incident` SET kind = 'concept', identifier = 'status_set_incident', _i18n = { ru: { label: 'Статусы: incident' }, en: { label: 'Statuses: incident' } }, created_at = time::now();
RELATE thing:`status_set_incident`->part_of->thing:`vocab_domovoy_status`;
CREATE thing:`status_set_appeal` SET kind = 'concept', identifier = 'status_set_appeal', _i18n = { ru: { label: 'Статусы: appeal' }, en: { label: 'Statuses: appeal' } }, created_at = time::now();
RELATE thing:`status_set_appeal`->part_of->thing:`vocab_domovoy_status`;
CREATE thing:`status_set_attempt` SET kind = 'concept', identifier = 'status_set_attempt', _i18n = { ru: { label: 'Статусы: attempt' }, en: { label: 'Statuses: attempt' } }, created_at = time::now();
RELATE thing:`status_set_attempt`->part_of->thing:`vocab_domovoy_status`;
CREATE thing:`status_set_rule_breaker` SET kind = 'concept', identifier = 'status_set_rule_breaker', _i18n = { ru: { label: 'Статусы: rule_breaker' }, en: { label: 'Statuses: rule_breaker' } }, created_at = time::now();
RELATE thing:`status_set_rule_breaker`->part_of->thing:`vocab_domovoy_status`;
CREATE thing:`status_set_content` SET kind = 'concept', identifier = 'status_set_content', _i18n = { ru: { label: 'Статусы: content' }, en: { label: 'Statuses: content' } }, created_at = time::now();
RELATE thing:`status_set_content`->part_of->thing:`vocab_domovoy_status`;
CREATE thing:`status_set_event` SET kind = 'concept', identifier = 'status_set_event', _i18n = { ru: { label: 'Статусы: event' }, en: { label: 'Statuses: event' } }, created_at = time::now();
RELATE thing:`status_set_event`->part_of->thing:`vocab_domovoy_status`;
CREATE thing:`status_set_notification` SET kind = 'concept', identifier = 'status_set_notification', _i18n = { ru: { label: 'Статусы: notification' }, en: { label: 'Statuses: notification' } }, created_at = time::now();
RELATE thing:`status_set_notification`->part_of->thing:`vocab_domovoy_status`;
CREATE thing:`status_set_promise` SET kind = 'concept', identifier = 'status_set_promise', _i18n = { ru: { label: 'Статусы: promise' }, en: { label: 'Statuses: promise' } }, created_at = time::now();
RELATE thing:`status_set_promise`->part_of->thing:`vocab_domovoy_status`;
CREATE thing:`status_set_diagnosis` SET kind = 'concept', identifier = 'status_set_diagnosis', _i18n = { ru: { label: 'Статусы: diagnosis' }, en: { label: 'Statuses: diagnosis' } }, created_at = time::now();
RELATE thing:`status_set_diagnosis`->part_of->thing:`vocab_domovoy_status`;
CREATE thing:`status_not_started` SET kind = 'concept', identifier = 'not_started', color = 'gray', _i18n = { ru: { label: 'Не начато' }, en: { label: 'Not started' } }, created_at = time::now();
RELATE thing:`status_not_started`->part_of->thing:`status_set_task` SET order = 1;
CREATE thing:`status_in_progress` SET kind = 'concept', identifier = 'in_progress', color = 'blue', _i18n = { ru: { label: 'В процессе' }, en: { label: 'In progress' } }, created_at = time::now();
RELATE thing:`status_in_progress`->part_of->thing:`status_set_task` SET order = 2;
CREATE thing:`status_waiting` SET kind = 'concept', identifier = 'waiting', color = 'amber', _i18n = { ru: { label: 'Ожидает' }, en: { label: 'Waiting' } }, created_at = time::now();
RELATE thing:`status_waiting`->part_of->thing:`status_set_task` SET order = 3;
CREATE thing:`status_paused` SET kind = 'concept', identifier = 'paused', color = 'amber', _i18n = { ru: { label: 'На паузе' }, en: { label: 'Paused' } }, created_at = time::now();
RELATE thing:`status_paused`->part_of->thing:`status_set_task` SET order = 4;
CREATE thing:`status_done` SET kind = 'concept', identifier = 'done', color = 'green', _i18n = { ru: { label: 'Выполнено' }, en: { label: 'Done' } }, created_at = time::now();
RELATE thing:`status_done`->part_of->thing:`status_set_task` SET order = 5;
CREATE thing:`status_cancelled` SET kind = 'concept', identifier = 'cancelled', color = 'red', _i18n = { ru: { label: 'Отменено' }, en: { label: 'Cancelled' } }, created_at = time::now();
RELATE thing:`status_cancelled`->part_of->thing:`status_set_task` SET order = 6;
CREATE thing:`status_queued` SET kind = 'concept', identifier = 'queued', color = 'gray', _i18n = { ru: { label: 'В очереди' }, en: { label: 'Queued' } }, created_at = time::now();
RELATE thing:`status_queued`->part_of->thing:`status_set_job` SET order = 1;
CREATE thing:`status_running` SET kind = 'concept', identifier = 'running', color = 'blue', _i18n = { ru: { label: 'Выполняется' }, en: { label: 'Running' } }, created_at = time::now();
RELATE thing:`status_running`->part_of->thing:`status_set_job` SET order = 2;
RELATE thing:`status_done`->part_of->thing:`status_set_job` SET order = 3;
CREATE thing:`status_failed` SET kind = 'concept', identifier = 'failed', color = 'red', _i18n = { ru: { label: 'Ошибка' }, en: { label: 'Failed' } }, created_at = time::now();
RELATE thing:`status_failed`->part_of->thing:`status_set_job` SET order = 4;
RELATE thing:`status_cancelled`->part_of->thing:`status_set_job` SET order = 5;
CREATE thing:`status_skipped` SET kind = 'concept', identifier = 'skipped', color = 'gray', _i18n = { ru: { label: 'Пропущено' }, en: { label: 'Skipped' } }, created_at = time::now();
RELATE thing:`status_skipped`->part_of->thing:`status_set_job` SET order = 6;
CREATE thing:`status_active` SET kind = 'concept', identifier = 'active', color = 'green', _i18n = { ru: { label: 'Активно' }, en: { label: 'Active' } }, created_at = time::now();
RELATE thing:`status_active`->part_of->thing:`status_set_worker` SET order = 1;
CREATE thing:`status_draining` SET kind = 'concept', identifier = 'draining', color = 'amber', _i18n = { ru: { label: 'Завершает' }, en: { label: 'Draining' } }, created_at = time::now();
RELATE thing:`status_draining`->part_of->thing:`status_set_worker` SET order = 2;
CREATE thing:`status_dead` SET kind = 'concept', identifier = 'dead', color = 'red', _i18n = { ru: { label: 'Мёртв' }, en: { label: 'Dead' } }, created_at = time::now();
RELATE thing:`status_dead`->part_of->thing:`status_set_worker` SET order = 3;
CREATE thing:`status_new` SET kind = 'concept', identifier = 'new', color = 'gray', _i18n = { ru: { label: 'Новый' }, en: { label: 'New' } }, created_at = time::now();
RELATE thing:`status_new`->part_of->thing:`status_set_order` SET order = 1;
CREATE thing:`status_confirmed` SET kind = 'concept', identifier = 'confirmed', color = 'blue', _i18n = { ru: { label: 'Подтверждён' }, en: { label: 'Confirmed' } }, created_at = time::now();
RELATE thing:`status_confirmed`->part_of->thing:`status_set_order` SET order = 2;
CREATE thing:`status_paid` SET kind = 'concept', identifier = 'paid', color = 'green', _i18n = { ru: { label: 'Оплачено' }, en: { label: 'Paid' } }, created_at = time::now();
RELATE thing:`status_paid`->part_of->thing:`status_set_order` SET order = 3;
CREATE thing:`status_picking` SET kind = 'concept', identifier = 'picking', color = 'blue', _i18n = { ru: { label: 'Собирается' }, en: { label: 'Picking' } }, created_at = time::now();
RELATE thing:`status_picking`->part_of->thing:`status_set_order` SET order = 4;
CREATE thing:`status_ready` SET kind = 'concept', identifier = 'ready', color = 'blue', _i18n = { ru: { label: 'Готов' }, en: { label: 'Ready' } }, created_at = time::now();
RELATE thing:`status_ready`->part_of->thing:`status_set_order` SET order = 5;
CREATE thing:`status_shipped` SET kind = 'concept', identifier = 'shipped', color = 'blue', _i18n = { ru: { label: 'Отправлен' }, en: { label: 'Shipped' } }, created_at = time::now();
RELATE thing:`status_shipped`->part_of->thing:`status_set_order` SET order = 6;
CREATE thing:`status_delivered` SET kind = 'concept', identifier = 'delivered', color = 'green', _i18n = { ru: { label: 'Доставлен' }, en: { label: 'Delivered' } }, created_at = time::now();
RELATE thing:`status_delivered`->part_of->thing:`status_set_order` SET order = 7;
RELATE thing:`status_done`->part_of->thing:`status_set_order` SET order = 8;
RELATE thing:`status_cancelled`->part_of->thing:`status_set_order` SET order = 9;
CREATE thing:`status_requested` SET kind = 'concept', identifier = 'requested', color = 'gray', _i18n = { ru: { label: 'Запрошен' }, en: { label: 'Requested' } }, created_at = time::now();
RELATE thing:`status_requested`->part_of->thing:`status_set_order_return` SET order = 1;
CREATE thing:`status_approved` SET kind = 'concept', identifier = 'approved', color = 'green', _i18n = { ru: { label: 'Одобрено' }, en: { label: 'Approved' } }, created_at = time::now();
RELATE thing:`status_approved`->part_of->thing:`status_set_order_return` SET order = 2;
CREATE thing:`status_received` SET kind = 'concept', identifier = 'received', color = 'green', _i18n = { ru: { label: 'Получено' }, en: { label: 'Received' } }, created_at = time::now();
RELATE thing:`status_received`->part_of->thing:`status_set_order_return` SET order = 3;
CREATE thing:`status_refunded` SET kind = 'concept', identifier = 'refunded', color = 'purple', _i18n = { ru: { label: 'Возвращено' }, en: { label: 'Refunded' } }, created_at = time::now();
RELATE thing:`status_refunded`->part_of->thing:`status_set_order_return` SET order = 4;
CREATE thing:`status_rejected` SET kind = 'concept', identifier = 'rejected', color = 'red', _i18n = { ru: { label: 'Отклонено' }, en: { label: 'Rejected' } }, created_at = time::now();
RELATE thing:`status_rejected`->part_of->thing:`status_set_order_return` SET order = 5;
CREATE thing:`status_pending` SET kind = 'concept', identifier = 'pending', color = 'amber', _i18n = { ru: { label: 'Ожидается' }, en: { label: 'Pending' } }, created_at = time::now();
RELATE thing:`status_pending`->part_of->thing:`status_set_payment` SET order = 1;
RELATE thing:`status_paid`->part_of->thing:`status_set_payment` SET order = 2;
RELATE thing:`status_failed`->part_of->thing:`status_set_payment` SET order = 3;
RELATE thing:`status_refunded`->part_of->thing:`status_set_payment` SET order = 4;
RELATE thing:`status_new`->part_of->thing:`status_set_delivery` SET order = 1;
CREATE thing:`status_in_transit` SET kind = 'concept', identifier = 'in_transit', color = 'blue', _i18n = { ru: { label: 'В пути' }, en: { label: 'In transit' } }, created_at = time::now();
RELATE thing:`status_in_transit`->part_of->thing:`status_set_delivery` SET order = 2;
CREATE thing:`status_customs` SET kind = 'concept', identifier = 'customs', color = 'amber', _i18n = { ru: { label: 'На таможне' }, en: { label: 'At customs' } }, created_at = time::now();
RELATE thing:`status_customs`->part_of->thing:`status_set_delivery` SET order = 3;
RELATE thing:`status_delivered`->part_of->thing:`status_set_delivery` SET order = 4;
CREATE thing:`status_undelivered` SET kind = 'concept', identifier = 'undelivered', color = 'red', _i18n = { ru: { label: 'Не доставлено' }, en: { label: 'Undelivered' } }, created_at = time::now();
RELATE thing:`status_undelivered`->part_of->thing:`status_set_delivery` SET order = 5;
CREATE thing:`status_returned` SET kind = 'concept', identifier = 'returned', color = 'purple', _i18n = { ru: { label: 'Возврат' }, en: { label: 'Returned' } }, created_at = time::now();
RELATE thing:`status_returned`->part_of->thing:`status_set_delivery` SET order = 6;
RELATE thing:`status_active`->part_of->thing:`status_set_listing` SET order = 1;
CREATE thing:`status_sold_out` SET kind = 'concept', identifier = 'sold_out', color = 'gray', _i18n = { ru: { label: 'Распродано' }, en: { label: 'Sold out' } }, created_at = time::now();
RELATE thing:`status_sold_out`->part_of->thing:`status_set_listing` SET order = 2;
CREATE thing:`status_withdrawn` SET kind = 'concept', identifier = 'withdrawn', color = 'gray', _i18n = { ru: { label: 'Снято' }, en: { label: 'Withdrawn' } }, created_at = time::now();
RELATE thing:`status_withdrawn`->part_of->thing:`status_set_listing` SET order = 3;
CREATE thing:`status_reported` SET kind = 'concept', identifier = 'reported', color = 'red', _i18n = { ru: { label: 'Зарегистрирован' }, en: { label: 'Reported' } }, created_at = time::now();
RELATE thing:`status_reported`->part_of->thing:`status_set_incident` SET order = 1;
CREATE thing:`status_triage` SET kind = 'concept', identifier = 'triage', color = 'amber', _i18n = { ru: { label: 'Разбор' }, en: { label: 'Triage' } }, created_at = time::now();
RELATE thing:`status_triage`->part_of->thing:`status_set_incident` SET order = 2;
CREATE thing:`status_mitigating` SET kind = 'concept', identifier = 'mitigating', color = 'blue', _i18n = { ru: { label: 'Устранение' }, en: { label: 'Mitigating' } }, created_at = time::now();
RELATE thing:`status_mitigating`->part_of->thing:`status_set_incident` SET order = 3;
CREATE thing:`status_resolved` SET kind = 'concept', identifier = 'resolved', color = 'green', _i18n = { ru: { label: 'Решено' }, en: { label: 'Resolved' } }, created_at = time::now();
RELATE thing:`status_resolved`->part_of->thing:`status_set_incident` SET order = 4;
CREATE thing:`status_post_mortem` SET kind = 'concept', identifier = 'post_mortem', color = 'purple', _i18n = { ru: { label: 'Post-mortem' }, en: { label: 'Post-mortem' } }, created_at = time::now();
RELATE thing:`status_post_mortem`->part_of->thing:`status_set_incident` SET order = 5;
CREATE thing:`status_filed` SET kind = 'concept', identifier = 'filed', color = 'gray', _i18n = { ru: { label: 'Подано' }, en: { label: 'Filed' } }, created_at = time::now();
RELATE thing:`status_filed`->part_of->thing:`status_set_appeal` SET order = 1;
CREATE thing:`status_review` SET kind = 'concept', identifier = 'review', color = 'blue', _i18n = { ru: { label: 'Рассмотрение' }, en: { label: 'In review' } }, created_at = time::now();
RELATE thing:`status_review`->part_of->thing:`status_set_appeal` SET order = 2;
CREATE thing:`status_decided` SET kind = 'concept', identifier = 'decided', color = 'green', _i18n = { ru: { label: 'Решено' }, en: { label: 'Decided' } }, created_at = time::now();
RELATE thing:`status_decided`->part_of->thing:`status_set_appeal` SET order = 3;
CREATE thing:`status_appealed` SET kind = 'concept', identifier = 'appealed', color = 'purple', _i18n = { ru: { label: 'Обжаловано' }, en: { label: 'Appealed' } }, created_at = time::now();
RELATE thing:`status_appealed`->part_of->thing:`status_set_appeal` SET order = 4;
RELATE thing:`status_in_progress`->part_of->thing:`status_set_attempt` SET order = 1;
CREATE thing:`status_passed` SET kind = 'concept', identifier = 'passed', color = 'green', _i18n = { ru: { label: 'Сдано' }, en: { label: 'Passed' } }, created_at = time::now();
RELATE thing:`status_passed`->part_of->thing:`status_set_attempt` SET order = 2;
RELATE thing:`status_failed`->part_of->thing:`status_set_attempt` SET order = 3;
CREATE thing:`status_abandoned` SET kind = 'concept', identifier = 'abandoned', color = 'gray', _i18n = { ru: { label: 'Прервано' }, en: { label: 'Abandoned' } }, created_at = time::now();
RELATE thing:`status_abandoned`->part_of->thing:`status_set_attempt` SET order = 4;
CREATE thing:`status_closed` SET kind = 'concept', identifier = 'closed', color = 'green', _i18n = { ru: { label: 'Закрыт' }, en: { label: 'Closed' } }, created_at = time::now();
RELATE thing:`status_closed`->part_of->thing:`status_set_rule_breaker` SET order = 1;
CREATE thing:`status_open` SET kind = 'concept', identifier = 'open', color = 'red', _i18n = { ru: { label: 'Открыт' }, en: { label: 'Open' } }, created_at = time::now();
RELATE thing:`status_open`->part_of->thing:`status_set_rule_breaker` SET order = 2;
CREATE thing:`status_half_open` SET kind = 'concept', identifier = 'half_open', color = 'amber', _i18n = { ru: { label: 'Полуоткрыт' }, en: { label: 'Half-open' } }, created_at = time::now();
RELATE thing:`status_half_open`->part_of->thing:`status_set_rule_breaker` SET order = 3;
CREATE thing:`status_draft` SET kind = 'concept', identifier = 'draft', color = 'gray', _i18n = { ru: { label: 'Черновик' }, en: { label: 'Draft' } }, created_at = time::now();
RELATE thing:`status_draft`->part_of->thing:`status_set_content` SET order = 1;
CREATE thing:`status_in_review` SET kind = 'concept', identifier = 'in_review', color = 'amber', _i18n = { ru: { label: 'На согласовании' }, en: { label: 'In review' } }, created_at = time::now();
RELATE thing:`status_in_review`->part_of->thing:`status_set_content` SET order = 2;
RELATE thing:`status_approved`->part_of->thing:`status_set_content` SET order = 3;
CREATE thing:`status_published` SET kind = 'concept', identifier = 'published', color = 'green', _i18n = { ru: { label: 'Опубликовано' }, en: { label: 'Published' } }, created_at = time::now();
RELATE thing:`status_published`->part_of->thing:`status_set_content` SET order = 4;
CREATE thing:`status_archived` SET kind = 'concept', identifier = 'archived', color = 'gray', _i18n = { ru: { label: 'В архиве' }, en: { label: 'Archived' } }, created_at = time::now();
RELATE thing:`status_archived`->part_of->thing:`status_set_content` SET order = 5;
CREATE thing:`status_revoked` SET kind = 'concept', identifier = 'revoked', color = 'red', _i18n = { ru: { label: 'Аннулирован' }, en: { label: 'Revoked' } }, created_at = time::now();
RELATE thing:`status_revoked`->part_of->thing:`status_set_content` SET order = 6;
CREATE thing:`status_planned` SET kind = 'concept', identifier = 'planned', color = 'gray', _i18n = { ru: { label: 'Запланировано' }, en: { label: 'Planned' } }, created_at = time::now();
RELATE thing:`status_planned`->part_of->thing:`status_set_event` SET order = 1;
RELATE thing:`status_active`->part_of->thing:`status_set_event` SET order = 2;
RELATE thing:`status_done`->part_of->thing:`status_set_event` SET order = 3;
RELATE thing:`status_cancelled`->part_of->thing:`status_set_event` SET order = 4;
RELATE thing:`status_queued`->part_of->thing:`status_set_notification` SET order = 1;
CREATE thing:`status_sent` SET kind = 'concept', identifier = 'sent', color = 'green', _i18n = { ru: { label: 'Отправлено' }, en: { label: 'Sent' } }, created_at = time::now();
RELATE thing:`status_sent`->part_of->thing:`status_set_notification` SET order = 2;
RELATE thing:`status_failed`->part_of->thing:`status_set_notification` SET order = 3;
CREATE thing:`status_read` SET kind = 'concept', identifier = 'read', color = 'green', _i18n = { ru: { label: 'Прочитано' }, en: { label: 'Read' } }, created_at = time::now();
RELATE thing:`status_read`->part_of->thing:`status_set_notification` SET order = 4;
RELATE thing:`status_pending`->part_of->thing:`status_set_promise` SET order = 1;
CREATE thing:`status_kept` SET kind = 'concept', identifier = 'kept', color = 'green', _i18n = { ru: { label: 'Выполнено' }, en: { label: 'Kept' } }, created_at = time::now();
RELATE thing:`status_kept`->part_of->thing:`status_set_promise` SET order = 2;
CREATE thing:`status_broken` SET kind = 'concept', identifier = 'broken', color = 'red', _i18n = { ru: { label: 'Нарушено' }, en: { label: 'Broken' } }, created_at = time::now();
RELATE thing:`status_broken`->part_of->thing:`status_set_promise` SET order = 3;
CREATE thing:`status_recorded` SET kind = 'concept', identifier = 'recorded', color = 'gray', _i18n = { ru: { label: 'Зафиксирован' }, en: { label: 'Recorded' } }, created_at = time::now();
RELATE thing:`status_recorded`->part_of->thing:`status_set_diagnosis` SET order = 1;
CREATE thing:`status_in_treatment` SET kind = 'concept', identifier = 'in_treatment', color = 'blue', _i18n = { ru: { label: 'Лечится' }, en: { label: 'In treatment' } }, created_at = time::now();
RELATE thing:`status_in_treatment`->part_of->thing:`status_set_diagnosis` SET order = 2;
RELATE thing:`status_resolved`->part_of->thing:`status_set_diagnosis` SET order = 3;

CREATE thing:`vocab_domovoy_category` SET kind = 'vocabulary', identifier = 'domovoy_category', source = 'internal', name = 'Категории', _i18n = { ru: { label: 'Категории' }, en: { label: 'Categories' } }, created_at = time::now();
-- D-33 пересмотрен (2026-08-02): dev-старт наполненный — категории из таблицы миграции
CREATE thing:`cat_food` SET kind = 'concept', identifier = 'food', _i18n = { ru: { label: 'Продукты' }, en: { label: 'Food' } }, created_at = time::now();
RELATE thing:`cat_food`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_medicine` SET kind = 'concept', identifier = 'medicine', _i18n = { ru: { label: 'Аптечка' }, en: { label: 'Medicine' } }, created_at = time::now();
RELATE thing:`cat_medicine`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_book` SET kind = 'concept', identifier = 'book', _i18n = { ru: { label: 'Книги' }, en: { label: 'Books' } }, created_at = time::now();
RELATE thing:`cat_book`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_clothing` SET kind = 'concept', identifier = 'clothing', _i18n = { ru: { label: 'Одежда' }, en: { label: 'Clothing' } }, created_at = time::now();
RELATE thing:`cat_clothing`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_electronics` SET kind = 'concept', identifier = 'electronics', _i18n = { ru: { label: 'Электроника' }, en: { label: 'Electronics' } }, created_at = time::now();
RELATE thing:`cat_electronics`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_electrical` SET kind = 'concept', identifier = 'electrical', _i18n = { ru: { label: 'Электрика' }, en: { label: 'Electrical' } }, created_at = time::now();
RELATE thing:`cat_electrical`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_audio` SET kind = 'concept', identifier = 'audio', _i18n = { ru: { label: 'Аудио' }, en: { label: 'Audio' } }, created_at = time::now();
RELATE thing:`cat_audio`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_storage_media` SET kind = 'concept', identifier = 'storage_media', _i18n = { ru: { label: 'Носители данных' }, en: { label: 'Storage media' } }, created_at = time::now();
RELATE thing:`cat_storage_media`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_peripheral` SET kind = 'concept', identifier = 'peripheral', _i18n = { ru: { label: 'Периферия' }, en: { label: 'Peripherals' } }, created_at = time::now();
RELATE thing:`cat_peripheral`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_navigation` SET kind = 'concept', identifier = 'navigation', _i18n = { ru: { label: 'Навигация' }, en: { label: 'Navigation' } }, created_at = time::now();
RELATE thing:`cat_navigation`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_media_archive` SET kind = 'concept', identifier = 'media_archive', _i18n = { ru: { label: 'Медиа-архив' }, en: { label: 'Media archive' } }, created_at = time::now();
RELATE thing:`cat_media_archive`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_construction` SET kind = 'concept', identifier = 'construction', _i18n = { ru: { label: 'Стройматериалы' }, en: { label: 'Construction' } }, created_at = time::now();
RELATE thing:`cat_construction`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_plumbing` SET kind = 'concept', identifier = 'plumbing', _i18n = { ru: { label: 'Сантехника' }, en: { label: 'Plumbing' } }, created_at = time::now();
RELATE thing:`cat_plumbing`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_refrigerator` SET kind = 'concept', identifier = 'refrigerator', wikidata = 'Q37828', _i18n = { ru: { label: 'Холодильники' }, en: { label: 'Refrigerators' } }, created_at = time::now();
RELATE thing:`cat_refrigerator`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_misc` SET kind = 'concept', identifier = 'misc', _i18n = { ru: { label: 'Разное' }, en: { label: 'Misc' } }, created_at = time::now();
RELATE thing:`cat_misc`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_tool` SET kind = 'concept', identifier = 'tool', _i18n = { ru: { label: 'Инструмент' }, en: { label: 'Tools' } }, created_at = time::now();
RELATE thing:`cat_tool`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_hand_tool` SET kind = 'concept', identifier = 'hand_tool', _i18n = { ru: { label: 'Ручной инструмент' }, en: { label: 'Hand tools' } }, created_at = time::now();
RELATE thing:`cat_hand_tool`->part_of->thing:`cat_tool`;
RELATE thing:`cat_hand_tool`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_power_tool` SET kind = 'concept', identifier = 'power_tool', wikidata = 'Q1327701', _i18n = { ru: { label: 'Электроинструмент' }, en: { label: 'Power tools' } }, created_at = time::now();
RELATE thing:`cat_power_tool`->part_of->thing:`cat_tool`;
RELATE thing:`cat_power_tool`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_vehicle` SET kind = 'concept', identifier = 'vehicle', _i18n = { ru: { label: 'Транспорт' }, en: { label: 'Vehicles' } }, created_at = time::now();
RELATE thing:`cat_vehicle`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_car` SET kind = 'concept', identifier = 'car', wikidata = 'Q1420', _i18n = { ru: { label: 'Автомобили' }, en: { label: 'Cars' } }, created_at = time::now();
RELATE thing:`cat_car`->part_of->thing:`cat_vehicle`;
RELATE thing:`cat_car`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_motorcycle` SET kind = 'concept', identifier = 'motorcycle', wikidata = 'Q34493', _i18n = { ru: { label: 'Мотоциклы' }, en: { label: 'Motorcycles' } }, created_at = time::now();
RELATE thing:`cat_motorcycle`->part_of->thing:`cat_vehicle`;
RELATE thing:`cat_motorcycle`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_boat` SET kind = 'concept', identifier = 'boat', _i18n = { ru: { label: 'Лодки и катера' }, en: { label: 'Boats' } }, created_at = time::now();
RELATE thing:`cat_boat`->part_of->thing:`cat_vehicle`;
RELATE thing:`cat_boat`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_snowmobile` SET kind = 'concept', identifier = 'snowmobile', _i18n = { ru: { label: 'Снегоходы' }, en: { label: 'Snowmobiles' } }, created_at = time::now();
RELATE thing:`cat_snowmobile`->part_of->thing:`cat_vehicle`;
RELATE thing:`cat_snowmobile`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_vehicle_supplies` SET kind = 'concept', identifier = 'vehicle_supplies', _i18n = { ru: { label: 'Автомото-принадлежности' }, en: { label: 'Vehicle supplies' } }, created_at = time::now();
RELATE thing:`cat_vehicle_supplies`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_auto_part` SET kind = 'concept', identifier = 'auto_part', _i18n = { ru: { label: 'Автозапчасти' }, en: { label: 'Auto parts' } }, created_at = time::now();
RELATE thing:`cat_auto_part`->part_of->thing:`cat_vehicle_supplies`;
RELATE thing:`cat_auto_part`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_auto_accessory` SET kind = 'concept', identifier = 'auto_accessory', _i18n = { ru: { label: 'Автоаксессуары' }, en: { label: 'Auto accessories' } }, created_at = time::now();
RELATE thing:`cat_auto_accessory`->part_of->thing:`cat_vehicle_supplies`;
RELATE thing:`cat_auto_accessory`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_moto_accessory` SET kind = 'concept', identifier = 'moto_accessory', _i18n = { ru: { label: 'Мотоаксессуары' }, en: { label: 'Moto accessories' } }, created_at = time::now();
RELATE thing:`cat_moto_accessory`->part_of->thing:`cat_vehicle_supplies`;
RELATE thing:`cat_moto_accessory`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_household_supplies` SET kind = 'concept', identifier = 'household_supplies', _i18n = { ru: { label: 'Хозтовары и расходники' }, en: { label: 'Household supplies' } }, created_at = time::now();
RELATE thing:`cat_household_supplies`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_household` SET kind = 'concept', identifier = 'household', _i18n = { ru: { label: 'Хозтовары' }, en: { label: 'Household' } }, created_at = time::now();
RELATE thing:`cat_household`->part_of->thing:`cat_household_supplies`;
RELATE thing:`cat_household`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_consumable` SET kind = 'concept', identifier = 'consumable', _i18n = { ru: { label: 'Расходники' }, en: { label: 'Consumables' } }, created_at = time::now();
RELATE thing:`cat_consumable`->part_of->thing:`cat_household_supplies`;
RELATE thing:`cat_consumable`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_container` SET kind = 'concept', identifier = 'container', _i18n = { ru: { label: 'Тара' }, en: { label: 'Containers' } }, created_at = time::now();
RELATE thing:`cat_container`->part_of->thing:`cat_household_supplies`;
RELATE thing:`cat_container`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_fastener` SET kind = 'concept', identifier = 'fastener', _i18n = { ru: { label: 'Крепёж' }, en: { label: 'Fasteners' } }, created_at = time::now();
RELATE thing:`cat_fastener`->part_of->thing:`cat_household_supplies`;
RELATE thing:`cat_fastener`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_garden_supplies` SET kind = 'concept', identifier = 'garden_supplies', _i18n = { ru: { label: 'Сад и огород' }, en: { label: 'Garden supplies' } }, created_at = time::now();
RELATE thing:`cat_garden_supplies`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_garden_tool` SET kind = 'concept', identifier = 'garden_tool', _i18n = { ru: { label: 'Садовый инвентарь' }, en: { label: 'Garden tools' } }, created_at = time::now();
RELATE thing:`cat_garden_tool`->part_of->thing:`cat_garden_supplies`;
RELATE thing:`cat_garden_tool`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_seeds` SET kind = 'concept', identifier = 'seeds', _i18n = { ru: { label: 'Семена' }, en: { label: 'Seeds' } }, created_at = time::now();
RELATE thing:`cat_seeds`->part_of->thing:`cat_garden_supplies`;
RELATE thing:`cat_seeds`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_sapling` SET kind = 'concept', identifier = 'sapling', _i18n = { ru: { label: 'Саженцы' }, en: { label: 'Saplings' } }, created_at = time::now();
RELATE thing:`cat_sapling`->part_of->thing:`cat_garden_supplies`;
RELATE thing:`cat_sapling`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_substrate` SET kind = 'concept', identifier = 'substrate', _i18n = { ru: { label: 'Субстраты' }, en: { label: 'Substrates' } }, created_at = time::now();
RELATE thing:`cat_substrate`->part_of->thing:`cat_garden_supplies`;
RELATE thing:`cat_substrate`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_agrochemistry` SET kind = 'concept', identifier = 'agrochemistry', _i18n = { ru: { label: 'Агрохимия' }, en: { label: 'Agrochemistry' } }, created_at = time::now();
RELATE thing:`cat_agrochemistry`->part_of->thing:`cat_garden_supplies`;
RELATE thing:`cat_agrochemistry`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_fertilizer` SET kind = 'concept', identifier = 'fertilizer', wikidata = 'Q83323', _i18n = { ru: { label: 'Удобрения' }, en: { label: 'Fertilizers' } }, created_at = time::now();
RELATE thing:`cat_fertilizer`->part_of->thing:`cat_agrochemistry`;
RELATE thing:`cat_fertilizer`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_growth_regulator` SET kind = 'concept', identifier = 'growth_regulator', _i18n = { ru: { label: 'Стимуляторы роста' }, en: { label: 'Growth regulators' } }, created_at = time::now();
RELATE thing:`cat_growth_regulator`->part_of->thing:`cat_agrochemistry`;
RELATE thing:`cat_growth_regulator`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_sports` SET kind = 'concept', identifier = 'sports', _i18n = { ru: { label: 'Спорт и отдых' }, en: { label: 'Sports & outdoors' } }, created_at = time::now();
RELATE thing:`cat_sports`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_fishing` SET kind = 'concept', identifier = 'fishing', _i18n = { ru: { label: 'Рыбалка' }, en: { label: 'Fishing' } }, created_at = time::now();
RELATE thing:`cat_fishing`->part_of->thing:`cat_sports`;
RELATE thing:`cat_fishing`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_marine_gear` SET kind = 'concept', identifier = 'marine_gear', _i18n = { ru: { label: 'Морское снаряжение' }, en: { label: 'Marine gear' } }, created_at = time::now();
RELATE thing:`cat_marine_gear`->part_of->thing:`cat_sports`;
RELATE thing:`cat_marine_gear`->part_of->thing:`vocab_domovoy_category`;
CREATE thing:`cat_tourism` SET kind = 'concept', identifier = 'tourism', _i18n = { ru: { label: 'Туризм' }, en: { label: 'Tourism' } }, created_at = time::now();
RELATE thing:`cat_tourism`->part_of->thing:`cat_sports`;
RELATE thing:`cat_tourism`->part_of->thing:`vocab_domovoy_category`;

CREATE thing:`vocab_domovoy_brand` SET kind = 'vocabulary', identifier = 'domovoy_brand', source = 'internal', name = 'Бренды', _i18n = { ru: { label: 'Бренды' }, en: { label: 'Brands' } }, created_at = time::now();
CREATE thing:`brand_apple` SET kind = 'concept', identifier = 'apple', wikidata = 'Q312', _i18n = { ru: { label: 'Apple' }, en: { label: 'Apple' } }, created_at = time::now();
RELATE thing:`brand_apple`->part_of->thing:`vocab_domovoy_brand`;
CREATE thing:`brand_bmw` SET kind = 'concept', identifier = 'bmw', wikidata = 'Q26678', _i18n = { ru: { label: 'Bmw' }, en: { label: 'Bmw' } }, created_at = time::now();
RELATE thing:`brand_bmw`->part_of->thing:`vocab_domovoy_brand`;
CREATE thing:`brand_bosch` SET kind = 'concept', identifier = 'bosch', wikidata = 'Q234021', _i18n = { ru: { label: 'Bosch' }, en: { label: 'Bosch' } }, created_at = time::now();
RELATE thing:`brand_bosch`->part_of->thing:`vocab_domovoy_brand`;
CREATE thing:`brand_lenovo` SET kind = 'concept', identifier = 'lenovo', wikidata = 'Q14799', _i18n = { ru: { label: 'Lenovo' }, en: { label: 'Lenovo' } }, created_at = time::now();
RELATE thing:`brand_lenovo`->part_of->thing:`vocab_domovoy_brand`;
CREATE thing:`brand_makita` SET kind = 'concept', identifier = 'makita', wikidata = 'Q691508', _i18n = { ru: { label: 'Makita' }, en: { label: 'Makita' } }, created_at = time::now();
RELATE thing:`brand_makita`->part_of->thing:`vocab_domovoy_brand`;

CREATE thing:`vocab_wikidata` SET kind = 'vocabulary', identifier = 'wikidata', source = 'external', authority = 'Wikimedia Foundation', version = 'live', name = 'Wikidata', _i18n = { ru: { label: 'Wikidata' }, en: { label: 'Wikidata' } }, created_at = time::now();
-- концепты Wikidata материализуются лениво (D-08); якоря — поле wikidata на узлах
CREATE thing:`vocab_iso_4217` SET kind = 'vocabulary', identifier = 'iso_4217', source = 'external', authority = 'ISO', name = 'Валюты', _i18n = { ru: { label: 'Валюты ISO 4217' }, en: { label: 'ISO 4217 currencies' } }, created_at = time::now();
CREATE thing:`currency_rub` SET kind = 'concept', identifier = 'RUB', _i18n = { ru: { label: 'Российский рубль' }, en: { label: 'Russian ruble' } }, created_at = time::now();
RELATE thing:`currency_rub`->part_of->thing:`vocab_iso_4217`;
CREATE thing:`vocab_iso_639` SET kind = 'vocabulary', identifier = 'iso_639', source = 'external', authority = 'ISO', name = 'Языки', _i18n = { ru: { label: 'Языки ISO 639' }, en: { label: 'ISO 639 languages' } }, created_at = time::now();
CREATE thing:`lang_ru` SET kind = 'concept', identifier = 'ru', _i18n = { ru: { label: 'Русский' }, en: { label: 'Russian' } }, created_at = time::now();
RELATE thing:`lang_ru`->part_of->thing:`vocab_iso_639`;
CREATE thing:`lang_en` SET kind = 'concept', identifier = 'en', _i18n = { ru: { label: 'Английский' }, en: { label: 'English' } }, created_at = time::now();
RELATE thing:`lang_en`->part_of->thing:`vocab_iso_639`;
CREATE thing:`vocab_iana_mime` SET kind = 'vocabulary', identifier = 'iana_mime', source = 'external', authority = 'IANA', name = 'MIME-типы', _i18n = { ru: { label: 'MIME-типы' }, en: { label: 'MIME types' } }, created_at = time::now();
CREATE thing:`mime_pdf` SET kind = 'concept', identifier = 'application/pdf', _i18n = { ru: { label: 'application/pdf' }, en: { label: 'application/pdf' } }, created_at = time::now();
RELATE thing:`mime_pdf`->part_of->thing:`vocab_iana_mime`;
CREATE thing:`mime_webp` SET kind = 'concept', identifier = 'image/webp', _i18n = { ru: { label: 'image/webp' }, en: { label: 'image/webp' } }, created_at = time::now();
RELATE thing:`mime_webp`->part_of->thing:`vocab_iana_mime`;

-- ── Люди ──────────────────────────────────────────────────────────────────
CREATE thing:`user_papa` SET kind = 'person', name = 'Папа', role = 'папа', created_at = time::now();
CREATE thing:`user_mama` SET kind = 'person', name = 'Мама', role = 'мама', created_at = time::now();
CREATE thing:`user_son` SET kind = 'person', name = 'Сын', role = 'сын', created_at = time::now();

-- ── Локации ────────────────────────────────────────────────────────────────
CREATE thing:`apt` SET kind = 'location', name = 'Квартира', created_at = time::now();
CREATE thing:`apt_kitchen` SET kind = 'location', name = 'Кухня', created_at = time::now();
RELATE thing:`apt_kitchen`->part_of->thing:`apt`;
CREATE thing:`apt_living` SET kind = 'location', name = 'Гостиная', created_at = time::now();
RELATE thing:`apt_living`->part_of->thing:`apt`;
CREATE thing:`apt_bedroom` SET kind = 'location', name = 'Спальня', created_at = time::now();
RELATE thing:`apt_bedroom`->part_of->thing:`apt`;
CREATE thing:`apt_child` SET kind = 'location', name = 'Детская', created_at = time::now();
RELATE thing:`apt_child`->part_of->thing:`apt`;
CREATE thing:`apt_bathroom` SET kind = 'location', name = 'Ванная', created_at = time::now();
RELATE thing:`apt_bathroom`->part_of->thing:`apt`;
CREATE thing:`apt_balcony` SET kind = 'location', name = 'Балкон', created_at = time::now();
RELATE thing:`apt_balcony`->part_of->thing:`apt`;
CREATE thing:`apt_storage` SET kind = 'location', name = 'Кладовка (квартира)', created_at = time::now();
RELATE thing:`apt_storage`->part_of->thing:`apt`;
CREATE thing:`apt_storage_shelf_1` SET kind = 'location', name = 'Полка кладовки 1', created_at = time::now();
RELATE thing:`apt_storage_shelf_1`->part_of->thing:`apt_storage`;
CREATE thing:`apt_storage_shelf_2` SET kind = 'location', name = 'Полка кладовки 2', created_at = time::now();
RELATE thing:`apt_storage_shelf_2`->part_of->thing:`apt_storage`;
CREATE thing:`apt_storage_shelf_3` SET kind = 'location', name = 'Полка кладовки 3', created_at = time::now();
RELATE thing:`apt_storage_shelf_3`->part_of->thing:`apt_storage`;
CREATE thing:`garage` SET kind = 'location', name = 'Гараж', created_at = time::now();
CREATE thing:`garage_pit` SET kind = 'location', name = 'Смотровая яма', created_at = time::now();
RELATE thing:`garage_pit`->part_of->thing:`garage`;
CREATE thing:`garage_workbench` SET kind = 'location', name = 'Верстак', created_at = time::now();
RELATE thing:`garage_workbench`->part_of->thing:`garage`;
CREATE thing:`garage_cabinet` SET kind = 'location', name = 'Шкаф инструментальный', created_at = time::now();
RELATE thing:`garage_cabinet`->part_of->thing:`garage`;
CREATE thing:`garage_shelf_1` SET kind = 'location', name = 'Стеллаж гараж полка 1', created_at = time::now();
RELATE thing:`garage_shelf_1`->part_of->thing:`garage`;
CREATE thing:`garage_shelf_2` SET kind = 'location', name = 'Стеллаж гараж полка 2', created_at = time::now();
RELATE thing:`garage_shelf_2`->part_of->thing:`garage`;
CREATE thing:`garage_shelf_3` SET kind = 'location', name = 'Стеллаж гараж полка 3', created_at = time::now();
RELATE thing:`garage_shelf_3`->part_of->thing:`garage`;
CREATE thing:`garage_shelf_4` SET kind = 'location', name = 'Стеллаж гараж полка 4', created_at = time::now();
RELATE thing:`garage_shelf_4`->part_of->thing:`garage`;
CREATE thing:`garage_shelf_5` SET kind = 'location', name = 'Стеллаж гараж полка 5', created_at = time::now();
RELATE thing:`garage_shelf_5`->part_of->thing:`garage`;
CREATE thing:`garage_ceiling` SET kind = 'location', name = 'Потолочное хранение гаража', created_at = time::now();
RELATE thing:`garage_ceiling`->part_of->thing:`garage`;
CREATE thing:`storage` SET kind = 'location', name = 'Кладовка (подъезд)', created_at = time::now();
CREATE thing:`storage_rack_1` SET kind = 'location', name = 'Стеллаж кладовки 1', created_at = time::now();
RELATE thing:`storage_rack_1`->part_of->thing:`storage`;
CREATE thing:`storage_rack_2` SET kind = 'location', name = 'Стеллаж кладовки 2', created_at = time::now();
RELATE thing:`storage_rack_2`->part_of->thing:`storage`;
CREATE thing:`storage_rack_3` SET kind = 'location', name = 'Стеллаж кладовки 3', created_at = time::now();
RELATE thing:`storage_rack_3`->part_of->thing:`storage`;
CREATE thing:`storage_rack_4` SET kind = 'location', name = 'Стеллаж кладовки 4', created_at = time::now();
RELATE thing:`storage_rack_4`->part_of->thing:`storage`;
CREATE thing:`storage_rack_5` SET kind = 'location', name = 'Стеллаж кладовки 5', created_at = time::now();
RELATE thing:`storage_rack_5`->part_of->thing:`storage`;
CREATE thing:`storage_rack_6` SET kind = 'location', name = 'Стеллаж кладовки 6', created_at = time::now();
RELATE thing:`storage_rack_6`->part_of->thing:`storage`;
CREATE thing:`storage_rack_7` SET kind = 'location', name = 'Стеллаж кладовки 7', created_at = time::now();
RELATE thing:`storage_rack_7`->part_of->thing:`storage`;
CREATE thing:`storage_box_1` SET kind = 'location', name = 'Коробка напольная 1', created_at = time::now();
RELATE thing:`storage_box_1`->part_of->thing:`storage`;
CREATE thing:`storage_box_2` SET kind = 'location', name = 'Коробка напольная 2', created_at = time::now();
RELATE thing:`storage_box_2`->part_of->thing:`storage`;
CREATE thing:`storage_box_3` SET kind = 'location', name = 'Коробка напольная 3', created_at = time::now();
RELATE thing:`storage_box_3`->part_of->thing:`storage`;
CREATE thing:`dacha` SET kind = 'location', name = 'Дача', created_at = time::now();
CREATE thing:`dacha_house` SET kind = 'location', name = 'Дачный дом', created_at = time::now();
RELATE thing:`dacha_house`->part_of->thing:`dacha`;
CREATE thing:`dacha_shed` SET kind = 'location', name = 'Сарай', created_at = time::now();
RELATE thing:`dacha_shed`->part_of->thing:`dacha`;
CREATE thing:`dacha_shed_shelf_1` SET kind = 'location', name = 'Полка сарая 1', created_at = time::now();
RELATE thing:`dacha_shed_shelf_1`->part_of->thing:`dacha_shed`;
CREATE thing:`dacha_shed_shelf_2` SET kind = 'location', name = 'Полка сарая 2', created_at = time::now();
RELATE thing:`dacha_shed_shelf_2`->part_of->thing:`dacha_shed`;
CREATE thing:`dacha_shed_shelf_3` SET kind = 'location', name = 'Полка сарая 3', created_at = time::now();
RELATE thing:`dacha_shed_shelf_3`->part_of->thing:`dacha_shed`;
CREATE thing:`dacha_cellar` SET kind = 'location', name = 'Погреб', created_at = time::now();
RELATE thing:`dacha_cellar`->part_of->thing:`dacha`;
CREATE thing:`dacha_garden` SET kind = 'location', name = 'Участок', created_at = time::now();
RELATE thing:`dacha_garden`->part_of->thing:`dacha`;
CREATE thing:`car_vesta` SET kind = 'item', category = 'car', brand = 'lada', model = 'Vesta', wikidata = 'Q17376334', name = 'Lada Vesta', created_at = time::now();
CREATE thing:`car_trunk` SET kind = 'location', name = 'Багажник Vesta', created_at = time::now();
RELATE thing:`car_trunk`->part_of->thing:`car_vesta`;
CREATE thing:`car_glove` SET kind = 'location', name = 'Бардачок Vesta', created_at = time::now();
RELATE thing:`car_glove`->part_of->thing:`car_vesta`;
CREATE thing:`moto_bmw` SET kind = 'item', category = 'motorcycle', brand = 'bmw', model = 'R 1250 GS', wikidata = 'Q57821567', name = 'BMW R1250GS', created_at = time::now();
CREATE thing:`moto_cases` SET kind = 'location', name = 'Кофры BMW', created_at = time::now();
RELATE thing:`moto_cases`->part_of->thing:`moto_bmw`;
CREATE thing:`moto_topcase` SET kind = 'location', name = 'Топкейс BMW', created_at = time::now();
RELATE thing:`moto_topcase`->part_of->thing:`moto_bmw`;

-- ── Расширенные люди ───────────────────────────────────────────────────────
CREATE thing:`user_grandma` SET kind = 'person', name = 'Бабушка', role = 'бабушка', created_at = time::now();
CREATE thing:`neighbor_vasich` SET kind = 'person', name = 'Сосед Василий Петрович', role = 'сосед', created_at = time::now();
CREATE thing:`friend_kolya` SET kind = 'person', name = 'Друг Коля', role = 'друг', created_at = time::now();
CREATE thing:`teacher_ivanova` SET kind = 'person', name = 'Иванова Наталья Петровна', role = 'классный руководитель', created_at = time::now();
CREATE thing:`director_smirnov` SET kind = 'person', name = 'Смирнов Андрей Викторович', role = 'директор школы', created_at = time::now();
CREATE thing:`social_kozlova` SET kind = 'person', name = 'Козлова Светлана Ивановна', role = 'социальный педагог', created_at = time::now();
CREATE thing:`doc_pediatr` SET kind = 'person', name = 'Захаров Денис Олегович', role = 'педиатр', created_at = time::now();
CREATE thing:`doc_stomatolog` SET kind = 'person', name = 'Фёдорова Ирина Сергеевна', role = 'стоматолог', created_at = time::now();
CREATE thing:`doc_surgeon` SET kind = 'person', name = 'Петров Аркадий Семёнович', role = 'хирург', created_at = time::now();
CREATE thing:`doc_allergolog` SET kind = 'person', name = 'Носков Роман Дмитриевич', role = 'аллерголог', created_at = time::now();
CREATE thing:`supplier_agropark` SET kind = 'org', name = 'АгроПарк Воронеж', role = 'поставщик', created_at = time::now();
CREATE thing:`customer_zina` SET kind = 'person', name = 'Зинаида Павловна', role = 'покупатель', created_at = time::now();
CREATE thing:`customer_irina` SET kind = 'person', name = 'Ирина Семёновна', role = 'покупатель', created_at = time::now();
CREATE thing:`customer_galina` SET kind = 'person', name = 'Галина Борисовна', role = 'покупатель', created_at = time::now();
CREATE thing:`customer_club_urozhai` SET kind = 'org', name = 'Клуб дачников «Урожай»', role = 'покупатель', created_at = time::now();
CREATE thing:`student_алексей_иванов` SET kind = 'person', name = 'Алексей Иванов', role = 'ученик_7б', created_at = time::now();
CREATE thing:`student_мария_петрова` SET kind = 'person', name = 'Мария Петрова', role = 'ученик_7б', created_at = time::now();
CREATE thing:`student_дмитрий_сидоров` SET kind = 'person', name = 'Дмитрий Сидоров', role = 'ученик_7б', created_at = time::now();
CREATE thing:`student_анна_козлова` SET kind = 'person', name = 'Анна Козлова', role = 'ученик_7б', created_at = time::now();
CREATE thing:`student_михаил_новиков` SET kind = 'person', name = 'Михаил Новиков', role = 'ученик_7б', created_at = time::now();
CREATE thing:`student_екатерина_морозова` SET kind = 'person', name = 'Екатерина Морозова', role = 'ученик_7б', created_at = time::now();
CREATE thing:`student_артём_волков` SET kind = 'person', name = 'Артём Волков', role = 'ученик_7б', created_at = time::now();
CREATE thing:`student_ольга_лебедева` SET kind = 'person', name = 'Ольга Лебедева', role = 'ученик_7б', created_at = time::now();
CREATE thing:`student_николай_соколов` SET kind = 'person', name = 'Николай Соколов', role = 'ученик_7б', created_at = time::now();
CREATE thing:`student_татьяна_попова` SET kind = 'person', name = 'Татьяна Попова', role = 'ученик_7б', created_at = time::now();
CREATE thing:`student_андрей_васильев` SET kind = 'person', name = 'Андрей Васильев', role = 'ученик_7б', created_at = time::now();
CREATE thing:`student_юлия_зайцева` SET kind = 'person', name = 'Юлия Зайцева', role = 'ученик_7б', created_at = time::now();
CREATE thing:`student_сергей_кузнецов` SET kind = 'person', name = 'Сергей Кузнецов', role = 'ученик_7б', created_at = time::now();
CREATE thing:`student_наталья_мельникова` SET kind = 'person', name = 'Наталья Мельникова', role = 'ученик_7б', created_at = time::now();
CREATE thing:`student_павел_орлов` SET kind = 'person', name = 'Павел Орлов', role = 'ученик_7б', created_at = time::now();
CREATE thing:`student_виктория_фёдорова` SET kind = 'person', name = 'Виктория Фёдорова', role = 'ученик_7б', created_at = time::now();
CREATE thing:`student_илья_голубев` SET kind = 'person', name = 'Илья Голубев', role = 'ученик_7б', created_at = time::now();
CREATE thing:`student_светлана_виноградова` SET kind = 'person', name = 'Светлана Виноградова', role = 'ученик_7б', created_at = time::now();
CREATE thing:`student_роман_богданов` SET kind = 'person', name = 'Роман Богданов', role = 'ученик_7б', created_at = time::now();
CREATE thing:`student_алина_ковалёва` SET kind = 'person', name = 'Алина Ковалёва', role = 'ученик_7б', created_at = time::now();
CREATE thing:`student_максим_чернов` SET kind = 'person', name = 'Максим Чернов', role = 'ученик_7б', created_at = time::now();
CREATE thing:`student_дарья_беляева` SET kind = 'person', name = 'Дарья Беляева', role = 'ученик_7б', created_at = time::now();
CREATE thing:`student_евгений_громов` SET kind = 'person', name = 'Евгений Громов', role = 'ученик_7б', created_at = time::now();
CREATE thing:`student_ксения_тихонова` SET kind = 'person', name = 'Ксения Тихонова', role = 'ученик_7б', created_at = time::now();
CREATE thing:`student_владимир_щукин` SET kind = 'person', name = 'Владимир Щукин', role = 'ученик_7б', created_at = time::now();

-- ── Новые локации ──────────────────────────────────────────────────────────
CREATE thing:`grandma_apt` SET kind = 'location', name = 'Квартира бабушки', created_at = time::now();
CREATE thing:`grandma_garden` SET kind = 'location', name = 'Огород бабушки (обещанный)', created_at = time::now();
RELATE thing:`grandma_garden`->part_of->thing:`grandma_apt`;
CREATE thing:`school_42` SET kind = 'location', name = 'Школа №42', created_at = time::now();
CREATE thing:`school_class_7b` SET kind = 'location', name = 'Класс 7Б', created_at = time::now();
RELATE thing:`school_class_7b`->part_of->thing:`school_42`;
CREATE thing:`school_storage` SET kind = 'location', name = 'Кладовка школы', created_at = time::now();
RELATE thing:`school_storage`->part_of->thing:`school_42`;
CREATE thing:`clinic_1` SET kind = 'location', name = 'Поликлиника №1', created_at = time::now();
CREATE thing:`clinic_cabinet_p` SET kind = 'location', name = 'Кабинет педиатра', created_at = time::now();
RELATE thing:`clinic_cabinet_p`->part_of->thing:`clinic_1`;
CREATE thing:`clinic_cabinet_s` SET kind = 'location', name = 'Кабинет стоматолога', created_at = time::now();
RELATE thing:`clinic_cabinet_s`->part_of->thing:`clinic_1`;
CREATE thing:`marina` SET kind = 'location', name = 'Причал Речной порт', created_at = time::now();
CREATE thing:`boat_viking` SET kind = 'item', category = 'boat', model = 'Viking 470', name = 'Катер Viking 470', created_at = time::now();
CREATE thing:`boat_cabin` SET kind = 'location', name = 'Каюта катера', created_at = time::now();
RELATE thing:`boat_cabin`->part_of->thing:`boat_viking`;
CREATE thing:`boat_deck_box` SET kind = 'location', name = 'Ящик под палубой', created_at = time::now();
RELATE thing:`boat_deck_box`->part_of->thing:`boat_viking`;
CREATE thing:`boat_engine_bay` SET kind = 'location', name = 'Моторный отсек катера', created_at = time::now();
RELATE thing:`boat_engine_bay`->part_of->thing:`boat_viking`;
CREATE thing:`snowmobile_arctic` SET kind = 'item', category = 'snowmobile', brand = 'arctic_cat', model = 'Arctic Cat 600', name = 'Снегоход Arctic Cat 600', created_at = time::now();
CREATE thing:`snowmobile_box` SET kind = 'location', name = 'Кофр снегохода', created_at = time::now();
RELATE thing:`snowmobile_box`->part_of->thing:`snowmobile_arctic`;
CREATE thing:`electronics_shelf` SET kind = 'location', name = 'Полка с электроникой (кабинет)', created_at = time::now();
CREATE thing:`seeds_business_storage` SET kind = 'location', name = 'Склад семян (балкон)', created_at = time::now();
RELATE thing:`seeds_business_storage`->part_of->thing:`apt`;

-- ── Вещи и связи contains ─────────────────────────────────────────────────
CREATE thing:`отвёртка_крестовая_ph2` SET kind = 'item', category = 'tool', name = 'Отвёртка крестовая PH2', created_at = time::now();
RELATE thing:`garage_shelf_1`->contains->thing:`отвёртка_крестовая_ph2`;
CREATE thing:`отвёртка_крестовая_ph1` SET kind = 'item', category = 'tool', name = 'Отвёртка крестовая PH1', created_at = time::now();
RELATE thing:`garage_shelf_3`->contains->thing:`отвёртка_крестовая_ph1`;
CREATE thing:`отвёртка_крестовая_ph3` SET kind = 'item', category = 'tool', name = 'Отвёртка крестовая PH3', created_at = time::now();
RELATE thing:`garage_shelf_2`->contains->thing:`отвёртка_крестовая_ph3`;
CREATE thing:`отвёртка_шлицевая_5мм` SET kind = 'item', category = 'tool', name = 'Отвёртка шлицевая 5мм', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`отвёртка_шлицевая_5мм`;
CREATE thing:`отвёртка_шлицевая_8мм` SET kind = 'item', category = 'tool', name = 'Отвёртка шлицевая 8мм', created_at = time::now();
RELATE thing:`garage_shelf_5`->contains->thing:`отвёртка_шлицевая_8мм`;
CREATE thing:`отвёртка_шлицевая_3мм` SET kind = 'item', category = 'tool', name = 'Отвёртка шлицевая 3мм', created_at = time::now();
RELATE thing:`garage_workbench`->contains->thing:`отвёртка_шлицевая_3мм`;
CREATE thing:`молоток_300г` SET kind = 'item', category = 'tool', name = 'Молоток 300г', created_at = time::now();
RELATE thing:`garage_shelf_1`->contains->thing:`молоток_300г`;
CREATE thing:`молоток_500г` SET kind = 'item', category = 'tool', name = 'Молоток 500г', created_at = time::now();
RELATE thing:`garage_shelf_1`->contains->thing:`молоток_500г`;
CREATE thing:`киянка_резиновая` SET kind = 'item', category = 'tool', name = 'Киянка резиновая', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`киянка_резиновая`;
CREATE thing:`пассатижи_160мм` SET kind = 'item', category = 'tool', name = 'Пассатижи 160мм', created_at = time::now();
RELATE thing:`garage_shelf_5`->contains->thing:`пассатижи_160мм`;
CREATE thing:`плоскогубцы_200мм` SET kind = 'item', category = 'tool', name = 'Плоскогубцы 200мм', created_at = time::now();
RELATE thing:`garage_shelf_5`->contains->thing:`плоскогубцы_200мм`;
CREATE thing:`круглогубцы` SET kind = 'item', category = 'tool', name = 'Круглогубцы', created_at = time::now();
RELATE thing:`garage_workbench`->contains->thing:`круглогубцы`;
CREATE thing:`бокорезы` SET kind = 'item', category = 'tool', name = 'Бокорезы', created_at = time::now();
RELATE thing:`garage_workbench`->contains->thing:`бокорезы`;
CREATE thing:`кусачки` SET kind = 'item', category = 'tool', name = 'Кусачки', created_at = time::now();
RELATE thing:`garage_workbench`->contains->thing:`кусачки`;
CREATE thing:`стриппер_для_проводов` SET kind = 'item', category = 'tool', name = 'Стриппер для проводов', created_at = time::now();
RELATE thing:`garage_shelf_1`->contains->thing:`стриппер_для_проводов`;
CREATE thing:`ключ_рожковый_8×10` SET kind = 'item', category = 'tool', name = 'Ключ рожковый 8×10', created_at = time::now();
RELATE thing:`garage_workbench`->contains->thing:`ключ_рожковый_8×10`;
CREATE thing:`ключ_рожковый_12×14` SET kind = 'item', category = 'tool', name = 'Ключ рожковый 12×14', created_at = time::now();
RELATE thing:`garage_shelf_3`->contains->thing:`ключ_рожковый_12×14`;
CREATE thing:`ключ_рожковый_17×19` SET kind = 'item', category = 'tool', name = 'Ключ рожковый 17×19', created_at = time::now();
RELATE thing:`garage_workbench`->contains->thing:`ключ_рожковый_17×19`;
CREATE thing:`ключ_рожковый_22×24` SET kind = 'item', category = 'tool', name = 'Ключ рожковый 22×24', created_at = time::now();
RELATE thing:`garage_shelf_1`->contains->thing:`ключ_рожковый_22×24`;
CREATE thing:`ключ_рожковый_27×30` SET kind = 'item', category = 'tool', name = 'Ключ рожковый 27×30', created_at = time::now();
RELATE thing:`garage_shelf_4`->contains->thing:`ключ_рожковый_27×30`;
CREATE thing:`ключ_рожковый_6×7` SET kind = 'item', category = 'tool', name = 'Ключ рожковый 6×7', created_at = time::now();
RELATE thing:`garage_workbench`->contains->thing:`ключ_рожковый_6×7`;
CREATE thing:`ключ_накидной_10×13` SET kind = 'item', category = 'tool', name = 'Ключ накидной 10×13', created_at = time::now();
RELATE thing:`garage_workbench`->contains->thing:`ключ_накидной_10×13`;
CREATE thing:`ключ_накидной_14×17` SET kind = 'item', category = 'tool', name = 'Ключ накидной 14×17', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`ключ_накидной_14×17`;
CREATE thing:`ключ_накидной_19×22` SET kind = 'item', category = 'tool', name = 'Ключ накидной 19×22', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`ключ_накидной_19×22`;
CREATE thing:`ключ_разводной_250мм` SET kind = 'item', category = 'tool', name = 'Ключ разводной 250мм', created_at = time::now();
RELATE thing:`garage_workbench`->contains->thing:`ключ_разводной_250мм`;
CREATE thing:`ключ_разводной_300мм` SET kind = 'item', category = 'tool', name = 'Ключ разводной 300мм', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`ключ_разводной_300мм`;
CREATE thing:`ключ_газовый_№1` SET kind = 'item', category = 'tool', name = 'Ключ газовый №1', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`ключ_газовый_№1`;
CREATE thing:`ключ_газовый_№2` SET kind = 'item', category = 'tool', name = 'Ключ газовый №2', created_at = time::now();
RELATE thing:`garage_workbench`->contains->thing:`ключ_газовый_№2`;
CREATE thing:`торцевая_головка_8мм` SET kind = 'item', category = 'tool', name = 'Торцевая головка 8мм', created_at = time::now();
RELATE thing:`garage_shelf_5`->contains->thing:`торцевая_головка_8мм`;
CREATE thing:`торцевая_головка_10мм` SET kind = 'item', category = 'tool', name = 'Торцевая головка 10мм', created_at = time::now();
RELATE thing:`garage_shelf_1`->contains->thing:`торцевая_головка_10мм`;
CREATE thing:`торцевая_головка_12мм` SET kind = 'item', category = 'tool', name = 'Торцевая головка 12мм', created_at = time::now();
RELATE thing:`garage_workbench`->contains->thing:`торцевая_головка_12мм`;
CREATE thing:`торцевая_головка_13мм` SET kind = 'item', category = 'tool', name = 'Торцевая головка 13мм', created_at = time::now();
RELATE thing:`garage_shelf_1`->contains->thing:`торцевая_головка_13мм`;
CREATE thing:`торцевая_головка_14мм` SET kind = 'item', category = 'tool', name = 'Торцевая головка 14мм', created_at = time::now();
RELATE thing:`garage_workbench`->contains->thing:`торцевая_головка_14мм`;
CREATE thing:`торцевая_головка_17мм` SET kind = 'item', category = 'tool', name = 'Торцевая головка 17мм', created_at = time::now();
RELATE thing:`garage_workbench`->contains->thing:`торцевая_головка_17мм`;
CREATE thing:`торцевая_головка_19мм` SET kind = 'item', category = 'tool', name = 'Торцевая головка 19мм', created_at = time::now();
RELATE thing:`garage_shelf_3`->contains->thing:`торцевая_головка_19мм`;
CREATE thing:`торцевая_головка_22мм` SET kind = 'item', category = 'tool', name = 'Торцевая головка 22мм', created_at = time::now();
RELATE thing:`garage_workbench`->contains->thing:`торцевая_головка_22мм`;
CREATE thing:`удлинитель_1_2"` SET kind = 'item', category = 'tool', name = 'Удлинитель 1/2"', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`удлинитель_1_2"`;
CREATE thing:`карданный_шарнир_1_2"` SET kind = 'item', category = 'tool', name = 'Карданный шарнир 1/2"', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`карданный_шарнир_1_2"`;
CREATE thing:`трещотка_1_2"_72_зуба` SET kind = 'item', category = 'tool', name = 'Трещотка 1/2" 72 зуба', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`трещотка_1_2"_72_зуба`;
CREATE thing:`трещотка_3_8"` SET kind = 'item', category = 'tool', name = 'Трещотка 3/8"', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`трещотка_3_8"`;
CREATE thing:`уровень_60см` SET kind = 'item', category = 'tool', name = 'Уровень 60см', created_at = time::now();
RELATE thing:`garage_shelf_2`->contains->thing:`уровень_60см`;
CREATE thing:`уровень_120см` SET kind = 'item', category = 'tool', name = 'Уровень 120см', created_at = time::now();
RELATE thing:`garage_workbench`->contains->thing:`уровень_120см`;
CREATE thing:`уровень_магнитный_40см` SET kind = 'item', category = 'tool', name = 'Уровень магнитный 40см', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`уровень_магнитный_40см`;
CREATE thing:`рулетка_5м` SET kind = 'item', category = 'tool', name = 'Рулетка 5м', created_at = time::now();
RELATE thing:`garage_shelf_5`->contains->thing:`рулетка_5м`;
CREATE thing:`рулетка_10м` SET kind = 'item', category = 'tool', name = 'Рулетка 10м', created_at = time::now();
RELATE thing:`garage_shelf_3`->contains->thing:`рулетка_10м`;
CREATE thing:`рулетка_3м` SET kind = 'item', category = 'tool', name = 'Рулетка 3м', created_at = time::now();
RELATE thing:`garage_shelf_2`->contains->thing:`рулетка_3м`;
CREATE thing:`линейка_металлическая_50см` SET kind = 'item', category = 'tool', name = 'Линейка металлическая 50см', created_at = time::now();
RELATE thing:`garage_workbench`->contains->thing:`линейка_металлическая_50см`;
CREATE thing:`штангенциркуль_150мм` SET kind = 'item', category = 'tool', name = 'Штангенциркуль 150мм', created_at = time::now();
RELATE thing:`garage_shelf_3`->contains->thing:`штангенциркуль_150мм`;
CREATE thing:`штангенциркуль_200мм` SET kind = 'item', category = 'tool', name = 'Штангенциркуль 200мм', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`штангенциркуль_200мм`;
CREATE thing:`угольник_250мм` SET kind = 'item', category = 'tool', name = 'Угольник 250мм', created_at = time::now();
RELATE thing:`garage_shelf_3`->contains->thing:`угольник_250мм`;
CREATE thing:`угольник_500мм` SET kind = 'item', category = 'tool', name = 'Угольник 500мм', created_at = time::now();
RELATE thing:`garage_workbench`->contains->thing:`угольник_500мм`;
CREATE thing:`малка` SET kind = 'item', category = 'tool', name = 'Малка', created_at = time::now();
RELATE thing:`garage_shelf_4`->contains->thing:`малка`;
CREATE thing:`нож_строительный_18мм` SET kind = 'item', category = 'tool', name = 'Нож строительный 18мм', created_at = time::now();
RELATE thing:`garage_shelf_3`->contains->thing:`нож_строительный_18мм`;
CREATE thing:`нож_строительный_25мм` SET kind = 'item', category = 'tool', name = 'Нож строительный 25мм', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`нож_строительный_25мм`;
CREATE thing:`ножовка_по_дереву` SET kind = 'item', category = 'tool', name = 'Ножовка по дереву', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`ножовка_по_дереву`;
CREATE thing:`ножовка_по_металлу` SET kind = 'item', category = 'tool', name = 'Ножовка по металлу', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`ножовка_по_металлу`;
CREATE thing:`лобзик_ручной` SET kind = 'item', category = 'tool', name = 'Лобзик ручной', created_at = time::now();
RELATE thing:`garage_workbench`->contains->thing:`лобзик_ручной`;
CREATE thing:`стамеска_20мм` SET kind = 'item', category = 'tool', name = 'Стамеска 20мм', created_at = time::now();
RELATE thing:`garage_workbench`->contains->thing:`стамеска_20мм`;
CREATE thing:`стамеска_12мм` SET kind = 'item', category = 'tool', name = 'Стамеска 12мм', created_at = time::now();
RELATE thing:`garage_shelf_3`->contains->thing:`стамеска_12мм`;
CREATE thing:`рубанок_ручной` SET kind = 'item', category = 'tool', name = 'Рубанок ручной', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`рубанок_ручной`;
CREATE thing:`напильник_плоский` SET kind = 'item', category = 'tool', name = 'Напильник плоский', created_at = time::now();
RELATE thing:`garage_shelf_4`->contains->thing:`напильник_плоский`;
CREATE thing:`напильник_круглый` SET kind = 'item', category = 'tool', name = 'Напильник круглый', created_at = time::now();
RELATE thing:`garage_shelf_1`->contains->thing:`напильник_круглый`;
CREATE thing:`напильник_трёхгранный` SET kind = 'item', category = 'tool', name = 'Напильник трёхгранный', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`напильник_трёхгранный`;
CREATE thing:`надфили_набор` SET kind = 'item', category = 'tool', name = 'Надфили набор', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`надфили_набор`;
CREATE thing:`щётка_металлическая` SET kind = 'item', category = 'tool', name = 'Щётка металлическая', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`щётка_металлическая`;
CREATE thing:`щётка_по_металлу_латунь` SET kind = 'item', category = 'tool', name = 'Щётка по металлу латунь', created_at = time::now();
RELATE thing:`garage_workbench`->contains->thing:`щётка_по_металлу_латунь`;
CREATE thing:`шпатель_100мм` SET kind = 'item', category = 'tool', name = 'Шпатель 100мм', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`шпатель_100мм`;
CREATE thing:`шпатель_150мм` SET kind = 'item', category = 'tool', name = 'Шпатель 150мм', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`шпатель_150мм`;
CREATE thing:`шпатель_250мм` SET kind = 'item', category = 'tool', name = 'Шпатель 250мм', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`шпатель_250мм`;
CREATE thing:`шпатель_угловой` SET kind = 'item', category = 'tool', name = 'Шпатель угловой', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`шпатель_угловой`;
CREATE thing:`мастерок_кладочный` SET kind = 'item', category = 'tool', name = 'Мастерок кладочный', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`мастерок_кладочный`;
CREATE thing:`кельма` SET kind = 'item', category = 'tool', name = 'Кельма', created_at = time::now();
RELATE thing:`garage_workbench`->contains->thing:`кельма`;
CREATE thing:`тёрка_штукатурная` SET kind = 'item', category = 'tool', name = 'Тёрка штукатурная', created_at = time::now();
RELATE thing:`garage_shelf_3`->contains->thing:`тёрка_штукатурная`;
CREATE thing:`зубило_слесарное` SET kind = 'item', category = 'tool', name = 'Зубило слесарное', created_at = time::now();
RELATE thing:`garage_workbench`->contains->thing:`зубило_слесарное`;
CREATE thing:`зубило_широкое` SET kind = 'item', category = 'tool', name = 'Зубило широкое', created_at = time::now();
RELATE thing:`garage_workbench`->contains->thing:`зубило_широкое`;
CREATE thing:`крейцмейсель` SET kind = 'item', category = 'tool', name = 'Крейцмейсель', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`крейцмейсель`;
CREATE thing:`кернер` SET kind = 'item', category = 'tool', name = 'Кернер', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`кернер`;
CREATE thing:`чертилка` SET kind = 'item', category = 'tool', name = 'Чертилка', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`чертилка`;
CREATE thing:`маркер_перманентный` SET kind = 'item', category = 'tool', name = 'Маркер перманентный', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`маркер_перманентный`;
CREATE thing:`дрель_шуруповёрт_makita_18v` SET kind = 'item', category = 'power_tool', name = 'Дрель-шуруповёрт Makita 18V', created_at = time::now(), condition = 'рабочее';
RELATE thing:`garage_shelf_2`->contains->thing:`дрель_шуруповёрт_makita_18v`;
CREATE thing:`дрель_ударная_bosch` SET kind = 'item', category = 'power_tool', name = 'Дрель ударная Bosch', created_at = time::now(), condition = 'отличное';
RELATE thing:`garage_workbench`->contains->thing:`дрель_ударная_bosch`;
CREATE thing:`перфоратор_makita_hr2630` SET kind = 'item', category = 'power_tool', name = 'Перфоратор Makita HR2630', created_at = time::now(), condition = 'рабочее';
RELATE thing:`garage_workbench`->contains->thing:`перфоратор_makita_hr2630`;
CREATE thing:`болгарка_125мм_bosch` SET kind = 'item', category = 'power_tool', name = 'Болгарка 125мм Bosch', created_at = time::now(), condition = 'рабочее';
RELATE thing:`garage_workbench`->contains->thing:`болгарка_125мм_bosch`;
CREATE thing:`болгарка_230мм` SET kind = 'item', category = 'power_tool', name = 'Болгарка 230мм', created_at = time::now(), condition = 'отличное';
RELATE thing:`garage_cabinet`->contains->thing:`болгарка_230мм`;
CREATE thing:`шлифмашина_орбитальная` SET kind = 'item', category = 'power_tool', name = 'Шлифмашина орбитальная', created_at = time::now(), condition = 'хорошее';
RELATE thing:`garage_cabinet`->contains->thing:`шлифмашина_орбитальная`;
CREATE thing:`электролобзик` SET kind = 'item', category = 'power_tool', name = 'Электролобзик', created_at = time::now(), condition = 'отличное';
RELATE thing:`garage_workbench`->contains->thing:`электролобзик`;
CREATE thing:`электрорубанок` SET kind = 'item', category = 'power_tool', name = 'Электрорубанок', created_at = time::now(), condition = 'отличное';
RELATE thing:`garage_workbench`->contains->thing:`электрорубанок`;
CREATE thing:`фрезер_погружной` SET kind = 'item', category = 'power_tool', name = 'Фрезер погружной', created_at = time::now(), condition = 'отличное';
RELATE thing:`garage_cabinet`->contains->thing:`фрезер_погружной`;
CREATE thing:`циркулярная_пила_190мм` SET kind = 'item', category = 'power_tool', name = 'Циркулярная пила 190мм', created_at = time::now(), condition = 'отличное';
RELATE thing:`garage_workbench`->contains->thing:`циркулярная_пила_190мм`;
CREATE thing:`лазерный_уровень` SET kind = 'item', category = 'power_tool', name = 'Лазерный уровень', created_at = time::now(), condition = 'рабочее';
RELATE thing:`garage_cabinet`->contains->thing:`лазерный_уровень`;
CREATE thing:`тепловизор_flir` SET kind = 'item', category = 'power_tool', name = 'Тепловизор Flir', created_at = time::now(), condition = 'рабочее';
RELATE thing:`garage_cabinet`->contains->thing:`тепловизор_flir`;
CREATE thing:`мультиметр_fluke_87v` SET kind = 'item', category = 'power_tool', name = 'Мультиметр Fluke 87V', created_at = time::now(), condition = 'отличное';
RELATE thing:`garage_cabinet`->contains->thing:`мультиметр_fluke_87v`;
CREATE thing:`мультиметр_dt_838` SET kind = 'item', category = 'power_tool', name = 'Мультиметр DT-838', created_at = time::now(), condition = 'рабочее';
RELATE thing:`garage_shelf_3`->contains->thing:`мультиметр_dt_838`;
CREATE thing:`тестер_напряжения` SET kind = 'item', category = 'power_tool', name = 'Тестер напряжения', created_at = time::now(), condition = 'хорошее';
RELATE thing:`garage_shelf_1`->contains->thing:`тестер_напряжения`;
CREATE thing:`паяльник_60вт` SET kind = 'item', category = 'power_tool', name = 'Паяльник 60Вт', created_at = time::now(), condition = 'рабочее';
RELATE thing:`garage_shelf_2`->contains->thing:`паяльник_60вт`;
CREATE thing:`паяльник_40вт` SET kind = 'item', category = 'power_tool', name = 'Паяльник 40Вт', created_at = time::now(), condition = 'рабочее';
RELATE thing:`garage_cabinet`->contains->thing:`паяльник_40вт`;
CREATE thing:`паяльная_станция_hakko` SET kind = 'item', category = 'power_tool', name = 'Паяльная станция Hakko', created_at = time::now(), condition = 'отличное';
RELATE thing:`garage_workbench`->contains->thing:`паяльная_станция_hakko`;
CREATE thing:`фен_строительный` SET kind = 'item', category = 'power_tool', name = 'Фен строительный', created_at = time::now(), condition = 'хорошее';
RELATE thing:`garage_workbench`->contains->thing:`фен_строительный`;
CREATE thing:`компрессор_50л` SET kind = 'item', category = 'power_tool', name = 'Компрессор 50л', created_at = time::now(), condition = 'рабочее';
RELATE thing:`garage_shelf_1`->contains->thing:`компрессор_50л`;
CREATE thing:`краскопульт` SET kind = 'item', category = 'power_tool', name = 'Краскопульт', created_at = time::now(), condition = 'отличное';
RELATE thing:`garage_shelf_1`->contains->thing:`краскопульт`;
CREATE thing:`сварочный_инвертор_200а` SET kind = 'item', category = 'power_tool', name = 'Сварочный инвертор 200А', created_at = time::now(), condition = 'рабочее';
RELATE thing:`garage_workbench`->contains->thing:`сварочный_инвертор_200а`;
CREATE thing:`маска_сварочная_хамелеон` SET kind = 'item', category = 'power_tool', name = 'Маска сварочная хамелеон', created_at = time::now(), condition = 'отличное';
RELATE thing:`garage_workbench`->contains->thing:`маска_сварочная_хамелеон`;
CREATE thing:`зарядник_для_акб_10а` SET kind = 'item', category = 'power_tool', name = 'Зарядник для АКБ 10А', created_at = time::now(), condition = 'хорошее';
RELATE thing:`garage_workbench`->contains->thing:`зарядник_для_акб_10а`;
CREATE thing:`зарядник_для_акб_4а` SET kind = 'item', category = 'power_tool', name = 'Зарядник для АКБ 4А', created_at = time::now(), condition = 'отличное';
RELATE thing:`garage_shelf_1`->contains->thing:`зарядник_для_акб_4а`;
CREATE thing:`болт_m3×10_(банка)` SET kind = 'item', category = 'fastener', name = 'Болт M3×10 (банка)', created_at = time::now(), quantity = 59;
RELATE thing:`garage_workbench`->contains->thing:`болт_m3×10_(банка)`;
CREATE thing:`гайка_m3×10_(банка)` SET kind = 'item', category = 'fastener', name = 'Гайка M3×10 (банка)', created_at = time::now(), quantity = 190;
RELATE thing:`garage_shelf_5`->contains->thing:`гайка_m3×10_(банка)`;
CREATE thing:`болт_m3×20_(банка)` SET kind = 'item', category = 'fastener', name = 'Болт M3×20 (банка)', created_at = time::now(), quantity = 67;
RELATE thing:`garage_workbench`->contains->thing:`болт_m3×20_(банка)`;
CREATE thing:`гайка_m3×20_(банка)` SET kind = 'item', category = 'fastener', name = 'Гайка M3×20 (банка)', created_at = time::now(), quantity = 53;
RELATE thing:`garage_workbench`->contains->thing:`гайка_m3×20_(банка)`;
CREATE thing:`болт_m4×10_(банка)` SET kind = 'item', category = 'fastener', name = 'Болт M4×10 (банка)', created_at = time::now(), quantity = 173;
RELATE thing:`garage_shelf_1`->contains->thing:`болт_m4×10_(банка)`;
CREATE thing:`гайка_m4×10_(банка)` SET kind = 'item', category = 'fastener', name = 'Гайка M4×10 (банка)', created_at = time::now(), quantity = 113;
RELATE thing:`garage_workbench`->contains->thing:`гайка_m4×10_(банка)`;
CREATE thing:`болт_m4×20_(банка)` SET kind = 'item', category = 'fastener', name = 'Болт M4×20 (банка)', created_at = time::now(), quantity = 191;
RELATE thing:`garage_workbench`->contains->thing:`болт_m4×20_(банка)`;
CREATE thing:`гайка_m4×20_(банка)` SET kind = 'item', category = 'fastener', name = 'Гайка M4×20 (банка)', created_at = time::now(), quantity = 20;
RELATE thing:`garage_shelf_1`->contains->thing:`гайка_m4×20_(банка)`;
CREATE thing:`болт_m4×30_(банка)` SET kind = 'item', category = 'fastener', name = 'Болт M4×30 (банка)', created_at = time::now(), quantity = 32;
RELATE thing:`garage_workbench`->contains->thing:`болт_m4×30_(банка)`;
CREATE thing:`гайка_m4×30_(банка)` SET kind = 'item', category = 'fastener', name = 'Гайка M4×30 (банка)', created_at = time::now(), quantity = 53;
RELATE thing:`garage_shelf_2`->contains->thing:`гайка_m4×30_(банка)`;
CREATE thing:`болт_m5×20_(банка)` SET kind = 'item', category = 'fastener', name = 'Болт M5×20 (банка)', created_at = time::now(), quantity = 40;
RELATE thing:`garage_workbench`->contains->thing:`болт_m5×20_(банка)`;
CREATE thing:`гайка_m5×20_(банка)` SET kind = 'item', category = 'fastener', name = 'Гайка M5×20 (банка)', created_at = time::now(), quantity = 76;
RELATE thing:`garage_shelf_4`->contains->thing:`гайка_m5×20_(банка)`;
CREATE thing:`болт_m5×30_(банка)` SET kind = 'item', category = 'fastener', name = 'Болт M5×30 (банка)', created_at = time::now(), quantity = 24;
RELATE thing:`garage_shelf_4`->contains->thing:`болт_m5×30_(банка)`;
CREATE thing:`гайка_m5×30_(банка)` SET kind = 'item', category = 'fastener', name = 'Гайка M5×30 (банка)', created_at = time::now(), quantity = 17;
RELATE thing:`garage_shelf_4`->contains->thing:`гайка_m5×30_(банка)`;
CREATE thing:`болт_m5×40_(банка)` SET kind = 'item', category = 'fastener', name = 'Болт M5×40 (банка)', created_at = time::now(), quantity = 28;
RELATE thing:`garage_shelf_5`->contains->thing:`болт_m5×40_(банка)`;
CREATE thing:`гайка_m5×40_(банка)` SET kind = 'item', category = 'fastener', name = 'Гайка M5×40 (банка)', created_at = time::now(), quantity = 109;
RELATE thing:`garage_shelf_2`->contains->thing:`гайка_m5×40_(банка)`;
CREATE thing:`болт_m6×20_(банка)` SET kind = 'item', category = 'fastener', name = 'Болт M6×20 (банка)', created_at = time::now(), quantity = 59;
RELATE thing:`garage_workbench`->contains->thing:`болт_m6×20_(банка)`;
CREATE thing:`гайка_m6×20_(банка)` SET kind = 'item', category = 'fastener', name = 'Гайка M6×20 (банка)', created_at = time::now(), quantity = 47;
RELATE thing:`garage_shelf_4`->contains->thing:`гайка_m6×20_(банка)`;
CREATE thing:`болт_m6×30_(банка)` SET kind = 'item', category = 'fastener', name = 'Болт M6×30 (банка)', created_at = time::now(), quantity = 104;
RELATE thing:`garage_shelf_4`->contains->thing:`болт_m6×30_(банка)`;
CREATE thing:`гайка_m6×30_(банка)` SET kind = 'item', category = 'fastener', name = 'Гайка M6×30 (банка)', created_at = time::now(), quantity = 78;
RELATE thing:`garage_workbench`->contains->thing:`гайка_m6×30_(банка)`;
CREATE thing:`болт_m6×40_(банка)` SET kind = 'item', category = 'fastener', name = 'Болт M6×40 (банка)', created_at = time::now(), quantity = 44;
RELATE thing:`garage_workbench`->contains->thing:`болт_m6×40_(банка)`;
CREATE thing:`гайка_m6×40_(банка)` SET kind = 'item', category = 'fastener', name = 'Гайка M6×40 (банка)', created_at = time::now(), quantity = 60;
RELATE thing:`garage_workbench`->contains->thing:`гайка_m6×40_(банка)`;
CREATE thing:`болт_m6×50_(банка)` SET kind = 'item', category = 'fastener', name = 'Болт M6×50 (банка)', created_at = time::now(), quantity = 196;
RELATE thing:`garage_shelf_1`->contains->thing:`болт_m6×50_(банка)`;
CREATE thing:`гайка_m6×50_(банка)` SET kind = 'item', category = 'fastener', name = 'Гайка M6×50 (банка)', created_at = time::now(), quantity = 17;
RELATE thing:`garage_shelf_3`->contains->thing:`гайка_m6×50_(банка)`;
CREATE thing:`болт_m6×60_(банка)` SET kind = 'item', category = 'fastener', name = 'Болт M6×60 (банка)', created_at = time::now(), quantity = 133;
RELATE thing:`garage_workbench`->contains->thing:`болт_m6×60_(банка)`;
CREATE thing:`гайка_m6×60_(банка)` SET kind = 'item', category = 'fastener', name = 'Гайка M6×60 (банка)', created_at = time::now(), quantity = 19;
RELATE thing:`garage_shelf_5`->contains->thing:`гайка_m6×60_(банка)`;
CREATE thing:`болт_m8×30_(банка)` SET kind = 'item', category = 'fastener', name = 'Болт M8×30 (банка)', created_at = time::now(), quantity = 52;
RELATE thing:`garage_shelf_5`->contains->thing:`болт_m8×30_(банка)`;
CREATE thing:`гайка_m8×30_(банка)` SET kind = 'item', category = 'fastener', name = 'Гайка M8×30 (банка)', created_at = time::now(), quantity = 177;
RELATE thing:`garage_shelf_1`->contains->thing:`гайка_m8×30_(банка)`;
CREATE thing:`болт_m8×40_(банка)` SET kind = 'item', category = 'fastener', name = 'Болт M8×40 (банка)', created_at = time::now(), quantity = 35;
RELATE thing:`garage_workbench`->contains->thing:`болт_m8×40_(банка)`;
CREATE thing:`гайка_m8×40_(банка)` SET kind = 'item', category = 'fastener', name = 'Гайка M8×40 (банка)', created_at = time::now(), quantity = 153;
RELATE thing:`garage_shelf_5`->contains->thing:`гайка_m8×40_(банка)`;
CREATE thing:`болт_m8×50_(банка)` SET kind = 'item', category = 'fastener', name = 'Болт M8×50 (банка)', created_at = time::now(), quantity = 163;
RELATE thing:`garage_shelf_5`->contains->thing:`болт_m8×50_(банка)`;
CREATE thing:`гайка_m8×50_(банка)` SET kind = 'item', category = 'fastener', name = 'Гайка M8×50 (банка)', created_at = time::now(), quantity = 173;
RELATE thing:`garage_workbench`->contains->thing:`гайка_m8×50_(банка)`;
CREATE thing:`болт_m10×40_(банка)` SET kind = 'item', category = 'fastener', name = 'Болт M10×40 (банка)', created_at = time::now(), quantity = 71;
RELATE thing:`garage_workbench`->contains->thing:`болт_m10×40_(банка)`;
CREATE thing:`гайка_m10×40_(банка)` SET kind = 'item', category = 'fastener', name = 'Гайка M10×40 (банка)', created_at = time::now(), quantity = 66;
RELATE thing:`garage_workbench`->contains->thing:`гайка_m10×40_(банка)`;
CREATE thing:`болт_m10×60_(банка)` SET kind = 'item', category = 'fastener', name = 'Болт M10×60 (банка)', created_at = time::now(), quantity = 38;
RELATE thing:`garage_workbench`->contains->thing:`болт_m10×60_(банка)`;
CREATE thing:`гайка_m10×60_(банка)` SET kind = 'item', category = 'fastener', name = 'Гайка M10×60 (банка)', created_at = time::now(), quantity = 85;
RELATE thing:`garage_workbench`->contains->thing:`гайка_m10×60_(банка)`;
CREATE thing:`шуруп_3×35_(банка)` SET kind = 'item', category = 'fastener', name = 'Шуруп 3×35 (банка)', created_at = time::now(), quantity = 122;
RELATE thing:`garage_shelf_1`->contains->thing:`шуруп_3×35_(банка)`;
CREATE thing:`шуруп_4×40_(банка)` SET kind = 'item', category = 'fastener', name = 'Шуруп 4×40 (банка)', created_at = time::now(), quantity = 23;
RELATE thing:`garage_shelf_5`->contains->thing:`шуруп_4×40_(банка)`;
CREATE thing:`шуруп_4×70_(банка)` SET kind = 'item', category = 'fastener', name = 'Шуруп 4×70 (банка)', created_at = time::now(), quantity = 134;
RELATE thing:`garage_shelf_5`->contains->thing:`шуруп_4×70_(банка)`;
CREATE thing:`шуруп_5×50_(банка)` SET kind = 'item', category = 'fastener', name = 'Шуруп 5×50 (банка)', created_at = time::now(), quantity = 94;
RELATE thing:`garage_shelf_3`->contains->thing:`шуруп_5×50_(банка)`;
CREATE thing:`шуруп_5×80_(банка)` SET kind = 'item', category = 'fastener', name = 'Шуруп 5×80 (банка)', created_at = time::now(), quantity = 99;
RELATE thing:`garage_shelf_1`->contains->thing:`шуруп_5×80_(банка)`;
CREATE thing:`шуруп_6×60_(банка)` SET kind = 'item', category = 'fastener', name = 'Шуруп 6×60 (банка)', created_at = time::now(), quantity = 117;
RELATE thing:`garage_shelf_3`->contains->thing:`шуруп_6×60_(банка)`;
CREATE thing:`шуруп_6×100_(банка)` SET kind = 'item', category = 'fastener', name = 'Шуруп 6×100 (банка)', created_at = time::now(), quantity = 161;
RELATE thing:`garage_workbench`->contains->thing:`шуруп_6×100_(банка)`;
CREATE thing:`саморез_3.2×12_(банка)` SET kind = 'item', category = 'fastener', name = 'Саморез 3.2×12 (банка)', created_at = time::now(), quantity = 175;
RELATE thing:`garage_shelf_5`->contains->thing:`саморез_3.2×12_(банка)`;
CREATE thing:`саморез_4.2×19_(банка)` SET kind = 'item', category = 'fastener', name = 'Саморез 4.2×19 (банка)', created_at = time::now(), quantity = 174;
RELATE thing:`garage_workbench`->contains->thing:`саморез_4.2×19_(банка)`;
CREATE thing:`саморез_4.8×25_(банка)` SET kind = 'item', category = 'fastener', name = 'Саморез 4.8×25 (банка)', created_at = time::now(), quantity = 72;
RELATE thing:`garage_shelf_1`->contains->thing:`саморез_4.8×25_(банка)`;
CREATE thing:`саморез_6.3×35_(банка)` SET kind = 'item', category = 'fastener', name = 'Саморез 6.3×35 (банка)', created_at = time::now(), quantity = 195;
RELATE thing:`garage_shelf_1`->contains->thing:`саморез_6.3×35_(банка)`;
CREATE thing:`дюбель_6×40_(пачка_50шт)` SET kind = 'item', category = 'fastener', name = 'Дюбель 6×40 (пачка 50шт)', created_at = time::now(), quantity = 74;
RELATE thing:`garage_shelf_5`->contains->thing:`дюбель_6×40_(пачка_50шт)`;
CREATE thing:`дюбель_8×60_(пачка_25шт)` SET kind = 'item', category = 'fastener', name = 'Дюбель 8×60 (пачка 25шт)', created_at = time::now(), quantity = 188;
RELATE thing:`garage_shelf_3`->contains->thing:`дюбель_8×60_(пачка_25шт)`;
CREATE thing:`дюбель_10×80` SET kind = 'item', category = 'fastener', name = 'Дюбель 10×80', created_at = time::now(), quantity = 180;
RELATE thing:`garage_shelf_3`->contains->thing:`дюбель_10×80`;
CREATE thing:`анкер_m8_(10шт)` SET kind = 'item', category = 'fastener', name = 'Анкер M8 (10шт)', created_at = time::now(), quantity = 69;
RELATE thing:`garage_workbench`->contains->thing:`анкер_m8_(10шт)`;
CREATE thing:`анкер_m10_(10шт)` SET kind = 'item', category = 'fastener', name = 'Анкер M10 (10шт)', created_at = time::now(), quantity = 167;
RELATE thing:`garage_shelf_1`->contains->thing:`анкер_m10_(10шт)`;
CREATE thing:`анкер_химический` SET kind = 'item', category = 'fastener', name = 'Анкер химический', created_at = time::now(), quantity = 16;
RELATE thing:`garage_workbench`->contains->thing:`анкер_химический`;
CREATE thing:`гвозди_60мм_(кг)` SET kind = 'item', category = 'fastener', name = 'Гвозди 60мм (кг)', created_at = time::now(), quantity = 38;
RELATE thing:`garage_workbench`->contains->thing:`гвозди_60мм_(кг)`;
CREATE thing:`гвозди_100мм_(кг)` SET kind = 'item', category = 'fastener', name = 'Гвозди 100мм (кг)', created_at = time::now(), quantity = 194;
RELATE thing:`garage_shelf_3`->contains->thing:`гвозди_100мм_(кг)`;
CREATE thing:`гвозди_финишные_30мм` SET kind = 'item', category = 'fastener', name = 'Гвозди финишные 30мм', created_at = time::now(), quantity = 148;
RELATE thing:`garage_workbench`->contains->thing:`гвозди_финишные_30мм`;
CREATE thing:`шпильки_м8_1м_(3шт)` SET kind = 'item', category = 'fastener', name = 'Шпильки М8 1м (3шт)', created_at = time::now(), quantity = 24;
RELATE thing:`garage_shelf_1`->contains->thing:`шпильки_м8_1м_(3шт)`;
CREATE thing:`шайбы_m6_(банка)` SET kind = 'item', category = 'fastener', name = 'Шайбы M6 (банка)', created_at = time::now(), quantity = 99;
RELATE thing:`garage_shelf_2`->contains->thing:`шайбы_m6_(банка)`;
CREATE thing:`шайбы_m8_(банка)` SET kind = 'item', category = 'fastener', name = 'Шайбы M8 (банка)', created_at = time::now(), quantity = 115;
RELATE thing:`garage_shelf_5`->contains->thing:`шайбы_m8_(банка)`;
CREATE thing:`шплинты_(набор)` SET kind = 'item', category = 'fastener', name = 'Шплинты (набор)', created_at = time::now(), quantity = 83;
RELATE thing:`garage_shelf_2`->contains->thing:`шплинты_(набор)`;
CREATE thing:`стопорные_кольца_(набор)` SET kind = 'item', category = 'fastener', name = 'Стопорные кольца (набор)', created_at = time::now(), quantity = 96;
RELATE thing:`garage_shelf_3`->contains->thing:`стопорные_кольца_(набор)`;
CREATE thing:`пружинные_шайбы_m6` SET kind = 'item', category = 'fastener', name = 'Пружинные шайбы M6', created_at = time::now(), quantity = 175;
RELATE thing:`garage_shelf_2`->contains->thing:`пружинные_шайбы_m6`;
CREATE thing:`масло_моторное_10w_40_(4л)` SET kind = 'item', category = 'auto_part', name = 'Масло моторное 10W-40 (4л)', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`масло_моторное_10w_40_(4л)`;
CREATE thing:`масло_моторное_5w_30_(4л)` SET kind = 'item', category = 'auto_part', name = 'Масло моторное 5W-30 (4л)', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`масло_моторное_5w_30_(4л)`;
CREATE thing:`масло_трансмиссионное_75w_90` SET kind = 'item', category = 'auto_part', name = 'Масло трансмиссионное 75W-90', created_at = time::now();
RELATE thing:`car_trunk`->contains->thing:`масло_трансмиссионное_75w_90`;
CREATE thing:`масло_вилочное_motul_5w` SET kind = 'item', category = 'auto_part', name = 'Масло вилочное Motul 5W', created_at = time::now();
RELATE thing:`garage_shelf_2`->contains->thing:`масло_вилочное_motul_5w`;
CREATE thing:`масло_для_цепи_мотоцикла` SET kind = 'item', category = 'auto_part', name = 'Масло для цепи мотоцикла', created_at = time::now();
RELATE thing:`garage_shelf_2`->contains->thing:`масло_для_цепи_мотоцикла`;
CREATE thing:`фильтр_масляный_bmw_r1250gs` SET kind = 'item', category = 'auto_part', name = 'Фильтр масляный BMW R1250GS', created_at = time::now();
RELATE thing:`garage_shelf_4`->contains->thing:`фильтр_масляный_bmw_r1250gs`;
CREATE thing:`фильтр_масляный_vesta` SET kind = 'item', category = 'auto_part', name = 'Фильтр масляный Vesta', created_at = time::now();
RELATE thing:`car_trunk`->contains->thing:`фильтр_масляный_vesta`;
CREATE thing:`фильтр_воздушный_bmw_r1250gs` SET kind = 'item', category = 'auto_part', name = 'Фильтр воздушный BMW R1250GS', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`фильтр_воздушный_bmw_r1250gs`;
CREATE thing:`фильтр_воздушный_vesta` SET kind = 'item', category = 'auto_part', name = 'Фильтр воздушный Vesta', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`фильтр_воздушный_vesta`;
CREATE thing:`фильтр_топливный_vesta` SET kind = 'item', category = 'auto_part', name = 'Фильтр топливный Vesta', created_at = time::now();
RELATE thing:`car_trunk`->contains->thing:`фильтр_топливный_vesta`;
CREATE thing:`фильтр_салонный_vesta` SET kind = 'item', category = 'auto_part', name = 'Фильтр салонный Vesta', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`фильтр_салонный_vesta`;
CREATE thing:`свечи_зажигания_bmw_(4шт)` SET kind = 'item', category = 'auto_part', name = 'Свечи зажигания BMW (4шт)', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`свечи_зажигания_bmw_(4шт)`;
CREATE thing:`свечи_зажигания_vesta_(4шт)` SET kind = 'item', category = 'auto_part', name = 'Свечи зажигания Vesta (4шт)', created_at = time::now();
RELATE thing:`garage_shelf_2`->contains->thing:`свечи_зажигания_vesta_(4шт)`;
CREATE thing:`тормозная_жидкость_dot4_(0.5л)` SET kind = 'item', category = 'auto_part', name = 'Тормозная жидкость DOT4 (0.5л)', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`тормозная_жидкость_dot4_(0.5л)`;
CREATE thing:`антифриз_g12_(1л)` SET kind = 'item', category = 'auto_part', name = 'Антифриз G12 (1л)', created_at = time::now();
RELATE thing:`garage_shelf_3`->contains->thing:`антифриз_g12_(1л)`;
CREATE thing:`охлаждающая_жидкость_bmw_(1л)` SET kind = 'item', category = 'auto_part', name = 'Охлаждающая жидкость BMW (1л)', created_at = time::now();
RELATE thing:`garage_shelf_2`->contains->thing:`охлаждающая_жидкость_bmw_(1л)`;
CREATE thing:`промывка_двигателя` SET kind = 'item', category = 'auto_part', name = 'Промывка двигателя', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`промывка_двигателя`;
CREATE thing:`очиститель_карбюратора` SET kind = 'item', category = 'auto_part', name = 'Очиститель карбюратора', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`очиститель_карбюратора`;
CREATE thing:`очиститель_тормозов` SET kind = 'item', category = 'auto_part', name = 'Очиститель тормозов', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`очиститель_тормозов`;
CREATE thing:`смазка_цепи_мотоцикла` SET kind = 'item', category = 'auto_part', name = 'Смазка цепи мотоцикла', created_at = time::now();
RELATE thing:`car_trunk`->contains->thing:`смазка_цепи_мотоцикла`;
CREATE thing:`смазка_графитовая` SET kind = 'item', category = 'auto_part', name = 'Смазка графитовая', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`смазка_графитовая`;
CREATE thing:`wd_40_(400мл)` SET kind = 'item', category = 'auto_part', name = 'WD-40 (400мл)', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`wd_40_(400мл)`;
CREATE thing:`медная_смазка` SET kind = 'item', category = 'auto_part', name = 'Медная смазка', created_at = time::now();
RELATE thing:`garage_shelf_1`->contains->thing:`медная_смазка`;
CREATE thing:`смазка_шрус` SET kind = 'item', category = 'auto_part', name = 'Смазка ШРУС', created_at = time::now();
RELATE thing:`garage_shelf_3`->contains->thing:`смазка_шрус`;
CREATE thing:`колодки_тормозные_bmw_передние` SET kind = 'item', category = 'auto_part', name = 'Колодки тормозные BMW передние', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`колодки_тормозные_bmw_передние`;
CREATE thing:`колодки_тормозные_vesta` SET kind = 'item', category = 'auto_part', name = 'Колодки тормозные Vesta', created_at = time::now();
RELATE thing:`garage_shelf_1`->contains->thing:`колодки_тормозные_vesta`;
CREATE thing:`диски_тормозные_vesta_передние` SET kind = 'item', category = 'auto_part', name = 'Диски тормозные Vesta передние', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`диски_тормозные_vesta_передние`;
CREATE thing:`ремень_грм_vesta_комплект` SET kind = 'item', category = 'auto_part', name = 'Ремень ГРМ Vesta комплект', created_at = time::now();
RELATE thing:`car_trunk`->contains->thing:`ремень_грм_vesta_комплект`;
CREATE thing:`ролики_натяжной_грм_vesta` SET kind = 'item', category = 'auto_part', name = 'Ролики натяжной ГРМ Vesta', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`ролики_натяжной_грм_vesta`;
CREATE thing:`помпа_vesta` SET kind = 'item', category = 'auto_part', name = 'Помпа Vesta', created_at = time::now();
RELATE thing:`car_trunk`->contains->thing:`помпа_vesta`;
CREATE thing:`аккумулятор_12v_55ah` SET kind = 'item', category = 'auto_part', name = 'Аккумулятор 12V 55Ah', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`аккумулятор_12v_55ah`;
CREATE thing:`клеммы_акб_(пара)` SET kind = 'item', category = 'auto_part', name = 'Клеммы АКБ (пара)', created_at = time::now();
RELATE thing:`garage_shelf_5`->contains->thing:`клеммы_акб_(пара)`;
CREATE thing:`провода_для_прикурки` SET kind = 'item', category = 'auto_part', name = 'Провода для прикурки', created_at = time::now();
RELATE thing:`garage_shelf_3`->contains->thing:`провода_для_прикурки`;
CREATE thing:`предохранители_набор` SET kind = 'item', category = 'auto_part', name = 'Предохранители набор', created_at = time::now();
RELATE thing:`garage_shelf_4`->contains->thing:`предохранители_набор`;
CREATE thing:`лампа_h4_(2шт)` SET kind = 'item', category = 'auto_part', name = 'Лампа H4 (2шт)', created_at = time::now();
RELATE thing:`car_trunk`->contains->thing:`лампа_h4_(2шт)`;
CREATE thing:`лампа_h7_(2шт)` SET kind = 'item', category = 'auto_part', name = 'Лампа H7 (2шт)', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`лампа_h7_(2шт)`;
CREATE thing:`лампы_w5w_(10шт)` SET kind = 'item', category = 'auto_part', name = 'Лампы W5W (10шт)', created_at = time::now();
RELATE thing:`garage_shelf_4`->contains->thing:`лампы_w5w_(10шт)`;
CREATE thing:`лампы_p21w_(5шт)` SET kind = 'item', category = 'auto_part', name = 'Лампы P21W (5шт)', created_at = time::now();
RELATE thing:`car_trunk`->contains->thing:`лампы_p21w_(5шт)`;
CREATE thing:`шина_зимняя_195_65_r15_(4шт)` SET kind = 'item', category = 'auto_part', name = 'Шина зимняя 195/65 R15 (4шт)', created_at = time::now();
RELATE thing:`car_trunk`->contains->thing:`шина_зимняя_195_65_r15_(4шт)`;
CREATE thing:`шина_летняя_195_65_r15_(4шт)` SET kind = 'item', category = 'auto_part', name = 'Шина летняя 195/65 R15 (4шт)', created_at = time::now();
RELATE thing:`car_trunk`->contains->thing:`шина_летняя_195_65_r15_(4шт)`;
CREATE thing:`диски_стальные_r15_(4шт)` SET kind = 'item', category = 'auto_part', name = 'Диски стальные R15 (4шт)', created_at = time::now();
RELATE thing:`car_trunk`->contains->thing:`диски_стальные_r15_(4шт)`;
CREATE thing:`гайки_колёсные_(5шт)` SET kind = 'item', category = 'auto_part', name = 'Гайки колёсные (5шт)', created_at = time::now();
RELATE thing:`car_trunk`->contains->thing:`гайки_колёсные_(5шт)`;
CREATE thing:`домкрат_подкатной_2т` SET kind = 'item', category = 'auto_part', name = 'Домкрат подкатной 2т', created_at = time::now();
RELATE thing:`garage_cabinet`->contains->thing:`домкрат_подкатной_2т`;
CREATE thing:`крюк_буксировочный` SET kind = 'item', category = 'auto_part', name = 'Крюк буксировочный', created_at = time::now();
RELATE thing:`car_trunk`->contains->thing:`крюк_буксировочный`;
CREATE thing:`знак_аварийный` SET kind = 'item', category = 'auto_part', name = 'Знак аварийный', created_at = time::now();
RELATE thing:`car_trunk`->contains->thing:`знак_аварийный`;
CREATE thing:`огнетушитель_1кг_(авто)` SET kind = 'item', category = 'auto_part', name = 'Огнетушитель 1кг (авто)', created_at = time::now();
RELATE thing:`garage_shelf_2`->contains->thing:`огнетушитель_1кг_(авто)`;
CREATE thing:`аптечка_автомобильная` SET kind = 'item', category = 'auto_part', name = 'Аптечка автомобильная', created_at = time::now();
RELATE thing:`car_trunk`->contains->thing:`аптечка_автомобильная`;
CREATE thing:`трос_буксировочный_5т` SET kind = 'item', category = 'auto_part', name = 'Трос буксировочный 5т', created_at = time::now();
RELATE thing:`car_trunk`->contains->thing:`трос_буксировочный_5т`;
CREATE thing:`цепи_противоскольжения_r15` SET kind = 'item', category = 'auto_part', name = 'Цепи противоскольжения R15', created_at = time::now();
RELATE thing:`car_trunk`->contains->thing:`цепи_противоскольжения_r15`;
CREATE thing:`кабель_ввг_2×1.5_(бухта_100м)` SET kind = 'item', category = 'electrical', name = 'Кабель ВВГ 2×1.5 (бухта 100м)', created_at = time::now();
RELATE thing:`garage_shelf_4`->contains->thing:`кабель_ввг_2×1.5_(бухта_100м)`;
CREATE thing:`кабель_ввг_3×1.5_(бухта_100м)` SET kind = 'item', category = 'electrical', name = 'Кабель ВВГ 3×1.5 (бухта 100м)', created_at = time::now();
RELATE thing:`apt_storage_shelf_1`->contains->thing:`кабель_ввг_3×1.5_(бухта_100м)`;
CREATE thing:`кабель_ввг_3×2.5_(бухта_50м)` SET kind = 'item', category = 'electrical', name = 'Кабель ВВГ 3×2.5 (бухта 50м)', created_at = time::now();
RELATE thing:`garage_shelf_5`->contains->thing:`кабель_ввг_3×2.5_(бухта_50м)`;
CREATE thing:`кабель_nym_3×2.5_(10м)` SET kind = 'item', category = 'electrical', name = 'Кабель NYM 3×2.5 (10м)', created_at = time::now();
RELATE thing:`storage_rack_3`->contains->thing:`кабель_nym_3×2.5_(10м)`;
CREATE thing:`провод_пвс_2×0.75_(бухта_50м)` SET kind = 'item', category = 'electrical', name = 'Провод ПВС 2×0.75 (бухта 50м)', created_at = time::now();
RELATE thing:`garage_shelf_2`->contains->thing:`провод_пвс_2×0.75_(бухта_50м)`;
CREATE thing:`провод_пугв_1.5мм_(катушка)` SET kind = 'item', category = 'electrical', name = 'Провод ПУГВ 1.5мм (катушка)', created_at = time::now();
RELATE thing:`garage_shelf_2`->contains->thing:`провод_пугв_1.5мм_(катушка)`;
CREATE thing:`гофра_16мм_(50м)` SET kind = 'item', category = 'electrical', name = 'Гофра 16мм (50м)', created_at = time::now();
RELATE thing:`garage_shelf_5`->contains->thing:`гофра_16мм_(50м)`;
CREATE thing:`гофра_20мм_(25м)` SET kind = 'item', category = 'electrical', name = 'Гофра 20мм (25м)', created_at = time::now();
RELATE thing:`apt_storage_shelf_3`->contains->thing:`гофра_20мм_(25м)`;
CREATE thing:`гофра_25мм_(25м)` SET kind = 'item', category = 'electrical', name = 'Гофра 25мм (25м)', created_at = time::now();
RELATE thing:`apt_storage_shelf_1`->contains->thing:`гофра_25мм_(25м)`;
CREATE thing:`кабель_канал_20×10_(2м)_×10шт` SET kind = 'item', category = 'electrical', name = 'Кабель-канал 20×10 (2м) ×10шт', created_at = time::now();
RELATE thing:`apt_storage_shelf_1`->contains->thing:`кабель_канал_20×10_(2м)_×10шт`;
CREATE thing:`кабель_канал_40×25_(2м)_×5шт` SET kind = 'item', category = 'electrical', name = 'Кабель-канал 40×25 (2м) ×5шт', created_at = time::now();
RELATE thing:`apt_storage_shelf_1`->contains->thing:`кабель_канал_40×25_(2м)_×5шт`;
CREATE thing:`розетка_накладная_(5шт)` SET kind = 'item', category = 'electrical', name = 'Розетка накладная (5шт)', created_at = time::now();
RELATE thing:`apt_storage_shelf_2`->contains->thing:`розетка_накладная_(5шт)`;
CREATE thing:`розетка_встраиваемая_(10шт)` SET kind = 'item', category = 'electrical', name = 'Розетка встраиваемая (10шт)', created_at = time::now();
RELATE thing:`storage_rack_6`->contains->thing:`розетка_встраиваемая_(10шт)`;
CREATE thing:`выключатель_одноклавишный_(5шт)` SET kind = 'item', category = 'electrical', name = 'Выключатель одноклавишный (5шт)', created_at = time::now();
RELATE thing:`garage_shelf_2`->contains->thing:`выключатель_одноклавишный_(5шт)`;
CREATE thing:`выключатель_двухклавишный_(3шт)` SET kind = 'item', category = 'electrical', name = 'Выключатель двухклавишный (3шт)', created_at = time::now();
RELATE thing:`storage_rack_1`->contains->thing:`выключатель_двухклавишный_(3шт)`;
CREATE thing:`патрон_е27_(10шт)` SET kind = 'item', category = 'electrical', name = 'Патрон Е27 (10шт)', created_at = time::now();
RELATE thing:`storage_rack_2`->contains->thing:`патрон_е27_(10шт)`;
CREATE thing:`патрон_е14_(10шт)` SET kind = 'item', category = 'electrical', name = 'Патрон Е14 (10шт)', created_at = time::now();
RELATE thing:`apt_storage_shelf_1`->contains->thing:`патрон_е14_(10шт)`;
CREATE thing:`лампа_led_e27_9w_4000k_(10шт)` SET kind = 'item', category = 'electrical', name = 'Лампа LED E27 9W 4000K (10шт)', created_at = time::now();
RELATE thing:`garage_shelf_4`->contains->thing:`лампа_led_e27_9w_4000k_(10шт)`;
CREATE thing:`лампа_led_e14_7w_(5шт)` SET kind = 'item', category = 'electrical', name = 'Лампа LED E14 7W (5шт)', created_at = time::now();
RELATE thing:`storage_rack_5`->contains->thing:`лампа_led_e14_7w_(5шт)`;
CREATE thing:`лента_led_5м_4000k` SET kind = 'item', category = 'electrical', name = 'Лента LED 5м 4000K', created_at = time::now();
RELATE thing:`storage_rack_5`->contains->thing:`лента_led_5м_4000k`;
CREATE thing:`блок_питания_12v_5a_для_led` SET kind = 'item', category = 'electrical', name = 'Блок питания 12V 5A для LED', created_at = time::now();
RELATE thing:`garage_shelf_2`->contains->thing:`блок_питания_12v_5a_для_led`;
CREATE thing:`автомат_16а_однополюсный_(5шт)` SET kind = 'item', category = 'electrical', name = 'Автомат 16А однополюсный (5шт)', created_at = time::now();
RELATE thing:`apt_storage_shelf_2`->contains->thing:`автомат_16а_однополюсный_(5шт)`;
CREATE thing:`автомат_25а_однополюсный` SET kind = 'item', category = 'electrical', name = 'Автомат 25А однополюсный', created_at = time::now();
RELATE thing:`storage_rack_3`->contains->thing:`автомат_25а_однополюсный`;
CREATE thing:`автомат_32а_двухполюсный` SET kind = 'item', category = 'electrical', name = 'Автомат 32А двухполюсный', created_at = time::now();
RELATE thing:`storage_rack_2`->contains->thing:`автомат_32а_двухполюсный`;
CREATE thing:`узо_16а_30ма` SET kind = 'item', category = 'electrical', name = 'УЗО 16А 30мА', created_at = time::now();
RELATE thing:`apt_storage_shelf_1`->contains->thing:`узо_16а_30ма`;
CREATE thing:`диф.автомат_16а_30ма` SET kind = 'item', category = 'electrical', name = 'Диф.автомат 16А 30мА', created_at = time::now();
RELATE thing:`garage_shelf_3`->contains->thing:`диф.автомат_16а_30ма`;
CREATE thing:`щиток_распределительный_12_мест` SET kind = 'item', category = 'electrical', name = 'Щиток распределительный 12 мест', created_at = time::now();
RELATE thing:`apt_storage_shelf_1`->contains->thing:`щиток_распределительный_12_мест`;
CREATE thing:`шина_нулевая` SET kind = 'item', category = 'electrical', name = 'Шина нулевая', created_at = time::now();
RELATE thing:`garage_shelf_2`->contains->thing:`шина_нулевая`;
CREATE thing:`клеммы_wago_2_контактные_(100шт)` SET kind = 'item', category = 'electrical', name = 'Клеммы Wago 2-контактные (100шт)', created_at = time::now();
RELATE thing:`storage_rack_1`->contains->thing:`клеммы_wago_2_контактные_(100шт)`;
CREATE thing:`клеммы_wago_3_контактные_(50шт)` SET kind = 'item', category = 'electrical', name = 'Клеммы Wago 3-контактные (50шт)', created_at = time::now();
RELATE thing:`storage_rack_5`->contains->thing:`клеммы_wago_3_контактные_(50шт)`;
CREATE thing:`изолента_пвх_чёрная_(5_рулонов)` SET kind = 'item', category = 'electrical', name = 'Изолента ПВХ чёрная (5 рулонов)', created_at = time::now();
RELATE thing:`storage_rack_2`->contains->thing:`изолента_пвх_чёрная_(5_рулонов)`;
CREATE thing:`изолента_пвх_синяя` SET kind = 'item', category = 'electrical', name = 'Изолента ПВХ синяя', created_at = time::now();
RELATE thing:`garage_shelf_1`->contains->thing:`изолента_пвх_синяя`;
CREATE thing:`термоусадка_набор` SET kind = 'item', category = 'electrical', name = 'Термоусадка набор', created_at = time::now();
RELATE thing:`storage_rack_4`->contains->thing:`термоусадка_набор`;
CREATE thing:`скотч_малярный_19мм_(5шт)` SET kind = 'item', category = 'electrical', name = 'Скотч малярный 19мм (5шт)', created_at = time::now();
RELATE thing:`storage_rack_7`->contains->thing:`скотч_малярный_19мм_(5шт)`;
CREATE thing:`распределительная_коробка_ip55_(3шт)` SET kind = 'item', category = 'electrical', name = 'Распределительная коробка IP55 (3шт)', created_at = time::now();
RELATE thing:`garage_shelf_5`->contains->thing:`распределительная_коробка_ip55_(3шт)`;
CREATE thing:`заглушки_для_кабель_канала` SET kind = 'item', category = 'electrical', name = 'Заглушки для кабель-канала', created_at = time::now();
RELATE thing:`storage_rack_4`->contains->thing:`заглушки_для_кабель_канала`;
CREATE thing:`удлинитель_5м_4_розетки` SET kind = 'item', category = 'electrical', name = 'Удлинитель 5м 4 розетки', created_at = time::now();
RELATE thing:`storage_rack_4`->contains->thing:`удлинитель_5м_4_розетки`;
CREATE thing:`удлинитель_10м_3_розетки` SET kind = 'item', category = 'electrical', name = 'Удлинитель 10м 3 розетки', created_at = time::now();
RELATE thing:`garage_shelf_4`->contains->thing:`удлинитель_10м_3_розетки`;
CREATE thing:`сетевой_фильтр_6_розеток` SET kind = 'item', category = 'electrical', name = 'Сетевой фильтр 6 розеток', created_at = time::now();
RELATE thing:`apt_storage_shelf_1`->contains->thing:`сетевой_фильтр_6_розеток`;
CREATE thing:`ибп_650va` SET kind = 'item', category = 'electrical', name = 'ИБП 650VA', created_at = time::now();
RELATE thing:`storage_rack_5`->contains->thing:`ибп_650va`;
CREATE thing:`прокладка_резиновая_1_2"_(пачка)` SET kind = 'item', category = 'plumbing', name = 'Прокладка резиновая 1/2" (пачка)', created_at = time::now();
RELATE thing:`apt_storage_shelf_3`->contains->thing:`прокладка_резиновая_1_2"_(пачка)`;
CREATE thing:`прокладка_резиновая_3_4"_(пачка)` SET kind = 'item', category = 'plumbing', name = 'Прокладка резиновая 3/4" (пачка)', created_at = time::now();
RELATE thing:`apt_storage_shelf_3`->contains->thing:`прокладка_резиновая_3_4"_(пачка)`;
CREATE thing:`лента_фум_(5_мотков)` SET kind = 'item', category = 'plumbing', name = 'Лента ФУМ (5 мотков)', created_at = time::now();
RELATE thing:`apt_storage_shelf_2`->contains->thing:`лента_фум_(5_мотков)`;
CREATE thing:`пакля_сантехническая` SET kind = 'item', category = 'plumbing', name = 'Пакля сантехническая', created_at = time::now();
RELATE thing:`storage_rack_4`->contains->thing:`пакля_сантехническая`;
CREATE thing:`угол_1_2"_американка` SET kind = 'item', category = 'plumbing', name = 'Угол 1/2" американка', created_at = time::now();
RELATE thing:`storage_rack_4`->contains->thing:`угол_1_2"_американка`;
CREATE thing:`тройник_1_2"` SET kind = 'item', category = 'plumbing', name = 'Тройник 1/2"', created_at = time::now();
RELATE thing:`storage_rack_4`->contains->thing:`тройник_1_2"`;
CREATE thing:`муфта_1_2"` SET kind = 'item', category = 'plumbing', name = 'Муфта 1/2"', created_at = time::now();
RELATE thing:`apt_storage_shelf_2`->contains->thing:`муфта_1_2"`;
CREATE thing:`кран_шаровый_1_2"_прямой` SET kind = 'item', category = 'plumbing', name = 'Кран шаровый 1/2" прямой', created_at = time::now();
RELATE thing:`apt_storage_shelf_2`->contains->thing:`кран_шаровый_1_2"_прямой`;
CREATE thing:`кран_шаровый_3_4"` SET kind = 'item', category = 'plumbing', name = 'Кран шаровый 3/4"', created_at = time::now();
RELATE thing:`apt_storage_shelf_2`->contains->thing:`кран_шаровый_3_4"`;
CREATE thing:`фильтр_грубой_очистки_3_4"` SET kind = 'item', category = 'plumbing', name = 'Фильтр грубой очистки 3/4"', created_at = time::now();
RELATE thing:`apt_storage_shelf_3`->contains->thing:`фильтр_грубой_очистки_3_4"`;
CREATE thing:`редуктор_давления_3_4"` SET kind = 'item', category = 'plumbing', name = 'Редуктор давления 3/4"', created_at = time::now();
RELATE thing:`apt_storage_shelf_1`->contains->thing:`редуктор_давления_3_4"`;
CREATE thing:`гибкая_подводка_60см_(2шт)` SET kind = 'item', category = 'plumbing', name = 'Гибкая подводка 60см (2шт)', created_at = time::now();
RELATE thing:`apt_storage_shelf_3`->contains->thing:`гибкая_подводка_60см_(2шт)`;
CREATE thing:`гибкая_подводка_80см` SET kind = 'item', category = 'plumbing', name = 'Гибкая подводка 80см', created_at = time::now();
RELATE thing:`apt_storage_shelf_1`->contains->thing:`гибкая_подводка_80см`;
CREATE thing:`сифон_для_раковины` SET kind = 'item', category = 'plumbing', name = 'Сифон для раковины', created_at = time::now();
RELATE thing:`storage_rack_2`->contains->thing:`сифон_для_раковины`;
CREATE thing:`сифон_для_ванной` SET kind = 'item', category = 'plumbing', name = 'Сифон для ванной', created_at = time::now();
RELATE thing:`storage_rack_3`->contains->thing:`сифон_для_ванной`;
CREATE thing:`труба_пп_20мм_(2м)_×5шт` SET kind = 'item', category = 'plumbing', name = 'Труба ПП 20мм (2м) ×5шт', created_at = time::now();
RELATE thing:`apt_storage_shelf_1`->contains->thing:`труба_пп_20мм_(2м)_×5шт`;
CREATE thing:`труба_пп_25мм_(2м)_×3шт` SET kind = 'item', category = 'plumbing', name = 'Труба ПП 25мм (2м) ×3шт', created_at = time::now();
RELATE thing:`apt_storage_shelf_2`->contains->thing:`труба_пп_25мм_(2м)_×3шт`;
CREATE thing:`паяльник_для_пп_труб` SET kind = 'item', category = 'plumbing', name = 'Паяльник для ПП труб', created_at = time::now();
RELATE thing:`storage_rack_4`->contains->thing:`паяльник_для_пп_труб`;
CREATE thing:`ножницы_для_труб` SET kind = 'item', category = 'plumbing', name = 'Ножницы для труб', created_at = time::now();
RELATE thing:`apt_storage_shelf_3`->contains->thing:`ножницы_для_труб`;
CREATE thing:`герметик_силиконовый_белый_(3шт)` SET kind = 'item', category = 'plumbing', name = 'Герметик силиконовый белый (3шт)', created_at = time::now();
RELATE thing:`apt_storage_shelf_3`->contains->thing:`герметик_силиконовый_белый_(3шт)`;
CREATE thing:`герметик_сантехнический_прозрачный` SET kind = 'item', category = 'plumbing', name = 'Герметик сантехнический прозрачный', created_at = time::now();
RELATE thing:`apt_storage_shelf_3`->contains->thing:`герметик_сантехнический_прозрачный`;
CREATE thing:`монтажная_пена_750мл_(3шт)` SET kind = 'item', category = 'plumbing', name = 'Монтажная пена 750мл (3шт)', created_at = time::now();
RELATE thing:`storage_rack_1`->contains->thing:`монтажная_пена_750мл_(3шт)`;
CREATE thing:`монтажная_пена_огнестойкая` SET kind = 'item', category = 'plumbing', name = 'Монтажная пена огнестойкая', created_at = time::now();
RELATE thing:`storage_rack_4`->contains->thing:`монтажная_пена_огнестойкая`;
CREATE thing:`шпаклёвка_финишная_knauf_25кг` SET kind = 'item', category = 'construction', name = 'Шпаклёвка финишная Knauf 25кг', created_at = time::now();
RELATE thing:`dacha_shed_shelf_3`->contains->thing:`шпаклёвка_финишная_knauf_25кг`;
CREATE thing:`шпаклёвка_стартовая_25кг` SET kind = 'item', category = 'construction', name = 'Шпаклёвка стартовая 25кг', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`шпаклёвка_стартовая_25кг`;
CREATE thing:`штукатурка_knauf_rotband_30кг` SET kind = 'item', category = 'construction', name = 'Штукатурка Knauf Rotband 30кг', created_at = time::now();
RELATE thing:`storage_rack_7`->contains->thing:`штукатурка_knauf_rotband_30кг`;
CREATE thing:`грунтовка_глубокого_проникновения_10л` SET kind = 'item', category = 'construction', name = 'Грунтовка глубокого проникновения 10л', created_at = time::now();
RELATE thing:`dacha_shed_shelf_2`->contains->thing:`грунтовка_глубокого_проникновения_10л`;
CREATE thing:`грунтовка_бетонконтакт_5л` SET kind = 'item', category = 'construction', name = 'Грунтовка бетонконтакт 5л', created_at = time::now();
RELATE thing:`dacha_shed_shelf_2`->contains->thing:`грунтовка_бетонконтакт_5л`;
CREATE thing:`клей_плиточный_25кг_(3_мешка)` SET kind = 'item', category = 'construction', name = 'Клей плиточный 25кг (3 мешка)', created_at = time::now();
RELATE thing:`storage_rack_2`->contains->thing:`клей_плиточный_25кг_(3_мешка)`;
CREATE thing:`затирка_для_плитки_белая_2кг` SET kind = 'item', category = 'construction', name = 'Затирка для плитки белая 2кг', created_at = time::now();
RELATE thing:`dacha_shed_shelf_3`->contains->thing:`затирка_для_плитки_белая_2кг`;
CREATE thing:`затирка_серая_2кг` SET kind = 'item', category = 'construction', name = 'Затирка серая 2кг', created_at = time::now();
RELATE thing:`dacha_shed_shelf_3`->contains->thing:`затирка_серая_2кг`;
CREATE thing:`клей_обойный_универсальный_(5шт)` SET kind = 'item', category = 'construction', name = 'Клей обойный универсальный (5шт)', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`клей_обойный_универсальный_(5шт)`;
CREATE thing:`уайт_спирит_1л_(3шт)` SET kind = 'item', category = 'construction', name = 'Уайт-спирит 1л (3шт)', created_at = time::now();
RELATE thing:`dacha_shed_shelf_3`->contains->thing:`уайт_спирит_1л_(3шт)`;
CREATE thing:`растворитель_646_1л` SET kind = 'item', category = 'construction', name = 'Растворитель 646 1л', created_at = time::now();
RELATE thing:`storage_rack_3`->contains->thing:`растворитель_646_1л`;
CREATE thing:`ацетон_1л` SET kind = 'item', category = 'construction', name = 'Ацетон 1л', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`ацетон_1л`;
CREATE thing:`бензин_калоша_1л` SET kind = 'item', category = 'construction', name = 'Бензин Калоша 1л', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`бензин_калоша_1л`;
CREATE thing:`краска_водоэмульсионная_белая_10л` SET kind = 'item', category = 'construction', name = 'Краска водоэмульсионная белая 10л', created_at = time::now();
RELATE thing:`dacha_shed_shelf_3`->contains->thing:`краска_водоэмульсионная_белая_10л`;
CREATE thing:`краска_для_потолков_5л` SET kind = 'item', category = 'construction', name = 'Краска для потолков 5л', created_at = time::now();
RELATE thing:`storage_rack_4`->contains->thing:`краска_для_потолков_5л`;
CREATE thing:`эмаль_пф_115_белая_2.5кг` SET kind = 'item', category = 'construction', name = 'Эмаль ПФ-115 белая 2.5кг', created_at = time::now();
RELATE thing:`storage_rack_4`->contains->thing:`эмаль_пф_115_белая_2.5кг`;
CREATE thing:`лак_паркетный_2.5л` SET kind = 'item', category = 'construction', name = 'Лак паркетный 2.5л', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`лак_паркетный_2.5л`;
CREATE thing:`морилка_для_дерева_(3_цвета)` SET kind = 'item', category = 'construction', name = 'Морилка для дерева (3 цвета)', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`морилка_для_дерева_(3_цвета)`;
CREATE thing:`антисептик_для_дерева_5л` SET kind = 'item', category = 'construction', name = 'Антисептик для дерева 5л', created_at = time::now();
RELATE thing:`dacha_shed_shelf_3`->contains->thing:`антисептик_для_дерева_5л`;
CREATE thing:`сетка_штукатурная_фасадная_(рулон)` SET kind = 'item', category = 'construction', name = 'Сетка штукатурная фасадная (рулон)', created_at = time::now();
RELATE thing:`storage_rack_3`->contains->thing:`сетка_штукатурная_фасадная_(рулон)`;
CREATE thing:`стеклохолст_малярный_(рулон)` SET kind = 'item', category = 'construction', name = 'Стеклохолст малярный (рулон)', created_at = time::now();
RELATE thing:`storage_rack_5`->contains->thing:`стеклохолст_малярный_(рулон)`;
CREATE thing:`пена_монтажная_профессиональная_(5шт)` SET kind = 'item', category = 'construction', name = 'Пена монтажная профессиональная (5шт)', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`пена_монтажная_профессиональная_(5шт)`;
CREATE thing:`пена_зимняя__10°c` SET kind = 'item', category = 'construction', name = 'Пена зимняя -10°C', created_at = time::now();
RELATE thing:`storage_rack_4`->contains->thing:`пена_зимняя__10°c`;
CREATE thing:`гипсокартон_12.5мм_(5_листов)` SET kind = 'item', category = 'construction', name = 'Гипсокартон 12.5мм (5 листов)', created_at = time::now();
RELATE thing:`dacha_shed_shelf_2`->contains->thing:`гипсокартон_12.5мм_(5_листов)`;
CREATE thing:`гкл_влагостойкий_(3_листа)` SET kind = 'item', category = 'construction', name = 'ГКЛ влагостойкий (3 листа)', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`гкл_влагостойкий_(3_листа)`;
CREATE thing:`профиль_cd_3м_(20шт)` SET kind = 'item', category = 'construction', name = 'Профиль CD 3м (20шт)', created_at = time::now();
RELATE thing:`storage_rack_7`->contains->thing:`профиль_cd_3м_(20шт)`;
CREATE thing:`профиль_ud_3м_(10шт)` SET kind = 'item', category = 'construction', name = 'Профиль UD 3м (10шт)', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`профиль_ud_3м_(10шт)`;
CREATE thing:`подвес_прямой_(50шт)` SET kind = 'item', category = 'construction', name = 'Подвес прямой (50шт)', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`подвес_прямой_(50шт)`;
CREATE thing:`лист_osb_9мм` SET kind = 'item', category = 'construction', name = 'Лист OSB 9мм', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`лист_osb_9мм`;
CREATE thing:`фанера_10мм_1.5×1.5` SET kind = 'item', category = 'construction', name = 'Фанера 10мм 1.5×1.5', created_at = time::now();
RELATE thing:`dacha_shed_shelf_3`->contains->thing:`фанера_10мм_1.5×1.5`;
CREATE thing:`вагонка_сосна_(10_штук)` SET kind = 'item', category = 'construction', name = 'Вагонка сосна (10 штук)', created_at = time::now();
RELATE thing:`dacha_shed_shelf_2`->contains->thing:`вагонка_сосна_(10_штук)`;
CREATE thing:`лопата_штыковая` SET kind = 'item', category = 'garden_tool', name = 'Лопата штыковая', created_at = time::now();
RELATE thing:`dacha_shed_shelf_3`->contains->thing:`лопата_штыковая`;
CREATE thing:`лопата_совковая` SET kind = 'item', category = 'garden_tool', name = 'Лопата совковая', created_at = time::now();
RELATE thing:`dacha_garden`->contains->thing:`лопата_совковая`;
CREATE thing:`вилы_садовые_4_зубые` SET kind = 'item', category = 'garden_tool', name = 'Вилы садовые 4-зубые', created_at = time::now();
RELATE thing:`dacha_shed_shelf_2`->contains->thing:`вилы_садовые_4_зубые`;
CREATE thing:`грабли_12_зубые` SET kind = 'item', category = 'garden_tool', name = 'Грабли 12-зубые', created_at = time::now();
RELATE thing:`dacha_shed_shelf_2`->contains->thing:`грабли_12_зубые`;
CREATE thing:`грабли_веерные` SET kind = 'item', category = 'garden_tool', name = 'Грабли веерные', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`грабли_веерные`;
CREATE thing:`тяпка` SET kind = 'item', category = 'garden_tool', name = 'Тяпка', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`тяпка`;
CREATE thing:`мотыга` SET kind = 'item', category = 'garden_tool', name = 'Мотыга', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`мотыга`;
CREATE thing:`коса_триммерная` SET kind = 'item', category = 'garden_tool', name = 'Коса триммерная', created_at = time::now();
RELATE thing:`dacha_garden`->contains->thing:`коса_триммерная`;
CREATE thing:`ручной_культиватор` SET kind = 'item', category = 'garden_tool', name = 'Ручной культиватор', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`ручной_культиватор`;
CREATE thing:`окучник` SET kind = 'item', category = 'garden_tool', name = 'Окучник', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`окучник`;
CREATE thing:`шланг_садовый_20м` SET kind = 'item', category = 'garden_tool', name = 'Шланг садовый 20м', created_at = time::now();
RELATE thing:`dacha_shed_shelf_3`->contains->thing:`шланг_садовый_20м`;
CREATE thing:`шланг_садовый_30м` SET kind = 'item', category = 'garden_tool', name = 'Шланг садовый 30м', created_at = time::now();
RELATE thing:`dacha_garden`->contains->thing:`шланг_садовый_30м`;
CREATE thing:`рассекатель_для_шланга` SET kind = 'item', category = 'garden_tool', name = 'Рассекатель для шланга', created_at = time::now();
RELATE thing:`dacha_garden`->contains->thing:`рассекатель_для_шланга`;
CREATE thing:`пистолет_для_полива` SET kind = 'item', category = 'garden_tool', name = 'Пистолет для полива', created_at = time::now();
RELATE thing:`dacha_shed_shelf_3`->contains->thing:`пистолет_для_полива`;
CREATE thing:`коннекторы_для_шланга_(набор)` SET kind = 'item', category = 'garden_tool', name = 'Коннекторы для шланга (набор)', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`коннекторы_для_шланга_(набор)`;
CREATE thing:`лейка_10л` SET kind = 'item', category = 'garden_tool', name = 'Лейка 10л', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`лейка_10л`;
CREATE thing:`лейка_5л` SET kind = 'item', category = 'garden_tool', name = 'Лейка 5л', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`лейка_5л`;
CREATE thing:`секатор_садовый` SET kind = 'item', category = 'garden_tool', name = 'Секатор садовый', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`секатор_садовый`;
CREATE thing:`сучкорез` SET kind = 'item', category = 'garden_tool', name = 'Сучкорез', created_at = time::now();
RELATE thing:`dacha_garden`->contains->thing:`сучкорез`;
CREATE thing:`ножницы_садовые_для_живой_изгороди` SET kind = 'item', category = 'garden_tool', name = 'Ножницы садовые для живой изгороди', created_at = time::now();
RELATE thing:`dacha_shed_shelf_1`->contains->thing:`ножницы_садовые_для_живой_изгороди`;
CREATE thing:`пила_садовая_складная` SET kind = 'item', category = 'garden_tool', name = 'Пила садовая складная', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`пила_садовая_складная`;
CREATE thing:`серп` SET kind = 'item', category = 'garden_tool', name = 'Серп', created_at = time::now();
RELATE thing:`dacha_shed_shelf_3`->contains->thing:`серп`;
CREATE thing:`удобрение_кемира_(1кг)` SET kind = 'item', category = 'garden_tool', name = 'Удобрение Кемира (1кг)', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`удобрение_кемира_(1кг)`;
CREATE thing:`удобрение_нитрофоска_(1кг)` SET kind = 'item', category = 'garden_tool', name = 'Удобрение Нитрофоска (1кг)', created_at = time::now();
RELATE thing:`dacha_shed_shelf_3`->contains->thing:`удобрение_нитрофоска_(1кг)`;
CREATE thing:`зола_(мешок)` SET kind = 'item', category = 'garden_tool', name = 'Зола (мешок)', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`зола_(мешок)`;
CREATE thing:`торф_(мешок)` SET kind = 'item', category = 'garden_tool', name = 'Торф (мешок)', created_at = time::now();
RELATE thing:`dacha_shed_shelf_3`->contains->thing:`торф_(мешок)`;
CREATE thing:`агроволокно_3.2м_(10м)` SET kind = 'item', category = 'garden_tool', name = 'Агроволокно 3.2м (10м)', created_at = time::now();
RELATE thing:`dacha_shed_shelf_2`->contains->thing:`агроволокно_3.2м_(10м)`;
CREATE thing:`колышки_деревянные_(50шт)` SET kind = 'item', category = 'garden_tool', name = 'Колышки деревянные (50шт)', created_at = time::now();
RELATE thing:`dacha_shed_shelf_2`->contains->thing:`колышки_деревянные_(50шт)`;
CREATE thing:`сетка_от_вредителей_(рулон)` SET kind = 'item', category = 'garden_tool', name = 'Сетка от вредителей (рулон)', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`сетка_от_вредителей_(рулон)`;
CREATE thing:`горшки_пластиковые_5л_(10шт)` SET kind = 'item', category = 'garden_tool', name = 'Горшки пластиковые 5л (10шт)', created_at = time::now();
RELATE thing:`dacha_shed_shelf_2`->contains->thing:`горшки_пластиковые_5л_(10шт)`;
CREATE thing:`поддоны_для_горшков_(10шт)` SET kind = 'item', category = 'garden_tool', name = 'Поддоны для горшков (10шт)', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`поддоны_для_горшков_(10шт)`;
CREATE thing:`рассадные_кассеты` SET kind = 'item', category = 'garden_tool', name = 'Рассадные кассеты', created_at = time::now();
RELATE thing:`dacha_shed_shelf_2`->contains->thing:`рассадные_кассеты`;
CREATE thing:`тачка_садовая_100л` SET kind = 'item', category = 'garden_tool', name = 'Тачка садовая 100л', created_at = time::now();
RELATE thing:`dacha_garden`->contains->thing:`тачка_садовая_100л`;
CREATE thing:`носилки_строительные` SET kind = 'item', category = 'garden_tool', name = 'Носилки строительные', created_at = time::now();
RELATE thing:`dacha_garden`->contains->thing:`носилки_строительные`;
CREATE thing:`ведро_оцинкованное_12л_(2шт)` SET kind = 'item', category = 'garden_tool', name = 'Ведро оцинкованное 12л (2шт)', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`ведро_оцинкованное_12л_(2шт)`;
CREATE thing:`ведро_пластиковое_10л_(3шт)` SET kind = 'item', category = 'garden_tool', name = 'Ведро пластиковое 10л (3шт)', created_at = time::now();
RELATE thing:`dacha_garden`->contains->thing:`ведро_пластиковое_10л_(3шт)`;
CREATE thing:`бак_для_воды_200л_(на_даче)` SET kind = 'item', category = 'garden_tool', name = 'Бак для воды 200л (на даче)', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`бак_для_воды_200л_(на_даче)`;
CREATE thing:`рукомойник_дачный` SET kind = 'item', category = 'garden_tool', name = 'Рукомойник дачный', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`рукомойник_дачный`;
CREATE thing:`моющее_для_посуды_(запас_5шт)` SET kind = 'item', category = 'household', name = 'Моющее для посуды (запас 5шт)', created_at = time::now();
RELATE thing:`apt_storage_shelf_3`->contains->thing:`моющее_для_посуды_(запас_5шт)`;
CREATE thing:`средство_для_мытья_окон_(3шт)` SET kind = 'item', category = 'household', name = 'Средство для мытья окон (3шт)', created_at = time::now();
RELATE thing:`storage_rack_5`->contains->thing:`средство_для_мытья_окон_(3шт)`;
CREATE thing:`средство_для_унитаза_(3шт)` SET kind = 'item', category = 'household', name = 'Средство для унитаза (3шт)', created_at = time::now();
RELATE thing:`storage_rack_7`->contains->thing:`средство_для_унитаза_(3шт)`;
CREATE thing:`чистящее_для_ванной_(3шт)` SET kind = 'item', category = 'household', name = 'Чистящее для ванной (3шт)', created_at = time::now();
RELATE thing:`apt_storage_shelf_2`->contains->thing:`чистящее_для_ванной_(3шт)`;
CREATE thing:`отбеливатель_1л` SET kind = 'item', category = 'household', name = 'Отбеливатель 1л', created_at = time::now();
RELATE thing:`storage_rack_7`->contains->thing:`отбеливатель_1л`;
CREATE thing:`пятновыводитель` SET kind = 'item', category = 'household', name = 'Пятновыводитель', created_at = time::now();
RELATE thing:`storage_rack_3`->contains->thing:`пятновыводитель`;
CREATE thing:`порошок_стиральный_3кг_(2шт)` SET kind = 'item', category = 'household', name = 'Порошок стиральный 3кг (2шт)', created_at = time::now();
RELATE thing:`storage_rack_1`->contains->thing:`порошок_стиральный_3кг_(2шт)`;
CREATE thing:`кондиционер_для_белья_1л` SET kind = 'item', category = 'household', name = 'Кондиционер для белья 1л', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`кондиционер_для_белья_1л`;
CREATE thing:`таблетки_для_посудомойки_(60шт)` SET kind = 'item', category = 'household', name = 'Таблетки для посудомойки (60шт)', created_at = time::now();
RELATE thing:`apt_storage_shelf_3`->contains->thing:`таблетки_для_посудомойки_(60шт)`;
CREATE thing:`соль_для_посудомойки_2кг` SET kind = 'item', category = 'household', name = 'Соль для посудомойки 2кг', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`соль_для_посудомойки_2кг`;
CREATE thing:`ополаскиватель_для_посудомойки` SET kind = 'item', category = 'household', name = 'Ополаскиватель для посудомойки', created_at = time::now();
RELATE thing:`storage_rack_2`->contains->thing:`ополаскиватель_для_посудомойки`;
CREATE thing:`мешки_для_мусора_60л_(100шт)` SET kind = 'item', category = 'household', name = 'Мешки для мусора 60л (100шт)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`мешки_для_мусора_60л_(100шт)`;
CREATE thing:`мешки_для_мусора_120л_(20шт)` SET kind = 'item', category = 'household', name = 'Мешки для мусора 120л (20шт)', created_at = time::now();
RELATE thing:`storage_rack_4`->contains->thing:`мешки_для_мусора_120л_(20шт)`;
CREATE thing:`пакеты_зип_лок_(набор)` SET kind = 'item', category = 'household', name = 'Пакеты зип-лок (набор)', created_at = time::now();
RELATE thing:`apt_storage_shelf_3`->contains->thing:`пакеты_зип_лок_(набор)`;
CREATE thing:`пищевая_плёнка_(рулон)` SET kind = 'item', category = 'household', name = 'Пищевая плёнка (рулон)', created_at = time::now();
RELATE thing:`apt_storage_shelf_1`->contains->thing:`пищевая_плёнка_(рулон)`;
CREATE thing:`фольга_(рулон)` SET kind = 'item', category = 'household', name = 'Фольга (рулон)', created_at = time::now();
RELATE thing:`storage_rack_3`->contains->thing:`фольга_(рулон)`;
CREATE thing:`пергамент_(рулон)` SET kind = 'item', category = 'household', name = 'Пергамент (рулон)', created_at = time::now();
RELATE thing:`storage_rack_1`->contains->thing:`пергамент_(рулон)`;
CREATE thing:`свечи_хозяйственные_(10шт)` SET kind = 'item', category = 'household', name = 'Свечи хозяйственные (10шт)', created_at = time::now();
RELATE thing:`storage_rack_3`->contains->thing:`свечи_хозяйственные_(10шт)`;
CREATE thing:`спички_(10_коробков)` SET kind = 'item', category = 'household', name = 'Спички (10 коробков)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`спички_(10_коробков)`;
CREATE thing:`зажигалки_(5шт)` SET kind = 'item', category = 'household', name = 'Зажигалки (5шт)', created_at = time::now();
RELATE thing:`storage_rack_1`->contains->thing:`зажигалки_(5шт)`;
CREATE thing:`батарейки_aa_(30шт)` SET kind = 'item', category = 'household', name = 'Батарейки AA (30шт)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`батарейки_aa_(30шт)`;
CREATE thing:`батарейки_aaa_(20шт)` SET kind = 'item', category = 'household', name = 'Батарейки AAA (20шт)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`батарейки_aaa_(20шт)`;
CREATE thing:`батарейки_d_(4шт)` SET kind = 'item', category = 'household', name = 'Батарейки D (4шт)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`батарейки_d_(4шт)`;
CREATE thing:`батарейки_крона_(5шт)` SET kind = 'item', category = 'household', name = 'Батарейки Крона (5шт)', created_at = time::now();
RELATE thing:`storage_rack_5`->contains->thing:`батарейки_крона_(5шт)`;
CREATE thing:`аккумуляторы_aa_2600мач_(4шт)` SET kind = 'item', category = 'household', name = 'Аккумуляторы AA 2600мАч (4шт)', created_at = time::now();
RELATE thing:`apt_storage_shelf_3`->contains->thing:`аккумуляторы_aa_2600мач_(4шт)`;
CREATE thing:`зарядник_для_аккумуляторов` SET kind = 'item', category = 'household', name = 'Зарядник для аккумуляторов', created_at = time::now();
RELATE thing:`storage_rack_4`->contains->thing:`зарядник_для_аккумуляторов`;
CREATE thing:`power_bank_20000мач` SET kind = 'item', category = 'household', name = 'Power Bank 20000мАч', created_at = time::now();
RELATE thing:`apt_storage_shelf_2`->contains->thing:`power_bank_20000мач`;
CREATE thing:`клей_пва_500мл` SET kind = 'item', category = 'household', name = 'Клей ПВА 500мл', created_at = time::now();
RELATE thing:`storage_rack_5`->contains->thing:`клей_пва_500мл`;
CREATE thing:`клей_момент_50мл_(5шт)` SET kind = 'item', category = 'household', name = 'Клей момент 50мл (5шт)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`клей_момент_50мл_(5шт)`;
CREATE thing:`суперклей_(10шт)` SET kind = 'item', category = 'household', name = 'Суперклей (10шт)', created_at = time::now();
RELATE thing:`apt_storage_shelf_3`->contains->thing:`суперклей_(10шт)`;
CREATE thing:`скотч_прозрачный_(10_рулонов)` SET kind = 'item', category = 'household', name = 'Скотч прозрачный (10 рулонов)', created_at = time::now();
RELATE thing:`storage_rack_3`->contains->thing:`скотч_прозрачный_(10_рулонов)`;
CREATE thing:`скотч_двусторонний_3м` SET kind = 'item', category = 'household', name = 'Скотч двусторонний 3М', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`скотч_двусторонний_3м`;
CREATE thing:`степлер_строительный` SET kind = 'item', category = 'household', name = 'Степлер строительный', created_at = time::now();
RELATE thing:`storage_rack_6`->contains->thing:`степлер_строительный`;
CREATE thing:`скобы_8мм_(1000шт)` SET kind = 'item', category = 'household', name = 'Скобы 8мм (1000шт)', created_at = time::now();
RELATE thing:`storage_rack_1`->contains->thing:`скобы_8мм_(1000шт)`;
CREATE thing:`скобы_14мм_(500шт)` SET kind = 'item', category = 'household', name = 'Скобы 14мм (500шт)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`скобы_14мм_(500шт)`;
CREATE thing:`шпагат_джутовый` SET kind = 'item', category = 'household', name = 'Шпагат джутовый', created_at = time::now();
RELATE thing:`storage_rack_4`->contains->thing:`шпагат_джутовый`;
CREATE thing:`верёвка_бельевая_20м` SET kind = 'item', category = 'household', name = 'Верёвка бельевая 20м', created_at = time::now();
RELATE thing:`apt_storage_shelf_3`->contains->thing:`верёвка_бельевая_20м`;
CREATE thing:`прищепки_(50шт)` SET kind = 'item', category = 'household', name = 'Прищепки (50шт)', created_at = time::now();
RELATE thing:`apt_storage_shelf_1`->contains->thing:`прищепки_(50шт)`;
CREATE thing:`raspberry_pi_4_4gb` SET kind = 'item', category = 'electronics', name = 'Raspberry Pi 4 4GB', created_at = time::now();
RELATE thing:`apt_storage_shelf_3`->contains->thing:`raspberry_pi_4_4gb`;
CREATE thing:`raspberry_pi_zero_2w` SET kind = 'item', category = 'electronics', name = 'Raspberry Pi Zero 2W', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`raspberry_pi_zero_2w`;
CREATE thing:`arduino_uno_(3шт)` SET kind = 'item', category = 'electronics', name = 'Arduino Uno (3шт)', created_at = time::now();
RELATE thing:`storage_rack_3`->contains->thing:`arduino_uno_(3шт)`;
CREATE thing:`arduino_nano_(5шт)` SET kind = 'item', category = 'electronics', name = 'Arduino Nano (5шт)', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`arduino_nano_(5шт)`;
CREATE thing:`esp32_(10шт)` SET kind = 'item', category = 'electronics', name = 'ESP32 (10шт)', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`esp32_(10шт)`;
CREATE thing:`esp8266_(5шт)` SET kind = 'item', category = 'electronics', name = 'ESP8266 (5шт)', created_at = time::now();
RELATE thing:`storage_rack_4`->contains->thing:`esp8266_(5шт)`;
CREATE thing:`блок_питания_5v_3a_usb_c` SET kind = 'item', category = 'electronics', name = 'Блок питания 5V 3A USB-C', created_at = time::now();
RELATE thing:`apt_storage_shelf_1`->contains->thing:`блок_питания_5v_3a_usb_c`;
CREATE thing:`блок_питания_12v_3a` SET kind = 'item', category = 'electronics', name = 'Блок питания 12V 3A', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`блок_питания_12v_3a`;
CREATE thing:`преобразователь_dc_dc_step_down` SET kind = 'item', category = 'electronics', name = 'Преобразователь DC-DC step-down', created_at = time::now();
RELATE thing:`storage_rack_4`->contains->thing:`преобразователь_dc_dc_step_down`;
CREATE thing:`ups_для_pi_1000мач` SET kind = 'item', category = 'electronics', name = 'UPS для Pi 1000мАч', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`ups_для_pi_1000мач`;
CREATE thing:`ethernet_switch_tp_link_8_портов` SET kind = 'item', category = 'electronics', name = 'Ethernet switch TP-Link 8 портов', created_at = time::now();
RELATE thing:`storage_rack_2`->contains->thing:`ethernet_switch_tp_link_8_портов`;
CREATE thing:`патч_корды_кат.5е_(набор)` SET kind = 'item', category = 'electronics', name = 'Патч-корды кат.5е (набор)', created_at = time::now();
RELATE thing:`storage_rack_4`->contains->thing:`патч_корды_кат.5е_(набор)`;
CREATE thing:`hdmi_кабель_2м_(3шт)` SET kind = 'item', category = 'electronics', name = 'HDMI кабель 2м (3шт)', created_at = time::now();
RELATE thing:`apt_storage_shelf_2`->contains->thing:`hdmi_кабель_2м_(3шт)`;
CREATE thing:`displayport_кабель_1.5м` SET kind = 'item', category = 'electronics', name = 'DisplayPort кабель 1.5м', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`displayport_кабель_1.5м`;
CREATE thing:`usb_концентратор_7_портов` SET kind = 'item', category = 'electronics', name = 'USB-концентратор 7 портов', created_at = time::now();
RELATE thing:`apt_storage_shelf_2`->contains->thing:`usb_концентратор_7_портов`;
CREATE thing:`usb_a_hub_с_питанием` SET kind = 'item', category = 'electronics', name = 'USB-A Hub с питанием', created_at = time::now();
RELATE thing:`storage_rack_2`->contains->thing:`usb_a_hub_с_питанием`;
CREATE thing:`флешка_64gb_usb_3.0_(3шт)` SET kind = 'item', category = 'electronics', name = 'Флешка 64GB USB 3.0 (3шт)', created_at = time::now();
RELATE thing:`storage_rack_3`->contains->thing:`флешка_64gb_usb_3.0_(3шт)`;
CREATE thing:`флешка_128gb` SET kind = 'item', category = 'electronics', name = 'Флешка 128GB', created_at = time::now();
RELATE thing:`apt_storage_shelf_1`->contains->thing:`флешка_128gb`;
CREATE thing:`microsd_64gb_(5шт)` SET kind = 'item', category = 'electronics', name = 'MicroSD 64GB (5шт)', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`microsd_64gb_(5шт)`;
CREATE thing:`ssd_256gb_2.5"_(запасной)` SET kind = 'item', category = 'electronics', name = 'SSD 256GB 2.5" (запасной)', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`ssd_256gb_2.5"_(запасной)`;
CREATE thing:`hdd_2tb_3.5"_(запасной)` SET kind = 'item', category = 'electronics', name = 'HDD 2TB 3.5" (запасной)', created_at = time::now();
RELATE thing:`storage_rack_3`->contains->thing:`hdd_2tb_3.5"_(запасной)`;
CREATE thing:`корпус_pi_металлический` SET kind = 'item', category = 'electronics', name = 'Корпус Pi металлический', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`корпус_pi_металлический`;
CREATE thing:`термопаста_мх_4_4г` SET kind = 'item', category = 'electronics', name = 'Термопаста МХ-4 4г', created_at = time::now();
RELATE thing:`apt_storage_shelf_2`->contains->thing:`термопаста_мх_4_4г`;
CREATE thing:`реле_5v_4_канальное_(3шт)` SET kind = 'item', category = 'electronics', name = 'Реле 5V 4-канальное (3шт)', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`реле_5v_4_канальное_(3шт)`;
CREATE thing:`датчик_температуры_ds18b20_(5шт)` SET kind = 'item', category = 'electronics', name = 'Датчик температуры DS18B20 (5шт)', created_at = time::now();
RELATE thing:`apt_storage_shelf_1`->contains->thing:`датчик_температуры_ds18b20_(5шт)`;
CREATE thing:`датчик_влажности_dht22_(3шт)` SET kind = 'item', category = 'electronics', name = 'Датчик влажности DHT22 (3шт)', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`датчик_влажности_dht22_(3шт)`;
CREATE thing:`датчик_движения_pir_(3шт)` SET kind = 'item', category = 'electronics', name = 'Датчик движения PIR (3шт)', created_at = time::now();
RELATE thing:`apt_storage_shelf_3`->contains->thing:`датчик_движения_pir_(3шт)`;
CREATE thing:`сервопривод_sg90_(5шт)` SET kind = 'item', category = 'electronics', name = 'Сервопривод SG90 (5шт)', created_at = time::now();
RELATE thing:`storage_rack_3`->contains->thing:`сервопривод_sg90_(5шт)`;
CREATE thing:`шаговый_двигатель_28byj` SET kind = 'item', category = 'electronics', name = 'Шаговый двигатель 28BYJ', created_at = time::now();
RELATE thing:`apt_storage_shelf_3`->contains->thing:`шаговый_двигатель_28byj`;
CREATE thing:`жк_экран_16×2_i2c` SET kind = 'item', category = 'electronics', name = 'ЖК экран 16×2 I2C', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`жк_экран_16×2_i2c`;
CREATE thing:`oled_0.96"_i2c_(3шт)` SET kind = 'item', category = 'electronics', name = 'OLED 0.96" I2C (3шт)', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`oled_0.96"_i2c_(3шт)`;
CREATE thing:`макетная_плата_830_точек_(3шт)` SET kind = 'item', category = 'electronics', name = 'Макетная плата 830 точек (3шт)', created_at = time::now();
RELATE thing:`storage_rack_2`->contains->thing:`макетная_плата_830_точек_(3шт)`;
CREATE thing:`провода_перемычки_набор` SET kind = 'item', category = 'electronics', name = 'Провода-перемычки набор', created_at = time::now();
RELATE thing:`apt_storage_shelf_1`->contains->thing:`провода_перемычки_набор`;
CREATE thing:`набор_резисторов_(600шт)` SET kind = 'item', category = 'electronics', name = 'Набор резисторов (600шт)', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`набор_резисторов_(600шт)`;
CREATE thing:`набор_конденсаторов` SET kind = 'item', category = 'electronics', name = 'Набор конденсаторов', created_at = time::now();
RELATE thing:`storage_rack_4`->contains->thing:`набор_конденсаторов`;
CREATE thing:`набор_диодов` SET kind = 'item', category = 'electronics', name = 'Набор диодов', created_at = time::now();
RELATE thing:`storage_rack_4`->contains->thing:`набор_диодов`;
CREATE thing:`транзисторы_npn_(набор)` SET kind = 'item', category = 'electronics', name = 'Транзисторы NPN (набор)', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`транзисторы_npn_(набор)`;
CREATE thing:`оптопары_pc817_(20шт)` SET kind = 'item', category = 'electronics', name = 'Оптопары PC817 (20шт)', created_at = time::now();
RELATE thing:`storage_rack_2`->contains->thing:`оптопары_pc817_(20шт)`;
CREATE thing:`зарядник_type_c_gan_65w` SET kind = 'item', category = 'electronics', name = 'Зарядник Type-C GaN 65W', created_at = time::now();
RELATE thing:`apt_storage_shelf_3`->contains->thing:`зарядник_type_c_gan_65w`;
CREATE thing:`зарядник_быстрый_qc3.0` SET kind = 'item', category = 'electronics', name = 'Зарядник быстрый QC3.0', created_at = time::now();
RELATE thing:`storage_rack_1`->contains->thing:`зарядник_быстрый_qc3.0`;
CREATE thing:`велосипед_горный` SET kind = 'item', category = 'sports', name = 'Велосипед горный', created_at = time::now();
RELATE thing:`apt_balcony`->contains->thing:`велосипед_горный`;
CREATE thing:`велошлем` SET kind = 'item', category = 'sports', name = 'Велошлем', created_at = time::now();
RELATE thing:`storage_rack_5`->contains->thing:`велошлем`;
CREATE thing:`велоперчатки` SET kind = 'item', category = 'sports', name = 'Велоперчатки', created_at = time::now();
RELATE thing:`apt_balcony`->contains->thing:`велоперчатки`;
CREATE thing:`велозамок` SET kind = 'item', category = 'sports', name = 'Велозамок', created_at = time::now();
RELATE thing:`storage_rack_7`->contains->thing:`велозамок`;
CREATE thing:`камера_велосипедная_26"_(2шт)` SET kind = 'item', category = 'sports', name = 'Камера велосипедная 26" (2шт)', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`камера_велосипедная_26"_(2шт)`;
CREATE thing:`покрышка_26×2.1_(2шт)` SET kind = 'item', category = 'sports', name = 'Покрышка 26×2.1 (2шт)', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`покрышка_26×2.1_(2шт)`;
CREATE thing:`насос_велосипедный_напольный` SET kind = 'item', category = 'sports', name = 'Насос велосипедный напольный', created_at = time::now();
RELATE thing:`storage_rack_4`->contains->thing:`насос_велосипедный_напольный`;
CREATE thing:`набор_для_ремонта_камеры` SET kind = 'item', category = 'sports', name = 'Набор для ремонта камеры', created_at = time::now();
RELATE thing:`storage_rack_7`->contains->thing:`набор_для_ремонта_камеры`;
CREATE thing:`фонарь_велосипедный_передний` SET kind = 'item', category = 'sports', name = 'Фонарь велосипедный передний', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`фонарь_велосипедный_передний`;
CREATE thing:`фонарь_велосипедный_задний` SET kind = 'item', category = 'sports', name = 'Фонарь велосипедный задний', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`фонарь_велосипедный_задний`;
CREATE thing:`велосипедный_рюкзак_20л` SET kind = 'item', category = 'sports', name = 'Велосипедный рюкзак 20л', created_at = time::now();
RELATE thing:`apt_balcony`->contains->thing:`велосипедный_рюкзак_20л`;
CREATE thing:`рюкзак_туристический_60л` SET kind = 'item', category = 'sports', name = 'Рюкзак туристический 60л', created_at = time::now();
RELATE thing:`apt_balcony`->contains->thing:`рюкзак_туристический_60л`;
CREATE thing:`рюкзак_туристический_80л` SET kind = 'item', category = 'sports', name = 'Рюкзак туристический 80л', created_at = time::now();
RELATE thing:`storage_rack_4`->contains->thing:`рюкзак_туристический_80л`;
CREATE thing:`спальник__10°c` SET kind = 'item', category = 'sports', name = 'Спальник -10°C', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`спальник__10°c`;
CREATE thing:`спальник_0°c_(летний)` SET kind = 'item', category = 'sports', name = 'Спальник 0°C (летний)', created_at = time::now();
RELATE thing:`storage_rack_4`->contains->thing:`спальник_0°c_(летний)`;
CREATE thing:`коврик_туристический` SET kind = 'item', category = 'sports', name = 'Коврик туристический', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`коврик_туристический`;
CREATE thing:`палатка_3_местная` SET kind = 'item', category = 'sports', name = 'Палатка 3-местная', created_at = time::now();
RELATE thing:`apt_balcony`->contains->thing:`палатка_3_местная`;
CREATE thing:`тент_3×4м` SET kind = 'item', category = 'sports', name = 'Тент 3×4м', created_at = time::now();
RELATE thing:`storage_rack_4`->contains->thing:`тент_3×4м`;
CREATE thing:`горелка_газовая_с_пьезо` SET kind = 'item', category = 'sports', name = 'Горелка газовая с пьезо', created_at = time::now();
RELATE thing:`storage_rack_4`->contains->thing:`горелка_газовая_с_пьезо`;
CREATE thing:`баллоны_газовые_230г_(5шт)` SET kind = 'item', category = 'sports', name = 'Баллоны газовые 230г (5шт)', created_at = time::now();
RELATE thing:`storage_rack_6`->contains->thing:`баллоны_газовые_230г_(5шт)`;
CREATE thing:`котелок_2л` SET kind = 'item', category = 'sports', name = 'Котелок 2л', created_at = time::now();
RELATE thing:`apt_balcony`->contains->thing:`котелок_2л`;
CREATE thing:`кружка_titanium` SET kind = 'item', category = 'sports', name = 'Кружка titanium', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`кружка_titanium`;
CREATE thing:`ложка_вилка_нож` SET kind = 'item', category = 'sports', name = 'Ложка-вилка-нож', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`ложка_вилка_нож`;
CREATE thing:`фонарь_налобный_led_(3шт)` SET kind = 'item', category = 'sports', name = 'Фонарь налобный LED (3шт)', created_at = time::now();
RELATE thing:`apt_balcony`->contains->thing:`фонарь_налобный_led_(3шт)`;
CREATE thing:`батарейки_для_фонаря` SET kind = 'item', category = 'sports', name = 'Батарейки для фонаря', created_at = time::now();
RELATE thing:`apt_balcony`->contains->thing:`батарейки_для_фонаря`;
CREATE thing:`компас_жидкостный` SET kind = 'item', category = 'sports', name = 'Компас жидкостный', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`компас_жидкостный`;
CREATE thing:`карты_топо_распечатанные` SET kind = 'item', category = 'sports', name = 'Карты топо распечатанные', created_at = time::now();
RELATE thing:`storage_rack_5`->contains->thing:`карты_топо_распечатанные`;
CREATE thing:`репшнур_6мм_(20м)` SET kind = 'item', category = 'sports', name = 'Репшнур 6мм (20м)', created_at = time::now();
RELATE thing:`apt_balcony`->contains->thing:`репшнур_6мм_(20м)`;
CREATE thing:`карабин_муфтованный_(5шт)` SET kind = 'item', category = 'sports', name = 'Карабин муфтованный (5шт)', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`карабин_муфтованный_(5шт)`;
CREATE thing:`скейтборд` SET kind = 'item', category = 'sports', name = 'Скейтборд', created_at = time::now();
RELATE thing:`storage_rack_6`->contains->thing:`скейтборд`;
CREATE thing:`роликовые_коньки_р.42` SET kind = 'item', category = 'sports', name = 'Роликовые коньки р.42', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`роликовые_коньки_р.42`;
CREATE thing:`защита_для_роликов` SET kind = 'item', category = 'sports', name = 'Защита для роликов', created_at = time::now();
RELATE thing:`storage_rack_4`->contains->thing:`защита_для_роликов`;
CREATE thing:`лыжи_горные_170см` SET kind = 'item', category = 'sports', name = 'Лыжи горные 170см', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`лыжи_горные_170см`;
CREATE thing:`крепления_горные` SET kind = 'item', category = 'sports', name = 'Крепления горные', created_at = time::now();
RELATE thing:`apt_balcony`->contains->thing:`крепления_горные`;
CREATE thing:`ботинки_горные_р.43` SET kind = 'item', category = 'sports', name = 'Ботинки горные р.43', created_at = time::now();
RELATE thing:`storage_rack_7`->contains->thing:`ботинки_горные_р.43`;
CREATE thing:`лыжи_беговые_185см` SET kind = 'item', category = 'sports', name = 'Лыжи беговые 185см', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`лыжи_беговые_185см`;
CREATE thing:`ботинки_беговые` SET kind = 'item', category = 'sports', name = 'Ботинки беговые', created_at = time::now();
RELATE thing:`dacha_shed`->contains->thing:`ботинки_беговые`;
CREATE thing:`лыжные_палки` SET kind = 'item', category = 'sports', name = 'Лыжные палки', created_at = time::now();
RELATE thing:`storage_rack_6`->contains->thing:`лыжные_палки`;
CREATE thing:`куртка_зимняя_пуховик_(папа)` SET kind = 'item', category = 'clothing', name = 'Куртка зимняя пуховик (Папа)', created_at = time::now();
RELATE thing:`storage_rack_3`->contains->thing:`куртка_зимняя_пуховик_(папа)`;
CREATE thing:`куртка_зимняя_пуховик_(мама)` SET kind = 'item', category = 'clothing', name = 'Куртка зимняя пуховик (Мама)', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`куртка_зимняя_пуховик_(мама)`;
CREATE thing:`куртка_зимняя_(сын)` SET kind = 'item', category = 'clothing', name = 'Куртка зимняя (Сын)', created_at = time::now();
RELATE thing:`storage_rack_1`->contains->thing:`куртка_зимняя_(сын)`;
CREATE thing:`пальто_зимнее` SET kind = 'item', category = 'clothing', name = 'Пальто зимнее', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`пальто_зимнее`;
CREATE thing:`куртка_осенняя_(папа)` SET kind = 'item', category = 'clothing', name = 'Куртка осенняя (Папа)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`куртка_осенняя_(папа)`;
CREATE thing:`ветровка_(мама)` SET kind = 'item', category = 'clothing', name = 'Ветровка (Мама)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`ветровка_(мама)`;
CREATE thing:`куртка_флис_(сын)` SET kind = 'item', category = 'clothing', name = 'Куртка флис (Сын)', created_at = time::now();
RELATE thing:`storage_rack_3`->contains->thing:`куртка_флис_(сын)`;
CREATE thing:`шуба_норка` SET kind = 'item', category = 'clothing', name = 'Шуба норка', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`шуба_норка`;
CREATE thing:`дублёнка` SET kind = 'item', category = 'clothing', name = 'Дублёнка', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`дублёнка`;
CREATE thing:`комбинезон_горнолыжный_(папа)` SET kind = 'item', category = 'clothing', name = 'Комбинезон горнолыжный (Папа)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`комбинезон_горнолыжный_(папа)`;
CREATE thing:`комбинезон_горнолыжный_(мама)` SET kind = 'item', category = 'clothing', name = 'Комбинезон горнолыжный (Мама)', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`комбинезон_горнолыжный_(мама)`;
CREATE thing:`термобельё_комплект_(папа)` SET kind = 'item', category = 'clothing', name = 'Термобельё комплект (Папа)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`термобельё_комплект_(папа)`;
CREATE thing:`термобельё_комплект_(мама)` SET kind = 'item', category = 'clothing', name = 'Термобельё комплект (Мама)', created_at = time::now();
RELATE thing:`storage_rack_3`->contains->thing:`термобельё_комплект_(мама)`;
CREATE thing:`термобельё_комплект_(сын)` SET kind = 'item', category = 'clothing', name = 'Термобельё комплект (Сын)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`термобельё_комплект_(сын)`;
CREATE thing:`шапка_зимняя_(3шт)` SET kind = 'item', category = 'clothing', name = 'Шапка зимняя (3шт)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`шапка_зимняя_(3шт)`;
CREATE thing:`шапка_флис_(3шт)` SET kind = 'item', category = 'clothing', name = 'Шапка флис (3шт)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`шапка_флис_(3шт)`;
CREATE thing:`балаклава_(2шт)` SET kind = 'item', category = 'clothing', name = 'Балаклава (2шт)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`балаклава_(2шт)`;
CREATE thing:`варежки_(3_пары)` SET kind = 'item', category = 'clothing', name = 'Варежки (3 пары)', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`варежки_(3_пары)`;
CREATE thing:`перчатки_зимние_(2_пары)` SET kind = 'item', category = 'clothing', name = 'Перчатки зимние (2 пары)', created_at = time::now();
RELATE thing:`storage_rack_4`->contains->thing:`перчатки_зимние_(2_пары)`;
CREATE thing:`перчатки_флис` SET kind = 'item', category = 'clothing', name = 'Перчатки флис', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`перчатки_флис`;
CREATE thing:`шарф_тёплый_(3шт)` SET kind = 'item', category = 'clothing', name = 'Шарф тёплый (3шт)', created_at = time::now();
RELATE thing:`storage_rack_2`->contains->thing:`шарф_тёплый_(3шт)`;
CREATE thing:`снуд_флис_(2шт)` SET kind = 'item', category = 'clothing', name = 'Снуд флис (2шт)', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`снуд_флис_(2шт)`;
CREATE thing:`ботинки_зимние_р.43_(папа)` SET kind = 'item', category = 'clothing', name = 'Ботинки зимние р.43 (Папа)', created_at = time::now();
RELATE thing:`storage_rack_4`->contains->thing:`ботинки_зимние_р.43_(папа)`;
CREATE thing:`ботинки_зимние_р.37_(мама)` SET kind = 'item', category = 'clothing', name = 'Ботинки зимние р.37 (Мама)', created_at = time::now();
RELATE thing:`storage_rack_2`->contains->thing:`ботинки_зимние_р.37_(мама)`;
CREATE thing:`ботинки_зимние_р.38_(сын)` SET kind = 'item', category = 'clothing', name = 'Ботинки зимние р.38 (Сын)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`ботинки_зимние_р.38_(сын)`;
CREATE thing:`сапоги_резиновые_р.43` SET kind = 'item', category = 'clothing', name = 'Сапоги резиновые р.43', created_at = time::now();
RELATE thing:`storage_rack_3`->contains->thing:`сапоги_резиновые_р.43`;
CREATE thing:`сапоги_резиновые_р.37` SET kind = 'item', category = 'clothing', name = 'Сапоги резиновые р.37', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`сапоги_резиновые_р.37`;
CREATE thing:`кроссовки_трейл_р.43` SET kind = 'item', category = 'clothing', name = 'Кроссовки трейл р.43', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`кроссовки_трейл_р.43`;
CREATE thing:`кроссовки_беговые_р.43` SET kind = 'item', category = 'clothing', name = 'Кроссовки беговые р.43', created_at = time::now();
RELATE thing:`storage_rack_3`->contains->thing:`кроссовки_беговые_р.43`;
CREATE thing:`сланцы_р.43_(дача)` SET kind = 'item', category = 'clothing', name = 'Сланцы р.43 (дача)', created_at = time::now();
RELATE thing:`storage_rack_4`->contains->thing:`сланцы_р.43_(дача)`;
CREATE thing:`сланцы_р.37_(дача)` SET kind = 'item', category = 'clothing', name = 'Сланцы р.37 (дача)', created_at = time::now();
RELATE thing:`storage_rack_2`->contains->thing:`сланцы_р.37_(дача)`;
CREATE thing:`плащ_дождевик_(2шт)` SET kind = 'item', category = 'clothing', name = 'Плащ дождевик (2шт)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`плащ_дождевик_(2шт)`;
CREATE thing:`чехлы_для_обуви` SET kind = 'item', category = 'clothing', name = 'Чехлы для обуви', created_at = time::now();
RELATE thing:`storage_rack_3`->contains->thing:`чехлы_для_обуви`;
CREATE thing:`мотокуртка_текстиль` SET kind = 'item', category = 'clothing', name = 'Мотокуртка текстиль', created_at = time::now();
RELATE thing:`storage_rack_4`->contains->thing:`мотокуртка_текстиль`;
CREATE thing:`мотоштаны` SET kind = 'item', category = 'clothing', name = 'Мотоштаны', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`мотоштаны`;
CREATE thing:`мотоперчатки_лето` SET kind = 'item', category = 'clothing', name = 'Мотоперчатки лето', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`мотоперчатки_лето`;
CREATE thing:`мотоперчатки_зима` SET kind = 'item', category = 'clothing', name = 'Мотоперчатки зима', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`мотоперчатки_зима`;
CREATE thing:`мотошлем_интеграл` SET kind = 'item', category = 'clothing', name = 'Мотошлем интеграл', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`мотошлем_интеграл`;
CREATE thing:`мотобашмаки` SET kind = 'item', category = 'clothing', name = 'Мотобашмаки', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`мотобашмаки`;
CREATE thing:`мотозащита_спины` SET kind = 'item', category = 'clothing', name = 'Мотозащита спины', created_at = time::now();
RELATE thing:`storage_rack_3`->contains->thing:`мотозащита_спины`;
CREATE thing:`жилет_светоотражающий` SET kind = 'item', category = 'clothing', name = 'Жилет светоотражающий', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`жилет_светоотражающий`;
CREATE thing:`вакуумные_пакеты_для_одежды_xl_(10шт)` SET kind = 'item', category = 'clothing', name = 'Вакуумные пакеты для одежды XL (10шт)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`вакуумные_пакеты_для_одежды_xl_(10шт)`;
CREATE thing:`паттерны_проектирования_(gof)` SET kind = 'item', category = 'book', name = 'Паттерны проектирования (GoF)', created_at = time::now();
RELATE thing:`apt_child`->contains->thing:`паттерны_проектирования_(gof)`;
CREATE thing:`чистый_код_(мартин)` SET kind = 'item', category = 'book', name = 'Чистый код (Мартин)', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`чистый_код_(мартин)`;
CREATE thing:`мифический_человеко_месяц` SET kind = 'item', category = 'book', name = 'Мифический человеко-месяц', created_at = time::now();
RELATE thing:`apt_living`->contains->thing:`мифический_человеко_месяц`;
CREATE thing:`прагматичный_программист` SET kind = 'item', category = 'book', name = 'Прагматичный программист', created_at = time::now();
RELATE thing:`dacha_house`->contains->thing:`прагматичный_программист`;
CREATE thing:`алгоритмы_(седжвик)` SET kind = 'item', category = 'book', name = 'Алгоритмы (Седжвик)', created_at = time::now();
RELATE thing:`apt_child`->contains->thing:`алгоритмы_(седжвик)`;
CREATE thing:`sicp` SET kind = 'item', category = 'book', name = 'SICP', created_at = time::now();
RELATE thing:`dacha_house`->contains->thing:`sicp`;
CREATE thing:`дракон_книга_(компиляторы)` SET kind = 'item', category = 'book', name = 'Дракон-книга (компиляторы)', created_at = time::now();
RELATE thing:`apt_living`->contains->thing:`дракон_книга_(компиляторы)`;
CREATE thing:`kubernetes_в_действии` SET kind = 'item', category = 'book', name = 'Kubernetes в действии', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`kubernetes_в_действии`;
CREATE thing:`docker_deep_dive` SET kind = 'item', category = 'book', name = 'Docker Deep Dive', created_at = time::now();
RELATE thing:`apt_living`->contains->thing:`docker_deep_dive`;
CREATE thing:`linux_командная_строка` SET kind = 'item', category = 'book', name = 'Linux командная строка', created_at = time::now();
RELATE thing:`apt_living`->contains->thing:`linux_командная_строка`;
CREATE thing:`сети_для_самых_маленьких` SET kind = 'item', category = 'book', name = 'Сети для самых маленьких', created_at = time::now();
RELATE thing:`apt_child`->contains->thing:`сети_для_самых_маленьких`;
CREATE thing:`tcp_ip_иллюстрированный` SET kind = 'item', category = 'book', name = 'TCP/IP иллюстрированный', created_at = time::now();
RELATE thing:`dacha_house`->contains->thing:`tcp_ip_иллюстрированный`;
CREATE thing:`postgresql_для_профессионалов` SET kind = 'item', category = 'book', name = 'PostgreSQL для профессионалов', created_at = time::now();
RELATE thing:`apt_living`->contains->thing:`postgresql_для_профессионалов`;
CREATE thing:`redis_в_действии` SET kind = 'item', category = 'book', name = 'Redis в действии', created_at = time::now();
RELATE thing:`apt_living`->contains->thing:`redis_в_действии`;
CREATE thing:`elasticsearch_полное_руководство` SET kind = 'item', category = 'book', name = 'Elasticsearch полное руководство', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`elasticsearch_полное_руководство`;
CREATE thing:`python_crash_course` SET kind = 'item', category = 'book', name = 'Python Crash Course', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`python_crash_course`;
CREATE thing:`fluent_python` SET kind = 'item', category = 'book', name = 'Fluent Python', created_at = time::now();
RELATE thing:`dacha_house`->contains->thing:`fluent_python`;
CREATE thing:`python_cookbook` SET kind = 'item', category = 'book', name = 'Python Cookbook', created_at = time::now();
RELATE thing:`dacha_house`->contains->thing:`python_cookbook`;
CREATE thing:`javascript:_хорошие_части` SET kind = 'item', category = 'book', name = 'JavaScript: Хорошие части', created_at = time::now();
RELATE thing:`apt_child`->contains->thing:`javascript:_хорошие_части`;
CREATE thing:`you_don't_know_js_(6_книг)` SET kind = 'item', category = 'book', name = 'You Don\'t Know JS (6 книг)', created_at = time::now();
RELATE thing:`dacha_house`->contains->thing:`you_don't_know_js_(6_книг)`;
CREATE thing:`node.js_в_действии` SET kind = 'item', category = 'book', name = 'Node.js в действии', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`node.js_в_действии`;
CREATE thing:`react_быстро` SET kind = 'item', category = 'book', name = 'React быстро', created_at = time::now();
RELATE thing:`dacha_house`->contains->thing:`react_быстро`;
CREATE thing:`vue.js_в_действии` SET kind = 'item', category = 'book', name = 'Vue.js в действии', created_at = time::now();
RELATE thing:`apt_living`->contains->thing:`vue.js_в_действии`;
CREATE thing:`правила_дорожного_движения_2026` SET kind = 'item', category = 'book', name = 'Правила Дорожного Движения 2026', created_at = time::now();
RELATE thing:`dacha_house`->contains->thing:`правила_дорожного_движения_2026`;
CREATE thing:`устройство_автомобиля` SET kind = 'item', category = 'book', name = 'Устройство автомобиля', created_at = time::now();
RELATE thing:`dacha_house`->contains->thing:`устройство_автомобиля`;
CREATE thing:`мотоцикл_bmw_r1250gs_руководство` SET kind = 'item', category = 'book', name = 'Мотоцикл BMW R1250GS руководство', created_at = time::now();
RELATE thing:`apt_child`->contains->thing:`мотоцикл_bmw_r1250gs_руководство`;
CREATE thing:`сварка_для_начинающих` SET kind = 'item', category = 'book', name = 'Сварка для начинающих', created_at = time::now();
RELATE thing:`apt_living`->contains->thing:`сварка_для_начинающих`;
CREATE thing:`домашняя_сантехника_своими_руками` SET kind = 'item', category = 'book', name = 'Домашняя сантехника своими руками', created_at = time::now();
RELATE thing:`apt_child`->contains->thing:`домашняя_сантехника_своими_руками`;
CREATE thing:`электромонтаж_в_доме` SET kind = 'item', category = 'book', name = 'Электромонтаж в доме', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`электромонтаж_в_доме`;
CREATE thing:`огород_круглый_год` SET kind = 'item', category = 'book', name = 'Огород круглый год', created_at = time::now();
RELATE thing:`dacha_house`->contains->thing:`огород_круглый_год`;
CREATE thing:`сад_без_хлопот` SET kind = 'item', category = 'book', name = 'Сад без хлопот', created_at = time::now();
RELATE thing:`dacha_house`->contains->thing:`сад_без_хлопот`;
CREATE thing:`грибы_подмосковья` SET kind = 'item', category = 'book', name = 'Грибы Подмосковья', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`грибы_подмосковья`;
CREATE thing:`атлас_грибника` SET kind = 'item', category = 'book', name = 'Атлас грибника', created_at = time::now();
RELATE thing:`apt_child`->contains->thing:`атлас_грибника`;
CREATE thing:`рыбалка_для_начинающих` SET kind = 'item', category = 'book', name = 'Рыбалка для начинающих', created_at = time::now();
RELATE thing:`apt_living`->contains->thing:`рыбалка_для_начинающих`;
CREATE thing:`физика_(иродов)` SET kind = 'item', category = 'book', name = 'Физика (Иродов)', created_at = time::now();
RELATE thing:`apt_child`->contains->thing:`физика_(иродов)`;
CREATE thing:`математический_анализ_(зорич)` SET kind = 'item', category = 'book', name = 'Математический анализ (Зорич)', created_at = time::now();
RELATE thing:`apt_child`->contains->thing:`математический_анализ_(зорич)`;
CREATE thing:`квантовая_механика` SET kind = 'item', category = 'book', name = 'Квантовая механика', created_at = time::now();
RELATE thing:`apt_living`->contains->thing:`квантовая_механика`;
CREATE thing:`теория_относительности_популярно` SET kind = 'item', category = 'book', name = 'Теория относительности популярно', created_at = time::now();
RELATE thing:`dacha_house`->contains->thing:`теория_относительности_популярно`;
CREATE thing:`записки_охотника_(тургенев)` SET kind = 'item', category = 'book', name = 'Записки охотника (Тургенев)', created_at = time::now();
RELATE thing:`apt_child`->contains->thing:`записки_охотника_(тургенев)`;
CREATE thing:`мастер_и_маргарита` SET kind = 'item', category = 'book', name = 'Мастер и Маргарита', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`мастер_и_маргарита`;
CREATE thing:`1984_(оруэлл)` SET kind = 'item', category = 'book', name = '1984 (Оруэлл)', created_at = time::now();
RELATE thing:`apt_living`->contains->thing:`1984_(оруэлл)`;
CREATE thing:`дюна` SET kind = 'item', category = 'book', name = 'Дюна', created_at = time::now();
RELATE thing:`dacha_house`->contains->thing:`дюна`;
CREATE thing:`властелин_колец` SET kind = 'item', category = 'book', name = 'Властелин колец', created_at = time::now();
RELATE thing:`apt_living`->contains->thing:`властелин_колец`;
CREATE thing:`гарри_поттер_(7_книг)` SET kind = 'item', category = 'book', name = 'Гарри Поттер (7 книг)', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`гарри_поттер_(7_книг)`;
CREATE thing:`аспирин_500мг_(20_табл)` SET kind = 'item', category = 'medicine', name = 'Аспирин 500мг (20 табл)', created_at = time::now();
RELATE thing:`apt_bathroom`->contains->thing:`аспирин_500мг_(20_табл)`;
CREATE thing:`парацетамол_500мг_(20_табл)` SET kind = 'item', category = 'medicine', name = 'Парацетамол 500мг (20 табл)', created_at = time::now();
RELATE thing:`apt_bathroom`->contains->thing:`парацетамол_500мг_(20_табл)`;
CREATE thing:`ибупрофен_400мг_(20_табл)` SET kind = 'item', category = 'medicine', name = 'Ибупрофен 400мг (20 табл)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`ибупрофен_400мг_(20_табл)`;
CREATE thing:`нурофен_суспензия_детская` SET kind = 'item', category = 'medicine', name = 'Нурофен суспензия детская', created_at = time::now();
RELATE thing:`apt_bathroom`->contains->thing:`нурофен_суспензия_детская`;
CREATE thing:`супрастин_(20_табл)` SET kind = 'item', category = 'medicine', name = 'Супрастин (20 табл)', created_at = time::now();
RELATE thing:`apt_bathroom`->contains->thing:`супрастин_(20_табл)`;
CREATE thing:`лоратадин_(10_табл)` SET kind = 'item', category = 'medicine', name = 'Лоратадин (10 табл)', created_at = time::now();
RELATE thing:`apt_bathroom`->contains->thing:`лоратадин_(10_табл)`;
CREATE thing:`активированный_уголь_(10_табл)` SET kind = 'item', category = 'medicine', name = 'Активированный уголь (10 табл)', created_at = time::now();
RELATE thing:`apt_bathroom`->contains->thing:`активированный_уголь_(10_табл)`;
CREATE thing:`смекта_(10_пак)` SET kind = 'item', category = 'medicine', name = 'Смекта (10 пак)', created_at = time::now();
RELATE thing:`apt_bathroom`->contains->thing:`смекта_(10_пак)`;
CREATE thing:`регидрон_(5_пак)` SET kind = 'item', category = 'medicine', name = 'Регидрон (5 пак)', created_at = time::now();
RELATE thing:`apt_bathroom`->contains->thing:`регидрон_(5_пак)`;
CREATE thing:`нифуроксазид_суспензия` SET kind = 'item', category = 'medicine', name = 'Нифуроксазид суспензия', created_at = time::now();
RELATE thing:`apt_bathroom`->contains->thing:`нифуроксазид_суспензия`;
CREATE thing:`эриус_(7_табл)` SET kind = 'item', category = 'medicine', name = 'Эриус (7 табл)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`эриус_(7_табл)`;
CREATE thing:`зиртек_капли` SET kind = 'item', category = 'medicine', name = 'Зиртек капли', created_at = time::now();
RELATE thing:`apt_bathroom`->contains->thing:`зиртек_капли`;
CREATE thing:`амоксициллин_500мг_(16_капс)` SET kind = 'item', category = 'medicine', name = 'Амоксициллин 500мг (16 капс)', created_at = time::now();
RELATE thing:`apt_bathroom`->contains->thing:`амоксициллин_500мг_(16_капс)`;
CREATE thing:`азитромицин_500мг_(3_табл)` SET kind = 'item', category = 'medicine', name = 'Азитромицин 500мг (3 табл)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`азитромицин_500мг_(3_табл)`;
CREATE thing:`флемоклав_875мг_(14_табл)` SET kind = 'item', category = 'medicine', name = 'Флемоклав 875мг (14 табл)', created_at = time::now();
RELATE thing:`apt_bathroom`->contains->thing:`флемоклав_875мг_(14_табл)`;
CREATE thing:`пантопразол_40мг_(14_табл)` SET kind = 'item', category = 'medicine', name = 'Пантопразол 40мг (14 табл)', created_at = time::now();
RELATE thing:`apt_bathroom`->contains->thing:`пантопразол_40мг_(14_табл)`;
CREATE thing:`омепразол_20мг_(28_капс)` SET kind = 'item', category = 'medicine', name = 'Омепразол 20мг (28 капс)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`омепразол_20мг_(28_капс)`;
CREATE thing:`линекс_(32_капс)` SET kind = 'item', category = 'medicine', name = 'Линекс (32 капс)', created_at = time::now();
RELATE thing:`apt_bathroom`->contains->thing:`линекс_(32_капс)`;
CREATE thing:`бифидумбактерин_(10_пак)` SET kind = 'item', category = 'medicine', name = 'Бифидумбактерин (10 пак)', created_at = time::now();
RELATE thing:`apt_bathroom`->contains->thing:`бифидумбактерин_(10_пак)`;
CREATE thing:`бинт_стерильный_5м_(5шт)` SET kind = 'item', category = 'medicine', name = 'Бинт стерильный 5м (5шт)', created_at = time::now();
RELATE thing:`apt_bathroom`->contains->thing:`бинт_стерильный_5м_(5шт)`;
CREATE thing:`бинт_нестерильный_(5шт)` SET kind = 'item', category = 'medicine', name = 'Бинт нестерильный (5шт)', created_at = time::now();
RELATE thing:`apt_bathroom`->contains->thing:`бинт_нестерильный_(5шт)`;
CREATE thing:`пластырь_бактерицидный_(30шт)` SET kind = 'item', category = 'medicine', name = 'Пластырь бактерицидный (30шт)', created_at = time::now();
RELATE thing:`apt_bathroom`->contains->thing:`пластырь_бактерицидный_(30шт)`;
CREATE thing:`пластырь_рулонный_5м` SET kind = 'item', category = 'medicine', name = 'Пластырь рулонный 5м', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`пластырь_рулонный_5м`;
CREATE thing:`вата_стерильная_100г` SET kind = 'item', category = 'medicine', name = 'Вата стерильная 100г', created_at = time::now();
RELATE thing:`apt_bathroom`->contains->thing:`вата_стерильная_100г`;
CREATE thing:`марля_стерильная` SET kind = 'item', category = 'medicine', name = 'Марля стерильная', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`марля_стерильная`;
CREATE thing:`перекись_водорода_3%_(200мл)` SET kind = 'item', category = 'medicine', name = 'Перекись водорода 3% (200мл)', created_at = time::now();
RELATE thing:`apt_bathroom`->contains->thing:`перекись_водорода_3%_(200мл)`;
CREATE thing:`йод_5%_(10мл)` SET kind = 'item', category = 'medicine', name = 'Йод 5% (10мл)', created_at = time::now();
RELATE thing:`apt_bathroom`->contains->thing:`йод_5%_(10мл)`;
CREATE thing:`зелёнка` SET kind = 'item', category = 'medicine', name = 'Зелёнка', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`зелёнка`;
CREATE thing:`мирамистин_150мл` SET kind = 'item', category = 'medicine', name = 'Мирамистин 150мл', created_at = time::now();
RELATE thing:`apt_bathroom`->contains->thing:`мирамистин_150мл`;
CREATE thing:`хлоргексидин_200мл` SET kind = 'item', category = 'medicine', name = 'Хлоргексидин 200мл', created_at = time::now();
RELATE thing:`apt_bathroom`->contains->thing:`хлоргексидин_200мл`;
CREATE thing:`термометр_электронный` SET kind = 'item', category = 'medicine', name = 'Термометр электронный', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`термометр_электронный`;
CREATE thing:`тонометр_автоматический` SET kind = 'item', category = 'medicine', name = 'Тонометр автоматический', created_at = time::now();
RELATE thing:`apt_bathroom`->contains->thing:`тонометр_автоматический`;
CREATE thing:`глюкометр_+_тест_полоски_(50шт)` SET kind = 'item', category = 'medicine', name = 'Глюкометр + тест полоски (50шт)', created_at = time::now();
RELATE thing:`apt_bathroom`->contains->thing:`глюкометр_+_тест_полоски_(50шт)`;
CREATE thing:`пульсоксиметр` SET kind = 'item', category = 'medicine', name = 'Пульсоксиметр', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`пульсоксиметр`;
CREATE thing:`грелка_электрическая` SET kind = 'item', category = 'medicine', name = 'Грелка электрическая', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`грелка_электрическая`;
CREATE thing:`грелка_резиновая` SET kind = 'item', category = 'medicine', name = 'Грелка резиновая', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`грелка_резиновая`;
CREATE thing:`маски_медицинские_(50шт)` SET kind = 'item', category = 'medicine', name = 'Маски медицинские (50шт)', created_at = time::now();
RELATE thing:`apt_bathroom`->contains->thing:`маски_медицинские_(50шт)`;
CREATE thing:`перчатки_нитрил_(100шт)` SET kind = 'item', category = 'medicine', name = 'Перчатки нитрил (100шт)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`перчатки_нитрил_(100шт)`;
CREATE thing:`паспорт_(папа)_—_копия` SET kind = 'document', name = 'Паспорт (Папа) — копия', created_at = time::now();
RELATE thing:`apt_storage_shelf_1`->contains->thing:`паспорт_(папа)_—_копия`;
CREATE thing:`паспорт_(мама)_—_копия` SET kind = 'document', name = 'Паспорт (Мама) — копия', created_at = time::now();
RELATE thing:`apt_storage_shelf_1`->contains->thing:`паспорт_(мама)_—_копия`;
CREATE thing:`свидетельство_о_рождении_сына` SET kind = 'document', name = 'Свидетельство о рождении Сына', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`свидетельство_о_рождении_сына`;
CREATE thing:`свидетельство_о_браке` SET kind = 'document', name = 'Свидетельство о браке', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`свидетельство_о_браке`;
CREATE thing:`инн_(папа)` SET kind = 'document', name = 'ИНН (Папа)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`инн_(папа)`;
CREATE thing:`инн_(мама)` SET kind = 'document', name = 'ИНН (Мама)', created_at = time::now();
RELATE thing:`apt_storage_shelf_2`->contains->thing:`инн_(мама)`;
CREATE thing:`снилс_(папа)` SET kind = 'document', name = 'СНИЛС (Папа)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`снилс_(папа)`;
CREATE thing:`снилс_(мама)` SET kind = 'document', name = 'СНИЛС (Мама)', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`снилс_(мама)`;
CREATE thing:`снилс_(сын)` SET kind = 'document', name = 'СНИЛС (Сын)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`снилс_(сын)`;
CREATE thing:`птс_bmw_r1250gs` SET kind = 'document', name = 'ПТС BMW R1250GS', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`птс_bmw_r1250gs`;
CREATE thing:`стс_bmw_r1250gs` SET kind = 'document', name = 'СТС BMW R1250GS', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`стс_bmw_r1250gs`;
CREATE thing:`осаго_bmw_2026` SET kind = 'document', name = 'ОСАГО BMW 2026', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`осаго_bmw_2026`;
CREATE thing:`птс_lada_vesta` SET kind = 'document', name = 'ПТС Lada Vesta', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`птс_lada_vesta`;
CREATE thing:`стс_lada_vesta` SET kind = 'document', name = 'СТС Lada Vesta', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`стс_lada_vesta`;
CREATE thing:`осаго_vesta_2026` SET kind = 'document', name = 'ОСАГО Vesta 2026', created_at = time::now();
RELATE thing:`apt_storage_shelf_1`->contains->thing:`осаго_vesta_2026`;
CREATE thing:`диагностическая_карта_bmw` SET kind = 'document', name = 'Диагностическая карта BMW', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`диагностическая_карта_bmw`;
CREATE thing:`диагностическая_карта_vesta` SET kind = 'document', name = 'Диагностическая карта Vesta', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`диагностическая_карта_vesta`;
CREATE thing:`свидетельство_о_собственности_квартира` SET kind = 'document', name = 'Свидетельство о собственности квартира', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`свидетельство_о_собственности_квартира`;
CREATE thing:`выписка_егрн_квартира` SET kind = 'document', name = 'Выписка ЕГРН квартира', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`выписка_егрн_квартира`;
CREATE thing:`свидетельство_собственности_гараж` SET kind = 'document', name = 'Свидетельство собственности гараж', created_at = time::now();
RELATE thing:`apt_storage_shelf_2`->contains->thing:`свидетельство_собственности_гараж`;
CREATE thing:`договор_аренды_кладовки` SET kind = 'document', name = 'Договор аренды кладовки', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`договор_аренды_кладовки`;
CREATE thing:`гарантийный_талон_холодильник` SET kind = 'document', name = 'Гарантийный талон холодильник', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`гарантийный_талон_холодильник`;
CREATE thing:`гарантийный_талон_стиралка` SET kind = 'document', name = 'Гарантийный талон стиралка', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`гарантийный_талон_стиралка`;
CREATE thing:`гарантийный_талон_телевизор` SET kind = 'document', name = 'Гарантийный талон телевизор', created_at = time::now();
RELATE thing:`apt_storage_shelf_1`->contains->thing:`гарантийный_талон_телевизор`;
CREATE thing:`гарантийный_талон_ноутбук` SET kind = 'document', name = 'Гарантийный талон ноутбук', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`гарантийный_талон_ноутбук`;
CREATE thing:`инструкция_bmw_r1250gs_ru` SET kind = 'document', name = 'Инструкция BMW R1250GS RU', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`инструкция_bmw_r1250gs_ru`;
CREATE thing:`сервисная_книжка_bmw` SET kind = 'document', name = 'Сервисная книжка BMW', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`сервисная_книжка_bmw`;
CREATE thing:`страховой_полис_квартира_2026` SET kind = 'document', name = 'Страховой полис квартира 2026', created_at = time::now();
RELATE thing:`apt_storage_shelf_1`->contains->thing:`страховой_полис_квартира_2026`;
CREATE thing:`страховой_полис_дача` SET kind = 'document', name = 'Страховой полис дача', created_at = time::now();
RELATE thing:`apt_bedroom`->contains->thing:`страховой_полис_дача`;
CREATE thing:`медицинский_полис_омс_(папа)` SET kind = 'document', name = 'Медицинский полис ОМС (Папа)', created_at = time::now();
RELATE thing:`apt_storage_shelf_1`->contains->thing:`медицинский_полис_омс_(папа)`;
CREATE thing:`медицинский_полис_омс_(мама)` SET kind = 'document', name = 'Медицинский полис ОМС (Мама)', created_at = time::now();
RELATE thing:`apt_storage_shelf_2`->contains->thing:`медицинский_полис_омс_(мама)`;
CREATE thing:`медицинский_полис_омс_(сын)` SET kind = 'document', name = 'Медицинский полис ОМС (Сын)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`медицинский_полис_омс_(сын)`;
CREATE thing:`насос_ручной_аварийный` SET kind = 'item', category = 'auto_accessory', name = 'Насос ручной аварийный', created_at = time::now();
RELATE thing:`car_trunk`->contains->thing:`насос_ручной_аварийный`;
CREATE thing:`монтировка_45см` SET kind = 'item', category = 'auto_accessory', name = 'Монтировка 45см', created_at = time::now();
RELATE thing:`car_trunk`->contains->thing:`монтировка_45см`;
CREATE thing:`буксировочный_крюк_(запасной)` SET kind = 'item', category = 'auto_accessory', name = 'Буксировочный крюк (запасной)', created_at = time::now();
RELATE thing:`car_trunk`->contains->thing:`буксировочный_крюк_(запасной)`;
CREATE thing:`перчатки_рабочие_х_б_(пара)` SET kind = 'item', category = 'auto_accessory', name = 'Перчатки рабочие х/б (пара)', created_at = time::now();
RELATE thing:`car_trunk`->contains->thing:`перчатки_рабочие_х_б_(пара)`;
CREATE thing:`тряпка_для_протирки` SET kind = 'item', category = 'auto_accessory', name = 'Тряпка для протирки', created_at = time::now();
RELATE thing:`car_trunk`->contains->thing:`тряпка_для_протирки`;
CREATE thing:`антидождь_для_стёкол` SET kind = 'item', category = 'auto_accessory', name = 'Антидождь для стёкол', created_at = time::now();
RELATE thing:`car_trunk`->contains->thing:`антидождь_для_стёкол`;
CREATE thing:`скребок_для_льда_+_щётка` SET kind = 'item', category = 'auto_accessory', name = 'Скребок для льда + щётка', created_at = time::now();
RELATE thing:`car_trunk`->contains->thing:`скребок_для_льда_+_щётка`;
CREATE thing:`омыватель_стёкол__20°c_1л` SET kind = 'item', category = 'auto_accessory', name = 'Омыватель стёкол -20°C 1л', created_at = time::now();
RELATE thing:`car_trunk`->contains->thing:`омыватель_стёкол__20°c_1л`;
CREATE thing:`незамерзайка_1л` SET kind = 'item', category = 'auto_accessory', name = 'Незамерзайка 1л', created_at = time::now();
RELATE thing:`car_trunk`->contains->thing:`незамерзайка_1л`;
CREATE thing:`аварийный_знак_(запасной)` SET kind = 'item', category = 'auto_accessory', name = 'Аварийный знак (запасной)', created_at = time::now();
RELATE thing:`car_trunk`->contains->thing:`аварийный_знак_(запасной)`;
CREATE thing:`жилет_оранжевый` SET kind = 'item', category = 'auto_accessory', name = 'Жилет оранжевый', created_at = time::now();
RELATE thing:`car_trunk`->contains->thing:`жилет_оранжевый`;
CREATE thing:`аптечка_в_авто_(укомплектованная)` SET kind = 'item', category = 'auto_accessory', name = 'Аптечка в авто (укомплектованная)', created_at = time::now();
RELATE thing:`car_trunk`->contains->thing:`аптечка_в_авто_(укомплектованная)`;
CREATE thing:`огнетушитель_оп_2` SET kind = 'item', category = 'auto_accessory', name = 'Огнетушитель ОП-2', created_at = time::now();
RELATE thing:`car_trunk`->contains->thing:`огнетушитель_оп_2`;
CREATE thing:`запасное_колесо_r15_(докатка)` SET kind = 'item', category = 'auto_accessory', name = 'Запасное колесо R15 (докатка)', created_at = time::now();
RELATE thing:`car_trunk`->contains->thing:`запасное_колесо_r15_(докатка)`;
CREATE thing:`аптечка_мото` SET kind = 'item', category = 'moto_accessory', name = 'Аптечка мото', created_at = time::now();
RELATE thing:`moto_cases`->contains->thing:`аптечка_мото`;
CREATE thing:`дождевик_мото_(комплект)` SET kind = 'item', category = 'moto_accessory', name = 'Дождевик мото (комплект)', created_at = time::now();
RELATE thing:`moto_cases`->contains->thing:`дождевик_мото_(комплект)`;
CREATE thing:`жгут_кровоостанавливающий` SET kind = 'item', category = 'moto_accessory', name = 'Жгут кровоостанавливающий', created_at = time::now();
RELATE thing:`moto_cases`->contains->thing:`жгут_кровоостанавливающий`;
CREATE thing:`запасные_предохранители_мото` SET kind = 'item', category = 'moto_accessory', name = 'Запасные предохранители мото', created_at = time::now();
RELATE thing:`moto_cases`->contains->thing:`запасные_предохранители_мото`;
CREATE thing:`инструмент_базовый_мото` SET kind = 'item', category = 'moto_accessory', name = 'Инструмент базовый мото', created_at = time::now();
RELATE thing:`moto_cases`->contains->thing:`инструмент_базовый_мото`;
CREATE thing:`насос_велосипедный_компактный` SET kind = 'item', category = 'moto_accessory', name = 'Насос велосипедный компактный', created_at = time::now();
RELATE thing:`moto_cases`->contains->thing:`насос_велосипедный_компактный`;
CREATE thing:`жгут_для_буксировки` SET kind = 'item', category = 'moto_accessory', name = 'Жгут для буксировки', created_at = time::now();
RELATE thing:`moto_cases`->contains->thing:`жгут_для_буксировки`;
CREATE thing:`карта_регионов_бумажная` SET kind = 'item', category = 'moto_accessory', name = 'Карта регионов бумажная', created_at = time::now();
RELATE thing:`moto_cases`->contains->thing:`карта_регионов_бумажная`;
CREATE thing:`кошелёк_запасной` SET kind = 'item', category = 'moto_accessory', name = 'Кошелёк запасной', created_at = time::now();
RELATE thing:`moto_cases`->contains->thing:`кошелёк_запасной`;
CREATE thing:`фотоальбом_семейный_(3шт)` SET kind = 'item', category = 'misc', name = 'Фотоальбом семейный (3шт)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`фотоальбом_семейный_(3шт)`;
CREATE thing:`видеокассеты_vhs_(коробка)` SET kind = 'item', category = 'misc', name = 'Видеокассеты VHS (коробка)', created_at = time::now();
RELATE thing:`storage_rack_7`->contains->thing:`видеокассеты_vhs_(коробка)`;
CREATE thing:`диски_cd_dvd_(пачка)` SET kind = 'item', category = 'misc', name = 'Диски CD/DVD (пачка)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`диски_cd_dvd_(пачка)`;
CREATE thing:`пластинки_виниловые_(15шт)` SET kind = 'item', category = 'misc', name = 'Пластинки виниловые (15шт)', created_at = time::now();
RELATE thing:`apt_storage_shelf_1`->contains->thing:`пластинки_виниловые_(15шт)`;
CREATE thing:`флипчарт_магнитный` SET kind = 'item', category = 'misc', name = 'Флипчарт магнитный', created_at = time::now();
RELATE thing:`storage_rack_5`->contains->thing:`флипчарт_магнитный`;
CREATE thing:`маркеры_для_доски_(набор_8_цветов)` SET kind = 'item', category = 'misc', name = 'Маркеры для доски (набор 8 цветов)', created_at = time::now();
RELATE thing:`storage_rack_6`->contains->thing:`маркеры_для_доски_(набор_8_цветов)`;
CREATE thing:`ламинатор_a4` SET kind = 'item', category = 'misc', name = 'Ламинатор A4', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`ламинатор_a4`;
CREATE thing:`плёнка_для_ламинатора_a4_(100шт)` SET kind = 'item', category = 'misc', name = 'Плёнка для ламинатора A4 (100шт)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`плёнка_для_ламинатора_a4_(100шт)`;
CREATE thing:`степлер_а4_(офисный)` SET kind = 'item', category = 'misc', name = 'Степлер А4 (офисный)', created_at = time::now();
RELATE thing:`apt_storage_shelf_2`->contains->thing:`степлер_а4_(офисный)`;
CREATE thing:`скобы_24_6_(1000шт)` SET kind = 'item', category = 'misc', name = 'Скобы 24/6 (1000шт)', created_at = time::now();
RELATE thing:`apt_storage_shelf_2`->contains->thing:`скобы_24_6_(1000шт)`;
CREATE thing:`дырокол_2_дырочный` SET kind = 'item', category = 'misc', name = 'Дырокол 2-дырочный', created_at = time::now();
RELATE thing:`apt_storage_shelf_3`->contains->thing:`дырокол_2_дырочный`;
CREATE thing:`папки_скоросшиватели_(20шт)` SET kind = 'item', category = 'misc', name = 'Папки-скоросшиватели (20шт)', created_at = time::now();
RELATE thing:`apt_storage_shelf_3`->contains->thing:`папки_скоросшиватели_(20шт)`;
CREATE thing:`файлы_a4_(100шт)` SET kind = 'item', category = 'misc', name = 'Файлы A4 (100шт)', created_at = time::now();
RELATE thing:`apt_storage_shelf_3`->contains->thing:`файлы_a4_(100шт)`;
CREATE thing:`конверты_a4_(50шт)` SET kind = 'item', category = 'misc', name = 'Конверты A4 (50шт)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`конверты_a4_(50шт)`;
CREATE thing:`конверты_а5_(50шт)` SET kind = 'item', category = 'misc', name = 'Конверты А5 (50шт)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`конверты_а5_(50шт)`;
CREATE thing:`картридж_для_принтера_чёрный` SET kind = 'item', category = 'misc', name = 'Картридж для принтера чёрный', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`картридж_для_принтера_чёрный`;
CREATE thing:`картридж_цветной` SET kind = 'item', category = 'misc', name = 'Картридж цветной', created_at = time::now();
RELATE thing:`storage_rack_3`->contains->thing:`картридж_цветной`;
CREATE thing:`бумага_a4_500л_(5_пачек)` SET kind = 'item', category = 'misc', name = 'Бумага A4 500л (5 пачек)', created_at = time::now();
RELATE thing:`apt_storage_shelf_1`->contains->thing:`бумага_a4_500л_(5_пачек)`;
CREATE thing:`стикеры_76×76_(3_цвета)` SET kind = 'item', category = 'misc', name = 'Стикеры 76×76 (3 цвета)', created_at = time::now();
RELATE thing:`storage_rack_6`->contains->thing:`стикеры_76×76_(3_цвета)`;
CREATE thing:`ручки_шариковые_(коробка_50шт)` SET kind = 'item', category = 'misc', name = 'Ручки шариковые (коробка 50шт)', created_at = time::now();
RELATE thing:`apt_storage_shelf_3`->contains->thing:`ручки_шариковые_(коробка_50шт)`;
CREATE thing:`карандаши_(набор)` SET kind = 'item', category = 'misc', name = 'Карандаши (набор)', created_at = time::now();
RELATE thing:`apt_storage_shelf_1`->contains->thing:`карандаши_(набор)`;
CREATE thing:`линейка_30см_(5шт)` SET kind = 'item', category = 'misc', name = 'Линейка 30см (5шт)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`линейка_30см_(5шт)`;
CREATE thing:`ластики_(10шт)` SET kind = 'item', category = 'misc', name = 'Ластики (10шт)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`ластики_(10шт)`;
CREATE thing:`корректор` SET kind = 'item', category = 'misc', name = 'Корректор', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`корректор`;
CREATE thing:`скотч_прозрачный_24мм_(10шт)` SET kind = 'item', category = 'misc', name = 'Скотч прозрачный 24мм (10шт)', created_at = time::now();
RELATE thing:`apt_storage_shelf_2`->contains->thing:`скотч_прозрачный_24мм_(10шт)`;
CREATE thing:`скотч_коричневый_упаковочный` SET kind = 'item', category = 'misc', name = 'Скотч коричневый упаковочный', created_at = time::now();
RELATE thing:`storage_rack_5`->contains->thing:`скотч_коричневый_упаковочный`;
CREATE thing:`пузырчатая_плёнка_(рулон)` SET kind = 'item', category = 'misc', name = 'Пузырчатая плёнка (рулон)', created_at = time::now();
RELATE thing:`apt_storage_shelf_1`->contains->thing:`пузырчатая_плёнка_(рулон)`;
CREATE thing:`гофрокартон_(5_листов)` SET kind = 'item', category = 'misc', name = 'Гофрокартон (5 листов)', created_at = time::now();
RELATE thing:`storage_rack_1`->contains->thing:`гофрокартон_(5_листов)`;
CREATE thing:`коробки_картонные_60×40×40_(5шт)` SET kind = 'item', category = 'misc', name = 'Коробки картонные 60×40×40 (5шт)', created_at = time::now();
RELATE thing:`apt_storage_shelf_2`->contains->thing:`коробки_картонные_60×40×40_(5шт)`;
CREATE thing:`пакеты_подарочные_(набор)` SET kind = 'item', category = 'misc', name = 'Пакеты подарочные (набор)', created_at = time::now();
RELATE thing:`apt_storage_shelf_2`->contains->thing:`пакеты_подарочные_(набор)`;
CREATE thing:`лента_подарочная_(набор)` SET kind = 'item', category = 'misc', name = 'Лента подарочная (набор)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`лента_подарочная_(набор)`;
CREATE thing:`бумага_упаковочная_(рулон)` SET kind = 'item', category = 'misc', name = 'Бумага упаковочная (рулон)', created_at = time::now();
RELATE thing:`storage_rack_2`->contains->thing:`бумага_упаковочная_(рулон)`;
CREATE thing:`свечи_декоративные_(набор)` SET kind = 'item', category = 'misc', name = 'Свечи декоративные (набор)', created_at = time::now();
RELATE thing:`storage_rack_3`->contains->thing:`свечи_декоративные_(набор)`;
CREATE thing:`подсвечники_(3шт)` SET kind = 'item', category = 'misc', name = 'Подсвечники (3шт)', created_at = time::now();
RELATE thing:`apt_storage_shelf_3`->contains->thing:`подсвечники_(3шт)`;
CREATE thing:`фонарь_кемпинговый_led` SET kind = 'item', category = 'misc', name = 'Фонарь кемпинговый LED', created_at = time::now();
RELATE thing:`apt_storage_shelf_2`->contains->thing:`фонарь_кемпинговый_led`;
CREATE thing:`фонарь_ручной_1000лм` SET kind = 'item', category = 'misc', name = 'Фонарь ручной 1000лм', created_at = time::now();
RELATE thing:`storage_rack_6`->contains->thing:`фонарь_ручной_1000лм`;
CREATE thing:`мешки_туристические_герметичные_(3шт)` SET kind = 'item', category = 'misc', name = 'Мешки туристические герметичные (3шт)', created_at = time::now();
RELATE thing:`apt_storage_shelf_2`->contains->thing:`мешки_туристические_герметичные_(3шт)`;
CREATE thing:`карабины_бытовые_(10шт)` SET kind = 'item', category = 'misc', name = 'Карабины бытовые (10шт)', created_at = time::now();
RELATE thing:`storage_rack_1`->contains->thing:`карабины_бытовые_(10шт)`;
CREATE thing:`крючки_самоклеящиеся_(20шт)` SET kind = 'item', category = 'misc', name = 'Крючки самоклеящиеся (20шт)', created_at = time::now();
RELATE thing:`storage_rack_3`->contains->thing:`крючки_самоклеящиеся_(20шт)`;
CREATE thing:`саморезы_для_гипсокартона_(200шт)` SET kind = 'item', category = 'misc', name = 'Саморезы для гипсокартона (200шт)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`саморезы_для_гипсокартона_(200шт)`;
CREATE thing:`дюбели_пластиковые_6мм_(100шт)` SET kind = 'item', category = 'misc', name = 'Дюбели пластиковые 6мм (100шт)', created_at = time::now();
RELATE thing:`storage_rack_3`->contains->thing:`дюбели_пластиковые_6мм_(100шт)`;
CREATE thing:`анкеры_молли_(20шт)` SET kind = 'item', category = 'misc', name = 'Анкеры молли (20шт)', created_at = time::now();
RELATE thing:`apt_storage`->contains->thing:`анкеры_молли_(20шт)`;
CREATE thing:`спасательные_жилеты_6шт` SET kind = 'item', category = 'marine_gear', name = 'Спасательные жилеты 6шт', created_at = time::now();
RELATE thing:`boat_deck_box`->contains->thing:`спасательные_жилеты_6шт`;
CREATE thing:`сигнальные_огни_(набор)` SET kind = 'item', category = 'marine_gear', name = 'Сигнальные огни (набор)', created_at = time::now();
RELATE thing:`boat_deck_box`->contains->thing:`сигнальные_огни_(набор)`;
CREATE thing:`якорь_15кг_+_цепь_10м` SET kind = 'item', category = 'marine_gear', name = 'Якорь 15кг + цепь 10м', created_at = time::now();
RELATE thing:`boat_deck_box`->contains->thing:`якорь_15кг_+_цепь_10м`;
CREATE thing:`трос_причальный_20м` SET kind = 'item', category = 'marine_gear', name = 'Трос причальный 20м', created_at = time::now();
RELATE thing:`boat_deck_box`->contains->thing:`трос_причальный_20м`;
CREATE thing:`спасательный_круг` SET kind = 'item', category = 'marine_gear', name = 'Спасательный круг', created_at = time::now();
RELATE thing:`boat_deck_box`->contains->thing:`спасательный_круг`;
CREATE thing:`черпак_+_помпа_ручная` SET kind = 'item', category = 'marine_gear', name = 'Черпак + помпа ручная', created_at = time::now();
RELATE thing:`boat_deck_box`->contains->thing:`черпак_+_помпа_ручная`;
CREATE thing:`весло_запасное_2шт` SET kind = 'item', category = 'marine_gear', name = 'Весло запасное 2шт', created_at = time::now();
RELATE thing:`boat_deck_box`->contains->thing:`весло_запасное_2шт`;
CREATE thing:`аптечка_морская` SET kind = 'item', category = 'marine_gear', name = 'Аптечка морская', created_at = time::now();
RELATE thing:`boat_cabin`->contains->thing:`аптечка_морская`;
CREATE thing:`маяк_аварийный_epirb` SET kind = 'item', category = 'marine_gear', name = 'Маяк аварийный EPIRB', created_at = time::now();
RELATE thing:`boat_cabin`->contains->thing:`маяк_аварийный_epirb`;
CREATE thing:`компас_морской` SET kind = 'item', category = 'navigation', name = 'Компас морской', created_at = time::now();
RELATE thing:`boat_cabin`->contains->thing:`компас_морской`;
CREATE thing:`карты_речные_(регион)` SET kind = 'item', category = 'navigation', name = 'Карты речные (регион)', created_at = time::now();
RELATE thing:`boat_cabin`->contains->thing:`карты_речные_(регион)`;
CREATE thing:`эхолот_garmin_striker_4` SET kind = 'item', category = 'navigation', name = 'Эхолот Garmin Striker 4', created_at = time::now();
RELATE thing:`boat_cabin`->contains->thing:`эхолот_garmin_striker_4`;
CREATE thing:`vhf_радиостанция` SET kind = 'item', category = 'navigation', name = 'VHF радиостанция', created_at = time::now();
RELATE thing:`boat_cabin`->contains->thing:`vhf_радиостанция`;
CREATE thing:`мотор_подвесной_15л.с.` SET kind = 'item', category = 'auto_part', name = 'Мотор подвесной 15л.с.', created_at = time::now();
RELATE thing:`boat_engine_bay`->contains->thing:`мотор_подвесной_15л.с.`;
CREATE thing:`масло_для_мотора_2t_1л` SET kind = 'item', category = 'consumable', name = 'Масло для мотора 2T 1л', created_at = time::now();
RELATE thing:`boat_engine_bay`->contains->thing:`масло_для_мотора_2t_1л`;
CREATE thing:`топливный_фильтр_(мотор)` SET kind = 'item', category = 'consumable', name = 'Топливный фильтр (мотор)', created_at = time::now();
RELATE thing:`boat_engine_bay`->contains->thing:`топливный_фильтр_(мотор)`;
CREATE thing:`свечи_для_мотора_(2шт)` SET kind = 'item', category = 'consumable', name = 'Свечи для мотора (2шт)', created_at = time::now();
RELATE thing:`boat_engine_bay`->contains->thing:`свечи_для_мотора_(2шт)`;
CREATE thing:`канистра_топлива_20л` SET kind = 'item', category = 'consumable', name = 'Канистра топлива 20л', created_at = time::now();
RELATE thing:`boat_deck_box`->contains->thing:`канистра_топлива_20л`;
CREATE thing:`удочки_телескопические_2шт` SET kind = 'item', category = 'fishing', name = 'Удочки телескопические 2шт', created_at = time::now();
RELATE thing:`boat_deck_box`->contains->thing:`удочки_телескопические_2шт`;
CREATE thing:`снасти_рыболовные_(набор)` SET kind = 'item', category = 'fishing', name = 'Снасти рыболовные (набор)', created_at = time::now();
RELATE thing:`boat_deck_box`->contains->thing:`снасти_рыболовные_(набор)`;
CREATE thing:`подсак_складной` SET kind = 'item', category = 'fishing', name = 'Подсак складной', created_at = time::now();
RELATE thing:`boat_deck_box`->contains->thing:`подсак_складной`;
CREATE thing:`садок_для_рыбы` SET kind = 'item', category = 'fishing', name = 'Садок для рыбы', created_at = time::now();
RELATE thing:`boat_deck_box`->contains->thing:`садок_для_рыбы`;
CREATE thing:`ведро_рыболовное_15л` SET kind = 'item', category = 'fishing', name = 'Ведро рыболовное 15л', created_at = time::now();
RELATE thing:`boat_deck_box`->contains->thing:`ведро_рыболовное_15л`;
CREATE thing:`мангал_складной` SET kind = 'item', category = 'tourism', name = 'Мангал складной', created_at = time::now();
RELATE thing:`boat_deck_box`->contains->thing:`мангал_складной`;
CREATE thing:`шатёр_3×3м` SET kind = 'item', category = 'tourism', name = 'Шатёр 3×3м', created_at = time::now();
RELATE thing:`boat_deck_box`->contains->thing:`шатёр_3×3м`;
CREATE thing:`шлем_снегоходный_интеграл` SET kind = 'item', category = 'sports', name = 'Шлем снегоходный интеграл', created_at = time::now();
RELATE thing:`snowmobile_box`->contains->thing:`шлем_снегоходный_интеграл`;
CREATE thing:`очки_горнолыжные_тёмные` SET kind = 'item', category = 'sports', name = 'Очки горнолыжные тёмные', created_at = time::now();
RELATE thing:`snowmobile_box`->contains->thing:`очки_горнолыжные_тёмные`;
CREATE thing:`комбинезон_снегоходный` SET kind = 'item', category = 'sports', name = 'Комбинезон снегоходный', created_at = time::now();
RELATE thing:`snowmobile_box`->contains->thing:`комбинезон_снегоходный`;
CREATE thing:`варежки_снегоходные` SET kind = 'item', category = 'sports', name = 'Варежки снегоходные', created_at = time::now();
RELATE thing:`snowmobile_box`->contains->thing:`варежки_снегоходные`;
CREATE thing:`ботинки_снегоходные_р.43` SET kind = 'item', category = 'sports', name = 'Ботинки снегоходные р.43', created_at = time::now();
RELATE thing:`snowmobile_box`->contains->thing:`ботинки_снегоходные_р.43`;
CREATE thing:`масло_моторное_для_снегохода` SET kind = 'item', category = 'consumable', name = 'Масло моторное для снегохода', created_at = time::now();
RELATE thing:`snowmobile_box`->contains->thing:`масло_моторное_для_снегохода`;
CREATE thing:`ремень_вариатора_запасной` SET kind = 'item', category = 'auto_part', name = 'Ремень вариатора запасной', created_at = time::now();
RELATE thing:`snowmobile_box`->contains->thing:`ремень_вариатора_запасной`;
CREATE thing:`свечи_для_снегохода_(2шт)` SET kind = 'item', category = 'auto_part', name = 'Свечи для снегохода (2шт)', created_at = time::now();
RELATE thing:`snowmobile_box`->contains->thing:`свечи_для_снегохода_(2шт)`;
CREATE thing:`трос_буксировочный_снегоход` SET kind = 'item', category = 'sports', name = 'Трос буксировочный снегоход', created_at = time::now();
RELATE thing:`snowmobile_box`->contains->thing:`трос_буксировочный_снегоход`;
CREATE thing:`аптечка_снегоходная` SET kind = 'item', category = 'sports', name = 'Аптечка снегоходная', created_at = time::now();
RELATE thing:`snowmobile_box`->contains->thing:`аптечка_снегоходная`;
CREATE thing:`огнетушитель_1кг_(снегоход)` SET kind = 'item', category = 'sports', name = 'Огнетушитель 1кг (снегоход)', created_at = time::now();
RELATE thing:`snowmobile_box`->contains->thing:`огнетушитель_1кг_(снегоход)`;
CREATE thing:`навигатор_garmin_gpsmap_64` SET kind = 'item', category = 'navigation', name = 'Навигатор Garmin GPSMAP 64', created_at = time::now();
RELATE thing:`snowmobile_box`->contains->thing:`навигатор_garmin_gpsmap_64`;
CREATE thing:`лопата_снежная_складная` SET kind = 'item', category = 'sports', name = 'Лопата снежная складная', created_at = time::now();
RELATE thing:`snowmobile_box`->contains->thing:`лопата_снежная_складная`;
CREATE thing:`канистра_бензина_10л` SET kind = 'item', category = 'consumable', name = 'Канистра бензина 10л', created_at = time::now();
RELATE thing:`snowmobile_box`->contains->thing:`канистра_бензина_10л`;
CREATE thing:`osmo_pocket_3` SET kind = 'item', category = 'media_archive', name = 'Osmo Pocket 3', created_at = time::now();
RELATE thing:`electronics_shelf`->contains->thing:`osmo_pocket_3`;
CREATE thing:`gopro_hero_12` SET kind = 'item', category = 'media_archive', name = 'GoPro Hero 12', created_at = time::now();
RELATE thing:`electronics_shelf`->contains->thing:`gopro_hero_12`;
CREATE thing:`стабилизатор_dji_om6` SET kind = 'item', category = 'media_archive', name = 'Стабилизатор DJI OM6', created_at = time::now();
RELATE thing:`electronics_shelf`->contains->thing:`стабилизатор_dji_om6`;
CREATE thing:`диктофон_sony_icd_ux570` SET kind = 'item', category = 'audio', name = 'Диктофон Sony ICD-UX570', created_at = time::now();
RELATE thing:`electronics_shelf`->contains->thing:`диктофон_sony_icd_ux570`;
CREATE thing:`наушники_sony_wh_1000xm5` SET kind = 'item', category = 'audio', name = 'Наушники Sony WH-1000XM5', created_at = time::now();
RELATE thing:`electronics_shelf`->contains->thing:`наушники_sony_wh_1000xm5`;
CREATE thing:`наушники_airpods_pro_2` SET kind = 'item', category = 'audio', name = 'Наушники AirPods Pro 2', created_at = time::now();
RELATE thing:`electronics_shelf`->contains->thing:`наушники_airpods_pro_2`;
CREATE thing:`колонка_jbl_flip_6` SET kind = 'item', category = 'audio', name = 'Колонка JBL Flip 6', created_at = time::now();
RELATE thing:`electronics_shelf`->contains->thing:`колонка_jbl_flip_6`;
CREATE thing:`kindle_paperwhite_11` SET kind = 'device', role = 'reader', name = 'Kindle Paperwhite 11', created_at = time::now();
RELATE thing:`electronics_shelf`->contains->thing:`kindle_paperwhite_11`;
CREATE thing:`планшет_ipad_air_5_(сын)` SET kind = 'device', role = 'tablet', name = 'Планшет iPad Air 5 (Сын)', created_at = time::now();
RELATE thing:`electronics_shelf`->contains->thing:`планшет_ipad_air_5_(сын)`;
CREATE thing:`телефон_старый_iphone_12` SET kind = 'device', role = 'phone', name = 'Телефон старый iPhone 12', created_at = time::now();
RELATE thing:`electronics_shelf`->contains->thing:`телефон_старый_iphone_12`;
CREATE thing:`телефон_xiaomi_redmi_note_12` SET kind = 'device', role = 'phone', name = 'Телефон Xiaomi Redmi Note 12', created_at = time::now();
RELATE thing:`electronics_shelf`->contains->thing:`телефон_xiaomi_redmi_note_12`;
CREATE thing:`роутер_tp_link_ax3000` SET kind = 'device', role = 'router', name = 'Роутер TP-Link AX3000', created_at = time::now();
RELATE thing:`electronics_shelf`->contains->thing:`роутер_tp_link_ax3000`;
CREATE thing:`raspberry_pi_5_8gb` SET kind = 'device', role = 'server', name = 'Raspberry Pi 5 8GB', created_at = time::now();
RELATE thing:`electronics_shelf`->contains->thing:`raspberry_pi_5_8gb`;
CREATE thing:`nuc_intel_i5_mini_pc` SET kind = 'device', role = 'server', name = 'NUC Intel i5 mini-PC', created_at = time::now();
RELATE thing:`electronics_shelf`->contains->thing:`nuc_intel_i5_mini_pc`;
CREATE thing:`ноутбук_thinkpad_t14s` SET kind = 'device', role = 'workstation', name = 'Ноутбук ThinkPad T14s', created_at = time::now();
RELATE thing:`electronics_shelf`->contains->thing:`ноутбук_thinkpad_t14s`;
CREATE thing:`монитор_dell_27"_4k` SET kind = 'item', category = 'peripheral', name = 'Монитор Dell 27" 4K', created_at = time::now();
RELATE thing:`electronics_shelf`->contains->thing:`монитор_dell_27"_4k`;
CREATE thing:`клавиатура_механич._keychron` SET kind = 'item', category = 'peripheral', name = 'Клавиатура механич. Keychron', created_at = time::now();
RELATE thing:`electronics_shelf`->contains->thing:`клавиатура_механич._keychron`;
CREATE thing:`мышь_logitech_mx_master_3` SET kind = 'item', category = 'peripheral', name = 'Мышь Logitech MX Master 3', created_at = time::now();
RELATE thing:`electronics_shelf`->contains->thing:`мышь_logitech_mx_master_3`;
CREATE thing:`веб_камера_logitech_c920` SET kind = 'item', category = 'peripheral', name = 'Веб-камера Logitech C920', created_at = time::now();
RELATE thing:`electronics_shelf`->contains->thing:`веб_камера_logitech_c920`;
CREATE thing:`принтер_hp_laserjet_m15w` SET kind = 'item', category = 'peripheral', name = 'Принтер HP LaserJet M15w', created_at = time::now();
RELATE thing:`electronics_shelf`->contains->thing:`принтер_hp_laserjet_m15w`;
CREATE thing:`sd_карты_256gb_(3шт)` SET kind = 'item', category = 'storage_media', name = 'SD-карты 256GB (3шт)', created_at = time::now();
RELATE thing:`electronics_shelf`->contains->thing:`sd_карты_256gb_(3шт)`;
CREATE thing:`ssd_samsung_1tb_nvme` SET kind = 'item', category = 'storage_media', name = 'SSD Samsung 1TB NVMe', created_at = time::now();
RELATE thing:`electronics_shelf`->contains->thing:`ssd_samsung_1tb_nvme`;
CREATE thing:`hdd_wd_4tb_(бэкап)` SET kind = 'item', category = 'storage_media', name = 'HDD WD 4TB (бэкап)', created_at = time::now();
RELATE thing:`electronics_shelf`->contains->thing:`hdd_wd_4tb_(бэкап)`;
CREATE thing:`томат_бычье_сердце_(пакет_50шт)` SET kind = 'item', category = 'seeds', name = 'Томат Бычье сердце (пакет 50шт)', created_at = time::now();
RELATE thing:`seeds_business_storage`->contains->thing:`томат_бычье_сердце_(пакет_50шт)`;
CREATE thing:`томат_черри_микс_(пакет_100шт)` SET kind = 'item', category = 'seeds', name = 'Томат Черри микс (пакет 100шт)', created_at = time::now();
RELATE thing:`seeds_business_storage`->contains->thing:`томат_черри_микс_(пакет_100шт)`;
CREATE thing:`томат_розовый_слон_(пакет_50шт)` SET kind = 'item', category = 'seeds', name = 'Томат Розовый слон (пакет 50шт)', created_at = time::now();
RELATE thing:`seeds_business_storage`->contains->thing:`томат_розовый_слон_(пакет_50шт)`;
CREATE thing:`перец_калифорнийское_чудо_(30шт)` SET kind = 'item', category = 'seeds', name = 'Перец Калифорнийское чудо (30шт)', created_at = time::now();
RELATE thing:`seeds_business_storage`->contains->thing:`перец_калифорнийское_чудо_(30шт)`;
CREATE thing:`перец_ратунда_(пакет_30шт)` SET kind = 'item', category = 'seeds', name = 'Перец Ратунда (пакет 30шт)', created_at = time::now();
RELATE thing:`seeds_business_storage`->contains->thing:`перец_ратунда_(пакет_30шт)`;
CREATE thing:`огурец_герман_f1_(пакет_10шт)` SET kind = 'item', category = 'seeds', name = 'Огурец Герман F1 (пакет 10шт)', created_at = time::now();
RELATE thing:`seeds_business_storage`->contains->thing:`огурец_герман_f1_(пакет_10шт)`;
CREATE thing:`огурец_кураж_f1_(пакет_10шт)` SET kind = 'item', category = 'seeds', name = 'Огурец Кураж F1 (пакет 10шт)', created_at = time::now();
RELATE thing:`seeds_business_storage`->contains->thing:`огурец_кураж_f1_(пакет_10шт)`;
CREATE thing:`баклажан_щелкунчик_(пакет_20шт)` SET kind = 'item', category = 'seeds', name = 'Баклажан Щелкунчик (пакет 20шт)', created_at = time::now();
RELATE thing:`seeds_business_storage`->contains->thing:`баклажан_щелкунчик_(пакет_20шт)`;
CREATE thing:`кабачок_цукеша_(пакет_15шт)` SET kind = 'item', category = 'seeds', name = 'Кабачок Цукеша (пакет 15шт)', created_at = time::now();
RELATE thing:`seeds_business_storage`->contains->thing:`кабачок_цукеша_(пакет_15шт)`;
CREATE thing:`тыква_улыбка_(пакет_10шт)` SET kind = 'item', category = 'seeds', name = 'Тыква Улыбка (пакет 10шт)', created_at = time::now();
RELATE thing:`seeds_business_storage`->contains->thing:`тыква_улыбка_(пакет_10шт)`;
CREATE thing:`капуста_колобок_(пакет_50шт)` SET kind = 'item', category = 'seeds', name = 'Капуста Колобок (пакет 50шт)', created_at = time::now();
RELATE thing:`seeds_business_storage`->contains->thing:`капуста_колобок_(пакет_50шт)`;
CREATE thing:`морковь_нантес_(пакет_2г)` SET kind = 'item', category = 'seeds', name = 'Морковь Нантес (пакет 2г)', created_at = time::now();
RELATE thing:`seeds_business_storage`->contains->thing:`морковь_нантес_(пакет_2г)`;
CREATE thing:`свёкла_детройт_(пакет_5г)` SET kind = 'item', category = 'seeds', name = 'Свёкла Детройт (пакет 5г)', created_at = time::now();
RELATE thing:`seeds_business_storage`->contains->thing:`свёкла_детройт_(пакет_5г)`;
CREATE thing:`редис_18_дней_(пакет_5г_×20)` SET kind = 'item', category = 'seeds', name = 'Редис 18 дней (пакет 5г ×20)', created_at = time::now();
RELATE thing:`seeds_business_storage`->contains->thing:`редис_18_дней_(пакет_5г_×20)`;
CREATE thing:`укроп_грибовский_(пакет_3г_×30)` SET kind = 'item', category = 'seeds', name = 'Укроп Грибовский (пакет 3г ×30)', created_at = time::now();
RELATE thing:`seeds_business_storage`->contains->thing:`укроп_грибовский_(пакет_3г_×30)`;
CREATE thing:`петрушка_богатырь_(пакет_2г_×20)` SET kind = 'item', category = 'seeds', name = 'Петрушка Богатырь (пакет 2г ×20)', created_at = time::now();
RELATE thing:`seeds_business_storage`->contains->thing:`петрушка_богатырь_(пакет_2г_×20)`;
CREATE thing:`базилик_генуэзский_(пакет_0.2г_×15)` SET kind = 'item', category = 'seeds', name = 'Базилик Генуэзский (пакет 0.2г ×15)', created_at = time::now();
RELATE thing:`seeds_business_storage`->contains->thing:`базилик_генуэзский_(пакет_0.2г_×15)`;
CREATE thing:`клубника_альбион_(пакет_20шт)` SET kind = 'item', category = 'seeds', name = 'Клубника Альбион (пакет 20шт)', created_at = time::now();
RELATE thing:`seeds_business_storage`->contains->thing:`клубника_альбион_(пакет_20шт)`;
CREATE thing:`клубника_королева_елизавета_(20шт)` SET kind = 'item', category = 'seeds', name = 'Клубника Королева Елизавета (20шт)', created_at = time::now();
RELATE thing:`seeds_business_storage`->contains->thing:`клубника_королева_елизавета_(20шт)`;
CREATE thing:`цветы_астры_смесь_(пакет_0.5г_×10)` SET kind = 'item', category = 'seeds', name = 'Цветы Астры смесь (пакет 0.5г ×10)', created_at = time::now();
RELATE thing:`seeds_business_storage`->contains->thing:`цветы_астры_смесь_(пакет_0.5г_×10)`;
CREATE thing:`цветы_бархатцы_(пакет_0.5г_×10)` SET kind = 'item', category = 'seeds', name = 'Цветы Бархатцы (пакет 0.5г ×10)', created_at = time::now();
RELATE thing:`seeds_business_storage`->contains->thing:`цветы_бархатцы_(пакет_0.5г_×10)`;
CREATE thing:`саженец_яблони_антоновка_2л` SET kind = 'item', category = 'sapling', name = 'Саженец яблони Антоновка 2л', created_at = time::now();
RELATE thing:`seeds_business_storage`->contains->thing:`саженец_яблони_антоновка_2л`;
CREATE thing:`саженец_груши_конференция_2л` SET kind = 'item', category = 'sapling', name = 'Саженец груши Конференция 2л', created_at = time::now();
RELATE thing:`seeds_business_storage`->contains->thing:`саженец_груши_конференция_2л`;
CREATE thing:`саженец_смородины_чёрная_(5шт)` SET kind = 'item', category = 'sapling', name = 'Саженец смородины чёрная (5шт)', created_at = time::now();
RELATE thing:`seeds_business_storage`->contains->thing:`саженец_смородины_чёрная_(5шт)`;
CREATE thing:`саженец_малины_полана_(5шт)` SET kind = 'item', category = 'sapling', name = 'Саженец малины Полана (5шт)', created_at = time::now();
RELATE thing:`seeds_business_storage`->contains->thing:`саженец_малины_полана_(5шт)`;
CREATE thing:`саженец_голубики_(3шт)` SET kind = 'item', category = 'sapling', name = 'Саженец голубики (3шт)', created_at = time::now();
RELATE thing:`seeds_business_storage`->contains->thing:`саженец_голубики_(3шт)`;
CREATE thing:`грунт_для_рассады_50л_(10_мешков)` SET kind = 'item', category = 'substrate', name = 'Грунт для рассады 50л (10 мешков)', created_at = time::now();
RELATE thing:`seeds_business_storage`->contains->thing:`грунт_для_рассады_50л_(10_мешков)`;
CREATE thing:`торф_верховой_250л_(5_мешков)` SET kind = 'item', category = 'substrate', name = 'Торф верховой 250л (5 мешков)', created_at = time::now();
RELATE thing:`seeds_business_storage`->contains->thing:`торф_верховой_250л_(5_мешков)`;
CREATE thing:`удобрение_буйские_npk_16_16_16_(1кг×10)` SET kind = 'item', category = 'fertilizer', name = 'Удобрение Буйские NPK 16-16-16 (1кг×10)', created_at = time::now();
RELATE thing:`seeds_business_storage`->contains->thing:`удобрение_буйские_npk_16_16_16_(1кг×10)`;
CREATE thing:`стимулятор_роста_эпин_(10_флак.)` SET kind = 'item', category = 'growth_regulator', name = 'Стимулятор роста Эпин (10 флак.)', created_at = time::now();
RELATE thing:`seeds_business_storage`->contains->thing:`стимулятор_роста_эпин_(10_флак.)`;
CREATE thing:`рассадные_стаканы_0.5л_(200шт)` SET kind = 'item', category = 'container', name = 'Рассадные стаканы 0.5л (200шт)', created_at = time::now();
RELATE thing:`seeds_business_storage`->contains->thing:`рассадные_стаканы_0.5л_(200шт)`;
CREATE thing:`пакеты_зип_семенные_9×14_(1000шт)` SET kind = 'item', category = 'container', name = 'Пакеты зип семенные 9×14 (1000шт)', created_at = time::now();
RELATE thing:`seeds_business_storage`->contains->thing:`пакеты_зип_семенные_9×14_(1000шт)`;
CREATE thing:`этикетки_самоклеящиеся_a4_(10_листов)` SET kind = 'item', category = 'container', name = 'Этикетки самоклеящиеся A4 (10 листов)', created_at = time::now();
RELATE thing:`seeds_business_storage`->contains->thing:`этикетки_самоклеящиеся_a4_(10_листов)`;

-- Итого вещей: 779

-- ── participant ────────────────────────────────────────────────────────────
RELATE thing:`student_алексей_иванов`->participant->thing:`school_class_7b`;
RELATE thing:`student_мария_петрова`->participant->thing:`school_class_7b`;
RELATE thing:`student_дмитрий_сидоров`->participant->thing:`school_class_7b`;
RELATE thing:`student_анна_козлова`->participant->thing:`school_class_7b`;
RELATE thing:`student_михаил_новиков`->participant->thing:`school_class_7b`;
RELATE thing:`student_екатерина_морозова`->participant->thing:`school_class_7b`;
RELATE thing:`student_артём_волков`->participant->thing:`school_class_7b`;
RELATE thing:`student_ольга_лебедева`->participant->thing:`school_class_7b`;
RELATE thing:`student_николай_соколов`->participant->thing:`school_class_7b`;
RELATE thing:`student_татьяна_попова`->participant->thing:`school_class_7b`;
RELATE thing:`student_андрей_васильев`->participant->thing:`school_class_7b`;
RELATE thing:`student_юлия_зайцева`->participant->thing:`school_class_7b`;
RELATE thing:`student_сергей_кузнецов`->participant->thing:`school_class_7b`;
RELATE thing:`student_наталья_мельникова`->participant->thing:`school_class_7b`;
RELATE thing:`student_павел_орлов`->participant->thing:`school_class_7b`;
RELATE thing:`student_виктория_фёдорова`->participant->thing:`school_class_7b`;
RELATE thing:`student_илья_голубев`->participant->thing:`school_class_7b`;
RELATE thing:`student_светлана_виноградова`->participant->thing:`school_class_7b`;
RELATE thing:`student_роман_богданов`->participant->thing:`school_class_7b`;
RELATE thing:`student_алина_ковалёва`->participant->thing:`school_class_7b`;
RELATE thing:`student_максим_чернов`->participant->thing:`school_class_7b`;
RELATE thing:`student_дарья_беляева`->participant->thing:`school_class_7b`;
RELATE thing:`student_евгений_громов`->participant->thing:`school_class_7b`;
RELATE thing:`student_ксения_тихонова`->participant->thing:`school_class_7b`;
RELATE thing:`student_владимир_щукин`->participant->thing:`school_class_7b`;
RELATE thing:`user_son`->participant->thing:`school_class_7b`;
RELATE thing:`teacher_ivanova`->participant->thing:`school_class_7b`;
RELATE thing:`director_smirnov`->participant->thing:`school_42`;
RELATE thing:`social_kozlova`->participant->thing:`school_42`;
RELATE thing:`teacher_ivanova`->participant->thing:`school_42`;
RELATE thing:`user_papa`->participant->thing:`user_grandma`;
RELATE thing:`user_mama`->participant->thing:`user_grandma`;

-- ── expert_in ──────────────────────────────────────────────────────────────
RELATE thing:`user_papa`->expert_in->thing:`moto_bmw`;
RELATE thing:`user_papa`->expert_in->thing:`garage_workbench`;
RELATE thing:`user_papa`->expert_in->thing:`boat_viking`;
RELATE thing:`user_mama`->expert_in->thing:`seeds_business_storage`;
RELATE thing:`user_mama`->expert_in->thing:`dacha_garden`;
RELATE thing:`doc_pediatr`->expert_in->thing:`clinic_cabinet_p`;
RELATE thing:`doc_stomatolog`->expert_in->thing:`clinic_cabinet_s`;
RELATE thing:`teacher_ivanova`->expert_in->thing:`school_class_7b`;

-- ── can_access ─────────────────────────────────────────────────────────────
RELATE thing:`user_papa`->can_access->thing:`apt`;
RELATE thing:`user_papa`->can_access->thing:`garage`;
RELATE thing:`user_papa`->can_access->thing:`storage`;
RELATE thing:`user_papa`->can_access->thing:`dacha`;
RELATE thing:`user_mama`->can_access->thing:`apt`;
RELATE thing:`user_mama`->can_access->thing:`garage`;
RELATE thing:`user_mama`->can_access->thing:`storage`;
RELATE thing:`user_mama`->can_access->thing:`dacha`;
RELATE thing:`user_son`->can_access->thing:`apt`;
RELATE thing:`user_son`->can_access->thing:`garage`;
RELATE thing:`user_son`->can_access->thing:`storage`;
RELATE thing:`user_son`->can_access->thing:`dacha`;
RELATE thing:`user_papa`->can_access->thing:`boat_viking`;
RELATE thing:`user_papa`->can_access->thing:`snowmobile_arctic`;
RELATE thing:`user_mama`->can_access->thing:`seeds_business_storage`;
RELATE thing:`user_son`->can_access->thing:`school_class_7b`;
RELATE thing:`neighbor_vasich`->can_access->thing:`garage`;

-- ── identified_by ──────────────────────────────────────────────────────────
RELATE thing:`moto_bmw`->identified_by->thing:`птс_bmw_r1250gs`;
RELATE thing:`car_vesta`->identified_by->thing:`птс_lada_vesta`;
RELATE thing:`user_papa`->identified_by->thing:`паспорт_(папа)_—_копия`;
RELATE thing:`user_mama`->identified_by->thing:`паспорт_(мама)_—_копия`;
RELATE thing:`user_son`->identified_by->thing:`свидетельство_о_рождении_сына`;

-- ── represents ────────────────────────────────────────────────────────────
RELATE thing:`птс_bmw_r1250gs`->represents->thing:`moto_bmw`;
RELATE thing:`стс_bmw_r1250gs`->represents->thing:`moto_bmw`;
RELATE thing:`птс_lada_vesta`->represents->thing:`car_vesta`;
RELATE thing:`свидетельство_о_собственности_квартира`->represents->thing:`apt`;
RELATE thing:`свидетельство_собственности_гараж`->represents->thing:`garage`;
RELATE thing:`медицинский_полис_омс_(папа)`->represents->thing:`user_papa`;
RELATE thing:`медицинский_полис_омс_(мама)`->represents->thing:`user_mama`;
RELATE thing:`медицинский_полис_омс_(сын)`->represents->thing:`user_son`;

-- ── filed_with ────────────────────────────────────────────────────────────
CREATE thing:`org_gibdd` SET kind = 'org', name = 'ГИБДД', created_at = time::now();
CREATE thing:`org_mfc` SET kind = 'org', name = 'МФЦ', created_at = time::now();
CREATE thing:`org_rosreestr` SET kind = 'org', name = 'Росреестр', created_at = time::now();
CREATE thing:`org_oms` SET kind = 'org', name = 'ФОМС (фонд ОМС)', created_at = time::now();
CREATE thing:`org_strahovaya` SET kind = 'org', name = 'Страховая компания РЕСО', created_at = time::now();
RELATE thing:`стс_bmw_r1250gs`->filed_with->thing:`org_gibdd`;
RELATE thing:`стс_lada_vesta`->filed_with->thing:`org_gibdd`;
RELATE thing:`осаго_bmw_2026`->filed_with->thing:`org_strahovaya`;
RELATE thing:`осаго_vesta_2026`->filed_with->thing:`org_strahovaya`;
RELATE thing:`страховой_полис_квартира_2026`->filed_with->thing:`org_strahovaya`;
RELATE thing:`выписка_егрн_квартира`->filed_with->thing:`org_rosreestr`;
RELATE thing:`медицинский_полис_омс_(папа)`->filed_with->thing:`org_oms`;
RELATE thing:`медицинский_полис_омс_(мама)`->filed_with->thing:`org_oms`;
RELATE thing:`медицинский_полис_омс_(сын)`->filed_with->thing:`org_oms`;

-- ── lent_to / borrowed_from ──────────────────────────────────────────────
RELATE thing:`дрель_шуруповёрт_makita_18v`->lent_to->thing:`neighbor_vasich` SET note = 'одолжено до возврата';
RELATE thing:`болгарка_125мм_bosch`->lent_to->thing:`neighbor_vasich` SET note = 'одолжено до возврата';
RELATE thing:`компрессор_50л`->lent_to->thing:`neighbor_vasich` SET note = 'одолжено до возврата';
RELATE thing:`дюна`->borrowed_from->thing:`friend_kolya` SET note = 'взято почитать';
RELATE thing:`1984_(оруэлл)`->borrowed_from->thing:`friend_kolya` SET note = 'взято почитать';

-- ── promised_to ───────────────────────────────────────────────────────────
CREATE thing:`task_grandma_garden` SET kind = 'task', name = 'Обустроить огород у бабушки', status = 'in_progress', priority = 'высокий', created_at = time::now();
RELATE thing:`task_grandma_garden`->assigned_to->thing:`user_papa`;
RELATE thing:`task_grandma_garden`->about->thing:`grandma_garden`;
RELATE thing:`task_grandma_garden`->promised_to->thing:`user_grandma`;
CREATE thing:`task_bike_for_son` SET kind = 'task', name = 'Купить горный велосипед сыну', status = 'not_started', created_at = time::now();
RELATE thing:`task_bike_for_son`->promised_to->thing:`user_son`;
RELATE thing:`task_bike_for_son`->assigned_to->thing:`user_papa`;
CREATE thing:`task_seeds_order_1` SET kind = 'task', name = 'Подготовить заказ для Зинаиды Павловны', status = 'done', created_at = time::now();
RELATE thing:`task_seeds_order_1`->promised_to->thing:`customer_zina`;
RELATE thing:`task_seeds_order_1`->assigned_to->thing:`user_mama`;

-- ── related_to ────────────────────────────────────────────────────────────
RELATE thing:`фильтр_масляный_bmw_r1250gs`->related_to->thing:`moto_bmw`;
RELATE thing:`фильтр_воздушный_bmw_r1250gs`->related_to->thing:`moto_bmw`;
RELATE thing:`масло_моторное_10w_40_(4л)`->related_to->thing:`moto_bmw`;
RELATE thing:`колодки_тормозные_bmw_передние`->related_to->thing:`moto_bmw`;
RELATE thing:`свечи_зажигания_bmw_(4шт)`->related_to->thing:`moto_bmw`;
RELATE thing:`фильтр_масляный_vesta`->related_to->thing:`car_vesta`;
RELATE thing:`ремень_грм_vesta_комплект`->related_to->thing:`car_vesta`;
RELATE thing:`шина_зимняя_195_65_r15_(4шт)`->related_to->thing:`car_vesta`;
RELATE thing:`шина_летняя_195_65_r15_(4шт)`->related_to->thing:`car_vesta`;
RELATE thing:`мотор_подвесной_15л.с.`->related_to->thing:`boat_viking`;
RELATE thing:`ремень_вариатора_запасной`->related_to->thing:`snowmobile_arctic`;

-- ── references ────────────────────────────────────────────────────────────
RELATE thing:`сервисная_книжка_bmw`->references->thing:`птс_bmw_r1250gs`;
RELATE thing:`инструкция_bmw_r1250gs_ru`->references->thing:`птс_bmw_r1250gs`;
RELATE thing:`осаго_bmw_2026`->references->thing:`птс_bmw_r1250gs`;
RELATE thing:`осаго_vesta_2026`->references->thing:`птс_lada_vesta`;

-- ── invalidates ───────────────────────────────────────────────────────────
CREATE thing:`osago_bmw_2025` SET kind = 'document', name = 'ОСАГО BMW 2025 (истёк)', status = 'revoked', created_at = time::now();
CREATE thing:`osago_vesta_2025` SET kind = 'document', name = 'ОСАГО Vesta 2025 (истёк)', status = 'revoked', created_at = time::now();
RELATE thing:`осаго_bmw_2026`->invalidates->thing:`osago_bmw_2025`;
RELATE thing:`осаго_vesta_2026`->invalidates->thing:`osago_vesta_2025`;

-- ── Объявления Авито (linked_to) ─────────────────────────────────────────
CREATE thing:`avito_velosiped` SET kind = 'listing', name = 'Продаётся горный велосипед', platform = 'Авито', price = 2500, currency = 'RUB', status = 'active', created_at = time::now();
RELATE thing:`avito_velosiped`->linked_to->thing:`велосипед_горный`;
RELATE thing:`user_papa`->produces->thing:`avito_velosiped`;
CREATE thing:`avito_lyzhi` SET kind = 'listing', name = 'Горные лыжи Salomon + крепления', platform = 'Авито', price = 8000, currency = 'RUB', status = 'active', created_at = time::now();
RELATE thing:`avito_lyzhi`->linked_to->thing:`лыжи_горные_170см`;
RELATE thing:`user_papa`->produces->thing:`avito_lyzhi`;
CREATE thing:`avito_skate` SET kind = 'listing', name = 'Скейтборд, редко катался', platform = 'Авито', price = 800, currency = 'RUB', status = 'active', created_at = time::now();
RELATE thing:`avito_skate`->linked_to->thing:`скейтборд`;
RELATE thing:`user_papa`->produces->thing:`avito_skate`;
CREATE thing:`avito_bolg230` SET kind = 'listing', name = 'Болгарка 230мм, рабочая', platform = 'Авито', price = 3500, currency = 'RUB', status = 'active', created_at = time::now();
RELATE thing:`avito_bolg230`->linked_to->thing:`болгарка_230мм`;
RELATE thing:`user_papa`->produces->thing:`avito_bolg230`;
CREATE thing:`avito_kompressor` SET kind = 'listing', name = 'Компрессор 50л, самовывоз', platform = 'Авито', price = 12000, currency = 'RUB', status = 'active', created_at = time::now();
RELATE thing:`avito_kompressor`->linked_to->thing:`компрессор_50л`;
RELATE thing:`user_papa`->produces->thing:`avito_kompressor`;
CREATE thing:`avito_iphone12` SET kind = 'listing', name = 'iPhone 12 64GB, всё работает', platform = 'Авито', price = 18000, currency = 'RUB', status = 'active', created_at = time::now();
RELATE thing:`avito_iphone12`->linked_to->thing:`телефон_старый_iphone_12`;
RELATE thing:`user_papa`->produces->thing:`avito_iphone12`;
CREATE thing:`avito_fotoalbum` SET kind = 'listing', name = 'Фотоальбомы семейные (3 штуки)', platform = 'Авито', price = 500, currency = 'RUB', status = 'active', created_at = time::now();
RELATE thing:`avito_fotoalbum`->linked_to->thing:`фотоальбом_семейный_(3шт)`;
RELATE thing:`user_papa`->produces->thing:`avito_fotoalbum`;

-- ── produces / located_at / used ────────────────────────────────────────
RELATE thing:`supplier_agropark`->produces->thing:`seeds_business_storage`;
RELATE thing:`user_mama`->produces->thing:`seeds_business_storage`;
CREATE thing:`harvest_2025` SET kind = 'event', name = 'Урожай дачи 2025', year = 2025, description = 'Томаты, огурцы, картошка', created_at = time::now();
RELATE thing:`dacha_garden`->produces->thing:`harvest_2025`;
RELATE thing:`boat_viking`->located_at->thing:`marina`;
RELATE thing:`snowmobile_arctic`->located_at->thing:`dacha_shed`;
RELATE thing:`car_vesta`->located_at->thing:`garage`;
RELATE thing:`moto_bmw`->located_at->thing:`garage`;
RELATE thing:`user_papa`->used->thing:`мультиметр_fluke_87v`;
RELATE thing:`user_papa`->used->thing:`паяльная_станция_hakko`;
RELATE thing:`user_papa`->used->thing:`сварочный_инвертор_200а`;
RELATE thing:`user_papa`->used->thing:`moto_bmw`;
RELATE thing:`user_papa`->used->thing:`boat_viking`;
RELATE thing:`user_papa`->used->thing:`snowmobile_arctic`;
RELATE thing:`user_mama`->used->thing:`секатор_садовый`;
RELATE thing:`user_mama`->used->thing:`лейка_10л`;
RELATE thing:`user_son`->used->thing:`планшет_ipad_air_5_(сын)`;
RELATE thing:`user_son`->used->thing:`велосипед_горный`;

-- ── Медицинские записи ────────────────────────────────────────────────────
CREATE thing:`diag_schnu` SET kind = 'diagnosis', name = 'Синдром хронического нежелания делать уроки (СХНДУ)', description = 'Лечение: смена учителя математики, прогулки на свежем воздухе', status = 'recorded', created_at = time::now();
RELATE thing:`user_son`->about->thing:`diag_schnu`;
RELATE thing:`doc_pediatr`->answered->thing:`diag_schnu`;
RELATE thing:`diag_schnu`->located_at->thing:`clinic_cabinet_p`;
RELATE thing:`user_son`->participant->thing:`clinic_cabinet_p`;
CREATE thing:`diag_caries` SET kind = 'diagnosis', name = 'Кариес третьей степени с отягощением леденцами', description = 'Лечение: 2 пломбы, запрет чупа-чупсов на месяц', status = 'recorded', created_at = time::now();
RELATE thing:`user_son`->about->thing:`diag_caries`;
RELATE thing:`doc_stomatolog`->answered->thing:`diag_caries`;
RELATE thing:`diag_caries`->located_at->thing:`clinic_cabinet_s`;
RELATE thing:`user_son`->participant->thing:`clinic_cabinet_s`;
CREATE thing:`diag_samokat` SET kind = 'diagnosis', name = 'Острый ушиб колена при падении с самоката', description = 'Лечение: мазь Вольтарен, покой 3 дня, больше не гонять', status = 'recorded', created_at = time::now();
RELATE thing:`user_son`->about->thing:`diag_samokat`;
RELATE thing:`doc_surgeon`->answered->thing:`diag_samokat`;
RELATE thing:`diag_samokat`->located_at->thing:`clinic_1`;
RELATE thing:`user_son`->participant->thing:`clinic_1`;
CREATE thing:`diag_allerg` SET kind = 'diagnosis', name = 'Аллергия на домашние задания по алгебре', description = 'Лечение: антигистаминное + репетитор Захаровой И.В.', status = 'recorded', created_at = time::now();
RELATE thing:`user_son`->about->thing:`diag_allerg`;
RELATE thing:`doc_allergolog`->answered->thing:`diag_allerg`;
RELATE thing:`diag_allerg`->located_at->thing:`clinic_1`;
RELATE thing:`user_son`->participant->thing:`clinic_1`;
CREATE thing:`diag_papa_back` SET kind = 'diagnosis', name = 'Хронический остеохондроз поясничного отдела', description = 'Лечение: ЛФК, не поднимать более 30 кг за один раз', status = 'recorded', created_at = time::now();
RELATE thing:`user_papa`->about->thing:`diag_papa_back`;
RELATE thing:`doc_surgeon`->answered->thing:`diag_papa_back`;
RELATE thing:`diag_papa_back`->located_at->thing:`clinic_1`;
RELATE thing:`user_papa`->participant->thing:`clinic_1`;
CREATE thing:`task_doctor_visit_1` SET kind = 'task', name = 'Записаться к педиатру (ежегодный осмотр)', status = 'done', created_at = time::now();
RELATE thing:`task_doctor_visit_1`->assigned_to->thing:`user_mama`;
RELATE thing:`task_doctor_visit_1`->about->thing:`user_son`;
RELATE thing:`task_doctor_visit_1`->needs->thing:`diag_schnu`;
CREATE thing:`task_stom_visit` SET kind = 'task', name = 'Поставить пломбу Сыну (стоматолог)', status = 'done', created_at = time::now();
RELATE thing:`task_stom_visit`->assigned_to->thing:`user_mama`;
RELATE thing:`task_stom_visit`->about->thing:`user_son`;

-- ── Контакты / история знакомств ─────────────────────────────────────────
CREATE thing:`contact_mechanic_igor` SET kind = 'person', name = 'Игорь — моторист катера', note = 'Чинит мотор по звонку, +7-909-111-22-33', created_at = time::now();
RELATE thing:`contact_mechanic_igor`->located_at->thing:`marina`;
RELATE thing:`user_papa`->related_to->thing:`contact_mechanic_igor`;
CREATE thing:`contact_snowmobile_andrey` SET kind = 'person', name = 'Андрей Снегоход', note = 'Хранит наш снегоход на даче, договорились на бартер', created_at = time::now();
RELATE thing:`contact_snowmobile_andrey`->located_at->thing:`dacha`;
RELATE thing:`user_papa`->related_to->thing:`contact_snowmobile_andrey`;
CREATE thing:`contact_seeds_petrov` SET kind = 'person', name = 'Петров Иван — семенной завод', note = 'Прямые поставки томатов, скидка 15% при заказе от 100 пачек', created_at = time::now();
RELATE thing:`contact_seeds_petrov`->located_at->thing:`supplier_agropark`;
RELATE thing:`user_papa`->related_to->thing:`contact_seeds_petrov`;
CREATE thing:`contact_avito_buyer_1` SET kind = 'person', name = 'Покупатель с Авито (велосипед)', note = 'Торгуется, хочет за 2000, встреча у метро', created_at = time::now();
RELATE thing:`user_papa`->related_to->thing:`contact_avito_buyer_1`;
CREATE thing:`contact_notary` SET kind = 'person', name = 'Нотариус Соловьёв А.А.', note = 'Оформлял доверенность на машину, офис Ленина 12', created_at = time::now();
RELATE thing:`contact_notary`->located_at->thing:`org_mfc`;
RELATE thing:`user_papa`->related_to->thing:`contact_notary`;
CREATE thing:`contact_electrician_fedya` SET kind = 'person', name = 'Федя-электрик', note = 'Делал проводку в гараже, рекомендован соседом Васичем', created_at = time::now();
RELATE thing:`contact_electrician_fedya`->located_at->thing:`garage`;
RELATE thing:`user_papa`->related_to->thing:`contact_electrician_fedya`;
CREATE thing:`contact_dacha_neighbor_tanya` SET kind = 'person', name = 'Таня с соседней дачи', note = 'Обменивается рассадой с Мамой, берёт помидоры', created_at = time::now();
RELATE thing:`contact_dacha_neighbor_tanya`->located_at->thing:`dacha`;
RELATE thing:`user_papa`->related_to->thing:`contact_dacha_neighbor_tanya`;

-- ── Платежи и счета ────────────────────────────────────────────────────────
CREATE thing:`org_internet_provider` SET kind = 'org', name = 'Ростелеком (интернет)', created_at = time::now();
CREATE thing:`org_electric` SET kind = 'org', name = 'Мосэнерго (электрика)', created_at = time::now();
CREATE thing:`org_phone` SET kind = 'org', name = 'МТС (телефон)', created_at = time::now();
CREATE thing:`org_bank_mortgage` SET kind = 'org', name = 'Сбербанк (ипотека)', created_at = time::now();
CREATE thing:`org_school_fund` SET kind = 'org', name = 'Фонд класса 7Б', created_at = time::now();
CREATE thing:`org_section_karate` SET kind = 'org', name = 'Секция карате «Тигр»', created_at = time::now();
CREATE thing:`pay_inet_jan` SET kind = 'payment', name = 'Интернет январь 2026', amount = 600, currency = 'RUB', category = 'интернет', date = '2026-01-01', status = 'paid', created_at = time::now();
RELATE thing:`user_mama`->about->thing:`pay_inet_jan`;
RELATE thing:`pay_inet_jan`->filed_with->thing:`org_internet_provider`;
CREATE thing:`pay_inet_feb` SET kind = 'payment', name = 'Интернет февраль 2026', amount = 600, currency = 'RUB', category = 'интернет', date = '2026-02-01', status = 'paid', created_at = time::now();
RELATE thing:`user_mama`->about->thing:`pay_inet_feb`;
RELATE thing:`pay_inet_feb`->filed_with->thing:`org_internet_provider`;
CREATE thing:`pay_inet_mar` SET kind = 'payment', name = 'Интернет март 2026', amount = 600, currency = 'RUB', category = 'интернет', date = '2026-03-01', status = 'paid', created_at = time::now();
RELATE thing:`user_mama`->about->thing:`pay_inet_mar`;
RELATE thing:`pay_inet_mar`->filed_with->thing:`org_internet_provider`;
CREATE thing:`pay_inet_apr` SET kind = 'payment', name = 'Интернет апрель 2026', amount = 600, currency = 'RUB', category = 'интернет', date = '2026-04-01', status = 'paid', created_at = time::now();
RELATE thing:`user_mama`->about->thing:`pay_inet_apr`;
RELATE thing:`pay_inet_apr`->filed_with->thing:`org_internet_provider`;
CREATE thing:`pay_inet_may` SET kind = 'payment', name = 'Интернет май 2026', amount = 600, currency = 'RUB', category = 'интернет', date = '2026-05-01', status = 'paid', created_at = time::now();
RELATE thing:`user_mama`->about->thing:`pay_inet_may`;
RELATE thing:`pay_inet_may`->filed_with->thing:`org_internet_provider`;
CREATE thing:`pay_elec_jan` SET kind = 'payment', name = 'Электричество январь', amount = 2340, currency = 'RUB', category = 'коммуналка', date = '2026-01-10', status = 'paid', created_at = time::now();
RELATE thing:`user_papa`->about->thing:`pay_elec_jan`;
RELATE thing:`pay_elec_jan`->filed_with->thing:`org_electric`;
CREATE thing:`pay_elec_feb` SET kind = 'payment', name = 'Электричество февраль', amount = 1980, currency = 'RUB', category = 'коммуналка', date = '2026-02-10', status = 'paid', created_at = time::now();
RELATE thing:`user_papa`->about->thing:`pay_elec_feb`;
RELATE thing:`pay_elec_feb`->filed_with->thing:`org_electric`;
CREATE thing:`pay_elec_mar` SET kind = 'payment', name = 'Электричество март', amount = 1750, currency = 'RUB', category = 'коммуналка', date = '2026-03-10', status = 'paid', created_at = time::now();
RELATE thing:`user_papa`->about->thing:`pay_elec_mar`;
RELATE thing:`pay_elec_mar`->filed_with->thing:`org_electric`;
CREATE thing:`pay_elec_apr` SET kind = 'payment', name = 'Электричество апрель', amount = 1620, currency = 'RUB', category = 'коммуналка', date = '2026-04-10', status = 'paid', created_at = time::now();
RELATE thing:`user_papa`->about->thing:`pay_elec_apr`;
RELATE thing:`pay_elec_apr`->filed_with->thing:`org_electric`;
CREATE thing:`pay_elec_may` SET kind = 'payment', name = 'Электричество май', amount = 1410, currency = 'RUB', category = 'коммуналка', date = '2026-05-10', status = 'paid', created_at = time::now();
RELATE thing:`user_papa`->about->thing:`pay_elec_may`;
RELATE thing:`pay_elec_may`->filed_with->thing:`org_electric`;
CREATE thing:`pay_phone_jan` SET kind = 'payment', name = 'МТС январь 2026', amount = 499, currency = 'RUB', category = 'телефон', date = '2026-01-05', status = 'paid', created_at = time::now();
RELATE thing:`user_papa`->about->thing:`pay_phone_jan`;
RELATE thing:`pay_phone_jan`->filed_with->thing:`org_phone`;
CREATE thing:`pay_phone_feb` SET kind = 'payment', name = 'МТС февраль 2026', amount = 499, currency = 'RUB', category = 'телефон', date = '2026-02-05', status = 'paid', created_at = time::now();
RELATE thing:`user_papa`->about->thing:`pay_phone_feb`;
RELATE thing:`pay_phone_feb`->filed_with->thing:`org_phone`;
CREATE thing:`pay_phone_mar` SET kind = 'payment', name = 'МТС март 2026', amount = 499, currency = 'RUB', category = 'телефон', date = '2026-03-05', status = 'paid', created_at = time::now();
RELATE thing:`user_papa`->about->thing:`pay_phone_mar`;
RELATE thing:`pay_phone_mar`->filed_with->thing:`org_phone`;
CREATE thing:`pay_phone_apr` SET kind = 'payment', name = 'МТС апрель 2026', amount = 499, currency = 'RUB', category = 'телефон', date = '2026-04-05', status = 'paid', created_at = time::now();
RELATE thing:`user_papa`->about->thing:`pay_phone_apr`;
RELATE thing:`pay_phone_apr`->filed_with->thing:`org_phone`;
CREATE thing:`pay_phone_may` SET kind = 'payment', name = 'МТС май 2026', amount = 499, currency = 'RUB', category = 'телефон', date = '2026-05-05', status = 'paid', created_at = time::now();
RELATE thing:`user_papa`->about->thing:`pay_phone_may`;
RELATE thing:`pay_phone_may`->filed_with->thing:`org_phone`;
CREATE thing:`pay_mort_jan` SET kind = 'payment', name = 'Ипотека январь 2026', amount = 42300, currency = 'RUB', category = 'ипотека', date = '2026-01-15', status = 'paid', created_at = time::now();
RELATE thing:`user_papa`->about->thing:`pay_mort_jan`;
RELATE thing:`pay_mort_jan`->filed_with->thing:`org_bank_mortgage`;
CREATE thing:`pay_mort_feb` SET kind = 'payment', name = 'Ипотека февраль 2026', amount = 42300, currency = 'RUB', category = 'ипотека', date = '2026-02-15', status = 'paid', created_at = time::now();
RELATE thing:`user_papa`->about->thing:`pay_mort_feb`;
RELATE thing:`pay_mort_feb`->filed_with->thing:`org_bank_mortgage`;
CREATE thing:`pay_mort_mar` SET kind = 'payment', name = 'Ипотека март 2026', amount = 42300, currency = 'RUB', category = 'ипотека', date = '2026-03-15', status = 'paid', created_at = time::now();
RELATE thing:`user_papa`->about->thing:`pay_mort_mar`;
RELATE thing:`pay_mort_mar`->filed_with->thing:`org_bank_mortgage`;
CREATE thing:`pay_mort_apr` SET kind = 'payment', name = 'Ипотека апрель 2026', amount = 42300, currency = 'RUB', category = 'ипотека', date = '2026-04-15', status = 'paid', created_at = time::now();
RELATE thing:`user_papa`->about->thing:`pay_mort_apr`;
RELATE thing:`pay_mort_apr`->filed_with->thing:`org_bank_mortgage`;
CREATE thing:`pay_mort_may` SET kind = 'payment', name = 'Ипотека май 2026', amount = 42300, currency = 'RUB', category = 'ипотека', date = '2026-05-15', status = 'paid', created_at = time::now();
RELATE thing:`user_papa`->about->thing:`pay_mort_may`;
RELATE thing:`pay_mort_may`->filed_with->thing:`org_bank_mortgage`;
CREATE thing:`pay_school_jan` SET kind = 'payment', name = 'Фонд класса январь', amount = 1000, currency = 'RUB', category = 'школа', date = '2026-01-20', status = 'paid', created_at = time::now();
RELATE thing:`user_mama`->about->thing:`pay_school_jan`;
RELATE thing:`pay_school_jan`->filed_with->thing:`org_school_fund`;
CREATE thing:`pay_school_apr` SET kind = 'payment', name = 'Фонд класса апрель', amount = 1000, currency = 'RUB', category = 'школа', date = '2026-04-20', status = 'paid', created_at = time::now();
RELATE thing:`user_mama`->about->thing:`pay_school_apr`;
RELATE thing:`pay_school_apr`->filed_with->thing:`org_school_fund`;
CREATE thing:`pay_karate_jan` SET kind = 'payment', name = 'Карате январь', amount = 3500, currency = 'RUB', category = 'секция', date = '2026-01-01', status = 'paid', created_at = time::now();
RELATE thing:`user_mama`->about->thing:`pay_karate_jan`;
RELATE thing:`pay_karate_jan`->filed_with->thing:`org_section_karate`;
CREATE thing:`pay_karate_feb` SET kind = 'payment', name = 'Карате февраль', amount = 3500, currency = 'RUB', category = 'секция', date = '2026-02-01', status = 'paid', created_at = time::now();
RELATE thing:`user_mama`->about->thing:`pay_karate_feb`;
RELATE thing:`pay_karate_feb`->filed_with->thing:`org_section_karate`;
CREATE thing:`pay_karate_mar` SET kind = 'payment', name = 'Карате март', amount = 3500, currency = 'RUB', category = 'секция', date = '2026-03-01', status = 'paid', created_at = time::now();
RELATE thing:`user_mama`->about->thing:`pay_karate_mar`;
RELATE thing:`pay_karate_mar`->filed_with->thing:`org_section_karate`;
CREATE thing:`pay_karate_apr` SET kind = 'payment', name = 'Карате апрель', amount = 3500, currency = 'RUB', category = 'секция', date = '2026-04-01', status = 'paid', created_at = time::now();
RELATE thing:`user_mama`->about->thing:`pay_karate_apr`;
RELATE thing:`pay_karate_apr`->filed_with->thing:`org_section_karate`;
CREATE thing:`pay_karate_may` SET kind = 'payment', name = 'Карате май', amount = 3500, currency = 'RUB', category = 'секция', date = '2026-05-01', status = 'paid', created_at = time::now();
RELATE thing:`user_mama`->about->thing:`pay_karate_may`;
RELATE thing:`pay_karate_may`->filed_with->thing:`org_section_karate`;
CREATE thing:`inc_seeds_feb` SET kind = 'payment', name = 'Продажа семян февраль', amount = 8400, currency = 'RUB', category = 'доход', date = '2026-02-15', status = 'paid', created_at = time::now();
RELATE thing:`user_mama`->about->thing:`inc_seeds_feb`;
RELATE thing:`inc_seeds_feb`->filed_with->thing:`customer_zina`;
CREATE thing:`inc_seeds_mar` SET kind = 'payment', name = 'Продажа семян март', amount = 15600, currency = 'RUB', category = 'доход', date = '2026-03-10', status = 'paid', created_at = time::now();
RELATE thing:`user_mama`->about->thing:`inc_seeds_mar`;
RELATE thing:`inc_seeds_mar`->filed_with->thing:`customer_club_urozhai`;
CREATE thing:`inc_seeds_apr` SET kind = 'payment', name = 'Продажа семян апрель', amount = 22000, currency = 'RUB', category = 'доход', date = '2026-04-05', status = 'paid', created_at = time::now();
RELATE thing:`user_mama`->about->thing:`inc_seeds_apr`;
RELATE thing:`inc_seeds_apr`->filed_with->thing:`customer_irina`;
CREATE thing:`inc_seeds_may` SET kind = 'payment', name = 'Продажа саженцев май', amount = 31500, currency = 'RUB', category = 'доход', date = '2026-05-12', status = 'paid', created_at = time::now();
RELATE thing:`user_mama`->about->thing:`inc_seeds_may`;
RELATE thing:`inc_seeds_may`->filed_with->thing:`customer_galina`;
CREATE thing:`exp_seeds_jan` SET kind = 'payment', name = 'Закупка АгроПарк январь', amount = 18000, currency = 'RUB', category = 'расход', date = '2026-01-20', status = 'paid', created_at = time::now();
RELATE thing:`user_mama`->about->thing:`exp_seeds_jan`;
RELATE thing:`exp_seeds_jan`->filed_with->thing:`supplier_agropark`;
CREATE thing:`exp_seeds_mar` SET kind = 'payment', name = 'Закупка АгроПарк март', amount = 24000, currency = 'RUB', category = 'расход', date = '2026-03-01', status = 'paid', created_at = time::now();
RELATE thing:`user_mama`->about->thing:`exp_seeds_mar`;
RELATE thing:`exp_seeds_mar`->filed_with->thing:`supplier_agropark`;
CREATE thing:`pay_to_moto` SET kind = 'payment', name = 'ТО BMW R1250GS 2025', amount = 18500, currency = 'RUB', category = 'ТО', date = '2025-09-15', status = 'paid', created_at = time::now();
RELATE thing:`user_papa`->about->thing:`pay_to_moto`;
RELATE thing:`pay_to_moto`->filed_with->thing:`org_gibdd`;
CREATE thing:`pay_to_vesta` SET kind = 'payment', name = 'ТО Lada Vesta 2025', amount = 6800, currency = 'RUB', category = 'ТО', date = '2025-11-20', status = 'paid', created_at = time::now();
RELATE thing:`user_papa`->about->thing:`pay_to_vesta`;
RELATE thing:`pay_to_vesta`->filed_with->thing:`org_gibdd`;
CREATE thing:`pay_osago_bmw` SET kind = 'payment', name = 'ОСАГО BMW 2026', amount = 4200, currency = 'RUB', category = 'страховка', date = '2026-01-10', status = 'paid', created_at = time::now();
RELATE thing:`user_papa`->about->thing:`pay_osago_bmw`;
RELATE thing:`pay_osago_bmw`->filed_with->thing:`org_strahovaya`;
CREATE thing:`pay_osago_vesta` SET kind = 'payment', name = 'ОСАГО Vesta 2026', amount = 5800, currency = 'RUB', category = 'страховка', date = '2026-01-15', status = 'paid', created_at = time::now();
RELATE thing:`user_papa`->about->thing:`pay_osago_vesta`;
RELATE thing:`pay_osago_vesta`->filed_with->thing:`org_strahovaya`;

-- ── Шаблоны платежей ──────────────────────────────────────────────────────
CREATE thing:`tmpl_pay_internet` SET kind = 'task', name = 'Оплата интернета (Ростелеком)', template = true, period = 'ежемесячно', cron = '0 9 1 * *', enabled = true, created_at = time::now(), amount = 600;
RELATE thing:`tmpl_pay_internet`->assigned_to->thing:`user_mama`;
RELATE thing:`tmpl_pay_internet`->filed_with->thing:`org_internet_provider`;
CREATE thing:`tmpl_pay_electric` SET kind = 'task', name = 'Оплата электричества', template = true, period = 'ежемесячно', cron = '0 9 10 * *', enabled = true, created_at = time::now();
RELATE thing:`tmpl_pay_electric`->assigned_to->thing:`user_papa`;
RELATE thing:`tmpl_pay_electric`->filed_with->thing:`org_electric`;
CREATE thing:`tmpl_pay_phone` SET kind = 'task', name = 'Оплата МТС', template = true, period = 'ежемесячно', cron = '0 9 5 * *', enabled = true, created_at = time::now(), amount = 499;
RELATE thing:`tmpl_pay_phone`->assigned_to->thing:`user_papa`;
RELATE thing:`tmpl_pay_phone`->filed_with->thing:`org_phone`;
CREATE thing:`tmpl_pay_mortgage` SET kind = 'task', name = 'Ипотека Сбербанк', template = true, period = 'ежемесячно', cron = '0 9 15 * *', enabled = true, created_at = time::now(), amount = 42300;
RELATE thing:`tmpl_pay_mortgage`->assigned_to->thing:`user_papa`;
RELATE thing:`tmpl_pay_mortgage`->filed_with->thing:`org_bank_mortgage`;
CREATE thing:`tmpl_pay_karate` SET kind = 'task', name = 'Секция карате', template = true, period = 'ежемесячно', cron = '0 9 1 * *', enabled = true, created_at = time::now(), amount = 3500;
RELATE thing:`tmpl_pay_karate`->assigned_to->thing:`user_mama`;
RELATE thing:`tmpl_pay_karate`->filed_with->thing:`org_section_karate`;

-- ── Задачи ─────────────────────────────────────────────────────────────────
CREATE thing:`tmpl_to_moto` SET kind = 'task', name = 'ТО мотоцикла BMW R1250GS (шаблон)', template = true, period = 'счётчик', trigger_field = 'odometer_km', trigger_threshold = 10000, trigger_source = thing:moto_bmw, last_trigger_value = 43200, enabled = true, created_at = time::now();
CREATE thing:`task_oil_moto` SET kind = 'task', name = 'Купить масло 10W-40 для BMW', status = 'not_started', created_at = time::now();
RELATE thing:`task_oil_moto`->assigned_to->thing:`user_papa`;
RELATE thing:`task_oil_moto`->needs->thing:`масло_моторное_10w_40_(4л)`;
CREATE thing:`task_to_moto` SET kind = 'task', name = 'ТО мотоцикла BMW R1250GS', status = 'not_started', created_at = time::now();
RELATE thing:`task_to_moto`->assigned_to->thing:`user_papa`;
RELATE thing:`task_to_moto`->about->thing:`moto_bmw`;
RELATE thing:`task_to_moto`->depends_on->thing:`task_oil_moto`;
RELATE thing:`task_to_moto`->requires->thing:`task_oil_moto`;
RELATE thing:`task_to_moto`->triggered_by->thing:`tmpl_to_moto`;
RELATE thing:`task_to_moto`->needs->thing:`фильтр_масляный_bmw_r1250gs`;
RELATE thing:`task_to_moto`->needs->thing:`фильтр_воздушный_bmw_r1250gs`;
CREATE thing:`task_garage_sort` SET kind = 'task', name = 'Разобрать стеллаж в гараже', status = 'not_started', created_at = time::now();
RELATE thing:`task_garage_sort`->assigned_to->thing:`user_papa`;
RELATE thing:`task_garage_sort`->about->thing:`garage`;
CREATE thing:`task_school_pay` SET kind = 'task', name = 'Оплатить карате (май)', status = 'done', created_at = time::now();
RELATE thing:`task_school_pay`->assigned_to->thing:`user_mama`;
RELATE thing:`task_school_pay`->about->thing:`user_son`;
RELATE thing:`task_school_pay`->references->thing:`pay_karate_may`;
CREATE thing:`task_to_vesta` SET kind = 'task', name = 'ТО Lada Vesta (осень 2026)', status = 'not_started', created_at = time::now();
RELATE thing:`task_to_vesta`->assigned_to->thing:`user_papa`;
RELATE thing:`task_to_vesta`->about->thing:`car_vesta`;
RELATE thing:`task_to_vesta`->references->thing:`птс_lada_vesta`;
RELATE thing:`task_to_vesta`->needs->thing:`фильтр_масляный_vesta`;
RELATE thing:`task_to_vesta`->needs->thing:`фильтр_воздушный_vesta`;
RELATE thing:`task_to_vesta`->needs->thing:`масло_моторное_5w_30_(4л)`;
CREATE thing:`task_boat_season` SET kind = 'task', name = 'Подготовить катер к сезону 2026', status = 'in_progress', created_at = time::now();
RELATE thing:`task_boat_season`->assigned_to->thing:`user_papa`;
RELATE thing:`task_boat_season`->about->thing:`boat_viking`;
RELATE thing:`task_boat_season`->needs->thing:`масло_для_мотора_2t_1л`;
RELATE thing:`task_boat_season`->needs->thing:`свечи_для_мотора_(2шт)`;
RELATE thing:`task_boat_season`->needs->thing:`топливный_фильтр_(мотор)`;
RELATE thing:`task_grandma_garden`->needs->thing:`лопата_штыковая`;
RELATE thing:`task_grandma_garden`->needs->thing:`грунт_для_рассады_50л_(10_мешков)`;
RELATE thing:`task_grandma_garden`->needs->thing:`удобрение_кемира_(1кг)`;
RELATE thing:`task_grandma_garden`->requires->thing:`task_seeds_order_1`;
CREATE thing:`task_snmob_insure` SET kind = 'task', name = 'Оформить страховку на снегоход', status = 'not_started', created_at = time::now();
RELATE thing:`task_snmob_insure`->assigned_to->thing:`user_papa`;
RELATE thing:`task_snmob_insure`->about->thing:`snowmobile_arctic`;
RELATE thing:`task_snmob_insure`->filed_with->thing:`org_strahovaya`;
CREATE thing:`task_tires_swap` SET kind = 'task', name = 'Переобуть Весту на летнюю резину', status = 'done', created_at = time::now();
RELATE thing:`task_tires_swap`->assigned_to->thing:`user_papa`;
RELATE thing:`task_tires_swap`->about->thing:`car_vesta`;
RELATE thing:`task_tires_swap`->needs->thing:`шина_летняя_195_65_r15_(4шт)`;
CREATE thing:`task_return_tools` SET kind = 'task', name = 'Забрать инструменты у Васича', status = 'not_started', created_at = time::now();
RELATE thing:`task_return_tools`->assigned_to->thing:`user_papa`;
RELATE thing:`task_return_tools`->about->thing:`neighbor_vasich`;
RELATE thing:`task_return_tools`->needs->thing:`дрель_шуруповёрт_makita_18v`;
CREATE thing:`task_log_boat_hours` SET kind = 'task', name = 'Записать моточасы катера после сезона', status = 'not_started', created_at = time::now();
RELATE thing:`task_log_boat_hours`->assigned_to->thing:`user_papa`;
RELATE thing:`task_log_boat_hours`->about->thing:`boat_viking`;
RELATE thing:`task_log_boat_hours`->triggered_by->thing:`harvest_2025`;
CREATE thing:`task_avito_followup` SET kind = 'task', name = 'Обновить объявления на Авито (поднять)', status = 'not_started', created_at = time::now();
RELATE thing:`task_avito_followup`->assigned_to->thing:`user_papa`;
RELATE thing:`task_avito_followup`->about->thing:`avito_velosiped`;
RELATE thing:`task_avito_followup`->about->thing:`avito_lyzhi`;
RELATE thing:`task_avito_followup`->about->thing:`avito_skate`;
RELATE thing:`task_avito_followup`->about->thing:`avito_bolg230`;
RELATE thing:`task_avito_followup`->about->thing:`avito_kompressor`;
RELATE thing:`task_avito_followup`->about->thing:`avito_iphone12`;
RELATE thing:`task_avito_followup`->about->thing:`avito_fotoalbum`;

-- ── Wiki: страницы ────────────────────────────────────────────────────────
CREATE thing:`wiki_bmw_maintenance` SET kind = 'page', name = 'ТО BMW R1250GS — регламент', body = '# ТО BMW R1250GS — регламент обслуживания

## Интервалы

| Пробег | Работа |
|--------|--------|
| 10 000 км | Замена масла + фильтр |
| 10 000 км | Проверка тормозных колодок |
| 20 000 км | Свечи зажигания |
| 20 000 км | Воздушный фильтр |
| 40 000 км | Тормозная жидкость |
| 40 000 км | Вилочное масло |

## Масла и жидкости

- **Моторное**: Motul 7100 10W-40 (3.75л)
- **Вилочное**: Motul Fork Oil Light 5W
- **Тормозная**: DOT 4

## История ТО

- 2025-09-15: 43 200 км — замена масла, фильтры, колодки передние

## Особенности

Мотоцикл оснащён системой ABS и ASC (контроль тяги).
При замене масла обязательно греть двигатель 5 минут перед сливом.
Момент затяжки сливной пробки: 25 Нм.
', created_at = time::now();
RELATE thing:`wiki_bmw_maintenance`->about->thing:`moto_bmw`;
RELATE thing:`user_papa`->produces->thing:`wiki_bmw_maintenance`;
CREATE thing:`wiki_garage_org` SET kind = 'page', name = 'Организация гаража — схема', body = '# Организация гаража

## Стеллажи (слева направо)

**Стеллаж 1** — инструмент ручной (верхние полки), крепёж (нижние)
**Стеллаж 2** — электрика, кабели, гофра
**Стеллаж 3** — авто/мото расходники (масла, фильтры)
**Стеллаж 4** — стройматериалы, шпаклёвки
**Стеллаж 5** — сезонное (шины, цепи)

## Верстак

Слева: тиски. По центру: рабочая зона. Справа: паяльная станция.
Ящики под верстаком: мелкий инструмент, электроинструмент.

## Правила

1. Инструмент возвращать на место сразу после использования
2. Перед уходом — протереть верстак, выключить свет
3. Огнетушитель у входа, всегда заряжен

## Что нужно сделать

- [ ] Повесить перфоборд для отвёрток
- [ ] Подписать все ящики с крепежом
- [ ] Установить розетки 220В над верстаком
', created_at = time::now();
RELATE thing:`wiki_garage_org`->about->thing:`garage`;
RELATE thing:`user_papa`->produces->thing:`wiki_garage_org`;
CREATE thing:`wiki_vesta_log` SET kind = 'page', name = 'Lada Vesta — бортовой журнал', body = '# Lada Vesta — бортовой журнал

## Технические данные

- **Год**: 2019
- **Двигатель**: 1.6 H4M (113 л.с.)
- **КПП**: механика 5-ст.
- **Пробег на 2026-01**: 87 400 км

## История обслуживания

| Дата | Пробег | Работа | Стоимость |
|------|--------|--------|-----------|
| 2025-11-20 | 85 000 км | ТО (масло, фильтры) | 6 800 ₽ |
| 2025-06-10 | 78 000 км | Замена тормозных колодок | 4 200 ₽ |
| 2024-10-05 | 70 000 км | Ремень ГРМ + помпа | 18 500 ₽ |

## Сезонное хранение шин

Зимние: **гараж, стеллаж 5** (с октября по апрель)
Летние: **гараж, стеллаж 5** (с апреля по октябрь)

## Контакты СТО

Автосервис «Ладья», ул. Механическая 12, тел. 8-800-555-35-35
Мастер — Дмитрий, знает нашу машину
', created_at = time::now();
RELATE thing:`wiki_vesta_log`->about->thing:`car_vesta`;
RELATE thing:`user_papa`->produces->thing:`wiki_vesta_log`;
CREATE thing:`wiki_dacha_plan` SET kind = 'page', name = 'Дача — план огорода 2026', body = '# Дача — план огорода 2026

## Грядки (схема с севера на юг)

```
[Север — забор]
Грядка А: томаты (Бычье сердце, Черри)
Грядка Б: перец, баклажан
Грядка В: огурцы (на шпалере)
Грядка Г: кабачки, тыква
Грядка Д: зелень (укроп, петрушка, базилик)
Грядка Е: клубника (многолетняя)
[Дом]
```

## Расписание посадок 2026

- **Февраль**: рассада томатов, перца на подоконник
- **Март**: рассада баклажана, сельдерея
- **Апрель**: пересадка рассады в теплицу
- **Май**: открытый грунт после заморозков

## Что купить к сезону

- Торф 2 мешка (для рассады)
- Агроволокно 10м
- Колышки 50шт
- Капельный полив (шланг + таймер)

## Итоги 2025

Урожай хороший. Особенно томаты «Бычье сердце» — с одного куста до 5 кг.
Огурцы заболели мучнистой росой в августе — обработать медьсодержащим в 2026.
', created_at = time::now();
RELATE thing:`wiki_dacha_plan`->about->thing:`dacha_garden`;
RELATE thing:`user_papa`->produces->thing:`wiki_dacha_plan`;
CREATE thing:`wiki_son_school` SET kind = 'page', name = 'Сын — школьная жизнь', body = '# Сын — школьная жизнь

## Класс 7Б, Школа №42

**Классный руководитель**: Иванова Наталья Петровна
**Контакт**: natasha.ivanova@school42.ru, чат WhatsApp «7Б родители»

## Расписание

Пн: математика, физика, история, физкультура
Вт: русский, литература, иностранный (англ.), биология
Ср: математика, химия, технология, музыка
Чт: русский, история, география, физкультура
Пт: математика, физика, иностранный, ИЗО

## Секции и кружки

- **Карате «Тигр»**: вт, чт 18:00–19:30 (оплата 3500₽/мес)

## Важные контакты

- Директор: Смирнов Андрей Викторович
- Соцпедагог: Козлова Светлана Ивановна (каб. 12)
- Мед. кабинет: каб. 5, пн-пт 8:00–15:00

## Документы

- ОМС полис актуален до 2028
- Прививочный сертификат в школьном медкабинете
', created_at = time::now();
RELATE thing:`wiki_son_school`->about->thing:`user_son`;
RELATE thing:`user_papa`->produces->thing:`wiki_son_school`;
CREATE thing:`wiki_seeds_business` SET kind = 'page', name = 'Бизнес: торговля семенами', body = '# Бизнес: торговля семенами и саженцами

## Описание

Мама занимается реализацией семян и саженцев через соцсети и рынок.
Сезон: февраль–май (основной), август–сентябрь (осенние саженцы).

## Каналы продаж

1. ВКонтакте: группа «Семена от Наташи» (1 200 подписчиков)
2. Авито: объявления с фото
3. Местный рынок: суббота 8:00–13:00 (сезон)
4. Сарафанное радио: Клуб дачников «Урожай»

## Поставщики

- **АгроПарк Воронеж** — основной оптовик, скидка 30% от розницы
  Контакт: Петров Иван, заказы от 5000₽ с бесплатной доставкой
- Частные коллекционеры (редкие сорта томатов)

## Маржинальность

Томаты: закупка 15₽/пакет → продажа 60-80₽. Маржа ~4-5х.
Саженцы: закупка 150-300₽ → продажа 400-700₽. Маржа ~2-2.5х.

## Склад

Балкон (t=+5..+15°C). Семена в ziplock-пакетах, подписаны маркером.
Срок хранения: томаты/перец 3 года, огурцы 5 лет.

## Задачи на сезон 2026

- [ ] Завести учёт продаж в таблице (Мама откладывает)
- [ ] Сделать нормальные фото для объявлений
- [ ] Попробовать Wildberries Маркет
', created_at = time::now();
RELATE thing:`wiki_seeds_business`->about->thing:`seeds_business_storage`;
RELATE thing:`user_papa`->produces->thing:`wiki_seeds_business`;
CREATE thing:`wiki_boat_guide` SET kind = 'page', name = 'Катер Viking 470 — руководство', body = '# Катер Viking 470 — руководство и регламент

## Технические данные

- **Длина**: 4.7 м, **Ширина**: 1.9 м
- **Мотор**: Tohatsu 15 л.с. (2-тактный)
- **Макс. нагрузка**: 4 человека / 350 кг
- **Место стоянки**: Речной причал, место №14

## Сезонная подготовка (весна)

1. Проверить лодку на течи (заполнить водой в тазу)
2. Масло в моторе (2T, 1л на сезон)
3. Свечи зажигания (каждые 2 сезона)
4. Топливный фильтр (каждый год)
5. Триммировать мотор, проверить крепление

## Безопасность

- Спасжилеты надевать ВСЕГДА, включая детей
- Маяк EPIRB заряжен (проверять батарею ежегодно)
- VHF радиостанция: канал 16 (вызов и дистресс)
- Максимальная скорость у берега: 5 узлов

## Места стоянок на реке

- Причал «Зелёный берег» (25 км вверх) — бесплатно
- Турбаза «Ока» (40 км) — платная стоянка 500₽/ночь
- Остров Песчаный — якорная стоянка, хорошая рыбалка
', created_at = time::now();
RELATE thing:`wiki_boat_guide`->about->thing:`boat_viking`;
RELATE thing:`user_papa`->produces->thing:`wiki_boat_guide`;

-- ── Wiki: заметки ─────────────────────────────────────────────────────────
CREATE thing:`note_vasich_tools` SET kind = 'note', name = 'Одолженный инструмент у Васича', body = 'Одолжил шуруповёрт, болгарку и компрессор. Просил вернуть до конца мая. Звонить на мобильный +7-916-222-33-44. Живёт в 47-й квартире.', created_at = time::now();
RELATE thing:`note_vasich_tools`->about->thing:`neighbor_vasich`;
CREATE thing:`note_grandma_garden_plan` SET kind = 'note', name = 'Что нужно для огорода бабушки', body = 'Бабушка хочет: грядки под томаты (3 шт), грядка под огурцы, зелень. Нужно привезти: торф 2 мешка, колышки, рассаду томатов от Мамы. Папа обещал сделать до июня. Бабушка напомнила уже 3 раза.', created_at = time::now();
RELATE thing:`note_grandma_garden_plan`->about->thing:`task_grandma_garden`;
CREATE thing:`note_boat_season_2026` SET kind = 'note', name = 'Заметки по катеру на сезон 2026', body = 'Игорь (моторист) сказал: мотор в порядке, но карбюратор надо почистить. Стоянка оплачена до сентября. Нужно купить новые весла (старые сломали в 2025). Планируем поездку на остров Песчаный в июле — взять мангал и ночевать.', created_at = time::now();
RELATE thing:`note_boat_season_2026`->about->thing:`boat_viking`;
CREATE thing:`note_son_karate` SET kind = 'note', name = 'Карате — прогресс', body = 'Тренер Максим Александрович говорит прогресс хороший. Следующий пояс (синий) — экзамен в сентябре. Нужна новая кимоно (вырос из старой). Размер 140 сейчас.', created_at = time::now();
RELATE thing:`note_son_karate`->about->thing:`user_son`;
CREATE thing:`note_avito_tips` SET kind = 'note', name = 'Советы по продажам на Авито', body = 'Объявления лучше поднимать в четверг вечером и воскресенье утром — больше просмотров. Велосипед: торговаться можно до 2200, ниже не отдавать. Компрессор: только самовывоз, тяжёлый (35кг). Звонить не раньше 10 утра.', created_at = time::now();
RELATE thing:`note_avito_tips`->about->thing:`user_papa`;
CREATE thing:`note_diag_allergy` SET kind = 'note', name = 'Аллергия у Сына — что делать', body = 'Аллерголог Носков сказал: сдать кровь на панель аллергенов. Пока принимать Лоратадин 1 таб/день в период обострения. Следующий приём через 3 месяца. Запись через Госуслуги.', created_at = time::now();
RELATE thing:`note_diag_allergy`->about->thing:`diag_allerg`;

-- ── Wiki: записи журнала (kind: запись) ───────────────────────────────────
CREATE thing:`log_moto_odometer_1` SET kind = 'log_entry', name = 'Одометр BMW — 2025-09-15', body = 'Перед ТО. Масло Motul 7100 10W-40 (3.75л), оба фильтра, передние колодки.', counter_value = 43200, created_at = time::now();
RELATE thing:`log_moto_odometer_1`->about->thing:`moto_bmw`;
RELATE thing:`log_moto_odometer_1`->triggered_by->thing:`moto_bmw`;
CREATE thing:`log_moto_odometer_2` SET kind = 'log_entry', name = 'Одометр BMW — 2026-05-01', body = 'Начало сезона 2026. Всё в норме.', counter_value = 46800, created_at = time::now();
RELATE thing:`log_moto_odometer_2`->about->thing:`moto_bmw`;
RELATE thing:`log_moto_odometer_2`->triggered_by->thing:`moto_bmw`;
CREATE thing:`log_vesta_odometer_1` SET kind = 'log_entry', name = 'Одометр Vesta — ТО 2025-11', body = 'ТО: масло, фильтры. Колодки ещё 30%.', counter_value = 85000, created_at = time::now();
RELATE thing:`log_vesta_odometer_1`->about->thing:`car_vesta`;
RELATE thing:`log_vesta_odometer_1`->triggered_by->thing:`car_vesta`;
CREATE thing:`log_boat_hours_1` SET kind = 'log_entry', name = 'Моточасы катера — 2025-09', body = 'Конец сезона 2025. Масло заменено. Карбюратор немного подтекает — к Игорю.', counter_value = 127, created_at = time::now();
RELATE thing:`log_boat_hours_1`->about->thing:`boat_viking`;
RELATE thing:`log_boat_hours_1`->triggered_by->thing:`boat_viking`;

-- ── Версионирование: ОСАГО (режим replace) ─────────────────────────────────
CREATE thing:`осаго_bmw_2025` SET kind = 'document', name = 'ОСАГО BMW 2025', status = 'archived', created_at = time::now();
RELATE thing:`осаго_bmw_2026`->supersedes->thing:`осаго_bmw_2025` SET reason = 'продление полиса', at = time::now();
CREATE thing:`осаго_vesta_2025` SET kind = 'document', name = 'ОСАГО Vesta 2025', status = 'archived', created_at = time::now();
RELATE thing:`осаго_vesta_2026`->supersedes->thing:`осаго_vesta_2025` SET reason = 'продление полиса', at = time::now();

-- ── Версионирование: регламент ТО (режим coexist) ──────────────────────────
CREATE thing:`reglament_to_bmw` SET kind = 'document', is_family = true, name = 'Регламент ТО BMW', version_policy = 'coexist', created_at = time::now();
CREATE thing:`reglament_to_bmw@1` SET kind = 'document', name = 'Регламент ТО BMW v1', version = '1.0', created_at = time::now();
CREATE thing:`reglament_to_bmw@2` SET kind = 'document', name = 'Регламент ТО BMW v2', version = '2.0', created_at = time::now();
RELATE thing:`reglament_to_bmw@1`->part_of->thing:`reglament_to_bmw`;
RELATE thing:`reglament_to_bmw@2`->part_of->thing:`reglament_to_bmw`;
RELATE thing:`reglament_to_bmw@2`->supersedes->thing:`reglament_to_bmw@1` SET reason = 'добавлен пункт по тормозной жидкости', at = time::now();
RELATE thing:`reglament_to_bmw@2`->about->thing:`moto_bmw`;

CREATE thing:`task_to_bmw_2026` SET kind = 'task', name = 'ТО BMW по регламенту', status = 'not_started', created_at = time::now();
RELATE thing:`task_to_bmw_2026`->requires->thing:`reglament_to_bmw` SET constraint = '>=2,<3';
RELATE thing:`task_to_bmw_2026`->used->thing:`reglament_to_bmw@2` SET resolved_at = time::now();
RELATE thing:`task_to_bmw_2026`->about->thing:`moto_bmw`;
RELATE thing:`task_to_bmw_2026`->assigned_to->thing:`user_papa`;

-- ── derived_from (происхождение / lineage) ─────────────────────────────────
-- Цепочка PDF → чанк → embedding + миниатюра из скана ОСАГО BMW
CREATE thing:`file_osago_bmw_scan` SET kind = 'file', name = 'Скан ОСАГО BMW 2026.pdf', mime = 'application/pdf', created_at = time::now();
RELATE thing:`file_osago_bmw_scan`->represents->thing:`осаго_bmw_2026`;
CREATE thing:`chunk_osago_bmw_001` SET kind = 'chunk', name = 'ОСАГО BMW — чанк 1', text = 'Страхователь, период страхования, КБМ...', created_at = time::now();
RELATE thing:`chunk_osago_bmw_001`->derived_from->thing:`file_osago_bmw_scan` SET method = 'chunk', at = time::now();
CREATE thing:`emb_osago_bmw_001` SET kind = 'embedding', name = 'ОСАГО BMW — embedding чанка 1', dim = 1024, created_at = time::now();
RELATE thing:`emb_osago_bmw_001`->derived_from->thing:`chunk_osago_bmw_001` SET method = 'embed', at = time::now();
CREATE thing:`file_osago_bmw_thumb` SET kind = 'file', name = 'ОСАГО BMW — миниатюра', mime = 'image/webp', created_at = time::now();
RELATE thing:`file_osago_bmw_thumb`->derived_from->thing:`file_osago_bmw_scan` SET method = 'thumbnail', at = time::now();

-- Датасет готов.
-- Вещей: 779 | Локаций: 63
-- Рёбра: contains, part_of, assigned_to, about, depends_on,
--        lent_to, borrowed_from, triggered_by, expert_in, answered,
--        promised_to, represents, can_access, related_to, references,
--        identified_by, linked_to, invalidates, filed_with, participant,
--        located_at, produces, used, needs, requires, supersedes,
--        derived_from  [все 27]

-- ═══ Семья (group) и контакты как participant {role: 'contact'} ═══════════
CREATE thing:`family` SET kind = 'group', name = 'Семья', created_at = time::now();
RELATE thing:`user_papa`->part_of->thing:`family`;
RELATE thing:`user_mama`->part_of->thing:`family`;
RELATE thing:`user_son`->part_of->thing:`family`;
RELATE thing:`family`->participant->thing:`contact_mechanic_igor` SET role = 'contact';
RELATE thing:`family`->participant->thing:`contact_snowmobile_andrey` SET role = 'contact';
RELATE thing:`family`->participant->thing:`contact_seeds_petrov` SET role = 'contact';
RELATE thing:`family`->participant->thing:`contact_avito_buyer_1` SET role = 'contact';
RELATE thing:`family`->participant->thing:`contact_notary` SET role = 'contact';
RELATE thing:`family`->participant->thing:`contact_electrician_fedya` SET role = 'contact';
RELATE thing:`family`->participant->thing:`contact_dacha_neighbor_tanya` SET role = 'contact';

-- ═══ Living: примеры animal/plant (D-05) + appointment (мед-паттерн) ══════
CREATE thing:`pet_murka` SET kind = 'animal', name = 'Мурка', species = 'кошка', wikidata = 'Q146', created_at = time::now();
RELATE thing:`pet_murka`->located_at->thing:`apt`;
CREATE thing:`tomato_bed_3` SET kind = 'plant', name = 'Грядка томатов №3', species = 'томат', stage = 'growing', wikidata = 'Q23501', created_at = time::now();
RELATE thing:`tomato_bed_3`->located_at->thing:`dacha_garden`;
CREATE thing:`event_vet_murka` SET kind = 'event', subtype = 'appointment', name = 'Приём у ветеринара — Мурка', status = 'planned', date = '2026-08-05', created_at = time::now();
RELATE thing:`event_vet_murka`->about->thing:`pet_murka`;
RELATE thing:`event_vet_murka`->participant->thing:`user_mama` SET role = 'сопровождающий';
-- ═══ Мета-классы субъектов и стартовая типизация рёбер (D-43) ══════════════
-- Классы — концепты-группировки в vocab:domovoy_kind (is_class=true), НЕ значения kind.
-- from_kinds/to_kinds на концептах рёбер: слаги kind или классов; NONE = любой.
-- Все enforce=false (soft): машинерия fn::check_edge появится с воркерами.
CREATE thing:`class_party` SET kind = 'concept', identifier = 'party', is_class = true, _i18n = { ru: { label: 'Социальный субъект' }, en: { label: 'Party' } }, created_at = time::now();
RELATE thing:`class_party`->part_of->thing:`vocab_domovoy_kind`;
CREATE thing:`class_actor` SET kind = 'concept', identifier = 'actor', is_class = true, _i18n = { ru: { label: 'Исполнитель' }, en: { label: 'Actor' } }, created_at = time::now();
RELATE thing:`class_actor`->part_of->thing:`vocab_domovoy_kind`;
RELATE thing:`class_party`->part_of->thing:`class_actor`;
RELATE thing:`kind_person`->part_of->thing:`class_party`;
RELATE thing:`kind_group`->part_of->thing:`class_party`;
RELATE thing:`kind_org`->part_of->thing:`class_party`;
RELATE thing:`kind_agent`->part_of->thing:`class_actor`;
RELATE thing:`kind_worker`->part_of->thing:`class_actor`;
RELATE thing:`kind_gateway`->part_of->thing:`class_actor`;
UPDATE thing:`edge_lent_to` SET from_kinds = ['item','device'], to_kinds = ['party'], cardinality = 'many-to-one', enforce = false;
UPDATE thing:`edge_borrowed_from` SET from_kinds = ['item','device'], to_kinds = ['party'], cardinality = 'many-to-one', enforce = false;
UPDATE thing:`edge_promised_to` SET from_kinds = ['task'], to_kinds = ['party'], cardinality = 'many-to-many', enforce = false;
UPDATE thing:`edge_assigned_to` SET from_kinds = NONE, to_kinds = ['actor'], cardinality = 'many-to-one', enforce = false;
UPDATE thing:`edge_participant` SET from_kinds = NONE, to_kinds = ['party'], cardinality = 'many-to-many', enforce = false;
UPDATE thing:`edge_expert_in` SET from_kinds = ['person','org'], to_kinds = NONE, cardinality = 'many-to-many', enforce = false;
UPDATE thing:`edge_filed_with` SET from_kinds = ['appeal'], to_kinds = ['org'], cardinality = 'many-to-one', enforce = false;
UPDATE thing:`edge_can_access` SET from_kinds = NONE, to_kinds = NONE, cardinality = 'many-to-many', enforce = false;

-- ═══ Класс container + типизация contains (D-51, D-52) ═════════════════════
CREATE thing:`class_container` SET kind = 'concept', identifier = 'container', is_class = true, _i18n = { ru: { label: 'Может содержать' }, en: { label: 'Container' } }, created_at = time::now();
RELATE thing:`class_container`->part_of->thing:`vocab_domovoy_kind`;
RELATE thing:`kind_location`->part_of->thing:`class_container`;
RELATE thing:`kind_item`->part_of->thing:`class_container`;
RELATE thing:`kind_device`->part_of->thing:`class_container`;
UPDATE thing:`edge_contains` SET from_kinds = ['container'], to_kinds = NONE, cardinality = 'one-to-many', enforce = false;

-- ═══ Системные view: workspace «Склад» (D-50) ══════════════════════════════
CREATE thing:`view_inbox` SET kind = 'view', subtype = 'smart_list', slug = 'inbox', query = "SELECT * FROM thing WHERE kind = 'item' AND category = NONE", bulk = true, _i18n = { ru: { label: 'Без категории' }, en: { label: 'Uncategorized' } }, created_at = time::now();
CREATE thing:`view_items_all` SET kind = 'view', subtype = 'smart_list', slug = 'items', query = "SELECT * FROM thing WHERE kind = 'item'", columns = ['Title', 'CategoryChip', 'LocationCrumb'], _i18n = { ru: { label: 'Все вещи' }, en: { label: 'All items' } }, created_at = time::now();
CREATE thing:`view_storage_tree` SET kind = 'view', subtype = 'tree', slug = 'storage', component = 'LocationTree', _i18n = { ru: { label: 'Дерево хранения' }, en: { label: 'Storage tree' } }, created_at = time::now();
CREATE thing:`view_lent` SET kind = 'view', subtype = 'smart_list', slug = 'lent', query = "SELECT in AS item, out AS holder, since FROM lent_to", columns = ['Title', 'LentToCard', 'SinceAge'], _i18n = { ru: { label: 'Одолжено' }, en: { label: 'Lent out' } }, created_at = time::now();
CREATE thing:`ws_sklad` SET kind = 'view', subtype = 'workspace', slug = 'sklad', icon = 'warehouse', sidebar = [thing:`view_inbox`, thing:`view_items_all`, thing:`view_storage_tree`, thing:`view_lent`], home = thing:`view_storage_tree`, _i18n = { ru: { label: 'Склад' }, en: { label: 'Storage' } }, created_at = time::now();

-- ═══ Живые примеры дуальности контейнеров (D-51, D-52) ═════════════════════
-- Холодильник = item-контейнер: вещь (бренд, гарантия) И место хранения
CREATE thing:`fridge_kitchen` SET kind = 'item', name = 'Холодильник Bosch KGN39', brand = 'bosch', model = 'KGN39', category = 'refrigerator', created_at = time::now();
RELATE thing:`apt_kitchen`->contains->thing:`fridge_kitchen` SET since = time::now();
RELATE thing:`гарантийный_талон_холодильник`->about->thing:`fridge_kitchen`;
CREATE thing:`fridge_garage` SET kind = 'item', name = 'Холодильник старый (гараж)', category = 'refrigerator', created_at = time::now();
RELATE thing:`garage`->contains->thing:`fridge_garage` SET since = time::now();
CREATE thing:`food_milk` SET kind = 'item', name = 'Молоко 3.2% (2 пакета)', quantity = 2, unit = 'шт', expires_at = '2026-07-28', category = 'food', created_at = time::now();
RELATE thing:`fridge_kitchen`->contains->thing:`food_milk` SET since = time::now();
CREATE thing:`food_pelmeni` SET kind = 'item', name = 'Пельмени домашние (заморозка)', quantity = 1, unit = 'кг', expires_at = '2026-10-01', category = 'food', created_at = time::now();
RELATE thing:`fridge_kitchen`->contains->thing:`food_pelmeni` SET since = time::now();
CREATE thing:`food_pickles` SET kind = 'item', name = 'Соленья дачные (банки)', quantity = 6, unit = 'шт', category = 'food', created_at = time::now();
RELATE thing:`fridge_garage`->contains->thing:`food_pickles` SET since = time::now();
-- Device = контейнер комплектующих: contains {installed: true}
CREATE thing:`ssd_512gb_nuc` SET kind = 'item', name = 'SSD 512GB NVMe (в NUC)', category = 'storage_media', created_at = time::now();
RELATE thing:`nuc_intel_i5_mini_pc`->contains->thing:`ssd_512gb_nuc` SET installed = true, since = time::now();
CREATE thing:`ram_16gb_nuc` SET kind = 'item', name = 'RAM 16GB DDR4 SO-DIMM (в NUC)', category = 'electronics', created_at = time::now();
RELATE thing:`nuc_intel_i5_mini_pc`->contains->thing:`ram_16gb_nuc` SET installed = true, since = time::now();

-- ═══ UI-декларации на концептах kind (этап A, D-44 ступень 3) ══════════════
UPDATE thing:`kind_item` SET ui = {
  header: ['Title', 'StatusChip', 'CategoryChip', 'BrandChip', 'QuantityDisplay'],
  body:   ['Description', 'LocationCrumb', 'LentToCard', 'ContainedItems', 'RepresentsDocs', 'GenericFields'],
  footer: ['WikidataLink', 'Timestamps']
};
UPDATE thing:`kind_device` SET ui = {
  header: ['Title', 'RoleChip', 'StatusChip', 'CategoryChip', 'BrandChip'],
  body:   ['Description', 'LocationCrumb', 'ContainedItems', 'RepresentsDocs', 'GenericFields'],
  footer: ['WikidataLink', 'Timestamps']
};
UPDATE thing:`kind_location` SET ui = {
  header: ['Title'],
  body:   ['Description', 'LocationCrumb', 'ContainedItems', 'GenericFields'],
  footer: ['Timestamps']
};
UPDATE thing:`kind_person` SET ui = {
  header: ['Title', 'RoleChip'],
  body:   ['Description', 'GenericFields'],
  footer: ['Timestamps']
};
