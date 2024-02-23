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