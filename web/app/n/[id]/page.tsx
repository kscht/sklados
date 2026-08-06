import { notFound } from "next/navigation";
import NodeScreen from "@/components/NodeScreen";
import Trail from "@/components/Trail";
import { loadNode, rawId } from "@/lib/node";

export const dynamic = "force-dynamic";

export default async function NodePage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const node = await loadNode(decodeURIComponent(id));
  if (!node) notFound();

  return (
    <main className="mx-auto max-w-4xl p-6">
      <Trail id={rawId(String(node.id))} name={String(node.name ?? rawId(String(node.id)))} />
      <NodeScreen node={node} />
    </main>
  );
}
