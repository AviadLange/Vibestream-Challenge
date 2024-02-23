--This query finds the posts with exactly 25 characters.
SELECT count(*) AS char_limit_posts
FROM posts
WHERE LENGTH(content) = 25;
