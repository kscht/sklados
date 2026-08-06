import { useQueryClient } from "@tanstack/react-query";
import { renameNode } from "@/lib/actions";

export default function RenameButton({ id, name }: { id: string; name: string }) {
  const qc = useQueryClient();
  return (
    <button
      title="Переименовать"
      className="text-neutral-300 hover:text-neutral-600 text-sm"
      onClick={async () => {
        const next = window.prompt("Название:", name);
        if (next && next !== name) {
          await renameNode(id, next);
          qc.invalidateQueries();
        }
      }}
    >
      ✏️
    </button>
  );
}
