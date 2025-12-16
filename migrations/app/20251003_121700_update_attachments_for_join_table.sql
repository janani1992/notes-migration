-- Migration to update attachments table structure for Many-to-Many relationship
-- Remove foreign key constraint and note_id column since we're using join table
SET search_path TO api, public;

-- PostgreSQL: Drop the foreign key constraint if it exists
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

-- Remove the note_id column from attachments table if it exists
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = current_schema() 
        AND table_name = 'attachments' 
        AND column_name = 'note_id'
    ) THEN
        ALTER TABLE attachments DROP COLUMN note_id;
    END IF;
END
$$;

-- Add constraints for data integrity (PostgreSQL syntax)
ALTER TABLE attachments ALTER COLUMN filename SET NOT NULL;
ALTER TABLE attachments ALTER COLUMN hash SET NOT NULL;
ALTER TABLE attachments ALTER COLUMN data SET NOT NULL;

-- Add indexes for better performance if they don't exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_attachments_hash') THEN
        CREATE INDEX idx_attachments_hash ON attachments(hash);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_attachments_filename') THEN
        CREATE INDEX idx_attachments_filename ON attachments(filename);
    END IF;
END
$$;