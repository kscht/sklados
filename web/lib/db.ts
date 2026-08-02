// HTTP-доступ к SurrealDB для server components (фаза 2, root-логин — до фазы 8).

type SqlResult<T> = { status: string; result: T; time?: string };

function httpBase(): string {
  // В compose приходит ws://surrealdb:8000/rpc — выводим HTTP-базу из него.
  const ws = process.env.SURREAL_URL ?? "ws://localhost:8000/rpc";
  return ws.replace(/^ws/, "http").replace(/\/rpc$/, "");
}

export async function sql<T = Record<string, unknown>[]>(query: string): Promise<T> {
  const auth = Buffer.from(
    `${process.env.SURREAL_USER ?? "root"}:${process.env.SURREAL_PASS ?? ""}`,
  ).toString("base64");

  const res = await fetch(`${httpBase()}/sql`, {
    method: "POST",
    headers: {
      Authorization: `Basic ${auth}`,
      Accept: "application/json",
      "surreal-ns": process.env.SURREAL_NS ?? "domovoy",
      "surreal-db": process.env.SURREAL_DB ?? "domovoy",
    },
    body: query,
    cache: "no-store",
  });
  if (!res.ok) throw new Error(`SurrealDB HTTP ${res.status}`);

  const batches = (await res.json()) as SqlResult<unknown>[];
  const last = batches[batches.length - 1];
  if (!last || last.status !== "OK") {
    throw new Error(`SurrealDB: ${JSON.stringify(last?.result ?? "empty response")}`);
  }
  return last.result as T;
}

// slug из URL — только безопасный алфавит, до подстановки в запрос
export function safeSlug(s: string): string {
  if (!/^[a-z0-9_-]{1,64}$/.test(s)) throw new Error(`bad slug: ${s}`);
  return s;
}
