#Find the total revenue of each facility
SELECT name,sum(revenue) as revenue from (select fac.name,case when book.memid=0 then book.slots*fac.guestcost
							                       else book.slots*fac.membercost end as revenue
							  from cd.facilities fac 
							  inner join cd.bookings book
							  on fac.facid=book.facid) as chp
group by name
order by revenue;
