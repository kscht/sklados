import Link from "next/link";
import { notFound } from "next/navigation";
import NodeScreen from "@/components/NodeScreen";
import { loadNode } from "@/lib/node";

export const dynamic = "force-dynamic";

export default async function NodePage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const node = await loadNode(decodeURIComponent(id));
  if (!node) notFound();

  return (
    <main className="mx-auto max-w-4xl p-6">
      <nav className="mb-6 text-sm text-neutral-400">
        <Link href="/" className="hover:underline">🏠 Домовой</Link>
      </nav>
      <NodeScreen node={node} />
    </main>
  );
}
