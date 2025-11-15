CREATE TABLE IF NOT EXISTS api.note_permissions (
    id BIGSERIAL PRIMARY KEY,
    note_id BIGINT NOT NULL REFERENCES api.notes(id) ON DELETE CASCADE,
    user_id BIGINT NOT NULL REFERENCES api.users(id) ON DELETE CASCADE,
    permission TEXT NOT NULL CHECK (permission IN ('OWNER','EDITOR','VIEWER'))
);
