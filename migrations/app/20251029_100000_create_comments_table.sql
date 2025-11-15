-- Create comments table
CREATE TABLE api.comments (
  id BIGSERIAL PRIMARY KEY,
  note_id BIGINT NOT NULL,
  user_id BIGINT NOT NULL,
  user_name VARCHAR(255) NOT NULL,
  user_email VARCHAR(255) NOT NULL,
  user_role TEXT NOT NULL CHECK (user_role IN ('OWNER', 'EDITOR', 'VIEWER')),
  content TEXT NOT NULL,
  line_start INT NOT NULL,
  line_end INT,
  highlighted_text TEXT,
  status TEXT NOT NULL DEFAULT 'OPEN' CHECK (status IN ('OPEN', 'RESOLVED', 'ARCHIVED')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  resolved_at TIMESTAMP WITH TIME ZONE NULL,
  resolved_by BIGINT,
  FOREIGN KEY (note_id) REFERENCES api.notes(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES api.users(id),
  CONSTRAINT fk_resolved_by FOREIGN KEY (resolved_by) REFERENCES api.users(id)
);

-- Create indexes for comments table
CREATE INDEX idx_comments_note_id ON api.comments(note_id);
CREATE INDEX idx_comments_user_id ON api.comments(user_id);
CREATE INDEX idx_comments_status ON api.comments(status);
CREATE INDEX idx_comments_line_start ON api.comments(line_start);
