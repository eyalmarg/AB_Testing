-- DATASET

SELECT g.uid AS user_id
	,g.GROUP AS user_group
	,g.device
	,u.gender
	,u.country
	,CASE 
		WHEN a.dt >= g.join_dt
			THEN 1
		ELSE 0
		END AS converted
	,sum(a.spent) AS spent
FROM masterschool.groups g
LEFT JOIN users u ON g.uid = u.id
LEFT JOIN activity a ON g.uid = a.uid
GROUP BY 1	,2	,3	,4	,5	,6;


-- DATASET WITH DATES

select g.uid as user_id, g.group as user_group, g.device, u.gender, u.country, a.dt as activity_date,
	   case when a.dt >= g.join_dt then 1 else 0 end as converted, sum(a.spent) as spent
from masterschool.groups g	
left join users u
	on g.uid = u.id
left join activity a
	on g.uid = a.uid
group by 1, 2, 3, 4, 5, 6, 7;

-- STATISTICAL PARAMETERS

with dataset as (
select g.uid as user_id, g.group as user_group, g.device, u.gender, u.country, 
	   case when a.dt >= g.join_dt then 1 else 0 end as converted, sum(a.spent) as spent
from masterschool.groups g	
left join users u
	on g.uid = u.id
left join activity a
	on g.uid = a.uid
group by 1, 2, 3, 4, 5, 6
)
select user_group, count( distinct user_id) as group_size,
       round(sum(converted)/count( distinct user_id) * 100, 3) as conversion_rate,
       round(sum(spent)/count(distinct user_id), 3) as avg_spending_per_user
from dataset
group by 1;

-- KEY MEASURMENT BY DEVICE

with dataset as (
	select g.uid as user_id, g.group as user_group, g.device, u.gender, u.country, 
		   case when a.dt >= g.join_dt then 1 else 0 end as converted, sum(a.spent) as spent
	from masterschool.groups g	
	left join users u
		on g.uid = u.id
	left join activity a
		on g.uid = a.uid
	group by 1, 2, 3, 4, 5, 6
)
select user_group, device,
       round(sum(converted) / count(distinct user_id) * 100, 2) as conversion_rate,
	   round(sum(spent)/count(distinct user_id), 2) as avg_spending_per_user
from dataset
where device not like ""
group by 2, 1;

-- KEY MEASURMENT BY GENDER

with dataset as (
	select g.uid as user_id, g.group as user_group, g.device, u.gender, u.country, 
		   case when a.dt >= g.join_dt then 1 else 0 end as converted, sum(a.spent) as spent
	from masterschool.groups g	
	left join users u
		on g.uid = u.id
	left join activity a
		on g.uid = a.uid
	group by 1, 2, 3, 4, 5, 6
)
select user_group, gender,
       round(sum(converted) / count(distinct user_id) * 100, 2) as conversion_rate,
	   round(sum(spent)/count(distinct user_id), 2) as avg_spending_per_user
from dataset
group by 2, 1;

-- KEY MEASURMENT BY COUNTRY

with dataset as (
	select g.uid as user_id, g.group as user_group, g.device, u.gender, u.country, 
		   case when a.dt >= g.join_dt then 1 else 0 end as converted, sum(a.spent) as spent
	from masterschool.groups g	
	left join users u
		on g.uid = u.id
	left join activity a
		on g.uid = a.uid
	group by 1, 2, 3, 4, 5, 6
)
select user_group, country,
       round(sum(converted) / count(distinct user_id) * 100, 2) as conversion_rate,
	   round(sum(spent)/count(distinct user_id), 2) as avg_spending_per_user
from dataset
where country not like ""
group by 2, 1;


