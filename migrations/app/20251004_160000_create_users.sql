-- Migration to create users table

CREATE TABLE IF NOT EXISTS api.users (
    id BIGSERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE,
    is_active BOOLEAN NOT NULL DEFAULT true
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_users_email ON api.users(email);
CREATE INDEX IF NOT EXISTS idx_users_active ON api.users(is_active);
CREATE INDEX IF NOT EXISTS idx_users_created_at ON api.users(created_at);

-- Add comments for documentation
COMMENT ON TABLE api.users IS 'User accounts for Mindful Notes application';
COMMENT ON COLUMN api.users.id IS 'Primary key, auto-incrementing user ID';
COMMENT ON COLUMN api.users.full_name IS 'User full name as displayed in the application';
COMMENT ON COLUMN api.users.email IS 'User email address, used for login and must be unique';
COMMENT ON COLUMN api.users.password_hash IS 'Hashed password with salt in format salt:hash';
COMMENT ON COLUMN api.users.created_at IS 'Timestamp when user account was created';
COMMENT ON COLUMN api.users.updated_at IS 'Timestamp when user account was last updated';
COMMENT ON COLUMN api.users.is_active IS 'Flag to indicate if user account is active';