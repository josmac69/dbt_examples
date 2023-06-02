# Building an effective model for Product Lifecycle data with dbt

https://medium.com/@george.apps_98339/building-an-effective-model-for-product-lifecycle-data-with-dbt-7b959c4c8836

The article "Building an effective model for Product Lifecycle data with dbt" discusses the importance of consistent data modeling across a company's product range and how dbt (data build tool) can be used to achieve this. Here are the key points:

1. **Product Lifecycle Stages**: The author identifies four key stages in a product's lifecycle: Eligibility, Awareness, Onboarding, and Enablement. The Enablement stage is further divided into three subsections: Active, Inactive, and Dormant. These stages are used to answer questions about who could, wants to, can, and is using the product.

2. **Data Modeling**: The author suggests creating a consistent schema for every stage and using macros that act consistently but independently of the stage. The first step is to build out all "events" for each stage of each product. This involves tracking when a user becomes enabled and disabled, and when they perform an activity (like a transaction).

3. **dbt Macro**: The author provides a detailed walkthrough of a dbt macro that creates an output table summarizing a product's stages on a user and time level. The macro can generate an output table on different time granularities (daily, weekly, monthly) and can handle different definitions of an "active" user.

4. **Active, Inactive, Dormant Definitions**: The author discusses how to define an active user, which can vary per product. Users using the product within the last x days are considered active, while when most recent usage is between x days and y days they are deemed inactive, and anything more than y days they are dormant.

5. **Aggregated Fields**: For every stage, the author suggests aggregating to a user and time granularity level. In most stages, this will just give a count of users (showing 1 when they are in that stage), but for the “active” stage, it also includes a sum of their count and amount.

6. **Final Select Statement**: The final element is to join all the CTEs (Common Table Expressions) generated in the macro together to the original all users by time base table.

7. **Presentation**: To make this effective in a BI tool like Looker, you will need to join all these product tables together. This will enable the analysis of different products side by side and act as a very robust data store for a variety of purposes.

## Example macros from the article
* Time granularity
```
{# if we are dealing with weeks we want to use isoweek format #}
{% set iso_string = '' %}
{% if time_granularity == 'week' %}
   {% set iso_string = 'iso' %}
{% endif %}
{% set date_part_string = iso_string ~ time_granularity %}
{# choose a relevant start date dependent on the time_granularity #}
{% if time_granularity == 'day' %}
   {% set spine_start = 'date_sub(current_date(), interval 90 day)' %}
{% elif time_granularity == 'week' %}
   {% set spine_start = 'date_sub(current_date(), interval 70 week)' %}
{% elif time_granularity == 'month' %}
   {% set spine_start = 'date_sub(current_date(), interval 18 month)' %}
{% endif %}

{%- set start_date_string = "date_trunc(" ~ spine_start ~", " ~ date_part_string ~ ")" -%}
{%- set end_date_string = "date_sub(date_add(current_date(),interval 1 " ~ time_granularity ~ "), interval 1 day)" -%}
WITH date_spine AS (
    {{ dbt_utils.date_spine(
       datepart = time_granularity,
       start_date = start_date_string,
       end_date = end_date_string
       )
   }}
```

* All users by time
```
{# Get a list of unique ids across tables which will be used as a base for later joins to #}
, all_unique_ids AS (
   SELECT DISTINCT
       {{ granularity }}_id
   FROM {{ product_lifecycle_table }}
)
{# create a cross join of unique ids with time #}
, all_{{ granularity }}s_by_{{ time_granularity }} AS (
   SELECT
       all_unique_ids.{{ granularity }}_id
       , date_spine.date_{{time_granularity}}
   FROM all_unique_ids
       CROSS JOIN date_spine
)
```
* Generate aggregated fields
```
{%- set cte_list = [] -%}
{# Create CTE for each category in the product #}
{% for category in all_categories %}
   {%- set cte_name = '_' ~ product_lifecycle_table.identifier ~ '_' ~ category -%}
   {%- set _ = cte_list.append(cte_name) -%}
   , {{ cte_name }} AS (
       SELECT
           {# On the date granularity given get an aggregated count of all users in that category #}
           all_{{ granularity }}s_by_{{ time_granularity }}.{{ granularity }}_id
           , all_{{ granularity }}s_by_{{ time_granularity }}.date_{{time_granularity}}
           , COUNT(DISTINCT lc.{{ granularity }}_id) AS {{ product_name }}_is_{{ category }}_count

           {# If dealing with the active category also aggregate the count and amount measures #}
           {% if category == 'active' %}
           , SUM(lc.count) AS {{ product_name }}_total_active_count
           , SUM(lc.amount) AS {{ product_name }}_total_active_amount
           {% endif %}
       FROM all_{{ granularity }}s_by_{{ time_granularity }}
           LEFT JOIN {{ product_lifecycle_table }} lc
               {# For active we want to look at active in the period, so adjust the join #}
               {% if category == 'active' %}
               ON DATE_TRUNC(DATE(all_{{ granularity }}s_by_{{ time_granularity }}.date_{{ time_granularity }}), {{ time_granularity }}) = DATE_TRUNC(DATE(lc.timestamp), {{ time_granularity }})
               {% else %}
               {# Otherwise look at everything up to and including that date #}
               ON TIMESTAMP(all_{{ granularity }}s_by_{{ time_granularity }}.date_{{ time_granularity }}) BETWEEN TIMESTAMP_TRUNC(lc.timestamp, DAY) AND COALESCE(lc.next_timestamp, '2999-12-31 23:59:59')
               {% endif %}
               AND all_{{ granularity }}s_by_{{ time_granularity }}.{{ granularity }}_id = lc.{{ granularity }}_id
       WHERE lc.event_category = '{{ category }}'
           {% if category == 'eligible' or category == 'enabled' %}
           AND lc.event = '{{ category }}'
           {% endif %}
       GROUP BY 1,2
  )
{% endfor %}
```
