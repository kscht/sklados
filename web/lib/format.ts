// Отображение сырых значений графа в v1 (до виджетов фазы 3).

export type ThingRow = Record<string, unknown>;

// "thing:⟨дрель⟩" | "thing:`дрель`" | "thing:apt" → голый слаг
export function recordLabel(v: unknown): string {
  if (typeof v !== "string") return String(v ?? "");
  const m = v.match(/^([a-z_]+):[⟨`]?(.+?)[⟩`]?$/u);
  return m ? m[2] : v;
}

export function cell(v: unknown): string {
  if (v === null || v === undefined) return "";
  if (Array.isArray(v)) return v.map(cell).filter(Boolean).join(", ");
  if (typeof v === "object") {
    const o = v as ThingRow;
    if (typeof o.name === "string") return o.name;
    return JSON.stringify(v);
  }
  if (typeof v === "string" && /^[a-z_]+:/.test(v)) return recordLabel(v);
  return String(v);
}

export function i18nLabel(node: ThingRow, fallback = ""): string {
  const i18n = node._i18n as { ru?: { label?: string } } | undefined;
  return i18n?.ru?.label ?? (node.name as string) ?? fallback;
}
