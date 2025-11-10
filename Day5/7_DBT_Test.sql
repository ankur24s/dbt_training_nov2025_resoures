-- https://docs.getdbt.com/docs/build/data-tests


select * from  dev.gold_airbnb.dim_listings


select distinct room_type from  dev.gold_airbnb.dim_listings
/*
['Shared room',
                      'Private room',
                      'Vila',
                      'Hotel room',
                      'Entire home/apt',
                      'Entire Home'
                      ]
*/

-- schema.yml
version: 1

models:
  - name: dim_listings
    columns:
      - name: listing_id
        tests:
          - not_null
          - unique:
              config:
                severity: warn
                error_if: ">=5"
                warn_if:  ">=2"
      
      - name: price
        tests:
          - positive_value
  
  - name: dim_hosts
    columns:
      - name: host_id
        tests:
          - not_null
          - unique

  - name: dim_listing_w_hosts
    columns:
      - name: host_id
        tests:
          - relationships: 
              to: ref('dim_hosts')
              field: host_id

      - name: minimum_nights
        tests:
          - positive_value
      
      - name: room_type
        tests:
          - accepted_values:
              values: ['Shared room',
                      'Private room',
                      'Vila',
                      'Hotel room',
                      'Entire home/apt',
                      'Entire Home',
                      'Private room 123'
                      ]
					  
					  
					  
-- dbt test -m dim_listings (running all test associated with that models)
-- dbt test relationships_dim_listings_host_id__host_id__ref_dim_hosts_ (running the single test)
						
-- Generic tests

positive_value.sql
{% test positive_value(model, column_name) %}
select * from {{model}} 
where {{column_name}} < 0 
{% endtest %}

--Singular Tests
-- create a test in test>dim_listings_minimum_nights.SQL
select * from 
{{ref('dim_listings')}}
where minimum_nights <1
limit 10

--fact_reviews_min_lenght_review_text
select length(review_text), * 
from {{ref('fact_reviews')}}
where  length(review_text) <4

-- dbt test --select dim_listings_minimum_nights


--Assignment instructions

-- consistent_created_at.sql

-- Create a singular test in tests/consistent_created_at.sql that 

checks that there is no review date that is submitted before its listing was created: Make sure that every review_date in fct_reviews is more recent than the associated created_at in dim_listings_cleansed.


--Please provide the source code of the test.


solution:
SELECT * FROM {{ ref('dim_listings') }} l
INNER JOIN {{ ref('fact_reviews') }} r
USING (listing_id)
WHERE l.created_at >= r.review_date