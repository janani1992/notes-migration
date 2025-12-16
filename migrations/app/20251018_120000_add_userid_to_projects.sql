-- Add user_id to projects table as nullable
SET search_path TO api, public;

-- Add column if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'api'
        AND table_name = 'projects' 
        AND column_name = 'user_id'
    ) THEN
        ALTER TABLE projects ADD COLUMN user_id BIGINT;
    END IF;
END
$$;

-- Set user_id for existing projects (choose a default user, e.g., admin user with id=1)
UPDATE projects SET user_id = 1 WHERE user_id IS NULL;

-- Make user_id NOT NULL
ALTER TABLE projects ALTER COLUMN user_id SET NOT NULL;

-- Add foreign key constraint (optional, recommended)
ALTER TABLE projects ADD CONSTRAINT fk_projects_user FOREIGN KEY (user_id) REFERENCES users(id);

-- Remove global unique constraint on name if present, and add per-user unique constraint
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE constraint_name = 'projects_name_key' AND table_name = 'projects'
    ) THEN
        ALTER TABLE projects DROP CONSTRAINT projects_name_key;
    END IF;
END$$;

ALTER TABLE projects ADD CONSTRAINT projects_user_name_unique UNIQUE (user_id, name);
