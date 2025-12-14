-- Migration to add indexes and optimize attachments table for better performance
-- This ensures efficient queries when fetching attachments for a specific note

-- Add index on hash for deduplication and integrity checks
CREATE INDEX IF NOT EXISTS idx_attachments_hash ON api.attachments(hash);

-- Add index on filename for search functionality
CREATE INDEX IF NOT EXISTS idx_attachments_filename ON api.attachments(filename);

-- Note: Foreign key constraint on note_id is removed in join table migration
-- The note_id column itself is dropped in 20251003_121600_create_note_attachments_join_table.sql
-- Use the note_attachments join table for note-attachment relationships

-- Add constraints for data integrity (PostgreSQL syntax)
ALTER TABLE api.attachments ALTER COLUMN filename SET NOT NULL;
ALTER TABLE api.attachments ALTER COLUMN hash SET NOT NULL;
ALTER TABLE api.attachments ALTER COLUMN data SET NOT NULL;