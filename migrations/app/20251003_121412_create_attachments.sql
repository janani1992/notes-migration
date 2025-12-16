-- Migration to create the attachments table in api schema
-- This table stores file attachments that can be associated with notes
SET search_path TO api, public;

-- Create attachments table
CREATE TABLE IF NOT EXISTS attachments (
    id BIGSERIAL PRIMARY KEY,
    filename VARCHAR(255) NOT NULL,
    hash VARCHAR(255) NOT NULL UNIQUE,
    data BYTEA NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Drop trigger if it exists before creating
DROP TRIGGER IF EXISTS update_attachments_updated_at ON attachments;

CREATE TRIGGER update_attachments_updated_at 
    BEFORE UPDATE ON attachments 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Add indexes for better performance
CREATE INDEX IF NOT EXISTS idx_attachments_hash ON attachments(hash);
CREATE INDEX IF NOT EXISTS idx_attachments_filename ON attachments(filename);