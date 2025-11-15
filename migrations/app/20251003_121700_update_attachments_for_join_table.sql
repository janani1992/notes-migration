-- Migration to update attachments table structure for Many-to-Many relationship
-- Remove foreign key constraint and note_id column since we're using join table

-- PostgreSQL: Drop the foreign key constraint if it exists
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

-- Remove the note_id column from attachments table if it exists
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'api' 
        AND table_name = 'attachments' 
        AND column_name = 'note_id'
    ) THEN
        ALTER TABLE api.attachments DROP COLUMN note_id;
    END IF;
END
$$;

-- Add constraints for data integrity (PostgreSQL syntax)
ALTER TABLE api.attachments ALTER COLUMN filename SET NOT NULL;
ALTER TABLE api.attachments ALTER COLUMN hash SET NOT NULL;
ALTER TABLE api.attachments ALTER COLUMN data SET NOT NULL;

-- Add indexes for better performance if they don't exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_attachments_hash' AND schemaname = 'api') THEN
        CREATE INDEX idx_attachments_hash ON api.attachments(hash);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE indexname = 'idx_attachments_filename' AND schemaname = 'api') THEN
        CREATE INDEX idx_attachments_filename ON api.attachments(filename);
    END IF;
END
$$;