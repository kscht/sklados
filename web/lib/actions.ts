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

async function occupiedSlots(containerId: string): Promise<Map<string, number>> {
  const rows = await sql<{ out: string; slot: number | null; order: number | null }[]>(
    `SELECT out, slot, order FROM references WHERE in = ${rec(containerId)};`,
  );
  const m = new Map<string, number>();
  rows.forEach((r, i) => m.set(rawId(String(r.out)), r.slot ?? r.order ?? i + 1));
  return m;
}

function freeSlotsFrom(start: number, taken: Set<number>): () => number {
  let s = start;
  return () => { while (taken.has(s)) s++; taken.add(s); return s++; };
}

// симлинк: разместить узел ещё и в target (в первый свободный слот)
export async function placeInto(targetId: string, nodeId: string): Promise<void> {
  const occ = await occupiedSlots(targetId);
  const next = freeSlotsFrom(1, new Set(occ.values()));
  const slot = occ.get(rawId(nodeId)) ?? next();
  await sql(`
    LET $t = ${rec(targetId)}; LET $n = ${rec(nodeId)};
    DELETE references WHERE in = $t AND out = $n;
    RELATE $t->references->$n SET slot = ${slot}, order = ${slot};`);
}

export async function removePlacements(containerId: string, nodeIds: string[]): Promise<void> {
  const conds = nodeIds.map((n) => `out = ${rec(n)}`).join(" OR ");
  if (!conds) return;
  await sql(`DELETE references WHERE in = ${rec(containerId)} AND (${conds});`);
}

// точная расстановка по слотам — «сортировкой рулю я» (D-55)
export async function setSlots(
  containerId: string, moves: { nodeId: string; slot: number }[],
): Promise<void> {
  if (!moves.length) return;
  const rows = await sql<{ id: string; out: string }[]>(
    `SELECT id, out FROM references WHERE in = ${rec(containerId)};`,
  );
  const byOut = new Map(rows.map((r) => [rawId(String(r.out)), String(r.id)]));
  const updates = moves
    .filter((m) => byOut.has(rawId(m.nodeId)) && Number.isInteger(m.slot) && m.slot > 0 && m.slot < 10000)
    .map((m) => `UPDATE ${byOut.get(rawId(m.nodeId))} SET slot = ${m.slot}, order = ${m.slot};`)
    .join("\n");
  if (updates) await sql(updates);
}

// папка из выделения (+опц. цель, на её месте)
export async function createFolderFrom(
  containerId: string, memberIds: string[], targetId: string | null,
): Promise<string> {
  const members = [...new Set([...(targetId ? [targetId] : []), ...memberIds].map(rawId))];
  if (members.length < 1) throw new Error("empty folder");
  const occ = await occupiedSlots(containerId);
  const slot = occ.get(rawId(targetId ?? memberIds[0])) ?? 1;
  const res = await sql<{ id: string }>(`
    LET $c = ${rec(containerId)};
    LET $f = CREATE ONLY thing SET kind = 'view', subtype = 'desktop', name = 'Папка',
      grid_cols = 8, _i18n = { ru: { label: 'Папка' }, en: { label: 'Folder' } }, created_at = time::now();
    ${members.map((m) => `DELETE references WHERE in = $c AND out = ${rec(m)};`).join("\n")}
    RELATE $c->references->($f.id) SET slot = ${slot}, order = ${slot};
    ${members.map((m, i) => `RELATE ($f.id)->references->${rec(m)} SET slot = ${i + 1}, order = ${i + 1};`).join("\n")}
    RETURN { id: <string>$f.id };`);
  return res.id;
}

// переместить выделение внутрь существующей папки
export async function moveIntoFolder(
  folderId: string, containerId: string, nodeIds: string[],
): Promise<void> {
  for (const n of nodeIds) await placeInto(folderId, n);
  await removePlacements(containerId, nodeIds);
}

export async function renameNode(nodeId: string, name: string): Promise<void> {
  const clean = name.replace(/['\\`;]/g, "").slice(0, 120).trim();
  if (!clean) return;
  await sql(`UPDATE ${rec(nodeId)} SET name = '${clean}', _i18n.ru.label = '${clean}';`);
}
