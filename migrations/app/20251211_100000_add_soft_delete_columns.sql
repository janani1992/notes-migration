ALTER TABLE notes
ADD COLUMN deleted_at TIMESTAMP WITH TIME ZONE,
ADD COLUMN is_archived BOOLEAN DEFAULT FALSE NOT NULL,
ADD COLUMN archived_at TIMESTAMP WITH TIME ZONE,
ADD COLUMN deletion_reason VARCHAR(255);

CREATE INDEX idx_notes_deleted_at ON notes(deleted_at);
CREATE INDEX idx_notes_is_archived ON notes(is_archived);
