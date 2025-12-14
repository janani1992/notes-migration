-- Migration: Create tags table
-- Date: 2025-12-10
-- Description: Creates the tags table for organizing notes with labels

-- Create tags table
CREATE TABLE IF NOT EXISTS api.tags (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    user_id BIGINT NOT NULL,
    color VARCHAR(255),
    CONSTRAINT uk_tags_name_user UNIQUE (name, user_id),
    FOREIGN KEY (user_id) REFERENCES api.users(id) ON DELETE CASCADE
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_tags_user_id ON api.tags(user_id);
CREATE INDEX IF NOT EXISTS idx_tags_name ON api.tags(name);

-- Add comments for documentation
COMMENT ON TABLE api.tags IS 'Tags for categorizing notes';
COMMENT ON COLUMN api.tags.name IS 'Tag name';
COMMENT ON COLUMN api.tags.user_id IS 'Owner of the tag';
COMMENT ON COLUMN api.tags.color IS 'Display color for the tag';
