import { Link } from "react-router-dom";
import { useQuery } from "@tanstack/react-query";
import NodeScreen from "@/components/NodeScreen";
import { TrailReset } from "@/components/Trail";
import { loadNode } from "@/lib/node";

// Единый вход (D-53): / — рабочий стол (корневой desktop-узел из графа).
export default function Home() {
  const { data: desktop, isLoading, error } = useQuery({
    queryKey: ["node", "desktop_home"],
    queryFn: () => loadNode("desktop_home"),
  });

  if (isLoading) return <main className="p-6 text-neutral-400">Загрузка…</main>;

  if (error || !desktop) {
    return (
      <main className="mx-auto max-w-lg py-24 px-6">
        <h1 className="text-2xl font-bold mb-1">Домовой</h1>
        {error ? (
          <p className="text-sm text-red-600 mt-4">База недоступна: {String(error)}</p>
        ) : (
          <p className="text-sm text-neutral-500 mt-4">
            Рабочий стол не найден в графе — generic-фолбэк:{" "}
            <Link className="underline" to="/things">браузер узлов</Link>
          </p>
        )}
      </main>
    );
  }

  return (
    <main className="mx-auto max-w-4xl p-6">
      <TrailReset />
      <NodeScreen node={desktop} />
      <p className="mt-12 text-xs text-neutral-300">
        <Link className="hover:underline" to="/things">generic-браузер</Link>
      </p>
    </main>
  );
}
