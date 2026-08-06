import Link from "next/link";
import NodeScreen from "@/components/NodeScreen";
import { loadNode } from "@/lib/node";

export const dynamic = "force-dynamic";

// Единый вход (D-53): / — рабочий стол, корневой desktop-узел из графа.
// Фолбэк при пустом каталоге — generic-браузер (ступень 5 лестницы D-44).
export default async function Home() {
  let desktop = null;
  let dbError: string | null = null;
  try {
    desktop = await loadNode("desktop_home");
  } catch (e) {
    dbError = e instanceof Error ? e.message : String(e);
  }

  if (dbError || !desktop) {
    return (
      <main className="mx-auto max-w-lg py-24 px-6">
        <h1 className="text-2xl font-bold mb-1">Домовой</h1>
        {dbError ? (
          <p className="text-sm text-red-600 mt-4">База недоступна: {dbError}</p>
        ) : (
          <p className="text-sm text-neutral-500 mt-4">
            Рабочий стол не найден в графе — generic-фолбэк:{" "}
            <Link className="underline" href="/things">браузер узлов</Link>
          </p>
        )}
      </main>
    );
  }

  return (
    <main className="mx-auto max-w-4xl p-6">
      <NodeScreen node={desktop} />
      <p className="mt-12 text-xs text-neutral-300">
        <Link className="hover:underline" href="/things">generic-браузер</Link>
      </p>
    </main>
  );
}
