import { useParams } from "react-router-dom";
import { useQuery } from "@tanstack/react-query";
import NodeScreen from "@/components/NodeScreen";
import Trail from "@/components/Trail";
import { loadNode, rawId } from "@/lib/node";

export default function NodePage() {
  const { id = "" } = useParams();
  const { data: node, isLoading, error } = useQuery({
    queryKey: ["node", id],
    queryFn: () => loadNode(decodeURIComponent(id)),
  });

  if (isLoading) return <main className="p-6 text-neutral-400">Загрузка…</main>;
  if (error) return <main className="p-6 text-red-600 text-sm">Ошибка: {String(error)}</main>;
  if (!node) return <main className="p-6 text-neutral-500">Узел не найден.</main>;

  return (
    <main className="mx-auto max-w-4xl p-6">
      <Trail id={rawId(String(node.id))} name={String(node.name ?? rawId(String(node.id)))} />
      <NodeScreen node={node} />
    </main>
  );
}
