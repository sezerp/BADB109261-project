
select count(*) as user_cnt from users;
select count(*) as interest_cnt from interests;
select count(*) as friends_cnt from friends;
select count(*) as user_post_cnt from user_post;
select count(*) as user_post_hist_cnt from user_post_hist;
select count(*) as comments_cnt from comments;

select u.login_lowercase, count(com.id) as comments_cnt from comments com
     left join user_post up on com.post_id = up.id
     left join users u on com.user_id = u.id
group by u.login_lowercase
order by comments_cnt ASC;

select count(distinct friends.user_id, friend_id) as friends_cnt, login from friends
     left join users u on friends.user_id = u.id
group by friends.user_id
order by friends_cnt ASC;

select u.login, com.content as comment, up.content as post  from comments com
     join users u on com.user_id = u.id
     join user_post up on com.post_id = up.id;

select
    u.login,
    (select content from user_post where com.post_id = id) as post,
    com.content as comment
from comments com
    join users u on com.user_id = u.id;

select user_id, count(*) as cnt from user_post_hist group by user_id order by cnt DESC;
select user_id, count(*) as cnt from user_post group by user_id order by cnt DESC;

select
       u.login,
       sum(up.likes) as likes_all,
       avg(up.likes) as avarage_likes
from users u
    left join user_post up on u.id = up.user_id
group by u.id
order by likes_all desc;

select
    u.login,
    sum(up.likes) as likes_all,
    avg(up.likes) as avarage_likes
from users u
         left join user_post up on u.id = up.user_id
group by u.id
having likes_all > 500
order by likes_all desc;

select
    u.login,
    max(up.likes) as max_likes_under_post,
    min(up.likes) as min_likes_under_post,
    avg(up.likes) as avarage_likes
from users u
         left join user_post up on u.id = up.user_id
group by u.id
order by max_likes_under_post desc;

select u.login, count(i.user_id) as number_user_interests
from interests i
         join users u on i.user_id = u.id
group by i.user_id
order by number_user_interests DESC;

select
    name,
    count(*) as cnt
from interests
group by name
order by cnt desc;

select
    u.login,
    count(*) as cnt_lorem_ipsum_comments
from user_post up
         left join users u on up.user_id = u.id
where up.content LIKE '%lorem%'
group by u.id;

