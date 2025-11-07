-- Add project_id column to notes table
ALTER TABLE api.notes ADD COLUMN project_id BIGINT;

-- Add foreign key constraint
ALTER TABLE api.notes ADD CONSTRAINT fk_notes_project 
    FOREIGN KEY (project_id) REFERENCES api.projects(id) ON DELETE SET NULL;

-- Create index on project_id for better query performance
CREATE INDEX idx_notes_project_id ON api.notes(project_id);