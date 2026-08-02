import { sql } from "@/lib/db";
import { cell, i18nLabel, type ThingRow } from "@/lib/format";

// v1-рендерер view-узлов: smart_list (+group_by), tree (упрощённый), фолбэк.
// Полные виджеты по контрактам — фаза 3 (D-45).

const ROW_LIMIT = 300;

function pickColumns(rows: ThingRow[]): string[] {
  const preferred = ["name", "item", "holder", "category", "status", "quantity", "since", "expires_at"];
  const present = new Set(rows.flatMap((r) => Object.keys(r)));
  const cols = preferred.filter((c) => present.has(c));
  return cols.length ? cols : [...present].filter((c) => !c.startsWith("_") && c !== "id").slice(0, 6);
}

function Table({ rows }: { rows: ThingRow[] }) {
  if (!rows.length) return <p className="text-neutral-400 py-8 text-center">Пусто</p>;
  const cols = pickColumns(rows);
  return (
    <div className="overflow-x-auto">
      <table className="w-full text-sm">
        <thead>
          <tr className="border-b border-neutral-200 text-left text-neutral-500">
            {cols.map((c) => (
              <th key={c} className="py-2 pr-4 font-medium">{c}</th>
            ))}
          </tr>
        </thead>
        <tbody>
          {rows.slice(0, ROW_LIMIT).map((r, i) => (
            <tr key={(r.id as string) ?? i} className="border-b border-neutral-100 hover:bg-neutral-50">
              {cols.map((c) => (
                <td key={c} className="py-1.5 pr-4">{cell(r[c])}</td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
      {rows.length > ROW_LIMIT && (
        <p className="text-xs text-neutral-400 py-2">
          показано {ROW_LIMIT} из {rows.length} — пагинация в фазе 4
        </p>
      )}
    </div>
  );
}

function GroupedTable({ rows, by }: { rows: ThingRow[]; by: string }) {
  const groups = new Map<string, ThingRow[]>();
  for (const r of rows) {
    const k = String(r[by] ?? "—");
    groups.set(k, [...(groups.get(k) ?? []), r]);
  }
  const sorted = [...groups.entries()].sort((a, b) => b[1].length - a[1].length);
  return (
    <div className="space-y-2">
      {sorted.map(([k, items]) => (
        <details key={k} className="rounded border border-neutral-200">
          <summary className="cursor-pointer px-3 py-2 text-sm font-medium hover:bg-neutral-50">
            {k} <span className="text-neutral-400 font-normal">({items.length})</span>
          </summary>
          <div className="px-3 pb-2"><Table rows={items} /></div>
        </details>
      ))}
    </div>
  );
}

type LocNode = { id: string; name: string; parents: string[]; items: number };

async function TreeView() {
  const locs = await sql<LocNode[]>(
    `SELECT id, name, ->part_of->thing AS parents, count(->contains->thing) AS items
     FROM thing WHERE kind = 'location';`,
  );
  const byParent = new Map<string, LocNode[]>();
  const ids = new Set(locs.map((l) => String(l.id)));
  for (const l of locs) {
    const p = (l.parents ?? []).map(String).find((x) => ids.has(x)) ?? "";
    byParent.set(p, [...(byParent.get(p) ?? []), l]);
  }
  const render = (parent: string, depth: number): React.ReactNode =>
    (byParent.get(parent) ?? []).map((l) => (
      <div key={String(l.id)} style={{ marginLeft: depth * 16 }}>
        <div className="py-1 text-sm flex items-baseline gap-2">
          <span>{depth === 0 ? "🏠" : "▸"}</span>
          <span>{l.name}</span>
          {l.items > 0 && <span className="text-xs text-neutral-400">{l.items} шт</span>}
        </div>
        {render(String(l.id), depth + 1)}
      </div>
    ));
  return (
    <div>
      {render("", 0)}
      <p className="text-xs text-neutral-400 pt-4">
        v1: только иерархия локаций; item-контейнеры, drag-n-drop — фаза 6
      </p>
    </div>
  );
}

export default async function ViewRenderer({ view }: { view: ThingRow }) {
  const subtype = view.subtype as string;

  if (subtype === "smart_list" && typeof view.query === "string") {
    const rows = await sql<ThingRow[]>(view.query);
    const groupBy = view.group_by as string | undefined;
    return (
      <section>
        <h2 className="text-lg font-semibold mb-4">{i18nLabel(view)}</h2>
        {groupBy ? <GroupedTable rows={rows} by={groupBy} /> : <Table rows={rows} />}
      </section>
    );
  }

  if (subtype === "tree") {
    return (
      <section>
        <h2 className="text-lg font-semibold mb-4">{i18nLabel(view)}</h2>
        <TreeView />
      </section>
    );
  }

  // generic-фолбэк: незнакомый subtype (лестница D-44, ступень 5)
  return (
    <section>
      <h2 className="text-lg font-semibold mb-2">{i18nLabel(view)}</h2>
      <p className="text-sm text-neutral-500">
        Нет рендерера для subtype=«{subtype}» — generic-фолбэк.
      </p>
      <pre className="mt-4 text-xs bg-neutral-50 p-3 rounded overflow-x-auto">
        {JSON.stringify(view, null, 2)}
      </pre>
    </section>
  );
}
