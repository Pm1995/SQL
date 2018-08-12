#Problem 
#4 Ways to Join Only The First Row in SQL

#we need a list of users and the most recent widget each user has created.
#We have a users table and a widgets table, and each user has many widgets.
#users.id is the primary key on users, and widgets.user_id is the corresponding foreign key in widgets.
#To solve this problem, we need to join only the first row.

select users.user_id,widgets.widget_id
from users inner join 
                    (select widgets.user_id,widgets.widget_id,max(created_at)
                    	from widgets 
                    	groupby widgets.user_id,widgets.widget_id) as most_recent_widget
on users.user_id=most_recent_widget.widget_id; 


#without group by and using distinct_on 
select * from users join 
                 (select distinct on (user_id)* from widgets
                 	order by user_id,created at desc) as most_recent_widget
 on user.user_id=most_recent_widget.user_id


#using correlated subqueries 
select * from users join widgets 
on users.id=
            (select id from widgets
            	where users.id=widgets.id
            	order by created_at desc
            	limit 1)





