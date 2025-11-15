-- Migration: Add is_pinned and is_favorite columns to notes table
-- Date: 2025-11-16
-- Description: Adds two boolean columns to track if notes are pinned or marked as favorite

-- Add is_pinned column with default value false
ALTER TABLE api.notes ADD COLUMN is_pinned BOOLEAN DEFAULT false;

-- Add is_favorite column with default value false
ALTER TABLE api.notes ADD COLUMN is_favorite BOOLEAN DEFAULT false;

-- Add comments for documentation
COMMENT ON COLUMN api.notes.is_pinned IS 'Flag to indicate if note is pinned by the user';
COMMENT ON COLUMN api.notes.is_favorite IS 'Flag to indicate if note is marked as favorite by the user';

-- Optional: Create indexes for better query performance when filtering by these columns
CREATE INDEX IF NOT EXISTS idx_notes_is_pinned ON api.notes(is_pinned);
CREATE INDEX IF NOT EXISTS idx_notes_is_favorite ON api.notes(is_favorite);
