import type { NodeBundle } from "@/lib/node";
import { REGISTRY } from "@/components/widgets/registry";

// Универсальная карточка узла (этап A).
// Лестница D-44 (v1): ui с концепта kind (ступень 3) → generic-фолбэк (ступень 5).
// Правила движка: пустой виджет схлопывается; незнакомый слаг → бейдж, не падение.
// sections/hide — для единого экрана узла (NodeScreen): шапка и тело рендерятся
// вокруг грида содержимого.

const FALLBACK_LAYOUT: Record<string, string[]> = {
  header: ["Title", "StatusChip", "CategoryChip"],
  body: ["Description", "LocationCrumb", "ContainedItems", "LentToCard", "RepresentsDocs", "GenericFields"],
  footer: ["WikidataLink", "Timestamps"],
};

function Slot({ slugs, node, row }: { slugs: string[]; node: NodeBundle; row?: boolean }) {
  const rendered = slugs.map((slug) => {
    const W = REGISTRY[slug];
    if (!W) {
      return (
        <span key={slug} className="inline-flex items-center rounded bg-neutral-100 px-2 py-0.5 text-xs text-neutral-400">
          {slug} — нет в реестре
        </span>
      );
    }
    const out = W({ node });
    return out ? <div key={slug}>{out}</div> : null;
  }).filter(Boolean);

  if (!rendered.length) return null;
  return <div className={row ? "flex flex-wrap items-center gap-3" : "space-y-5"}>{rendered}</div>;
}

export default function NodeCard({
  node,
  hide = [],
  sections = ["header", "body", "footer"],
}: {
  node: NodeBundle;
  hide?: string[];
  sections?: ("header" | "body" | "footer")[];
}) {
  const layout = { ...FALLBACK_LAYOUT, ...(node._kind_ui ?? {}) };
  const slugs = (s: string) => (layout[s] ?? []).filter((w) => !hide.includes(w));
  return (
    <article>
      {sections.includes("header") && (
        <header className="space-y-3">
          <Slot slugs={slugs("header")} node={node} row />
        </header>
      )}
      {sections.includes("body") && (
        <div className="space-y-6">
          <Slot slugs={slugs("body")} node={node} />
        </div>
      )}
      {sections.includes("footer") && (
        <footer className="flex items-center gap-4 border-t border-neutral-100 pt-3">
          <Slot slugs={slugs("footer")} node={node} row />
        </footer>
      )}
    </article>
  );
}
