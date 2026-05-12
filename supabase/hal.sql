CREATE TABLE hal (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  device_id TEXT NOT NULL,
  part_no TEXT DEFAULT 'unknown',
  event TEXT NOT NULL,
  ts TIMESTAMPTZ NOT NULL,
  data JSONB DEFAULT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX ON hal (device_id);
CREATE INDEX ON hal (event);
CREATE INDEX ON hal (ts);
CREATE UNIQUE INDEX ON hal (device_id, event, ts);