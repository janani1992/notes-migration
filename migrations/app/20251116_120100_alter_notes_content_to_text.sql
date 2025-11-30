-- Migration: Change notes content column type from VARCHAR(1000) to TEXT
-- Date: 2025-11-16
-- Description: Allows notes to have unlimited length content instead of being limited to 1000 characters

-- Alter the content column type from VARCHAR(1000) to TEXT
ALTER TABLE api.notes ALTER COLUMN content TYPE TEXT;

-- Add comment for documentation
COMMENT ON COLUMN api.notes.content IS 'Note content (unlimited length)';
