import { sql, safeSlug } from "@/lib/db";
import type { ThingRow } from "@/lib/format";

export type Workspace = ThingRow & { sidebar?: ThingRow[]; home?: ThingRow };

export async function loadWorkspace(slug: string): Promise<Workspace | null> {
  const s = safeSlug(slug);
  const rows = await sql<Workspace[]>(
    `SELECT * FROM thing WHERE kind = 'view' AND subtype = 'workspace' AND slug = '${s}' FETCH sidebar, home;`,
  );
  return rows[0] ?? null;
}
