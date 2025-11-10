 - name: dim_listings
    description:  Table which contains Airbnb listings.
	columns:
      - name: listing_id
        description: Primary key for the listing
		
- name: dim_hosts
    columns:
      - name: host_id
        description: The hosts's id. References the host table.
		
- name: dim_listing_w_hosts
	columns:
		- name: minimum_nights
        description: '{{ doc("dim_listing_minimum_nights") }}'
		
		- name: room_type
        description: Type of the apartment / room
		
-----------------------------------------------------
create docs.md

{% docs dim_listing_minimum_nights %}
Minimum number of nights required to rent this property. 

Keep in mind that old listings might have `minimum_nights` set to 0 in the source tables. Our cleansing algorithm updates this to `1`.

{% enddocs %}

----------------------------------------
create overview.md

{% docs __overview__ %}
# Airbnb pipeline

Hey, welcome to our Airbnb pipeline documentation!

Here is the schema of our input data:
![input schema](https://dbtlearn.s3.us-east-2.amazonaws.com/input_schema.png)


{% enddocs %}

after putting to assets:
(assets/input_schema.png)

---------------------------------------------------
Assignemnt:


up to date and documnet missing column

----------------------------------------------

	
