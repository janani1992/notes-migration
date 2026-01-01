-- Add last_viewed_at column to notes table for tracking recently accessed notes
-- Migration: 20251231_120000_add_last_viewed_to_notes.sql
-- Date: 2025-12-31

ALTER TABLE notes ADD COLUMN IF NOT EXISTS last_viewed_at TIMESTAMP WITH TIME ZONE;

-- Create index for efficient querying of recent notes
CREATE INDEX IF NOT EXISTS idx_notes_last_viewed_at ON notes(last_viewed_at DESC) WHERE deleted_at IS NULL;

-- Create composite index for user's recent notes
CREATE INDEX IF NOT EXISTS idx_notes_user_last_viewed ON notes(user_id, last_viewed_at DESC) WHERE deleted_at IS NULL AND is_archived = false;

COMMENT ON COLUMN notes.last_viewed_at IS 'Timestamp when the note was last viewed by any user';
