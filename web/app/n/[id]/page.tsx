import Link from "next/link";
import { notFound } from "next/navigation";
import NodeCard from "@/components/NodeCard";
import { loadNode } from "@/lib/node";

export const dynamic = "force-dynamic";

export default async function NodePage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const node = await loadNode(decodeURIComponent(id));
  if (!node) notFound();

  return (
    <main className="p-6">
      <nav className="mb-6 text-sm text-neutral-400">
        <Link href="/" className="hover:underline">Домовой</Link>
        <span className="mx-1">/</span>
        <Link href="/w/sklad" className="hover:underline">Склад</Link>
      </nav>
      <NodeCard node={node} />
    </main>
  );
}
