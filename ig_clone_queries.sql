use ig_clone;

/*
Marketing: The marketing team wants to launch some campaigns, 
*/
/*
1.) Rewarding Most Loyal Users: People who have been using the platform for the longest time.
Task: Find the 5 oldest users of the Instagram from the database provided
*/

SELECT username
	FROM users
    ORDER BY created_at LIMIT 5;
    
/*
2.) Remind Inactive Users to Start Posting: By sending them promotional emails to post their 1st photo.
Task: Find the users who have never posted a single photo on Instagram
*/

SELECT username 
	FROM users
		WHERE NOT EXISTS
(SELECT user_id 
	FROM photos
    WHERE
		photos.user_id = users.id);
	
/*	
3.) Declaring Contest Winner: The team started a contest and the user who gets the most likes on a single photo will win the contest now they wish to declare the winner.
Task: Identify the winner of the contest and provide their details to the team
*/

SELECT 
    username,
    photos.image_url, 
    COUNT(*) AS total
FROM photos
INNER JOIN likes
    ON likes.photo_id = photos.id
INNER JOIN users
    ON photos.user_id = users.id
GROUP BY photos.id
ORDER BY total DESC
LIMIT 1;

  
  
/* 4.) Hashtag Researching: A partner brand wants to know, which hashtags to use in the post to reach the most people on the platform.
Your Task: Identify and suggest the top 5 most commonly used hashtags on the platform
*/

SELECT tags.tag_name as Tag_Name,
	count(photo_tags.photo_id) as Tag_Counts
    FROM tags
    INNER JOIN photo_tags
    ON tags.id = photo_tags.tag_id
    GROUP BY 1
    ORDER BY 2 DESC LIMIT 5; 
    
/* 5.) Launch AD Campaign: The team wants to know, which day would be the best day to launch ADs.
Your Task: What day of the week do most users register on? Provide insights on when to schedule an ad campaign
*/

SELECT 
	dayname(created_at),
    COUNT(id)
    FROM
		users
	GROUP BY 1
	ORDER BY 2 DESC;
    
/*B) Investor Metrics: 
User Engagement: Are users still as active and post on Instagram or they are making fewer posts
Task: Provide how many times does average user posts on Instagram. 
Also, provide the total number of photos on Instagram/total number of users
*/

SELECT
	ROUND( ((SELECT COUNT(photos.id) FROM photos) / (SELECT COUNT(users.id) FROM users)), 2)  as photos_to_users;
    

/* 2. Bots & Fake Accounts: The investors want to know if the platform is crowded with fake and dummy accounts
Your Task: Provide data on users (bots) who have liked every single photo on the site (since any normal user would not be able to do this).
*/

SELECT users.id,
	users.username,
	COUNT(users.id) as total_likes
FROM
	users
    INNER JOIN likes
    ON users.id = likes.user_id
GROUP BY users.id
HAVING total_likes = (SELECT COUNT(*) FROM photos);
