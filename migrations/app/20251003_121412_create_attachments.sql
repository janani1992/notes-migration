-- Migration to create the attachments table
-- This table stores file attachments that can be associated with notes

-- Create attachments table
CREATE TABLE IF NOT EXISTS api.attachments (
    id BIGSERIAL PRIMARY KEY,
    filename VARCHAR(255) NOT NULL,
    hash VARCHAR(255) NOT NULL UNIQUE,
    data BYTEA NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    note_id BIGINT,
    FOREIGN KEY (note_id) REFERENCES api.notes(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Create trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION api.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

DROP TRIGGER IF EXISTS update_attachments_updated_at ON api.attachments;
CREATE TRIGGER update_attachments_updated_at 
    BEFORE UPDATE ON api.attachments 
    FOR EACH ROW 
    EXECUTE FUNCTION api.update_updated_at_column();

-- Add indexes for better performance
CREATE INDEX IF NOT EXISTS idx_attachments_hash ON api.attachments(hash);
CREATE INDEX IF NOT EXISTS idx_attachments_note_id ON api.attachments(note_id);
CREATE INDEX IF NOT EXISTS idx_attachments_filename ON api.attachments(filename);