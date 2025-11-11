https://github.com/calogica/dbt-expectations
https://github.com/great-expectations/great_expectations
https://github.com/calogica/dbt-expectations/blob/main/README.md

1 - dbt_expectations.expect_table_row_count_to_equal_other_table

 - name: dim_hosts
    description: contains all hosts having airbnb propoerty in Berlin
    tests:
      - dbt_expectations.expect_table_row_count_to_equal_other_table:
          compare_model: source('airbnb','hosts')
		  
		  
2 - dbt_expectations.expect_column_quantile_values_to_be_between:

	- name: price
        description: price to book that listing
        tests:
          - positive_value
          - dbt_expectations.expect_column_quantile_values_to_be_between:
              quantile: .95
              min_value: 50
              max_value: 500
			  
3 - dbt_expectations.expect_column_max_to_be_between:

	- dbt_expectations.expect_column_max_to_be_between:
              max_value: 5000
			  
4 - dbt_expectations.expect_column_values_to_be_of_type:

	- dbt_expectations.expect_column_values_to_be_of_type:
              column_type: number
			  
5 - dbt_expectations.expect_column_distinct_count_to_equal:

    Add this into source.yml
	
	- name: listings
        identifier: src_listings
        columns:
            - name: room_type
              tests:
                - dbt_expectations.expect_column_distinct_count_to_equal:
                    value: 6
