--This parts filters for only JamesTiger8285's posts, and counts them.
WITH james AS
	(SELECT post_date, COUNT(post_id) AS james_posts
	FROM posts
	INNER JOIN users
	USING(user_id)
	WHERE user_name = 'JamesTiger8285'
	GROUP BY post_date),

--This parts filters for only RobertMermaid7605's posts, and counts them.
robert AS(
  SELECT post_date, COUNT(post_id) AS robert_posts
	FROM posts
	INNER JOIN users
	USING(user_id)
	WHERE user_name = 'RobertMermaid7605'
	GROUP BY post_date)

--This part compares the amount of posts for these two indeviduals.
SELECT post_date
FROM james
FULL JOIN robert
USING(post_date)
WHERE ABS(COALESCE(james_posts, 0) - COALESCE(robert_posts, 0)) >= 3;