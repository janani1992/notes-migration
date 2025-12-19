-- Add color column to tags table
SET search_path TO api, public;

ALTER TABLE tags ADD COLUMN IF NOT EXISTS color VARCHAR(7);

ALTER TABLE tags ADD COLUMN IF NOT EXISTS user_id BIGINT REFERENCES users(id);
