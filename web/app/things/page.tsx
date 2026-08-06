import Link from "next/link";
import { sql } from "@/lib/db";
import { cell, type ThingRow } from "@/lib/format";
import { nodeHref } from "@/components/widgets/registry";

export const dynamic = "force-dynamic";

// Generic-фолбэк (лестница D-44, ступень 5): работает даже с пустым каталогом view.
export default async function Things({
  searchParams,
}: {
  searchParams: Promise<{ kind?: string }>;
}) {
  const { kind } = await searchParams;
  const kindFilter = kind && /^[a-z_]{1,32}$/.test(kind) ? kind : null;

  const kinds = await sql<{ kind: string; n: number }[]>(
    "SELECT kind, count() AS n FROM thing GROUP BY kind ORDER BY n DESC;",
  );
  const rows = await sql<ThingRow[]>(
    kindFilter
      ? `SELECT * FROM thing WHERE kind = '${kindFilter}' LIMIT 200;`
      : "SELECT * FROM thing ORDER BY kind LIMIT 200;",
  );

  return (
    <main className="p-6">
      <h1 className="text-xl font-bold mb-4">
        <Link href="/" className="text-neutral-400 hover:underline">Домовой</Link> / things
      </h1>
      <div className="flex flex-wrap gap-1.5 mb-6">
        {kinds.map((k) => (
          <Link
            key={k.kind}
            href={`/things?kind=${k.kind}`}
            className={`rounded-full border px-2.5 py-0.5 text-xs ${
              k.kind === kindFilter
                ? "bg-neutral-900 text-white border-neutral-900"
                : "border-neutral-300 text-neutral-600 hover:bg-neutral-100"
            }`}
          >
            {k.kind} {k.n}
          </Link>
        ))}
      </div>
      <table className="w-full text-sm">
        <thead>
          <tr className="border-b border-neutral-200 text-left text-neutral-500">
            <th className="py-2 pr-4 font-medium">name</th>
            <th className="py-2 pr-4 font-medium">kind</th>
            <th className="py-2 pr-4 font-medium">category</th>
            <th className="py-2 pr-4 font-medium">status</th>
          </tr>
        </thead>
        <tbody>
          {rows.map((r, i) => (
            <tr key={(r.id as string) ?? i} className="border-b border-neutral-100 hover:bg-neutral-50">
              <td className="py-1.5 pr-4">
                <Link href={nodeHref(r.id)} className="text-blue-700 hover:underline">{cell(r.name)}</Link>
              </td>
              <td className="py-1.5 pr-4 text-neutral-500">{cell(r.kind)}</td>
              <td className="py-1.5 pr-4 text-neutral-400">{cell(r.category)}</td>
              <td className="py-1.5 pr-4">{cell(r.status)}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </main>
  );
}
