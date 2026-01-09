-- Add theme_preference column to users table for dark mode persistence
-- Migration: 20251231_130000_add_theme_preference_to_users.sql
-- Date: 2025-12-31

ALTER TABLE api.users ADD COLUMN IF NOT EXISTS theme_preference VARCHAR(20) DEFAULT 'light';

-- Add check constraint to ensure only valid theme values
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'check_theme_preference') THEN
        ALTER TABLE api.users ADD CONSTRAINT check_theme_preference 
            CHECK (theme_preference IN ('light', 'dark', 'auto'));
    END IF;
END $$;

COMMENT ON COLUMN api.users.theme_preference IS 'User UI theme preference: light, dark, or auto';
