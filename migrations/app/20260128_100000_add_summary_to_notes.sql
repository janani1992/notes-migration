-- Add summary columns to notes table
ALTER TABLE api.notes
    ADD COLUMN IF NOT EXISTS summary TEXT,
    ADD COLUMN IF NOT EXISTS summary_generated_at TIMESTAMP WITH TIME ZONE;
