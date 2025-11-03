-- Migration to create the note_attachments join table for Many-to-Many relationship
-- This allows attachments to be shared between multiple notes

-- Create the join table for note-attachment many-to-many relationship
CREATE TABLE IF NOT EXISTS note_attachments (
    note_id BIGINT NOT NULL,
    attachment_id BIGINT NOT NULL,
    PRIMARY KEY (note_id, attachment_id),
    FOREIGN KEY (note_id) REFERENCES notes(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (attachment_id) REFERENCES attachments(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Add indexes for better performance on the join table
CREATE INDEX IF NOT EXISTS idx_note_attachments_note_id ON note_attachments(note_id);
CREATE INDEX IF NOT EXISTS idx_note_attachments_attachment_id ON note_attachments(attachment_id);

-- Remove the note_id column from attachments table since we're using join table now
-- PostgreSQL version using DO block
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = current_schema() 
        AND table_name = 'attachments' 
        AND column_name = 'note_id'
    ) THEN
        ALTER TABLE attachments DROP COLUMN note_id;
    END IF;
END
$$;