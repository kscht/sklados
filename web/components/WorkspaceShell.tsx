import Link from "next/link";
import { i18nLabel, type ThingRow } from "@/lib/format";

export default function WorkspaceShell({
  ws,
  views,
  activeSlug,
  children,
}: {
  ws: ThingRow;
  views: ThingRow[];
  activeSlug: string;
  children: React.ReactNode;
}) {
  const wsSlug = ws.slug as string;
  return (
    <div className="flex min-h-screen">
      <aside className="w-56 shrink-0 border-r border-neutral-200 bg-neutral-50 p-4">
        <Link href="/" className="block font-bold mb-6">
          🏠 {i18nLabel(ws)}
        </Link>
        <nav className="space-y-1">
          {views.map((v) => {
            const slug = v.slug as string;
            const active = slug === activeSlug;
            return (
              <Link
                key={slug}
                href={`/w/${wsSlug}/${slug}`}
                className={`block rounded px-3 py-1.5 text-sm ${
                  active
                    ? "bg-neutral-900 text-white"
                    : "text-neutral-700 hover:bg-neutral-200"
                }`}
              >
                {i18nLabel(v)}
              </Link>
            );
          })}
        </nav>
        <p className="mt-8 text-[11px] leading-4 text-neutral-400">
          сайдбар прочитан из графа
          <br />
          (kind=view, D-50)
        </p>
      </aside>
      <main className="flex-1 p-6">{children}</main>
    </div>
  );
}
