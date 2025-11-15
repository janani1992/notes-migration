-- Add user_id to notes table as nullable
ALTER TABLE api.notes ADD COLUMN user_id BIGINT;

-- Set user_id for existing notes (choose a default user, e.g., admin user with id=1)
UPDATE api.notes SET user_id = 1 WHERE user_id IS NULL;

-- Make user_id NOT NULL
ALTER TABLE api.notes ALTER COLUMN user_id SET NOT NULL;

-- Add foreign key constraint (optional, recommended)
ALTER TABLE api.notes ADD CONSTRAINT fk_notes_user FOREIGN KEY (user_id) REFERENCES api.users(id);

-- Ensure no notes have NULL content before enforcing NOT NULL constraint
UPDATE api.notes SET content = '' WHERE content IS NULL;

-- Remove global unique constraint on title if present, and add per-user unique constraint
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE constraint_name = 'notes_title_key' AND table_name = 'notes' AND table_schema = 'api'
    ) THEN
        ALTER TABLE api.notes DROP CONSTRAINT notes_title_key;
    END IF;
END$$;

ALTER TABLE api.notes ADD CONSTRAINT notes_user_title_unique UNIQUE (user_id, title);
