-- Create suggestions table in api schema
SET search_path TO api, public;

CREATE TABLE IF NOT EXISTS suggestions (
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
  resolved_at TIMESTAMP WITH TIME ZONE NULL,
  resolved_by BIGINT,
  FOREIGN KEY (note_id) REFERENCES notes(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT fk_suggestion_resolved_by FOREIGN KEY (resolved_by) REFERENCES users(id)
);

-- Create indexes for suggestions table
CREATE INDEX IF NOT EXISTS idx_suggestions_note_id ON suggestions(note_id);
CREATE INDEX IF NOT EXISTS idx_suggestions_user_id ON suggestions(user_id);
CREATE INDEX IF NOT EXISTS idx_suggestions_status ON suggestions(status);
CREATE INDEX IF NOT EXISTS idx_suggestions_line_start ON suggestions(line_start);
