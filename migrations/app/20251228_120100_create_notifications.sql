-- Create notifications table for user alerts
CREATE TABLE IF NOT EXISTS api.notifications (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES api.users(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    read_at TIMESTAMP WITH TIME ZONE,
    related_note_id BIGINT REFERENCES api.notes(id) ON DELETE CASCADE,
    related_user_id BIGINT REFERENCES api.users(id) ON DELETE SET NULL,
    action_url VARCHAR(500),
    CONSTRAINT chk_notification_type CHECK (type IN ('REMINDER', 'MENTION', 'NOTE_SHARED', 'NOTE_COMMENT', 'SUGGESTION', 'DEADLINE', 'COLLABORATION_INVITE'))
);

-- Create indexes for performance
CREATE INDEX idx_notifications_user_id ON api.notifications(user_id);
CREATE INDEX idx_notifications_is_read ON api.notifications(is_read);
CREATE INDEX idx_notifications_created_at ON api.notifications(created_at DESC);
CREATE INDEX idx_notifications_type ON api.notifications(type);
CREATE INDEX idx_notifications_user_unread ON api.notifications(user_id, is_read) WHERE is_read = FALSE;
CREATE INDEX idx_notifications_related_note ON api.notifications(related_note_id);

-- Add comment
COMMENT ON TABLE api.notifications IS 'Stores user notifications for mentions, reminders, and other alerts';
COMMENT ON COLUMN api.notifications.type IS 'Type of notification: REMINDER, MENTION, NOTE_SHARED, etc.';
COMMENT ON COLUMN api.notifications.action_url IS 'URL to navigate to when notification is clicked';
COMMENT ON COLUMN api.notifications.related_note_id IS 'Optional reference to related note';
COMMENT ON COLUMN api.notifications.related_user_id IS 'Optional reference to related user (e.g., who mentioned you)';
