-- Migration to add indexes and optimize attachments table for better performance
-- This ensures efficient queries when fetching attachments for a specific note

-- Add index on note_id for faster joins and lookups
CREATE INDEX IF NOT EXISTS idx_attachments_note_id ON attachments(note_id);

-- Add index on hash for deduplication and integrity checks
CREATE INDEX IF NOT EXISTS idx_attachments_hash ON attachments(hash);

-- Add index on filename for search functionality
CREATE INDEX IF NOT EXISTS idx_attachments_filename ON attachments(filename);

-- PostgreSQL: Drop foreign key constraint if it exists
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'fk_attachments_note_id' 
        AND table_name = 'attachments'
    ) THEN
        ALTER TABLE attachments DROP CONSTRAINT fk_attachments_note_id;
    END IF;
END
$$;

-- Add the foreign key constraint with proper cascade behavior
ALTER TABLE attachments 
ADD CONSTRAINT fk_attachments_note_id 
FOREIGN KEY (note_id) REFERENCES notes(id) 
ON DELETE CASCADE 
ON UPDATE CASCADE;

-- Add constraints for data integrity (PostgreSQL syntax)
ALTER TABLE attachments ALTER COLUMN filename SET NOT NULL;
ALTER TABLE attachments ALTER COLUMN hash SET NOT NULL;
ALTER TABLE attachments ALTER COLUMN data SET NOT NULL;