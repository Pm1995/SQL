#Find the total revenue of each facility
SELECT name,sum(revenue) as revenue from (select fac.name,case when book.memid=0 then book.slots*fac.guestcost
							                       else book.slots*fac.membercost end as revenue
							  from cd.facilities fac 
							  inner join cd.bookings book
							  on fac.facid=book.facid) as chp
group by name
order by revenue;


#Find facilities with a total revenue less than 1000
select fac.name,sum(case when book.memid=0 then book.slots*fac.guestcost
					     else book.slots*fac.membercost end) as revenue
from cd.facilities fac
inner join cd.bookings book
on fac.facid=book.facid
group by fac.name
having sum(case when book.memid=0 then book.slots*fac.guestcost
					     else book.slots*fac.membercost end)<1000;


#List the total slots booked per facility per month, part 2:with running sum 
SELECT facid,EXTRACT(month FROM starttime) AS month,SUM(slots)
FROM cd.bookings
WHERE starttime>='2012-01-01' AND starttime<'2013-01-01'
GROUP BY rollup(facid,month)
ORDER BY facid,month;



#List the total hours booked per named facility
select fac.facid,fac.name,cast(sum(book.slots)*0.5 as decimal(16,2)) as "Total Hours"
from cd.facilities fac
inner join cd.bookings book
on fac.facid=book.facid
group by fac.facid,fac.name
order by fac.facid;

