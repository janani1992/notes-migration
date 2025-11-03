-- CRDT Service PostgreSQL Schema
-- Run this script to set up the database for the mindful-crdt-service

-- Create the CRDT schema
CREATE SCHEMA IF NOT EXISTS crdt;

-- Main documents table (current state)
CREATE TABLE IF NOT EXISTS crdt.documents (
    doc_id VARCHAR(255) PRIMARY KEY,
    content TEXT NOT NULL,
    version BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Version history table (audit trail)
CREATE TABLE IF NOT EXISTS crdt.document_versions (
    id SERIAL PRIMARY KEY,
    doc_id VARCHAR(255) NOT NULL REFERENCES crdt.documents(doc_id) ON DELETE CASCADE,
    version BIGINT NOT NULL,
    content TEXT NOT NULL,
    operation_type VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_version UNIQUE(doc_id, version)
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_document_versions_doc_id ON crdt.document_versions(doc_id);
CREATE INDEX IF NOT EXISTS idx_document_versions_created_at ON crdt.document_versions(created_at);
CREATE INDEX IF NOT EXISTS idx_documents_updated_at ON crdt.documents(updated_at);
