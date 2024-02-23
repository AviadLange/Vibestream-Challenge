-- This part calculates the posts per user in the given dates and rank them.
WITH post_per_user AS(
  SELECT post_date, user_id, COUNT(*) AS posts,
		DENSE_RANK() OVER(PARTITION BY post_date ORDER BY COUNT(*) DESC) AS ranking
	FROM posts
	WHERE post_date IN('2023-11-30', '2023-12-01')
	GROUP BY 1, 2)

-- This parts returns only the top two of users in terms of amount of posts.
SELECT post_date, user_id, posts
FROM post_per_user
WHERE ranking IN(1, 2)
ORDER BY 1, 2;