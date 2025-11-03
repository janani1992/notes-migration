-- Migration: Create projects table
-- Date: 2025-10-07
-- Description: Creates the projects table to store project information for organizing notes

-- Create projects table
CREATE TABLE IF NOT EXISTS projects (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);

-- Add indexes for better performance
CREATE INDEX IF NOT EXISTS idx_projects_name ON projects(name);

-- Add constraints with descriptive names
ALTER TABLE projects ADD CONSTRAINT chk_projects_name_not_empty 
    CHECK (name IS NOT NULL AND LENGTH(TRIM(name)) > 0);
