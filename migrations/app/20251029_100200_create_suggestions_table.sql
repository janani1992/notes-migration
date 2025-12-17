-- Set search path to api schema
SET search_path TO api, public;

CREATE TABLE IF NOT EXISTS api.suggestions (
  id BIGSERIAL PRIMARY KEY,
  note_id BIGINT NOT NULL,
  user_id BIGINT NOT NULL,
  user_name VARCHAR(255) NOT NULL,
  user_email VARCHAR(255) NOT NULL,
  user_role TEXT NOT NULL CHECK (user_role IN ('OWNER', 'EDITOR', 'VIEWER')),
  original_text TEXT NOT NULL,
  suggested_text TEXT NOT NULL,
  line_start INT NOT NULL,
  line_end INT,
  status TEXT NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'ACCEPTED', 'REJECTED')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  accepted_at TIMESTAMP WITH TIME ZONE,
  accepted_by BIGINT,
  rejection_reason TEXT,
  FOREIGN KEY (note_id) REFERENCES api.notes(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES api.users(id),
  CONSTRAINT fk_accepted_by FOREIGN KEY (accepted_by) REFERENCES api.users(id)
);

-- Create indexes for suggestions table
CREATE INDEX IF NOT EXISTS idx_suggestions_note_id ON suggestions(note_id);
CREATE INDEX IF NOT EXISTS idx_suggestions_user_id ON suggestions(user_id);
CREATE INDEX IF NOT EXISTS idx_suggestions_status ON suggestions(status);
CREATE INDEX IF NOT EXISTS idx_suggestions_line_start ON suggestions(line_start);
