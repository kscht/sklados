import Link from "next/link";
import type { GridChild } from "@/lib/node";
import { nodeHref } from "@/components/widgets/registry";

// Грид иконок-узлов (этап A2, D-53): упорядоченная сетка в стиле iOS.

const KIND_ICON: Record<string, string> = {
  location: "📦", item: "🔧", device: "💻", person: "👤", group: "👥",
  document: "📄", file: "🗎", note: "📝", page: "📃", task: "☑️",
  payment: "💳", event: "📅", listing: "🏷", diagnosis: "🩺", org: "🏢",
  animal: "🐾", plant: "🌱", view: "🗂",
};

const CATEGORY_ICON: Record<string, string> = {
  refrigerator: "🧊", food: "🥫", tool: "🛠", power_tool: "🛠", fastener: "🔩",
  book: "📚", clothing: "👕", medicine: "💊", seeds: "🌾", car: "🚗",
  motorcycle: "🏍", boat: "🛥", snowmobile: "🛷", sports: "⚽", fishing: "🎣",
};

export function iconFor(c: GridChild): string {
  if (c.icon) return c.icon;
  if (c.kind === "view") return c.subtype === "desktop" ? "📁" : "🗂";
  if (c.category && CATEGORY_ICON[c.category]) return CATEGORY_ICON[c.category];
  return KIND_ICON[c.kind ?? ""] ?? "◾";
}

export default function NodeGrid({ items }: { items: GridChild[] }) {
  if (!items.length) return null;
  return (
    <div className="grid grid-cols-3 sm:grid-cols-4 md:grid-cols-6 lg:grid-cols-8 gap-2">
      {items.map((c) => (
        <Link
          key={String(c.id)}
          href={nodeHref(c.id)}
          className="group flex flex-col items-center rounded-xl px-2 py-3 text-center hover:bg-neutral-100 transition-colors"
        >
          <span className="flex h-14 w-14 items-center justify-center rounded-2xl bg-neutral-100 text-3xl shadow-sm group-hover:scale-105 transition-transform">
            {iconFor(c)}
          </span>
          <span className="mt-1.5 line-clamp-2 text-xs leading-tight text-neutral-700">
            {c.label ?? c.name ?? String(c.id)}
          </span>
          {c.installed && (
            <span className="mt-0.5 text-[10px] text-emerald-600">установлено</span>
          )}
        </Link>
      ))}
    </div>
  );
}
