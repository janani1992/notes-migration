-- Migration to create the notes table in api schema
SET search_path TO api, public;

-- Create the notes table
CREATE TABLE IF NOT EXISTS notes (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    updated_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    priority VARCHAR(20) NOT NULL DEFAULT 'MEDIUM',
    user_id BIGINT NOT NULL,
    project_id BIGINT,
    is_pinned BOOLEAN NOT NULL DEFAULT FALSE,
    is_favorite BOOLEAN NOT NULL DEFAULT FALSE,
    deleted_at TIMESTAMP WITH TIME ZONE,
    is_archived BOOLEAN NOT NULL DEFAULT FALSE,
    archived_at TIMESTAMP WITH TIME ZONE,
    deletion_reason TEXT,
    CHECK (priority IN ('LOW', 'MEDIUM', 'HIGH', 'URGENT'))
);
