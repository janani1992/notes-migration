-- Migration: Convert created_at and updated_at columns in notes table to timestamp with time zone
-- This ensures compatibility with Java Instant and UTC storage

ALTER TABLE api.notes
  ALTER COLUMN created_at TYPE timestamp with time zone USING created_at AT TIME ZONE 'UTC',
  ALTER COLUMN updated_at TYPE timestamp with time zone USING updated_at AT TIME ZONE 'UTC';

-- Optional: Ensure all timestamps are in UTC
UPDATE api.notes
  SET created_at = created_at AT TIME ZONE 'UTC',
      updated_at = updated_at AT TIME ZONE 'UTC';
