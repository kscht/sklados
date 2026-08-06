"use client";

import Link from "next/link";
import { useEffect, useState } from "react";

// Breadcrumb-трейл (этап A2): путь, которым пришёл пользователь.
// У узла графа много родителей — «правильного» пути нет, поэтому трейл
// хранит фактическую навигацию (sessionStorage), / сбрасывает.

type Crumb = { id: string; name: string };
const KEY = "domovoy_trail";

export function TrailReset() {
  useEffect(() => { sessionStorage.removeItem(KEY); }, []);
  return null;
}

export default function Trail({ id, name }: { id: string; name: string }) {
  const [trail, setTrail] = useState<Crumb[]>([]);

  useEffect(() => {
    let t: Crumb[] = [];
    try { t = JSON.parse(sessionStorage.getItem(KEY) ?? "[]"); } catch {}
    const i = t.findIndex((c) => c.id === id);
    if (i >= 0) t = t.slice(0, i + 1);
    else t = [...t, { id, name }].slice(-8);
    sessionStorage.setItem(KEY, JSON.stringify(t));
    setTrail(t);
  }, [id, name]);

  return (
    <nav className="mb-6 flex flex-wrap items-center gap-1 text-sm text-neutral-400">
      <Link href="/" className="hover:underline" onClick={() => sessionStorage.removeItem(KEY)}>
        🏠 Домовой
      </Link>
      {trail.map((c, i) => (
        <span key={c.id} className="flex items-center gap-1">
          <span>/</span>
          {i === trail.length - 1 ? (
            <span className="text-neutral-600">{c.name}</span>
          ) : (
            <Link href={`/n/${encodeURIComponent(c.id)}`} className="hover:underline">{c.name}</Link>
          )}
        </span>
      ))}
    </nav>
  );
}
