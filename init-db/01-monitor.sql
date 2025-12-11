CREATE TABLE IF NOT EXISTS server_stats (
    id         SERIAL PRIMARY KEY,
    ts         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    cpu_usage  REAL,
    ram_usage  REAL,
    disk_usage REAL,
    hostname   TEXT
);

CREATE INDEX IF NOT EXISTS idx_server_stats_ts
    ON server_stats (ts);
