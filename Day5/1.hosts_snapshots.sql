{% snapshot hosts_snapshot %}
{{
 config(
 schema='snapshots',
 unique_key='id',
 strategy='timestamp',
 updated_at='updated_at',
 invalidate_hard_deletes=True
 )
}}
select * FROM {{source('src_airbnb','hosts')}}
{% endsnapshot %}