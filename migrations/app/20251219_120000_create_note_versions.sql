-- Migration: Create note_versions table for version history
-- Date: 2025-12-19
-- Description: Adds version history tracking for notes to support view and revert functionality

SET search_path TO api, public;

-- Create note_versions table
CREATE TABLE IF NOT EXISTS api.note_versions (
    id BIGSERIAL PRIMARY KEY,
    note_id BIGINT NOT NULL,
    version_number INT NOT NULL,
    
    -- Content snapshot at this version
    title VARCHAR(255) NOT NULL,
    content TEXT,
    priority VARCHAR(20) NOT NULL,
    
    -- Metadata
    changed_by BIGINT NOT NULL,
    change_type VARCHAR(20) NOT NULL CHECK (change_type IN ('CREATED', 'UPDATED', 'RESTORED')),
    change_description TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Track what fields were changed
    fields_changed TEXT[],
    
    -- Constraints
    CONSTRAINT fk_note_versions_note FOREIGN KEY (note_id) REFERENCES api.notes(id) ON DELETE CASCADE,
    CONSTRAINT fk_note_versions_user FOREIGN KEY (changed_by) REFERENCES api.users(id) ON DELETE SET NULL,
    CONSTRAINT uq_note_version UNIQUE (note_id, version_number)
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_note_versions_note_id ON api.note_versions(note_id);
CREATE INDEX IF NOT EXISTS idx_note_versions_created_at ON api.note_versions(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_note_versions_changed_by ON api.note_versions(changed_by);
CREATE INDEX IF NOT EXISTS idx_note_versions_note_version ON api.note_versions(note_id, version_number DESC);

-- Add comment to table
COMMENT ON TABLE api.note_versions IS 'Stores version history of notes for tracking changes and enabling restore functionality';
COMMENT ON COLUMN api.note_versions.version_number IS 'Sequential version number starting from 1 for each note';
COMMENT ON COLUMN api.note_versions.change_type IS 'Type of change: CREATED (initial version), UPDATED (modification), RESTORED (reverted to previous version)';
COMMENT ON COLUMN api.note_versions.fields_changed IS 'Array of field names that were changed in this version';
