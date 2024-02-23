/*
Question #1: 
Vibestream is designed for users to share brief updates about 
how they are feeling, as such the platform enforces a character limit of 25. 
How many posts are exactly 25 characters long?

Expected column names: char_limit_posts
*/

-- q1 solution:

--This query finds the posts with exactly 25 characters.
SELECT count(*) AS char_limit_posts
FROM posts
WHERE LENGTH(content) = 25;

/*

Question #2: 
Users JamesTiger8285 and RobertMermaid7605 are Vibestream’s most active posters.

Find the difference in the number of posts these two users made on each day 
that at least one of them made a post. Return dates where the absolute value of 
the difference between posts made is greater than 2 
(i.e dates where JamesTiger8285 made at least 3 more posts than RobertMermaid7605 or vice versa).

Expected column names: post_date
*/

-- q2 solution:

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

/*
Question #3: 
Most users have relatively low engagement and few connections. 
User WilliamEagle6815, for example, has only 2 followers.

Network Analysts would say this user has two **1-step path** relationships. 
Having 2 followers doesn’t mean WilliamEagle6815 is isolated, however. 
Through his followers, he is indirectly connected to the larger Vibestream network.  

Consider all users up to 3 steps away from this user:

- 1-step path (X → WilliamEagle6815)
- 2-step path (Y → X → WilliamEagle6815)
- 3-step path (Z → Y → X → WilliamEagle6815)

Write a query to find follower_id of all users within 4 steps of WilliamEagle6815. 
Order by follower_id and return the top 10 records.

Expected column names: follower_id

*/

-- q3 solution:

-- This part finds WilliamEagle6815's followers.
WITH william_followers AS(
  SELECT *
	FROM follows AS f
	INNER JOIN users AS u
	ON f.followee_id = u.user_id
	WHERE user_name = 'WilliamEagle6815'),

-- This part finds WilliamEagle6815's second circle followers.
second_circle AS(
  SELECT f.follower_id
	FROM follows AS f
	INNER JOIN william_followers AS w
	ON f.followee_id = w.follower_id),

-- This part finds WilliamEagle6815's third circle followers.
third_circle AS(
  SELECT f.follower_id
	FROM follows AS f
	INNER JOIN second_circle AS s
	ON f.followee_id = s.follower_id)
 
-- This part finds WilliamEagle6815's top fourth circle followers.
SELECT DISTINCT f.follower_id
	FROM follows AS f
	INNER JOIN third_circle AS t
	ON f.followee_id = t.follower_id
  ORDER BY f.follower_id
  LIMIT 10;

/*
Question #4: 
Return top posters for 2023-11-30 and 2023-12-01. 
A top poster is a user who has the most OR second most number of posts 
in a given day. Include the number of posts in the result and 
order the result by post_date and user_id.

Expected column names: post_date, user_id, posts

</aside>
*/

-- q4 solution:

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