-- Create comment_replies table
CREATE TABLE comment_replies (
  id BIGSERIAL PRIMARY KEY,
  comment_id BIGINT NOT NULL,
  note_id BIGINT NOT NULL,
  user_id BIGINT NOT NULL,
  user_name VARCHAR(255) NOT NULL,
  user_email VARCHAR(255) NOT NULL,
  user_role TEXT NOT NULL CHECK (user_role IN ('OWNER', 'EDITOR', 'VIEWER')),
  content TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (comment_id) REFERENCES comments(id) ON DELETE CASCADE,
  FOREIGN KEY (note_id) REFERENCES notes(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Create indexes for comment_replies table
CREATE INDEX idx_comment_replies_comment_id ON comment_replies(comment_id);
CREATE INDEX idx_comment_replies_note_id ON comment_replies(note_id);
CREATE INDEX idx_comment_replies_user_id ON comment_replies(user_id);
