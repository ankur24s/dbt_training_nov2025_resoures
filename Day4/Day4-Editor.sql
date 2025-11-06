---I will keep queries here
---I will keep queries here
-- Incremental Staratergy = append

{{config(
    materialized = 'incremental', 
    incremental_strategy="append"
    )}}

select * from  {{ref('silver_reviews')}}
{% if is_incremental() %}
where review_date > (select max(review_date) from {{this}})
{% endif %}





---------------merge

{{
    config(
    materialized = 'incremental', 
    unique_key = ['listing_id','reviewer_name'],
    merge_update_columns = ['REVIEW_DATE', 'REVIEW_TEXT', 'REVIEW_SENTIMENT']
    )
}}

select * from  {{ref('silver_reviews')}}
{% if is_incremental() %}
where review_date > (select max(review_date) from {{this}})
{% endif %}



>dbt run -s fact_reviews --full-refresh
------------------Delete + INSERT

{{
    config(
    materialized = 'incremental', 
    unique_key = ['listing_id','reviewer_name'],
    incremental_strategy = 'delete+insert'
    )
}}

select * from  {{ref('silver_reviews')}}
{% if is_incremental() %}
where review_date > (select max(review_date) from {{this}})
{% endif %}


-------------incremental predicates
{{
  config(
    materialized = 'incremental',
    unique_key = ['listing_id','reviewer_name'],
    cluster_by = ['REVIEW_DATE'],  
    incremental_strategy = 'merge',
    incremental_predicates = [
      "DBT_INTERNAL_DEST.REVIEW_DATE > dateadd(day, -30, '2021-10-28')"
    ]
  )
}}

--------------------------

select * from DEV.BRONZE_AIRBNB.SRC_hosts where id = 11622;

update  DEV.BRONZE_AIRBNB.SRC_hosts
set IS_SUPERHOST = 't'
where id = 11622;

 select * from DEV.GOLD_AIRBNB.DIM_LISTING_W_HOSTS
 where host_id = 11622


 SRC_LISTINGS   - > silver_listing => dim_listing  =>DIM_LISTING_W_HOSTS
 SRC_HOSTS   - > silver_HOSTS => dim_HOSTS  =>DIM_LISTING_W_HOSTS


 dim +DIM_LISTING_W_HOSTS


 -------------------------------
 select count(*) from DEV.BRONZE_AIRBNB.SRC_REVIEWS; 4,10,284

  select count(*) from DEV.SILVER_AIRBNB.SILVER_REVIEWS  --0

  select count(*) from DEV.GOLD_AIRBNB.FACT_REVIEWS

select * from DEV.GOLD_AIRBNB.FACT_REVIEWS

 select max(date) from DEV.BRONZE_AIRBNB.SRC_REVIEWS; --2021-10-22 00:00:00.000

 22 oct to 23 oct

 --truncate table DEV.BRONZE_AIRBNB.SRC_REVIEWS; 

 insert into DEV.BRONZE_AIRBNB.SRC_REVIEWS values
 (994259,'2021-10-23','Shankar','Nice Stay!','Positive')


select * from  DEV.SILVER_AIRBNB.SILVER_REVIEWS where review_date >
(select max(review_date) from DEV.GOLD_AIRBNB.FACT_REVIEWS)

select * from  {{ref('silver_reviews')}}
{% if is_incremental() %}
where review_date > (select max(review_date) from {{this}})
{% endif %}


select * from  DEV.silver_airbnb.silver_reviews

where review_date > (select max(review_date) from DEV.gold_airbnb.fact_reviews)


select * from  DEV.gold_airbnb.fact_reviews



select * from  DEV.GOLD_AIRBNB.FACT_REVIEWS where reviewer_name = 'Luca' and listing_id = '703286'

select * from   DEV.BRONZE_AIRBNB.SRC_REVIEWS  where reviewer_name = 'Luca' and listing_id = '703286'

insert into  DEV.BRONZE_AIRBNB.SRC_REVIEWS values
 (703286,'2021-10-27','Luca','Now just okay','Negative')

 merge into DEV.GOLD_AIRBNB.FACT_REVIEWS dest from DEV.SILVER_AIRBNB.SILVER_REVIEWS src
 on des
 and dest.reviewer_name = src.reviewer_name
 when matched and dest.review_txt <> ....



 select max(review_date) from  DEV.GOLD_AIRBNB.FACT_REVIEWS 

 [REVIEW_DATE, REVIEW_TEXT, REVIEW_SENTIMENT]

 
 delete from  DEV.BRONZE_AIRBNB.SRC_REVIEWS  where reviewer_name = 'Aude' and listing_id = '3176'
 and date = '2021-10-24'

 delete from  DEV.GOLD_AIRBNB.FACT_REVIEWS where reviewer_name = 'Aude' and listing_id = '3176'
 and review_date = '2021-10-25'

select count(*) from  DEV.GOLD_AIRBNB.FACT_REVIEWS  where  review_date >= '2021-09-25'  --7422

select * from  DEV.BRONZE_AIRBNB.SRC_REVIEWS where date >= '2021-09-30' 


insert into  DEV.BRONZE_AIRBNB.SRC_REVIEWS values
 (816748,'2021-10-28','Heather','It was awful!','Negative')



select * from  DEV.GOLD_AIRBNB.FACT_REVIEWS  where  review_date = '2021-09-20' 

insert into  DEV.BRONZE_AIRBNB.SRC_REVIEWS values
 (22677,'2021-10-28','Theodora','It was awful!','Negative')

 select * from   DEV.BRONZE_AIRBNB.SRC_REVIEWS where  (reviewer_name = 'Theodora' and listing_id = '22677') or  (reviewer_name = 'Heather' and listing_id = '816748')

 
select * from  DEV.GOLD_AIRBNB.FACT_REVIEWS where  (reviewer_name = 'Theodora' and listing_id = '22677') or  (reviewer_name = 'Heather' and listing_id = '816748')
