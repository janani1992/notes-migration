-- Create the api schema for the Spring Boot application
CREATE SCHEMA IF NOT EXISTS api;

-- Set search path to prioritize api schema
SET search_path TO api, public;