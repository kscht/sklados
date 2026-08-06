import NodeCard from "@/components/NodeCard";
import NodeGrid from "@/components/NodeGrid";
import ViewRenderer from "@/components/ViewRenderer";
import { gridChildren, type NodeBundle } from "@/lib/node";
import type { ThingRow } from "@/lib/format";

// Единая концепция (D-53): каждый узел — экран, «всё — один большой склад».
// Шапка узла → его содержимое гридом иконок (размещения + под-локации +
// contains) → остальные свойства. Query-view (smart_list/tree) рендерит
// свой контент вместо грида.

export default function NodeScreen({ node }: { node: NodeBundle }) {
  const isQueryView =
    node.kind === "view" && (node.subtype === "smart_list" || node.subtype === "tree");

  if (isQueryView) {
    return <ViewRenderer view={node as ThingRow} />;
  }

  const children = gridChildren(node);
  const hide = children.length ? ["ContainedItems"] : [];

  return (
    <div className="space-y-6">
      <NodeCard node={node} sections={["header"]} />
      {children.length > 0 && <NodeGrid items={children} />}
      <NodeCard node={node} sections={["body", "footer"]} hide={hide} />
    </div>
  );
}
