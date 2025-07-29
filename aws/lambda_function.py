import os
import psycopg
from psycopg.rows import dict_row

# Load .env locally, skip in Lambda
if not os.getenv("AWS_LAMBDA_FUNCTION_NAME"):
    from dotenv import load_dotenv
    load_dotenv()

SUPABASE_DB_URL = os.environ["SUPABASE_DB_URL"]

def update_all_recommendations(top_n: int = 10):
    try:
        with psycopg.connect(SUPABASE_DB_URL, row_factory=dict_row) as conn:
            with conn.cursor() as cur:
                # Get all onboarded users with embeddings
                cur.execute("""
                    SELECT "User".id, "user_vectors".embedding
                    FROM "User"
                    JOIN "user_vectors" ON "User".id = "user_vectors".user_id
                    WHERE "User".has_onboarded = TRUE;
                """)
                users = cur.fetchall()

                for user in users:
                    user_id = user["id"]
                    embedding = user["embedding"]
                    if not embedding:
                        continue

                    # Find top-N similar users using embedding <=> operator
                    cur.execute("""
                        SELECT user_id
                        FROM "user_vectors"
                        WHERE user_id != %s
                        ORDER BY embedding <=> %s
                        LIMIT %s;
                    """, (user_id, embedding, top_n))
                    similar_users = [row["user_id"] for row in cur.fetchall()]

                    # Upsert recommendations
                    cur.execute("""
                        INSERT INTO "recommendations" (user_id, recommended_user_ids)
                        VALUES (%s, %s)
                        ON CONFLICT (user_id)
                        DO UPDATE SET recommended_user_ids = EXCLUDED.recommended_user_ids;
                    """, (user_id, similar_users))

                conn.commit()
    except Exception as e:
        print("Exception during update_all_recommendations:", e)

def lambda_handler(event, context):
    update_all_recommendations()
    return {"status": "success"}
