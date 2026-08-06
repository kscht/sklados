import { Link } from "react-router-dom";
import { useQuery } from "@tanstack/react-query";
import { sql } from "@/lib/db";
import { cell, i18nLabel, type ThingRow } from "@/lib/format";
import { nodeHref } from "@/components/widgets/registry";

// Рендерер query-view (smart_list / tree) — клиентские запросы через TanStack Query.

const ROW_LIMIT = 300;

function pickColumns(rows: ThingRow[]): string[] {
  const preferred = ["name", "item", "holder", "category", "status", "quantity", "since", "expires_at"];
  const present = new Set(rows.flatMap((r) => Object.keys(r)));
  const cols = preferred.filter((c) => present.has(c));
  return cols.length ? cols : [...present].filter((c) => !c.startsWith("_") && c !== "id").slice(0, 6);
}

function Cell({ col, row }: { col: string; row: ThingRow }) {
  const v = row[col];
  if (col === "name" && row.id) {
    return <Link to={nodeHref(row.id)} className="text-blue-700 hover:underline">{cell(v)}</Link>;
  }
  if (typeof v === "string" && v.startsWith("thing:")) {
    return <Link to={nodeHref(v)} className="text-blue-700 hover:underline">{cell(v)}</Link>;
  }
  return <>{cell(v)}</>;
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
                <td key={c} className="py-1.5 pr-4"><Cell col={c} row={r} /></td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
      {rows.length > ROW_LIMIT && (
        <p className="text-xs text-neutral-400 py-2">
          показано {ROW_LIMIT} из {rows.length} — пагинация в этапе B
        </p>
      )}
    </div>
  );
}

type LocNode = { id: string; name: string; parents: string[]; items: number };

function TreeView() {
  const { data: locs = [] } = useQuery({
    queryKey: ["tree-locations"],
    queryFn: () => sql<LocNode[]>(
      `SELECT id, name, ->part_of->thing AS parents, count(->contains->thing) AS items
       FROM thing WHERE kind = 'location';`,
    ),
  });
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
          <Link to={nodeHref(l.id)} className="hover:underline">{l.name}</Link>
          {l.items > 0 && <span className="text-xs text-neutral-400">{l.items} шт</span>}
        </div>
        {render(String(l.id), depth + 1)}
      </div>
    ));
  return <div>{render("", 0)}</div>;
}

export default function ViewRenderer({ view }: { view: ThingRow }) {
  const subtype = view.subtype as string;
  const query = typeof view.query === "string" ? view.query : null;
  const { data: rows = [], isLoading } = useQuery({
    queryKey: ["view-query", String(view.id)],
    queryFn: () => sql<ThingRow[]>(query as string),
    enabled: subtype === "smart_list" && !!query,
  });

  if (subtype === "smart_list" && query) {
    const groupBy = view.group_by as string | undefined;
    return (
      <section>
        <h2 className="text-lg font-semibold mb-4">{i18nLabel(view)}</h2>
        {isLoading ? <p className="text-neutral-400 py-8 text-center">Загрузка…</p> : null}
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

  return (
    <section>
      <h2 className="text-lg font-semibold mb-2">{i18nLabel(view)}</h2>
      <p className="text-sm text-neutral-500">Нет рендерера для subtype=«{subtype}».</p>
    </section>
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
