-- Migration: Create template table and seed default templates
CREATE TABLE IF NOT EXISTS template (
  id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    default_content TEXT,
    fields TEXT[]
);

INSERT INTO template (name, description, default_content, fields)
VALUES
  ('Meeting Notes', 'Template for meeting notes', 'Attendees:\nAgenda:\nNotes:\nAction Items:', ARRAY['Attendees', 'Agenda', 'Notes', 'Action Items']),
  ('Daily Journal', 'Template for daily journaling', 'Date:\nMood:\nHighlights:\nReflections:', ARRAY['Date', 'Mood', 'Highlights', 'Reflections']),
  ('Task List', 'Template for task management', 'Tasks:\n- [ ] Task 1\n- [ ] Task 2', ARRAY['Tasks']),
  ('Ideas & Brainstorming', 'Template for capturing ideas', 'Idea:\nDetails:\nNext Steps:', ARRAY['Idea', 'Details', 'Next Steps']),
  ('Project Planning', 'Template for project planning', 'Project Name:\nGoals:\nMilestones:\nRisks:', ARRAY['Project Name', 'Goals', 'Milestones', 'Risks']);
