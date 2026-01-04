-- Create reminders table for note deadline reminders
CREATE TABLE IF NOT EXISTS api.reminders (
    id BIGSERIAL PRIMARY KEY,
    note_id BIGINT NOT NULL REFERENCES api.notes(id) ON DELETE CASCADE,
    user_id BIGINT NOT NULL REFERENCES api.users(id) ON DELETE CASCADE,
    remind_at TIMESTAMP WITH TIME ZONE NOT NULL,
    message TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    sent_at TIMESTAMP WITH TIME ZONE,
    is_recurring BOOLEAN DEFAULT FALSE,
    recurrence_interval VARCHAR(20),
    CONSTRAINT chk_reminder_status CHECK (status IN ('PENDING', 'SENT', 'CANCELLED', 'FAILED')),
    CONSTRAINT chk_recurrence_interval CHECK (recurrence_interval IS NULL OR recurrence_interval IN ('DAILY', 'WEEKLY', 'MONTHLY'))
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_reminders_user_id ON api.reminders(user_id);
CREATE INDEX IF NOT EXISTS idx_reminders_note_id ON api.reminders(note_id);
CREATE INDEX IF NOT EXISTS idx_reminders_remind_at ON api.reminders(remind_at);
CREATE INDEX IF NOT EXISTS idx_reminders_status ON api.reminders(status);
CREATE INDEX IF NOT EXISTS idx_reminders_pending_due ON api.reminders(status, remind_at) WHERE status = 'PENDING';

-- Add comment
COMMENT ON TABLE api.reminders IS 'Stores user reminders for notes with deadlines';
COMMENT ON COLUMN api.reminders.remind_at IS 'When to send the reminder';
COMMENT ON COLUMN api.reminders.is_recurring IS 'Whether this reminder repeats';
COMMENT ON COLUMN api.reminders.recurrence_interval IS 'How often to repeat (DAILY, WEEKLY, MONTHLY)';
