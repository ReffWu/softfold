const installPattern =
  /^[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}$/;

function text(value, limit) {
  return typeof value === "string" && value.length > 0 && value.length <= limit
    ? value
    : null;
}

function daysAgo(today, days) {
  const date = new Date(`${today}T00:00:00Z`);
  date.setUTCDate(date.getUTCDate() - days);
  return date.toISOString().slice(0, 10);
}

async function heartbeat(request, env) {
  const body = await request.json().catch(() => null);
  const install = text(body?.install_id, 36)?.toUpperCase();
  const version = text(body?.app_version, 32);
  const os = text(body?.os_version, 32);
  const model = text(body?.model, 64);
  if (!install || !installPattern.test(install) || !version || !os || !model) {
    return new Response(null, { status: 400 });
  }
  const folded = body.folded === true ? 1 : 0;
  const today = new Date().toISOString().slice(0, 10);
  await env.DB.batch([
    env.DB.prepare(
      `INSERT INTO installations
         (install_id, first_seen, last_seen, last_fold, app_version, os_version, model)
       VALUES (?1, ?2, ?2, CASE WHEN ?3 = 1 THEN ?2 END, ?4, ?5, ?6)
       ON CONFLICT (install_id) DO UPDATE SET
         last_seen = ?2,
         last_fold = CASE WHEN ?3 = 1 THEN ?2 ELSE last_fold END,
         app_version = ?4, os_version = ?5, model = ?6`,
    ).bind(install, today, folded, version, os, model),
    env.DB.prepare(
      `INSERT INTO activity (install_id, day, folded) VALUES (?1, ?2, ?3)
       ON CONFLICT (install_id, day) DO UPDATE SET folded = MAX(folded, ?3)`,
    ).bind(install, today, folded),
  ]);
  return new Response(null, { status: 204 });
}

async function stats(request, env) {
  if (
    !env.STATS_TOKEN ||
    request.headers.get("Authorization") !== `Bearer ${env.STATS_TOKEN}`
  ) {
    return new Response(null, { status: 404 });
  }
  const today = new Date().toISOString().slice(0, 10);
  const since = (days) => daysAgo(today, days - 1);
  const [totals, versions, retention] = await env.DB.batch([
    env.DB.prepare(
      `SELECT
         COUNT(*) AS installed,
         SUM(last_seen >= ?1) AS active_today,
         SUM(last_seen >= ?2) AS active_7_days,
         SUM(last_seen >= ?3) AS active_30_days,
         SUM(last_fold >= ?2) AS folded_7_days,
         SUM(last_fold >= ?3) AS folded_30_days
       FROM installations`,
    ).bind(today, since(7), since(30)),
    env.DB.prepare(
      `SELECT app_version, COUNT(*) AS installs FROM installations
       WHERE last_seen >= ?1 GROUP BY app_version ORDER BY installs DESC`,
    ).bind(since(30)),
    env.DB.prepare(
      `SELECT offset, COUNT(*) AS cohort, SUM(returned) AS returned FROM (
         SELECT i.install_id, o.value AS offset,
           EXISTS (
             SELECT 1 FROM activity a WHERE a.install_id = i.install_id
               AND a.day >= date(i.first_seen, '+' || o.value || ' days')
           ) AS returned
         FROM installations i, json_each('[1,7,30]') o
         WHERE date(i.first_seen, '+' || o.value || ' days') <= ?1
       ) GROUP BY offset ORDER BY offset`,
    ).bind(today),
  ]);
  return Response.json({
    day: today,
    ...totals.results[0],
    versions_30_days: versions.results,
    retention: retention.results,
  });
}

export default {
  async fetch(request, env) {
    const { pathname } = new URL(request.url);
    if (request.method === "POST" && pathname === "/heartbeat") {
      return heartbeat(request, env);
    }
    if (request.method === "GET" && pathname === "/stats") {
      return stats(request, env);
    }
    return new Response(null, { status: 404 });
  },
};
