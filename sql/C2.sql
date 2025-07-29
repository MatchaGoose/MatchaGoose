-- Tables

create table "User"(
  id uuid not null default gen_random_uuid(),
  email text not null,
  password text not null,
  created_at timestamp with time zone not null default now(),
  first_name text null,
  last_name text null,
  bio text null,
  image_url text null,
  linkedin_url text null,
  twitter_url text null,
  github_url text null,
  last_login timestamp with time zone not null,
  has_onboarded boolean not null,
  user_domain domains[] null,
  desired_domain domains[] null,
  user_sector sectors[] null,
  skills skills[] null,
  desired_skills skills[] null,
  constraint User_pkey primary key (id),
  constraint User_email_key unique (email)
);

CREATE TABLE "Likes" (
  like_id     uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  liker_id    uuid NOT NULL REFERENCES "User"(id),
  likee_id    uuid NOT NULL REFERENCES "User"(id),
  liked_at    timestamp NOT NULL
);

CREATE TABLE "Matches" (
  match_id     uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user1_id    uuid NOT NULL REFERENCES "User"(id),
  user2_id    uuid NOT NULL REFERENCES "User"(id),
  matched_at    timestamp NOT NULL
);

CREATE TABLE "Messages" (
  message_id     uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  match_id    uuid NOT NULL REFERENCES "Matches"(match_id),
  sender_id    uuid NOT NULL REFERENCES "User"(id),
  content text NOT NULL,
  sent_at timestamp NOT NULL
);

CREATE TABLE "recommendations" (
  user_id               uuid        PRIMARY KEY NOT NULL REFERENCES "User"(id),
  recommended_user_ids  uuid[]      NOT NULL DEFAULT ARRAY[]::uuid[]
);

create table "user_vectors" (
  user_id uuid not null,
  embedding extensions.vector not null,
  constraint user_vectors_pkey primary key (user_id),
  constraint user_vectors_user_id_fkey foreign KEY (user_id) references "User"(id)
);

-- Triggers

-- If there are two records such that person 1 likes person 2 and person 2 likes person 1, the match is added to the match table
CREATE function insert_match()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public."Matches"(user1_id, user2_id, matched_at)
  SELECT LEAST(NEW.liker_id, NEW.likee_id),
         GREATEST(NEW.liker_id, NEW.likee_id),
         NOW()
  WHERE EXISTS (
    SELECT 1 FROM public."Likes"
     WHERE liker_id = NEW.likee_id
       AND likee_id = NEW.liker_id
  )
    AND NOT EXISTS (
    SELECT 1 FROM public."Matches"
     WHERE user1_id = LEAST(NEW.liker_id, NEW.likee_id)
       AND user2_id = GREATEST(NEW.liker_id, NEW.likee_id)
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_insert_match
AFTER INSERT ON public."Likes"
FOR EACH ROW
EXECUTE FUNCTION insert_match();
