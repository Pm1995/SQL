#SQL 101 


#4 Ways to Join Only The First Row in SQL---

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


--------------------------------------------------------------------------------------------------------


#Counting Conditionally in SQL---

#When preparing a report on the number of customers you have, it can be helpful to split out the premium 
#customers — i.e., those who spend more than $100/month — from the rest of the group.

#method 1 
select date(created_at),sum(case when monthly_payment_amount>100 then 1
                                  else 0 end) as prenium_customers,count(*)
from customers
group by 1; 

#method 2 
select date(created_at),prenium,total 
             from (select date(created_at),sum(case when monthly_payment_amount>100 then 1
             	                                else 0 end) as prenium,count(*) as total 
                    from customers
                   group by date(created_at));

#method 3 
 select date(created_at),sum(prenium) as prenium
                            from (select date(created_at),case when monthly_payment_amount>100 then 1 
                            	                                   else 0 end as prenium
                            	   from customers)
 group by 1;


-------------------------------------------------------------------------------------------------------

 #Computing Day-Over-Day Changes With Window Functions

 #In most sophisticated analysis, the rate of change is at least as important as the raw values. 
 #This makes life tough for a SQL analyst, where adding daily deltas to your 
 #result set can be difficult. In this post, we’ll show you how to pull results like these:

 select dt,count(dt) events
 from events 
 group by dt
 order by dt desc
 limit 10; 

 #using lan(a,N) function of redshift to update the count of events on a daily basis
 select dt,count(dt) as ct,lag(count(dt),1) over (order by dt) as ct_yesterday
 from events 
 group by dt 
 order by dt desc 
 limit 10; 

 #getting the daily percentage change by using a subquery
 select dt,ct,ct_yesterday,((ct-ct_yesterday)/ct_yesterday)*100 as daily_delta
        from (select dt,count(dt) as ct,lag(count(dt),1) over (order by dt) as ct_yesterday
        	  from events 
        	  group by dt 
        	  order by dt desc
        	  limit 10); 

-------------------------------------------------------------------------------------------------------

#Selecting Only One Row Per Group

#Sometimes you just want to graph the winners. Were there more iOS or Android users today? 
#Grouping and counting the daily usage per platform is easy,
# but getting only the top platform for each day can be tough.

#to get the first row per group using row_number() function. Alternatively, can also use rank() function- for postgres

select dt,platform,ct
   from (select dt,platform,row_number() over (partition by dt order by ct desc) as row_num
   	     from gameplays
   	     group by dt,platform)
   where row_num=1;


#for mysql- use group_concat function with full query to get maximum count:
select dt,group_concat(platform order by ct desc) platform
       from (select dt,count(dt) as ct
       	     from gameplays
       	     group by dt,platform)
       groupby dt, 

select dt,substring_index(
  group_concat(
    platform order by ct desc
  )
, ',',1) platform,max(ct) as ct
         from (select dt,count(dt) as ct
         	from gameplays
         	groupby dt,platform
           )
    groupby dt;
-------------------------------------------------------------------------------------------------------







