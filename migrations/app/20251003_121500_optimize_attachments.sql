-- Migration to add indexes and optimize attachments table for better performance
-- This ensures efficient queries when fetching attachments for a specific note

-- Add index on note_id for faster joins and lookups
CREATE INDEX IF NOT EXISTS idx_attachments_note_id ON api.attachments(note_id);

-- Add index on hash for deduplication and integrity checks
CREATE INDEX IF NOT EXISTS idx_attachments_hash ON api.attachments(hash);

-- Add index on filename for search functionality
CREATE INDEX IF NOT EXISTS idx_attachments_filename ON api.attachments(filename);

-- PostgreSQL: Drop foreign key constraint if it exists
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'fk_attachments_note_id' 
        AND table_name = 'attachments' AND table_schema = 'api'
    ) THEN
        ALTER TABLE api.attachments DROP CONSTRAINT fk_attachments_note_id;
    END IF;
END
$$;

-- Add the foreign key constraint with proper cascade behavior
ALTER TABLE api.attachments 
ADD CONSTRAINT fk_attachments_note_id 
FOREIGN KEY (note_id) REFERENCES api.notes(id) 
ON DELETE CASCADE 
ON UPDATE CASCADE;

-- Add constraints for data integrity (PostgreSQL syntax)
ALTER TABLE api.attachments ALTER COLUMN filename SET NOT NULL;
ALTER TABLE api.attachments ALTER COLUMN hash SET NOT NULL;
ALTER TABLE api.attachments ALTER COLUMN data SET NOT NULL;