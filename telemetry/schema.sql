CREATE TABLE IF NOT EXISTS installations (
  install_id TEXT PRIMARY KEY,
  first_seen TEXT NOT NULL,
  last_seen TEXT NOT NULL,
  last_fold TEXT,
  app_version TEXT NOT NULL,
  os_version TEXT NOT NULL,
  model TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS activity (
  install_id TEXT NOT NULL,
  day TEXT NOT NULL,
  folded INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (install_id, day)
);
