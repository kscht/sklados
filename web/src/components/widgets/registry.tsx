import { Link } from "react-router-dom";
import type { NodeBundle } from "@/lib/node";
import { rawId } from "@/lib/node";

// Реестр виджетов (этап A): slug → компонент + контракт.
// Правило D-49: виджет без данных возвращает null — движок его схлопывает.

export function nodeHref(id: unknown): string {
  return `/n/${encodeURIComponent(rawId(String(id)))}`;
}

const COLOR: Record<string, string> = {
  gray: "bg-neutral-200 text-neutral-700",
  blue: "bg-blue-100 text-blue-800",
  amber: "bg-amber-100 text-amber-800",
  green: "bg-green-100 text-green-800",
  red: "bg-red-100 text-red-800",
  purple: "bg-purple-100 text-purple-800",
};

const chip = "inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium";

type W = (props: { node: NodeBundle }) => React.ReactNode;

const Title: W = ({ node }) => (
  <div>
    <h1 className="text-2xl font-bold leading-tight">{String(node.name ?? rawId(String(node.id)))}</h1>
    <p className="text-xs text-neutral-400 mt-0.5">{node._kind_label ?? String(node.kind)}</p>
  </div>
);

const CategoryChip: W = ({ node }) =>
  node.category ? (
    <span className={`${chip} bg-neutral-100 text-neutral-700 border border-neutral-200`}>
      {node._cat_label ?? String(node.category)}
    </span>
  ) : null;

const StatusChip: W = ({ node }) =>
  node.status ? (
    <span className={`${chip} ${COLOR[node._status_meta?.color ?? "gray"]}`}>
      {node._status_meta?.label ?? String(node.status)}
    </span>
  ) : null;

const BrandChip: W = ({ node }) =>
  node.brand ? <span className={`${chip} bg-neutral-900 text-white`}>{String(node.brand)}</span> : null;

const RoleChip: W = ({ node }) =>
  node.role ? <span className={`${chip} bg-indigo-100 text-indigo-800`}>{String(node.role)}</span> : null;

const QuantityDisplay: W = ({ node }) =>
  node.quantity != null ? (
    <span className="text-sm text-neutral-500">{String(node.quantity)} {String(node.unit ?? "шт")}</span>
  ) : null;

const Description: W = ({ node }) =>
  node.description || node.notes ? (
    <p className="text-sm text-neutral-700 whitespace-pre-line">{String(node.description ?? node.notes)}</p>
  ) : null;

const LocationCrumb: W = ({ node }) =>
  node._located_in?.length ? (
    <div className="text-sm">
      <span className="text-neutral-400">Находится: </span>
      {node._located_in.map((l, i) => (
        <span key={String(l.id)}>
          {i > 0 && " · "}
          <Link to={nodeHref(l.id)} className="text-blue-700 hover:underline">{l.name}</Link>
        </span>
      ))}
    </div>
  ) : null;

const ContainedItems: W = ({ node }) =>
  node._contains?.length ? (
    <div>
      <h3 className="text-sm font-semibold text-neutral-500 mb-2">Содержит ({node._contains.length})</h3>
      <ul className="space-y-1">
        {node._contains.map((c) => (
          <li key={String(c.id)} className="text-sm flex items-center gap-2">
            <Link to={nodeHref(c.id)} className="text-blue-700 hover:underline">{c.name}</Link>
            {c.installed && <span className={`${chip} bg-emerald-100 text-emerald-800`}>установлено</span>}
            {c.category && <span className="text-xs text-neutral-400">{c.category}</span>}
          </li>
        ))}
      </ul>
    </div>
  ) : null;

const LentToCard: W = ({ node }) =>
  node._lent?.length ? (
    <div className="rounded-lg border border-amber-200 bg-amber-50 px-3 py-2">
      {node._lent.map((l) => (
        <p key={String(l.id)} className="text-sm text-amber-900">
          Одолжено: <Link to={nodeHref(l.id)} className="font-medium hover:underline">{l.name}</Link>
          {l.since && <span className="text-amber-700"> · с {String(l.since).slice(0, 10)}</span>}
        </p>
      ))}
    </div>
  ) : null;

const RepresentsDocs: W = ({ node }) =>
  node._docs?.length ? (
    <div>
      <h3 className="text-sm font-semibold text-neutral-500 mb-2">Документы</h3>
      <ul className="space-y-1">
        {node._docs.map((d) => (
          <li key={String(d.id)}>
            <Link to={nodeHref(d.id)} className="text-sm text-blue-700 hover:underline">📄 {d.name}</Link>
          </li>
        ))}
      </ul>
    </div>
  ) : null;

const WikidataLink: W = ({ node }) =>
  node.wikidata ? (
    <a href={`https://www.wikidata.org/wiki/${node.wikidata}`} target="_blank" rel="noreferrer"
       className="text-xs text-neutral-400 hover:text-blue-700 hover:underline">
      Wikidata: {String(node.wikidata)}
    </a>
  ) : null;

const Timestamps: W = ({ node }) =>
  node.created_at ? (
    <span className="text-xs text-neutral-400">создано {String(node.created_at).slice(0, 10)}</span>
  ) : null;

const HIDDEN = new Set(["id", "kind", "name", "description", "notes", "status", "category", "brand",
  "role", "quantity", "unit", "wikidata", "created_at", "ui", "_i18n", "subtype", "icon", "grid_cols", "slug"]);
const GenericFields: W = ({ node }) => {
  const rest = Object.entries(node).filter(
    ([k, v]) => !k.startsWith("_") && !HIDDEN.has(k) && v != null && typeof v !== "object",
  );
  if (!rest.length) return null;
  return (
    <table className="text-sm">
      <tbody>
        {rest.map(([k, v]) => (
          <tr key={k}>
            <td className="pr-4 py-0.5 text-neutral-400">{k}</td>
            <td className="py-0.5">{String(v)}</td>
          </tr>
        ))}
      </tbody>
    </table>
  );
};

export const REGISTRY: Record<string, W> = {
  Title, CategoryChip, StatusChip, BrandChip, RoleChip, QuantityDisplay,
  Description, LocationCrumb, ContainedItems, LentToCard, RepresentsDocs,
  WikidataLink, Timestamps, GenericFields,
};
