-- Add project_id column to notes table
SET search_path TO api, public;

-- Add column if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'api'
        AND table_name = 'notes' 
        AND column_name = 'project_id'
    ) THEN
        ALTER TABLE notes ADD COLUMN project_id BIGINT;
    END IF;
END
$$;

-- Add foreign key constraint if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'fk_notes_project' 
        AND table_schema = 'api'
        AND table_name = 'notes'
    ) THEN
        ALTER TABLE notes ADD CONSTRAINT fk_notes_project 
            FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE SET NULL;
    END IF;
END
$$;

-- Create index on project_id for better query performance
CREATE INDEX IF NOT EXISTS idx_notes_project_id ON notes(project_id);
