"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { useRef, useState } from "react";
import type { GridChild } from "@/lib/node";
import {
  createFolderWith, listDesktops, placeInto, removePlacement, reorderPlacement,
} from "@/lib/actions";

// Грид иконок-узлов (этап A2, D-53): iOS-стиль.
// DnD: бросил рядом → переупорядочил; подержал над иконкой ~0.7с → папка.
// ПКМ: «Разместить ещё в…» (симлинк, D-54), «Убрать отсюда».

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

function nodeHref(id: unknown): string {
  const raw = String(id).replace(/^thing:/, "").replace(/^[⟨`]/, "").replace(/[⟩`]$/, "");
  return `/n/${encodeURIComponent(raw)}`;
}

const FOLDER_HOLD_MS = 700;

type Menu = { x: number; y: number; child: GridChild } | null;

export default function NodeGrid({
  items, containerId, editable,
}: {
  items: GridChild[];
  containerId: string;   // узел-экран, чьи дети показаны
  editable: boolean;     // true = desktop: dnd-порядок, папки, «убрать»
}) {
  const router = useRouter();
  const [dragId, setDragId] = useState<string | null>(null);
  const [overId, setOverId] = useState<string | null>(null);
  const [folderHint, setFolderHint] = useState(false);
  const [menu, setMenu] = useState<Menu>(null);
  const [picker, setPicker] = useState<GridChild | null>(null);
  const [desktops, setDesktops] = useState<{ id: string; name: string }[]>([]);
  const holdTimer = useRef<ReturnType<typeof setTimeout> | null>(null);

  const done = () => { setDragId(null); setOverId(null); setFolderHint(false); router.refresh(); };

  const onDrop = async (target: GridChild | null) => {
    if (!editable || !dragId) return;
    const t = target ? String(target.id) : null;
    if (t === dragId) return done();
    if (t && folderHint) {
      if (target?.kind === "view" && target?.subtype === "desktop") {
        // бросил в существующую папку → переместить внутрь
        await placeInto(t, dragId);
        await removePlacement(containerId, dragId);
      } else {
        // бросил на обычную иконку с удержанием → новая папка с обоими
        await createFolderWith(containerId, dragId, t);
      }
    } else {
      await reorderPlacement(containerId, dragId, t);
    }
    done();
  };

  const openPicker = async (child: GridChild) => {
    setMenu(null);
    setDesktops(await listDesktops());
    setPicker(child);
  };

  if (!items.length) return null;
  return (
    <div className="relative" onClick={() => setMenu(null)}>
      <div className="grid grid-cols-3 sm:grid-cols-4 md:grid-cols-6 lg:grid-cols-8 gap-2"
           onDragOver={(e) => editable && e.preventDefault()}
           onDrop={(e) => { e.preventDefault(); onDrop(null); }}>
        {items.map((c) => {
          const id = String(c.id);
          const isOver = overId === id && dragId !== id;
          return (
            <Link
              key={id}
              href={nodeHref(c.id)}
              draggable={editable}
              onDragStart={() => setDragId(id)}
              onDragEnd={() => { setDragId(null); setOverId(null); setFolderHint(false); }}
              onDragEnter={() => {
                if (!editable || !dragId || dragId === id) return;
                setOverId(id); setFolderHint(false);
                if (holdTimer.current) clearTimeout(holdTimer.current);
                holdTimer.current = setTimeout(() => setFolderHint(true), FOLDER_HOLD_MS);
              }}
              onDragLeave={() => { if (holdTimer.current) clearTimeout(holdTimer.current); }}
              onDragOver={(e) => editable && e.preventDefault()}
              onDrop={(e) => { e.preventDefault(); e.stopPropagation(); onDrop(c); }}
              onContextMenu={(e) => { e.preventDefault(); setMenu({ x: e.clientX, y: e.clientY, child: c }); }}
              className={`group flex flex-col items-center rounded-xl px-2 py-3 text-center transition-colors ${
                isOver ? (folderHint ? "bg-amber-100 ring-2 ring-amber-400" : "bg-blue-50 ring-1 ring-blue-300") : "hover:bg-neutral-100"
              } ${dragId === id ? "opacity-40" : ""}`}
            >
              <span className="flex h-14 w-14 items-center justify-center rounded-2xl bg-neutral-100 text-3xl shadow-sm group-hover:scale-105 transition-transform">
                {iconFor(c)}
              </span>
              <span className="mt-1.5 line-clamp-2 text-xs leading-tight text-neutral-700">
                {c.label ?? c.name ?? id}
              </span>
              {c.installed && <span className="mt-0.5 text-[10px] text-emerald-600">установлено</span>}
            </Link>
          );
        })}
      </div>

      {menu && (
        <div className="fixed z-50 w-52 rounded-lg border border-neutral-200 bg-white py-1 shadow-lg"
             style={{ left: menu.x, top: menu.y }}>
          <button className="block w-full px-3 py-1.5 text-left text-sm hover:bg-neutral-100"
                  onClick={() => openPicker(menu.child)}>
            Разместить ещё в…
          </button>
          {editable && (
            <button className="block w-full px-3 py-1.5 text-left text-sm text-red-600 hover:bg-neutral-100"
                    onClick={async () => { setMenu(null); await removePlacement(containerId, String(menu.child.id)); router.refresh(); }}>
              Убрать отсюда
            </button>
          )}
        </div>
      )}

      {picker && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/30"
             onClick={() => setPicker(null)}>
          <div className="w-72 rounded-xl bg-white p-4 shadow-xl" onClick={(e) => e.stopPropagation()}>
            <h3 className="mb-3 text-sm font-semibold">
              Разместить «{picker.label ?? picker.name}» в:
            </h3>
            <div className="max-h-64 space-y-1 overflow-y-auto">
              {desktops.map((d) => (
                <button key={String(d.id)}
                        className="block w-full rounded px-3 py-1.5 text-left text-sm hover:bg-neutral-100"
                        onClick={async () => { await placeInto(String(d.id), String(picker.id)); setPicker(null); router.refresh(); }}>
                  📁 {d.name}
                </button>
              ))}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
