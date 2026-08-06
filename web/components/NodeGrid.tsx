"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { useMemo, useRef, useState } from "react";
import type { GridChild } from "@/lib/node";
import {
  createFolderFrom, listDesktops, moveIntoFolder, placeInto, removePlacements, setSlots,
} from "@/lib/actions";

// Грид иконок-узлов, v2 (D-53 + D-55):
// - режим просмотра: клики только навигация, dnd ВЫКЛЮЧЕН (защита от случайного тача);
// - «Изменить» → режим редактирования: разреженная сетка со слотами, пустые места
//   легитимны, авто-уплотнения нет — сортировкой рулит пользователь;
// - мультивыделение: клик = toggle, shift-клик = диапазон; действия над выделением;
// - dnd: на пустую ячейку = перенос выделения; удержание над иконкой 0.7с = папка
//   (или перенос в существующую папку).

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

const HOLD_MS = 700;
type Cell = { slot: number; child: GridChild | null };

export default function NodeGrid({
  items, containerId, editable, cols = 8,
}: {
  items: GridChild[];
  containerId: string;
  editable: boolean;
  cols?: number;
}) {
  const router = useRouter();
  const [edit, setEdit] = useState(false);
  const [sel, setSel] = useState<Set<string>>(new Set());
  const [lastClick, setLastClick] = useState<string | null>(null);
  const [dragging, setDragging] = useState(false);
  const [overSlot, setOverSlot] = useState<number | null>(null);
  const [folderHint, setFolderHint] = useState<string | null>(null);
  const [picker, setPicker] = useState(false);
  const [desktops, setDesktops] = useState<{ id: string; name: string }[]>([]);
  const holdTimer = useRef<ReturnType<typeof setTimeout> | null>(null);
  const [busy, setBusy] = useState(false);

  // раскладка по слотам: слот из данных, узлы без слота — в свободные по порядку
  const cells: Cell[] = useMemo(() => {
    const taken = new Map<number, GridChild>();
    const noSlot: GridChild[] = [];
    for (const c of items) {
      const s = c.slot ?? null;
      if (s && s > 0 && !taken.has(s)) taken.set(s, c);
      else noSlot.push(c);
    }
    let free = 1;
    for (const c of noSlot) { while (taken.has(free)) free++; taken.set(free, c); }
    const maxSlot = Math.max(0, ...taken.keys());
    const rows = Math.ceil(Math.max(maxSlot, 1) / cols) + (edit ? 1 : 0);
    const total = rows * cols;
    return Array.from({ length: total }, (_, i) => ({ slot: i + 1, child: taken.get(i + 1) ?? null }));
  }, [items, cols, edit]);

  const occupied = useMemo(
    () => cells.filter((c): c is Cell & { child: GridChild } => !!c.child), [cells],
  );

  const doneOp = () => { setDragging(false); setOverSlot(null); setFolderHint(null); setBusy(false); router.refresh(); };
  const selIds = () =>
    occupied.filter((c) => sel.has(String(c.child.id))).map((c) => String(c.child.id));

  const toggleSelect = (id: string, shift: boolean) => {
    setSel((prev) => {
      const next = new Set(prev);
      if (shift && lastClick) {
        const ids = occupied.map((c) => String(c.child.id));
        const a = ids.indexOf(lastClick), b = ids.indexOf(id);
        if (a >= 0 && b >= 0) {
          for (let i = Math.min(a, b); i <= Math.max(a, b); i++) next.add(ids[i]);
          return next;
        }
      }
      if (next.has(id)) next.delete(id); else next.add(id);
      return next;
    });
    setLastClick(id);
  };

  // перенос выделения: первый — в целевой слот, остальные — в свободные дальше
  const dropToSlot = async (targetSlot: number) => {
    const ids = selIds();
    if (!ids.length || busy) return;
    setBusy(true);
    const keep = new Set(
      occupied.filter((c) => !sel.has(String(c.child.id))).map((c) => c.slot),
    );
    const moves: { nodeId: string; slot: number }[] = [];
    let s = targetSlot;
    for (const id of ids) { while (keep.has(s)) s++; moves.push({ nodeId: id, slot: s }); s++; }
    await setSlots(containerId, moves);
    doneOp();
  };

  const dropToTile = async (target: GridChild) => {
    const ids = selIds().filter((id) => id !== String(target.id));
    if (busy) return;
    if (folderHint === String(target.id) && ids.length) {
      setBusy(true);
      if (target.kind === "view" && target.subtype === "desktop") {
        await moveIntoFolder(String(target.id), containerId, ids);
      } else {
        await createFolderFrom(containerId, ids, String(target.id));
        setSel(new Set());
      }
      doneOp();
    } else {
      // быстрый дроп на занятую ячейку — переносим в её слот (цель не трогаем? нет:
      // предсказуемо ставим выделение начиная со слота цели, цель уедет в keep-набор)
      const cell = occupied.find((c) => String(c.child.id) === String(target.id));
      if (cell) await dropToSlot(cell.slot);
    }
  };

  const bulk = async (fn: () => Promise<void>) => { if (!busy) { setBusy(true); await fn(); setSel(new Set()); doneOp(); } };

  if (!items.length && !editable) return null;
  return (
    <div className="relative">
      {editable && (
        <div className="mb-2 flex flex-wrap items-center gap-2 text-sm">
          {!edit ? (
            <button className="rounded border border-neutral-300 px-3 py-1 hover:bg-neutral-100"
                    onClick={() => setEdit(true)}>Изменить</button>
          ) : (
            <>
              <button className="rounded bg-neutral-900 px-3 py-1 text-white"
                      onClick={() => { setEdit(false); setSel(new Set()); }}>Готово</button>
              <span className="text-neutral-400">{sel.size ? `выбрано: ${sel.size}` : "клик — выбрать, shift — диапазон, тяни — переносить"}</span>
              {sel.size > 0 && (
                <>
                  <button className="rounded border border-neutral-300 px-2 py-1 hover:bg-neutral-100"
                          onClick={() => bulk(async () => { await createFolderFrom(containerId, selIds(), null); })}>
                    В папку
                  </button>
                  <button className="rounded border border-neutral-300 px-2 py-1 hover:bg-neutral-100"
                          onClick={async () => { setDesktops(await listDesktops()); setPicker(true); }}>
                    Разместить ещё в…
                  </button>
                  <button className="rounded border border-red-200 px-2 py-1 text-red-600 hover:bg-red-50"
                          onClick={() => bulk(async () => { await removePlacements(containerId, selIds()); })}>
                    Убрать
                  </button>
                </>
              )}
            </>
          )}
        </div>
      )}

      <div className="grid gap-2" style={{ gridTemplateColumns: `repeat(${cols}, minmax(0, 1fr))` }}>
        {cells.map(({ slot, child }) => {
          if (!child) {
            return edit ? (
              <div key={`e${slot}`}
                   onDragOver={(e) => { e.preventDefault(); setOverSlot(slot); }}
                   onDragLeave={() => setOverSlot((s) => (s === slot ? null : s))}
                   onDrop={(e) => { e.preventDefault(); dropToSlot(slot); }}
                   className={`min-h-20 rounded-xl border border-dashed ${
                     overSlot === slot ? "border-blue-400 bg-blue-50" : "border-neutral-200"
                   }`} />
            ) : (
              <div key={`e${slot}`} className="min-h-20" />
            );
          }
          const id = String(child.id);
          const selected = sel.has(id);
          const isFolderTarget = folderHint === id;
          const tile = (
            <>
              <span className={`flex h-14 w-14 items-center justify-center rounded-2xl bg-neutral-100 text-3xl shadow-sm ${edit && selected ? "ring-2 ring-blue-500" : ""}`}>
                {iconFor(child)}
              </span>
              <span className="mt-1.5 line-clamp-2 text-xs leading-tight text-neutral-700">
                {child.label ?? child.name ?? id}
              </span>
              {child.installed && <span className="mt-0.5 text-[10px] text-emerald-600">установлено</span>}
              {edit && selected && (
                <span className="absolute right-1 top-1 flex h-5 w-5 items-center justify-center rounded-full bg-blue-600 text-[11px] text-white">✓</span>
              )}
            </>
          );
          const cls = `relative flex flex-col items-center rounded-xl px-2 py-3 text-center transition-colors ${
            isFolderTarget ? "bg-amber-100 ring-2 ring-amber-400"
            : edit ? (selected ? "bg-blue-50" : "hover:bg-neutral-100 cursor-pointer")
            : "hover:bg-neutral-100"
          }`;
          return edit ? (
            <div key={id} className={cls}
                 draggable={sel.size > 0 && selected}
                 onClick={(e) => toggleSelect(id, e.shiftKey)}
                 onDragStart={() => setDragging(true)}
                 onDragEnd={() => { setDragging(false); setFolderHint(null); }}
                 onDragEnter={() => {
                   if (!dragging || selected) return;
                   if (holdTimer.current) clearTimeout(holdTimer.current);
                   holdTimer.current = setTimeout(() => setFolderHint(id), HOLD_MS);
                 }}
                 onDragLeave={() => { if (holdTimer.current) clearTimeout(holdTimer.current); setFolderHint((f) => (f === id ? null : f)); }}
                 onDragOver={(e) => e.preventDefault()}
                 onDrop={(e) => { e.preventDefault(); e.stopPropagation(); dropToTile(child); }}>
              {tile}
            </div>
          ) : (
            <Link key={id} href={nodeHref(child.id)} className={cls}>{tile}</Link>
          );
        })}
      </div>

      {picker && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/30" onClick={() => setPicker(false)}>
          <div className="w-72 rounded-xl bg-white p-4 shadow-xl" onClick={(e) => e.stopPropagation()}>
            <h3 className="mb-3 text-sm font-semibold">Разместить выбранное ({sel.size}) в:</h3>
            <div className="max-h-64 space-y-1 overflow-y-auto">
              {desktops.map((d) => (
                <button key={String(d.id)}
                        className="block w-full rounded px-3 py-1.5 text-left text-sm hover:bg-neutral-100"
                        onClick={() => { setPicker(false); bulk(async () => { for (const id of selIds()) await placeInto(String(d.id), id); }); }}>
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
