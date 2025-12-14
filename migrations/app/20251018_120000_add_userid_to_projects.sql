-- Add user_id to projects table as nullable
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'api' 
        AND table_name = 'projects' 
        AND column_name = 'user_id'
    ) THEN
        ALTER TABLE api.projects ADD COLUMN user_id BIGINT;
    END IF;
END
$$;

-- Set user_id for existing projects (choose a default user, e.g., admin user with id=1)
UPDATE api.projects SET user_id = 1 WHERE user_id IS NULL;

-- Make user_id NOT NULL
ALTER TABLE api.projects ALTER COLUMN user_id SET NOT NULL;

-- Add foreign key constraint (optional, recommended)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'fk_projects_user' 
        AND table_name = 'projects' AND table_schema = 'api'
    ) THEN
        ALTER TABLE api.projects ADD CONSTRAINT fk_projects_user FOREIGN KEY (user_id) REFERENCES api.users(id);
    END IF;
END
$$;

-- Remove global unique constraint on name if present, and add per-user unique constraint
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE constraint_name = 'projects_name_key' AND table_name = 'projects' AND table_schema = 'api'
    ) THEN
        ALTER TABLE api.projects DROP CONSTRAINT projects_name_key;
    END IF;
END$$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE constraint_name = 'projects_user_name_unique' AND table_name = 'projects' AND table_schema = 'api'
    ) THEN
        ALTER TABLE api.projects ADD CONSTRAINT projects_user_name_unique UNIQUE (user_id, name);
    END IF;
END$$;
