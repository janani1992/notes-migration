-- Create a join table for notes and attachments (many-to-many relationship)
SET search_path TO api, public;

CREATE TABLE IF NOT EXISTS note_attachments (
    note_id BIGINT NOT NULL,
    attachment_id BIGINT NOT NULL,
    PRIMARY KEY (note_id, attachment_id),
    FOREIGN KEY (note_id) REFERENCES notes(id) ON DELETE CASCADE,
    FOREIGN KEY (attachment_id) REFERENCES attachments(id) ON DELETE CASCADE
);

-- Add index for better query performance
CREATE INDEX IF NOT EXISTS idx_note_attachments_note_id ON note_attachments(note_id);
CREATE INDEX IF NOT EXISTS idx_note_attachments_attachment_id ON note_attachments(attachment_id);
