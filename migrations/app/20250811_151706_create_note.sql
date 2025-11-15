-- Create notes table with BIGSERIAL primary key for JPA/Hibernate compatibility
CREATE TABLE IF NOT EXISTS api.notes (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content VARCHAR(1000) NOT NULL,
    priority VARCHAR(10) NOT NULL DEFAULT 'MEDIUM',
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    CONSTRAINT chk_priority CHECK (priority IN ('LOW', 'MEDIUM', 'HIGH', 'URGENT'))
);