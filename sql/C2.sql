-- Tables

CREATE TABLE likes (
  like_id     uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  liker_id    uuid NOT NULL REFERENCES "User"(id),
  likee_id    uuid NOT NULL REFERENCES "User"(id),
  liked_at    timestamp NOT NULL
);

CREATE TABLE matches (
  match_id     uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user1_id    uuid NOT NULL REFERENCES "User"(id),
  user2_id    uuid NOT NULL REFERENCES "User"(id),
  matched_at    timestamp NOT NULL
);

CREATE TABLE messages (
  message_id     uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  match_id    uuid NOT NULL REFERENCES "matches"(match_id),
  sender_id    uuid NOT NULL REFERENCES "User"(id),
  content text NOT NULL,
  sent_at timestamp NOT NULL
);

CREATE TABLE similarity (
  similarity_id     uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  looking_user_id    uuid NOT NULL REFERENCES "User"(id),
  offering_user_id    uuid NOT NULL REFERENCES "User"(id),
  similarity numeric(6,5) NOT NULL
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
