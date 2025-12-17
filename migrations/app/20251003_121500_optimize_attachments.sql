-- Migration to add indexes and optimize attachments table for better performance
-- This ensures efficient queries when fetching attachments for a specific note
SET search_path TO api, public;

-- Add index on note_id for faster joins and lookups
CREATE INDEX IF NOT EXISTS idx_attachments_note_id ON attachments(note_id);

-- Add index on hash for deduplication and integrity checks
CREATE INDEX IF NOT EXISTS idx_attachments_hash ON attachments(hash);

-- Add index on filename for search functionality
CREATE INDEX IF NOT EXISTS idx_attachments_filename ON attachments(filename);

-- Add constraints for data integrity (PostgreSQL syntax)
ALTER TABLE attachments ALTER COLUMN filename SET NOT NULL;
ALTER TABLE attachments ALTER COLUMN hash SET NOT NULL;
ALTER TABLE attachments ALTER COLUMN data SET NOT NULL;