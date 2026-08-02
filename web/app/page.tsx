import Link from "next/link";
import { sql } from "@/lib/db";
import { i18nLabel, type ThingRow } from "@/lib/format";

export const dynamic = "force-dynamic";

export default async function Home() {
  let workspaces: ThingRow[] = [];
  let dbError: string | null = null;
  try {
    workspaces = await sql<ThingRow[]>(
      "SELECT * FROM thing WHERE kind = 'view' AND subtype = 'workspace';",
    );
  } catch (e) {
    dbError = e instanceof Error ? e.message : String(e);
  }

  return (
    <main className="mx-auto max-w-lg py-24 px-6">
      <h1 className="text-2xl font-bold mb-1">Домовой</h1>
      <p className="text-sm text-neutral-500 mb-8">граф-система семьи · фаза 2</p>

      {dbError ? (
        <p className="text-sm text-red-600">База недоступна: {dbError}</p>
      ) : workspaces.length ? (
        <div className="space-y-2">
          {workspaces.map((ws) => (
            <Link
              key={ws.slug as string}
              href={`/w/${ws.slug}`}
              className="block rounded-lg border border-neutral-200 px-4 py-3 hover:bg-neutral-50"
            >
              <span className="font-medium">{i18nLabel(ws)}</span>
              <span className="ml-2 text-xs text-neutral-400">/w/{ws.slug as string}</span>
            </Link>
          ))}
        </div>
      ) : (
        <p className="text-sm text-neutral-500">
          Workspace-узлов в графе нет — generic-фолбэк:{" "}
          <Link className="underline" href="/things">браузер узлов</Link>
        </p>
      )}

      <p className="mt-10 text-xs text-neutral-400">
        <Link className="underline" href="/things">generic-браузер /things</Link>
      </p>
    </main>
  );
}
