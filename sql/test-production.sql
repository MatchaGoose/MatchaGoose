/*
This file contains sample queries run on the production dataset.

Note that each sample query is identified as Q[number].
To see the output for a specific sample query, 
locate the sample query's identifier on the "test-production.out" file.
*/

-- Feature 1: Signup / login page
-- Signup / login
Q1:
    -- Create a dense index on User(email)
    CREATE INDEX email_idx ON "User"(email);
    SELECT * FROM "User" WHERE email = 'lucas@gmail.com'; 
Q2: INSERT INTO "User" (
    id, email, password, created_at, last_login, has_onboarded
) VALUES (
    gen_random_uuid(), 'lucas@gmail.com', 'Lucas', NOW(), NOW(), FALSE
);

-- Feature 2: Onboarding pages
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

-- Feature 3: Swiping page
Q8:
SELECT offering_user_id, similarity
FROM "Similarity"
WHERE looking_user_id = '1df7d007-3918-43df-b050-8c99deec7b85'
ORDER BY similarity DESC
LIMIT 10;

-- Feature 4: Profile page
Q9: SELECT * FROM "User" WHERE id = '2ffc97ff-9cc3-4021-8edc-89a36bf6d783';
Q10:
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

-- Feature 5: Liking
Q11: INSERT INTO "Likes" (
    like_id, liker_id, likee_id, liked_at
) VALUES (
    gen_random_uuid(), '1df7d007-3918-43df-b050-8c99deec7b85', '2vr1d007-3918-43df-b050-8c14dfcc7b95', NOW()
);

-- Feature 6: Matching
Q12: SELECT (
    EXISTS (
        SELECT * 
        FROM "Likes"
        WHERE liker_id = '1df7d007-3918-43df-b050-8c99deec7b85' AND likee_id = '2vr1d007-3918-43df-b050-8c14dfcc7b95'
    ) AND EXISTS (
        SELECT *
        FROM "Likes"
        WHERE liker_id = '2vr1d007-3918-43df-b050-8c14dfcc7b95' AND likee_id = '1df7d007-3918-43df-b050-8c99deec7b85'
    )
) AS is_match;