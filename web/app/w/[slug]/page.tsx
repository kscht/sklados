import { notFound } from "next/navigation";
import ViewRenderer from "@/components/ViewRenderer";
import WorkspaceShell from "@/components/WorkspaceShell";
import { loadWorkspace } from "@/lib/workspace";

export const dynamic = "force-dynamic";

export default async function WorkspaceHome({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;
  const ws = await loadWorkspace(slug);
  if (!ws) notFound();

  const views = (ws.sidebar ?? []) as Record<string, unknown>[];
  const home = (ws.home ?? views[0]) as Record<string, unknown> | undefined;

  return (
    <WorkspaceShell ws={ws} views={views} activeSlug={(home?.slug as string) ?? ""}>
      {home ? <ViewRenderer view={home} /> : <p>В workspace нет view-узлов.</p>}
    </WorkspaceShell>
  );
}
