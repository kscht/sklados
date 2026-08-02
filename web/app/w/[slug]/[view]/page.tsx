import { notFound } from "next/navigation";
import ViewRenderer from "@/components/ViewRenderer";
import WorkspaceShell from "@/components/WorkspaceShell";
import { loadWorkspace } from "@/lib/workspace";
import { safeSlug } from "@/lib/db";

export const dynamic = "force-dynamic";

export default async function WorkspaceView({
  params,
}: {
  params: Promise<{ slug: string; view: string }>;
}) {
  const { slug, view } = await params;
  const ws = await loadWorkspace(slug);
  if (!ws) notFound();

  const views = (ws.sidebar ?? []) as Record<string, unknown>[];
  const active = views.find((v) => v.slug === safeSlug(view));
  if (!active) notFound();

  return (
    <WorkspaceShell ws={ws} views={views} activeSlug={view}>
      <ViewRenderer view={active} />
    </WorkspaceShell>
  );
}
