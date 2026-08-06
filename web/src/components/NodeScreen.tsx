import NodeCard from "@/components/NodeCard";
import NodeGrid from "@/components/NodeGrid";
import RenameButton from "@/components/RenameButton";
import ViewRenderer from "@/components/ViewRenderer";
import { gridChildren, rawId, type NodeBundle } from "@/lib/node";
import type { ThingRow } from "@/lib/format";

// Единая концепция (D-53): каждый узел — экран, «всё — один большой склад».

export default function NodeScreen({ node }: { node: NodeBundle }) {
  const isQueryView =
    node.kind === "view" && (node.subtype === "smart_list" || node.subtype === "tree");
  if (isQueryView) return <ViewRenderer view={node as ThingRow} />;

  const editable = node.kind === "view" && node.subtype === "desktop";
  const children = gridChildren(node);
  const hide = children.length ? ["ContainedItems"] : [];

  return (
    <div className="space-y-6">
      <div className="flex items-start justify-between gap-2">
        <NodeCard node={node} sections={["header"]} />
        {editable && <RenameButton id={rawId(String(node.id))} name={String(node.name ?? "")} />}
      </div>
      {(children.length > 0 || editable) && (
        <NodeGrid
          items={children}
          containerId={String(node.id)}
          editable={editable}
          cols={typeof node.grid_cols === "number" ? node.grid_cols : 8}
        />
      )}
      <NodeCard node={node} sections={["body", "footer"]} hide={hide} />
    </div>
  );
}
