-- Create note_permissions table for managing user permissions on notes
SET search_path TO api, public;

CREATE TABLE IF NOT EXISTS note_permissions (
    id BIGSERIAL PRIMARY KEY,
    note_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    permission VARCHAR(20) NOT NULL,
    granted_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (note_id) REFERENCES notes(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CHECK (permission IN ('OWNER', 'EDITOR', 'VIEWER')),
    UNIQUE(note_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_note_permissions_note_id ON note_permissions(note_id);
CREATE INDEX IF NOT EXISTS idx_note_permissions_user_id ON note_permissions(user_id);
