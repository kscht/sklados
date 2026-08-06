"use server";

import { sql } from "@/lib/db";
import { rawId } from "@/lib/node";

// Мутации графа для этапа A2 (root-доступ — до фазы F/Keycloak).
// Размещение = ребро references (D-54); мутации не трогают сами узлы.

function rec(id: string): string {
  const r = rawId(id);
  if (/['\\;`]/.test(r) || r.length > 200) throw new Error("bad id");
  return `type::record('thing:⟨${r}⟩')`;
}

export async function listDesktops(): Promise<{ id: string; name: string }[]> {
  return sql<{ id: string; name: string }[]>(
    `SELECT id, name FROM thing WHERE kind = 'view' AND subtype = 'desktop' ORDER BY name;`,
  );
}

// симлинк: разместить узел ещё и в target (идемпотентно)
export async function placeInto(targetId: string, nodeId: string): Promise<void> {
  const orders = await sql<(number | null)[]>(
    `SELECT VALUE order FROM references WHERE in = ${rec(targetId)};`,
  );
  const max = Math.max(0, ...orders.filter((x): x is number => typeof x === "number"));
  await sql(`
    LET $t = ${rec(targetId)}; LET $n = ${rec(nodeId)};
    DELETE references WHERE in = $t AND out = $n;
    RELATE $t->references->$n SET order = ${max + 1};`);
}

export async function removePlacement(containerId: string, nodeId: string): Promise<void> {
  await sql(`DELETE references WHERE in = ${rec(containerId)} AND out = ${rec(nodeId)};`);
}

// переупорядочивание: переставить nodeId перед beforeId (или в конец)
export async function reorderPlacement(
  containerId: string, nodeId: string, beforeId: string | null,
): Promise<void> {
  const rows = await sql<{ id: string; out: string }[]>(
    `SELECT id, out FROM references WHERE in = ${rec(containerId)} ORDER BY order;`,
  );
  const moved = rows.find((r) => rawId(String(r.out)) === rawId(nodeId));
  if (!moved) return;
  const rest = rows.filter((r) => r !== moved);
  const idx = beforeId === null
    ? rest.length
    : rest.findIndex((r) => rawId(String(r.out)) === rawId(beforeId));
  rest.splice(idx < 0 ? rest.length : idx, 0, moved);
  const updates = rest.map((r, i) => `UPDATE ${String(r.id)} SET order = ${i + 1};`).join("\n");
  await sql(updates);
}

// iOS-жест: бросил A на B → папка с обоими (на месте B)
export async function createFolderWith(
  containerId: string, draggedId: string, targetId: string,
): Promise<string> {
  const res = await sql<{ id: string }>(`
    LET $c = ${rec(containerId)}; LET $a = ${rec(draggedId)}; LET $b = ${rec(targetId)};
    LET $ord = (SELECT VALUE order FROM references WHERE in = $c AND out = $b)[0] ?? 99;
    LET $f = CREATE ONLY thing SET kind = 'view', subtype = 'desktop', name = 'Папка',
      _i18n = { ru: { label: 'Папка' }, en: { label: 'Folder' } }, created_at = time::now();
    DELETE references WHERE in = $c AND (out = $a OR out = $b);
    RELATE $c->references->($f.id) SET order = $ord;
    RELATE ($f.id)->references->$b SET order = 1;
    RELATE ($f.id)->references->$a SET order = 2;
    RETURN { id: <string>$f.id };`);
  return res.id;
}

export async function renameNode(nodeId: string, name: string): Promise<void> {
  const clean = name.replace(/['\\`;]/g, "").slice(0, 120).trim();
  if (!clean) return;
  await sql(`UPDATE ${rec(nodeId)} SET name = '${clean}', _i18n.ru.label = '${clean}';`);
}
