CREATE TABLE IF NOT EXISTS temperatures (
  id      SERIAL PRIMARY KEY,
  ts      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  place   TEXT NOT NULL,
  temp_c  NUMERIC(5,2) NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_temperatures_place_ts
  ON temperatures (place, ts DESC);
