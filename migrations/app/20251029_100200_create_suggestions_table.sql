-- Create suggestions table
CREATE TABLE suggestions (
  id BIGSERIAL PRIMARY KEY,
  note_id BIGINT NOT NULL,
  user_id BIGINT NOT NULL,
  user_name VARCHAR(255) NOT NULL,
  user_email VARCHAR(255) NOT NULL,
  user_role TEXT NOT NULL CHECK (user_role IN ('OWNER', 'EDITOR', 'VIEWER')),
  title VARCHAR(255) NOT NULL,
  description TEXT,
  line_start INT NOT NULL,
  line_end INT,
  original_text TEXT NOT NULL,
  suggested_text TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'ACCEPTED', 'REJECTED', 'ARCHIVED')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  accepted_at TIMESTAMP WITH TIME ZONE NULL,
  accepted_by BIGINT,
  rejection_reason TEXT,
  FOREIGN KEY (note_id) REFERENCES notes(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT fk_accepted_by FOREIGN KEY (accepted_by) REFERENCES users(id)
);

-- Create indexes for suggestions table
CREATE INDEX idx_suggestions_note_id ON suggestions(note_id);
CREATE INDEX idx_suggestions_user_id ON suggestions(user_id);
CREATE INDEX idx_suggestions_status ON suggestions(status);
CREATE INDEX idx_suggestions_line_start ON suggestions(line_start);
