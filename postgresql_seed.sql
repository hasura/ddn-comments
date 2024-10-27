--
postgres://hasura_role_93a458ce-b22a-484e-afe2-3393e65e31a3:uk7TqdsIwiQ8@snowy-bonus-642199.us-east-2.aws.neon.tech/trusty-lizard-43_db_368619?options=project%3Dsnowy-bonus-642199&sslmode=require

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Store some UUIDs for reference in other tables
DO $$ 
DECLARE 
    alice_id UUID;
    bob_id UUID;
    carol_id UUID;
    david_id UUID;
    emma_id UUID;
    project1_id UUID;
    project2_id UUID;
    project3_id UUID;
    thread1_id UUID;
    thread2_id UUID;
    comment1_id UUID;
BEGIN
    -- Seed Users (if not already present)
    INSERT INTO users (id, name, email, avatar_url) VALUES
    (uuid_generate_v4(), 'Alice Smith', 'alice@example.com', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Alice'),
    (uuid_generate_v4(), 'Bob Johnson', 'bob@example.com', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Bob'),
    (uuid_generate_v4(), 'Carol Williams', 'carol@example.com', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Carol'),
    (uuid_generate_v4(), 'David Brown', 'david@example.com', 'https://api.dicebear.com/7.x/avataaars/svg?seed=David'),
    (uuid_generate_v4(), 'Emma Davis', 'emma@example.com', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Emma');

    -- Get User IDs
    SELECT id INTO alice_id FROM users WHERE name = 'Alice Smith';
    SELECT id INTO bob_id FROM users WHERE name = 'Bob Johnson';
    SELECT id INTO carol_id FROM users WHERE name = 'Carol Williams';
    SELECT id INTO david_id FROM users WHERE name = 'David Brown';
    SELECT id INTO emma_id FROM users WHERE name = 'Emma Davis';

    -- Seed Projects
    INSERT INTO projects (id, name) VALUES
    (uuid_generate_v4(), 'Website Redesign'),
    (uuid_generate_v4(), 'Mobile App Development'),
    (uuid_generate_v4(), 'API Integration');

    -- Get Project IDs
    SELECT id INTO project1_id FROM projects WHERE name = 'Website Redesign';
    SELECT id INTO project2_id FROM projects WHERE name = 'Mobile App Development';
    SELECT id INTO project3_id FROM projects WHERE name = 'API Integration';

    -- Seed Project Members
    INSERT INTO project_members (id, project_id, user_id, role) VALUES
    -- Website Redesign team
    (uuid_generate_v4(), project1_id, alice_id, 'owner'),
    (uuid_generate_v4(), project1_id, bob_id, 'admin'),
    (uuid_generate_v4(), project1_id, carol_id, 'member'),
    -- Mobile App Development team
    (uuid_generate_v4(), project2_id, bob_id, 'owner'),
    (uuid_generate_v4(), project2_id, david_id, 'admin'),
    (uuid_generate_v4(), project2_id, emma_id, 'member'),
    -- API Integration team
    (uuid_generate_v4(), project3_id, carol_id, 'owner'),
    (uuid_generate_v4(), project3_id, alice_id, 'member'),
    (uuid_generate_v4(), project3_id, emma_id, 'member');

    -- Seed Threads
    INSERT INTO threads (id, project_id, thread_key, resolved, metadata) VALUES
    (uuid_generate_v4(), project1_id, 'homepage-feedback', false, '{"priority": "high", "category": "design"}'::jsonb),
    (uuid_generate_v4(), project1_id, 'navigation-issues', true, '{"priority": "medium", "category": "ux"}'::jsonb),
    (uuid_generate_v4(), project2_id, 'login-bug', false, '{"priority": "critical", "category": "bug"}'::jsonb);

    -- Get Thread IDs
    SELECT id INTO thread1_id FROM threads WHERE thread_key = 'homepage-feedback';
    SELECT id INTO thread2_id FROM threads WHERE thread_key = 'login-bug';

    -- Seed Comments
    INSERT INTO comments (id, thread_id, user_id, body) VALUES
    (uuid_generate_v4(), thread1_id, alice_id, '{"text": "The homepage layout needs improvement", "attachments": []}'::jsonb),
    (uuid_generate_v4(), thread1_id, bob_id, '{"text": "I agree, lets schedule a design review", "attachments": []}'::jsonb),
    (uuid_generate_v4(), thread2_id, carol_id, '{"text": "Found a critical issue with login flow", "attachments": ["error_log.txt"]}'::jsonb);

    -- Get Comment ID for reference
    SELECT id INTO comment1_id FROM comments 
    WHERE (body->>'text') = 'I agree, lets schedule a design review';

    -- Seed Mentions
    INSERT INTO mentions (id, comment_id, user_id) VALUES
    (uuid_generate_v4(), comment1_id, carol_id),
    (uuid_generate_v4(), comment1_id, alice_id);

    -- Seed Notifications
    INSERT INTO notifications (id, user_id, thread_id, comment_id) VALUES
    (uuid_generate_v4(), carol_id, thread1_id, comment1_id),
    (uuid_generate_v4(), alice_id, thread1_id, comment1_id);
END $$;