import { sql } from "@/lib/db";
import type { ThingRow } from "@/lib/format";

// Загрузка узла для NodeCard: ОДИН SELECT (D-45) — узел + рёбра + метаданные
// словарей (kind ui, категория, статус). Фрагменты соответствуют контрактам
// виджетов из реестра; v1 включает все фрагменты (13 виджетов — дёшево).

export type GridChild = {
  id: string; name?: string; kind?: string; subtype?: string;
  icon?: string; category?: string; label?: string; installed?: boolean;
  slot?: number | null;
};

export type NodeBundle = ThingRow & {
  _kind_ui?: Record<string, string[]>;
  _kind_label?: string;
  _status_meta?: { color?: string; label?: string };
  _cat_label?: string;
  _located_in?: { id: string; name: string }[];
  _contains?: (GridChild & { installed?: boolean })[];
  _lent?: { since?: string; id: string; name: string }[];
  _docs?: { id: string; name: string }[];
  _placed?: GridChild[];
  _sub_locations?: GridChild[];
};

// дети узла для грида: размещения (references) + под-локации + содержимое
export function gridChildren(n: NodeBundle): GridChild[] {
  const seen = new Set<string>();
  const out: GridChild[] = [];
  for (const c of [...(n._placed ?? []), ...(n._sub_locations ?? []), ...(n._contains ?? [])]) {
    const k = String(c.id);
    if (!seen.has(k)) { seen.add(k); out.push(c); }
  }
  return out;
}

// raw id без префикса "thing:" и обрамления ⟨⟩ / `` (SurrealDB отдаёт оба варианта)
export function rawId(id: string): string {
  return id.replace(/^thing:/, "").replace(/^[⟨`]/, "").replace(/[⟩`]$/, "");
}

function safeRaw(raw: string): string {
  if (/['\\;⟨⟩`]/.test(raw) || raw.length > 200) throw new Error("bad node id");
  return raw;
}

export async function loadNode(raw: string): Promise<NodeBundle | null> {
  const r = safeRaw(raw);
  const q = `
SELECT *,
 (SELECT VALUE ui FROM ONLY type::record(string::concat('thing:kind_', $parent.kind)) LIMIT 1) AS _kind_ui,
 (SELECT VALUE _i18n.ru.label FROM ONLY type::record(string::concat('thing:kind_', $parent.kind)) LIMIT 1) AS _kind_label,
 (SELECT VALUE { color: color, label: _i18n.ru.label } FROM ONLY type::record(string::concat('thing:status_', $parent.status ?? '_')) LIMIT 1) AS _status_meta,
 (SELECT VALUE _i18n.ru.label FROM ONLY type::record(string::concat('thing:cat_', $parent.category ?? '_')) LIMIT 1) AS _cat_label,
 (SELECT in.id AS id, in.name AS name FROM contains WHERE out = $parent.id) AS _located_in,
 (SELECT installed, out.id AS id, out.name AS name, out.kind AS kind, out.category AS category FROM contains WHERE in = $parent.id LIMIT 100) AS _contains,
 (SELECT since, out.id AS id, out.name AS name FROM lent_to WHERE in = $parent.id) AS _lent,
 (SELECT in.id AS id, in.name AS name FROM represents WHERE out = $parent.id) AS _docs_r,
 (SELECT in.id AS id, in.name AS name FROM about WHERE out = $parent.id AND in.kind = 'document') AS _docs_a,
 (SELECT order, slot, out.id AS id, out.name AS name, out.kind AS kind, out.subtype AS subtype, out.icon AS icon, out.category AS category, out._i18n.ru.label AS label FROM references WHERE in = $parent.id ORDER BY slot, order LIMIT 200) AS _placed,
 (SELECT in.id AS id, in.name AS name, in.kind AS kind, in.icon AS icon FROM part_of WHERE out = $parent.id AND in.kind = 'location' LIMIT 200) AS _sub_locations
FROM ONLY type::record('thing:⟨${r}⟩') LIMIT 1;`;
  const node = await sql<NodeBundle | null>(q);
  if (!node || typeof node !== "object") return null;
  node._docs = [...((node as ThingRow)._docs_r as [] ?? []), ...((node as ThingRow)._docs_a as [] ?? [])];
  return node;
}
