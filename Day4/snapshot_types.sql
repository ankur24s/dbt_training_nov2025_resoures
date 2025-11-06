select * from  dev.bronze_airbnb.src_listings  

Create one snapshot model - listings_snapshot

Syntax:


{% snapshot listings_snapshot%}
{{
config
	(
	 target_database = '',
	 target_schema = '',
	 unique_key = 'id',
	 strategy = 'check/timestamp'
	 updated_at/checked_cols = '',
	 invalidate_hard_deletes = true/false
	)
}}


{% endsnapshot %}


	
--------------------------------------strategy = 'check'; invalidate_hard_deletes = false -------------------
{% snapshot listings_snapshot %}
	{{
	config(
		schema = 'snapshot',
		unique_key = 'listing_id',
		strategy = 'check',
		check_cols = ['listing_url','room_type','minimum_nights','price_str'],
		invalidate_hard_deletes =False
		)
	}}

SELECT
listing_id, 
listing_name, 
listing_url, 
room_type, 
minimum_nights, 
host_id,
price_str, 
created_at, 
updated_at
FROM
{{ref('src_listings')}}

{% endsnapshot %}


-- lab steps
---------------strategy = 'check'; invalidate_hard_deletes = false -------------------
{% snapshot listings_snapshot %}
	{{
	config(
		database = 'int',
		schema = 'snapshot',
		unique_key = 'listing_id',
		strategy = 'check',
		check_cols = ['listing_url','room_type','minimum_nights','price_str'],
		invalidate_hard_deletes =True
		)
	}}

SELECT
listing_id, 
listing_name, 
listing_url, 
room_type, 
minimum_nights, 
host_id,
price_str, 
created_at, 
updated_at
FROM
{{ref('src_listings')}}

{% endsnapshot %}


--- Lab steps:
select * from  dev.bronze_airbnb.src_listings  where id = 7071;
select * from dev.silver_airbnb.silver_listings where listing_id = 7071;
select * from dev.snapshots.listings_snapshot where listing_id = 7071;  
['listing_url','room_type','minimum_nights','price_str'],

update  dev.bronze_airbnb.src_listings set ROOM_TYPE  ='Entire home/apt' where id = 7071;

--now run the command "dbt build -m +listings_snapshot" -- build to run both snapshot and upstream dependent models
select * from dev.snapshots.listings_snapshot where listing_id = 7071;  
--Try updating minimum_nights now
update  dev.bronze_airbnb.src_listings set minimum_nights  =3 where id = 7071;
-- run the command again - "dbt build -m +listings_snapshot" and check we have 3 rows now
select * from dev.snapshots.listings_snapshot where listing_id = 7071; ;
--demo of invalidate_hard_deletes
-- now we will delete a row from source
select * from  dev.bronze_airbnb.src_listings  where id = 3176;
select * from  dev.silver_airbnb.silver_listings  where listing_id = 3176;
select * from dev.snapshots.listings_snapshot where listing_id = 3176;  
--now we will delete this row from source 
delete from dev.bronze_airbnb.src_listings  where id = 3176;
-- now run the dbt build command 
select * from dev.snapshots.listings_snapshot  where listing_id = 3176; 
--it has not deleted the recrod in snapshot and the dbt_valid_to is still NULL

-- now change the configuration to invalidate_hard_deletes =True
---now run the dbt build command and check the data
-- select * from dev.snapshots.listings_snapshot  where listing_id = 3176;-- the record has expired now

select * from  dev.bronze_airbnb.src_listings  where id = 7071;
select * from dev.silver_airbnb.silver_listings where listing_id = 7071;
select * from dev.snapshots.listings_snapshot where listing_id = 7071;
-- the check update is on column ['listing_url','room_type','minimum_nights','price_str'], we will try to update listing name and see what happens.
update  dev.bronze_airbnb.src_listings set name  ='Demo room' where id = 7071;
-- run the dbt build command

select * from dev.silver_airbnb.silver_listings where listing_id = 7071;
select * from dev.snapshots.listings_snapshot where listing_id = 7071;
-- the changes will ne on STG but not on snapshot table becuase we did not included "listing_name" in check cols
-- we can either include check cols = all as well to check update on any column


------------------------strategy = 'timestamp'; invalidate_hard_deletes = false -------------------
{% snapshot listings_snapshot %}
	{{
	config(
		schema = 'snapshot',
		unique_key = 'listing_id',
		strategy = 'timestamp',
		updated_at='updated_at',
		invalidate_hard_deletes =True
		)
	}}

SELECT
listing_id, 
listing_name, 
listing_url, 
room_type, 
minimum_nights, 
host_id,
price_str, 
created_at, 
updated_at
FROM
{{ref('src_listings')}}

{% endsnapshot %}


--- Lab steps

select * from  dev.bronze_airbnb.src_listings  where id = 40600;
select * from dev.silver_airbnb.silver_listings where listing_id = 40600;
select * from dev.snapshots.listings_snapshot where listing_id = 40600; 

update  dev.bronze_airbnb.src_listings  set updated_at  = '2025-05-05',ROOM_TYPE = 'Entire Home'  where id = 40600;
--now run the command "dbt build -m +listings_snapshot" -- build to run both snapshot and upstream dependent models
select * from dev.snapshots.listings_snapshot where listing_id = 40600;

---- Add dbt_valid_to_current:

{% snapshot listings_snapshot %}
	{{
	config(
		database = 'int',
		schema = 'snapshot',
		unique_key = 'listing_id',
		strategy = 'timestamp',
		updated_at='updated_at',
		dbt_valid_to_current = 'to_date('9999-12-31')'
		invalidate_hard_deletes =True
		)
	}}

SELECT
listing_id, 
listing_name, 
listing_url, 
room_type, 
minimum_nights, 
host_id,
price_str, 
created_at, 
updated_at
FROM
{{ref('src_listings')}}

{% endsnapshot %}