-- Common initialization migrations
-- This file ensures the common migrations directory is not empty
-- Add any shared schemas, extensions, or common setup here

-- Enable extensions if needed
-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
-- CREATE EXTENSION IF NOT EXISTS "hstore";

-- Common schemas or roles can be defined here
-- CREATE SCHEMA IF NOT EXISTS shared;

SELECT 'Common migrations initialized' AS status;