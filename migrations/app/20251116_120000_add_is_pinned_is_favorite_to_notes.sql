-- Migration: Add is_pinned and is_favorite columns to notes table
-- Date: 2025-11-16
-- Description: Adds two boolean columns to track if notes are pinned or marked as favorite

-- Add is_pinned column with default value false
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'api' 
        AND table_name = 'notes' 
        AND column_name = 'is_pinned'
    ) THEN
        ALTER TABLE api.notes ADD COLUMN is_pinned BOOLEAN DEFAULT false;
    END IF;
END
$$;

-- Add is_favorite column with default value false
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'api' 
        AND table_name = 'notes' 
        AND column_name = 'is_favorite'
    ) THEN
        ALTER TABLE api.notes ADD COLUMN is_favorite BOOLEAN DEFAULT false;
    END IF;
END
$$;

-- Add comments for documentation
COMMENT ON COLUMN api.notes.is_pinned IS 'Flag to indicate if note is pinned by the user';
COMMENT ON COLUMN api.notes.is_favorite IS 'Flag to indicate if note is marked as favorite by the user';

-- Optional: Create indexes for better query performance when filtering by these columns
CREATE INDEX IF NOT EXISTS idx_notes_is_pinned ON api.notes(is_pinned);
CREATE INDEX IF NOT EXISTS idx_notes_is_favorite ON api.notes(is_favorite);
