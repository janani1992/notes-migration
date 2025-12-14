-- Add project_id column to notes table
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'api' 
        AND table_name = 'notes' 
        AND column_name = 'project_id'
    ) THEN
        ALTER TABLE api.notes ADD COLUMN project_id BIGINT;
    END IF;
END
$$;

-- Add foreign key constraint
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'fk_notes_project' 
        AND table_name = 'notes' AND table_schema = 'api'
    ) THEN
        ALTER TABLE api.notes ADD CONSTRAINT fk_notes_project 
            FOREIGN KEY (project_id) REFERENCES api.projects(id) ON DELETE SET NULL;
    END IF;
END
$$;

-- Create index on project_id for better query performance
CREATE INDEX IF NOT EXISTS idx_notes_project_id ON api.notes(project_id);