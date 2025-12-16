-- Add project_id column to notes table
ALTER TABLE notes ADD COLUMN project_id BIGINT;

-- Add foreign key constraint
ALTER TABLE notes ADD CONSTRAINT fk_notes_project 
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE SET NULL;

-- Create index on project_id for better query performance
CREATE INDEX idx_notes_project_id ON notes(project_id);