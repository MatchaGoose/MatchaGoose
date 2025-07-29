/*
This file contains sample queries run on the production dataset.

Note that each sample query is identified as Q[number].
To see the output for a specific sample query, 
locate the sample query's identifier on the "test-production.out" file.
*/

-- Feature 1: Signup / login page
-- Signup / login

-- Compare index / no index
Q05:
    1)
      -- Drop the index if it exists, so we can test without it
      DROP INDEX IF EXISTS email_idx;
    
      -- Run EXPLAIN ANALYZE without the index
      EXPLAIN ANALYZE
        SELECT * FROM "User" WHERE email = 'lucas@gmail.com';

    2)
    -- Create index on email
    CREATE INDEX IF NOT EXISTS email_idx ON "User"(email);
    
    -- Run EXPLAIN ANALYZE with the index
    EXPLAIN ANALYZE
        SELECT * FROM "User" WHERE email = 'lucas@gmail.com';

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
Q3:
    1) EXPLAIN ANALYZE
        UPDATE public."User"
          SET has_onboarded = true
        WHERE id IN (
          SELECT id
            FROM public."User"
            ORDER BY random()
            LIMIT 1000
        );
    2) CREATE INDEX IF NOT EXISTS idx_onboarding_user_id
          ON public."User"(id);

       EXPLAIN ANALYZE
        UPDATE public."User"
          SET has_onboarded = true
        WHERE id IN (
          SELECT id
            FROM public."User"
            ORDER BY random()
            LIMIT 1000
        );
        
            
Q4:
CREATE INDEX idx_onboarding_user_id ON User(user_id)
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
    1)  DROP INDEX IF EXISTS user_idx;
        EXPLAIN ANALYZE
        SELECT recommended_user_ids
        FROM "recommendations"
        WHERE user_id = 'b614d7cc-3d60-4789-a755-255a1d2b44b7';

    
    2)  CREATE INDEX user_idx ON "recommendations"(user_id);
        EXPLAIN ANALYZE
        SELECT recommended_user_ids
        FROM "recommendations"
        WHERE user_id = 'b614d7cc-3d60-4789-a755-255a1d2b44b7';

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

-- Feature 5: Update email / password
Q11:
    1) EXPLAIN ANALYZE
    SELECT password
    FROM "User"
    WHERE id = "b614d7cc-3d60-4789-a755-255a1d2b44b7";
    2) CREATE INDEX idx_user_id_cover ON "User"(id) INCLUDE (password, email);
    EXPLAIN ANALYZE
    SELECT password
    FROM "User"
    WHERE id = "b614d7cc-3d60-4789-a755-255a1d2b44b7";

-- Feature 6: Liking
Q12: INSERT INTO "Likes" (
    like_id, liker_id, likee_id, liked_at
) VALUES (
    gen_random_uuid(), '1df7d007-3918-43df-b050-8c99deec7b85', '2vr1d007-3918-43df-b050-8c14dfcc7b95', NOW()
);

-- Feature 7: Matching
Q13: SELECT (
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
