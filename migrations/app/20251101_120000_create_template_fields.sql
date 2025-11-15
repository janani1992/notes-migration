-- Create join table for Template.fields ElementCollection
CREATE TABLE IF NOT EXISTS api.template_fields (
    template_id BIGINT NOT NULL,
    fields VARCHAR(255),
    PRIMARY KEY (template_id, fields),
    FOREIGN KEY (template_id) REFERENCES api.template(id) ON DELETE CASCADE
);

-- Create index for better performance
CREATE INDEX IF NOT EXISTS idx_template_fields_template_id ON api.template_fields(template_id);
