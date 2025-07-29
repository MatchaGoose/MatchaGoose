/*
For each feature, this file contains:
1. Query templates (parameterized queries)
2. Sample queries

Note that each sample query is identified as Q[number].
To see the output for a specific sample query, 
locate the sample query's identifier on the "test-sample.out" file.
*/

-- Feature 1: Signup / login page

-- QUERY TEMPLATES (F1)
SELECT * FROM "User" WHERE email = $1; -- Check if emails exists / retrieve password
-- Insert new user
INSERT INTO "User" (
    id, email, password, created_at, last_login, has_onboarded
) VALUES (
    gen_random_uuid(), $1, $2, NOW(), NOW(), FALSE
);

-- SAMPLE QUERIES (F1)
-- Signup / login
Q1: SELECT * FROM "User" WHERE email = 'bob@bob.ca'; 
Q2: INSERT INTO "User" (
    id, email, password, created_at, last_login, has_onboarded
) VALUES (
    gen_random_uuid(), 'bob@bob.ca', 'bob', NOW(), NOW(), FALSE
);

-- Feature 2: Onboarding pages

-- QUERY TEMPLATES (F2)
-- Onboarding page 1
UPDATE "User"
SET
    first_name = $3,
    last_name = $4,
    bio = $5,
    image_url = $6
WHERE id = $1;

-- Onboarding page 2
UPDATE "User"
SET 
    user_domain = $7,      
    desired_domain = $8,    
    user_sector = $9
WHERE id = $1;

-- Onboarding page 3
UPDATE "User"
SET
    skills = $10,
    desired_skills = $11
WHERE id = $1;

-- Onboarding page 4
UPDATE "User"
SET
    linkedin_url = $12,
    github_url = $13,
    twitter_url = $14,
    has_onboarded = TRUE
WHERE id = $1;

-- SAMPLE QUERIES (F2)
-- Onboarding page 1
Q4:
UPDATE "User"
SET
    first_name = 'Bob',
    last_name = 'Stone',
    bio = 'Hi! I am a frontend engineer named Bob.',
    image_url = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'
WHERE id = '1df7d007-3918-43df-b050-8c99deec7b85';

-- Onboarding page 2
Q5:
UPDATE "User"
SET 
    user_domain = ARRAY['Frontend', 'Mobile'],     
    desired_domain = ARRAY['Backend', 'Infrastructure'], 
    user_sector = ARRAY['Legal', 'FinTech']
WHERE id = '1df7d007-3918-43df-b050-8c99deec7b85';

-- Onboarding page 3
Q6:
UPDATE "User"
SET
    skills = ['React', 'TypeScript'],
    desired_skills = ['Ruby', 'Java']
WHERE id = '1df7d007-3918-43df-b050-8c99deec7b85';

-- Onboarding page 4
Q7:
UPDATE "User"
SET
    linkedin_url = 'https://sample-link.com',
    github_url = 'https://sample-link.com',
    twitter_url = 'https://sample-link.com',
    has_onboarded = TRUE
WHERE id = '1df7d007-3918-43df-b050-8c99deec7b85';

-- Feature 3: Swiping / Liking

-- QUERY TEMPLATES (F3)
-- Select $2 most similar users to user with id $1
SELECT id, email
FROM "Similarity"
WHERE looking_user_id = $1
ORDER BY similarity DESC
LIMIT $2;
-- User with id $1 likes user with id $2
INSERT INTO "Likes" (
    like_id, liker_id, likee_id, liked_at
) VALUES (
    gen_random_uuid(), $1, $2, NOW()
);

-- SAMPLE QUERIES (F3)
Q8:
SELECT offering_user_id, similarity
FROM "Similarity"
WHERE looking_user_id = '1df7d007-3918-43df-b050-8c99deec7b85'
ORDER BY similarity DESC
LIMIT 2;

Q9: 
INSERT INTO "Likes" (
    like_id, liker_id, likee_id, liked_at
) VALUES (
    gen_random_uuid(), '1df7d007-3918-43df-b050-8c99deec7b85', '2vr1d007-3918-43df-b050-8c14dfcc7b95', NOW()
);

-- Feature 4: Profile page

-- QUERY TEMPLATES (F4)
-- Retrieve user information
SELECT * FROM "User" WHERE id = $1;

-- Update user information
UPDATE "User"
SET 
    first_name = $3,
    last_name = $4,
    bio = $5,
    image_url = $6,
    user_domain = $7,     
    desired_domain = $8, 
    user_sector = $9,
    skills = $10,
    desired_skills = $11,
    linkedin_url = $12,
    github_url = $13,
    twitter_url = $14,
WHERE id = $1;

-- SAMPLE QUERIES (F4)
Q10: SELECT * FROM "User" WHERE id = '2ffc97ff-9cc3-4021-8edc-89a36bf6d783';

Q11:
UPDATE "User"
SET
    first_name = 'Bob',
    last_name = 'Stone',
    bio = 'Hi! I am a frontend engineer named Bob.',
    image_url = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'
    user_domain = ARRAY['Frontend', 'Mobile'],     
    desired_domain = ARRAY['Backend', 'Infrastructure'], 
    user_sector = ARRAY['Legal', 'FinTech']
    skills = ['React', 'TypeScript'],
    desired_skills = ['Ruby', 'Java']
    linkedin_url = 'https://sample-link.com',
    github_url = 'https://sample-link.com',
    twitter_url = 'https://sample-link.com',
    has_onboarded = TRUE
WHERE id = '2ffc97ff-9cc3-4021-8edc-89a36bf6d783';

-- Feature 5: Update email / password

-- QUERY TEMPLATES (F5)
-- Query password for user with id $1
Q12: 
SELECT password 
FROM "User"
WHERE id = $1;
-- Update password to $2 for user with id $1
Q13:
UPDATE "User"
SET
    password = $2
WHERE id = $1;
-- Query email for user with id $1
Q14:
SELECT email 
FROM "User"
WHERE id = $1;
-- Update email to $2 for user with id $1
Q15:
UPDATE "User"
SET 
    email = $2
WHERE id = $1;

-- SAMPLE QUERIES (F5)
Q12:
SELECT password 
FROM "User"
WHERE id = '2ffc97ff-9cc3-4021-8edc-89a36bf6d783';

Q13:
UPDATE "User"
SET
    password = "hashed-password-2"
WHERE id = '2ffc97ff-9cc3-4021-8edc-89a36bf6d783';

Q14:
SELECT email 
FROM "User"
WHERE id = '2ffc97ff-9cc3-4021-8edc-89a36bf6d783';

Q15:
UPDATE "User"
SET 
    email = "bob2@bob.ca"
WHERE id = '2ffc97ff-9cc3-4021-8edc-89a36bf6d783';
