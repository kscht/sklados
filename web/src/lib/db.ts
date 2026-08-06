// Доступ к SurrealDB из браузера через same-origin /db-прокси (nginx инжектит
// Authorization; после этапа F — Keycloak-JWT напрямую, D-11/D-56).

type SqlResult<T> = { status: string; result: T; time?: string };

const NS = "domovoy";
const DB = "domovoy";

export async function sql<T = Record<string, unknown>[]>(query: string): Promise<T> {
  const res = await fetch("/db/sql", {
    method: "POST",
    headers: {
      Accept: "application/json",
      "surreal-ns": NS,
      "surreal-db": DB,
    },
    body: query,
  });
  if (!res.ok) throw new Error(`SurrealDB HTTP ${res.status}`);

  const batches = (await res.json()) as SqlResult<unknown>[];
  const last = batches[batches.length - 1];
  if (!last || last.status !== "OK") {
    throw new Error(`SurrealDB: ${JSON.stringify(last?.result ?? "empty response")}`);
  }
  return last.result as T;
}

export function safeSlug(s: string): string {
  if (!/^[a-z0-9_-]{1,64}$/.test(s)) throw new Error(`bad slug: ${s}`);
  return s;
}
