-- Migration: Create projects table
-- Date: 2025-10-07
-- Description: Creates the projects table to store project information for organizing notes

-- Create projects table
CREATE TABLE IF NOT EXISTS api.projects (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);

-- Add indexes for better performance
CREATE INDEX IF NOT EXISTS idx_projects_name ON api.projects(name);

-- Add constraints with descriptive names
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'chk_projects_name_not_empty' 
        AND table_name = 'projects' AND table_schema = 'api'
    ) THEN
        ALTER TABLE api.projects ADD CONSTRAINT chk_projects_name_not_empty 
            CHECK (name IS NOT NULL AND LENGTH(TRIM(name)) > 0);
    END IF;
END
$$;
