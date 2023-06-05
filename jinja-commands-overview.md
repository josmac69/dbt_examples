# Jinja commands

As an AI language model, I cannot provide a "full list" of all dbt Jinja commands, as the list may be updated and extended over time. However, I can give you an overview of some common dbt Jinja commands and short examples of their usage.

1. `ref()`
This command is used to refer to another model in your project.

Example:
```sql
SELECT * FROM {{ ref('model_name') }}
```

2. `config()`
This command is used to set configurations for a specific model.

Example:
```sql
{{ config(materialized='incremental') }}
```

3. `var()`
This command is used to access variables defined in your `dbt_project.yml` file.

Example:
```sql
SELECT * FROM {{ ref('model_name') }} WHERE date > '{{ var('start_date') }}'
```

4. `env_var()`
This command is used to access environment variables.

Example:
```sql
SELECT * FROM {{ ref('model_name') }} WHERE api_key = '{{ env_var('API_KEY') }}'
```

5. `source()`
This command is used to reference a source table defined in your `sources.yml` file.

Example:
```sql
SELECT * FROM {{ source('source_name', 'table_name') }}
```

6. `adapter.dispatch()`
This command is used to call a macro and provide database-specific implementations.

Example:
```sql
{% macro my_macro() %}
  {{ adapter.dispatch('my_macro')() }}
{% endmacro %}
```

7. `log()`
This command is used to log messages during runtime.

Example:
```sql
{% do log("This is a log message.", info) %}
```

8. `if`, `elif`, and `else`
These commands are used for conditional statements.

Example:
```sql
{% if target.name == 'prod' %}
  SELECT * FROM {{ ref('model_name') }} WHERE is_published = true
{% else %}
  SELECT * FROM {{ ref('model_name') }}
{% endif %}
```

9. `for` and `endfor`
These commands are used for looping.

Example:
```sql
{% set columns = ['column1', 'column2', 'column3'] %}
{% for column in columns %}
  SELECT {{ column }} FROM {{ ref('model_name') }}
{% endfor %}
```

10. `macro` and `endmacro`
These commands are used to define reusable code snippets.

Example:
```sql
{% macro calculate_percentage(numerator, denominator) %}
  CASE
    WHEN {{ denominator }} = 0 THEN NULL
    ELSE {{ numerator }}::float / {{ denominator }}::float
  END
{% endmacro %}
```

* official dbt Jinja documentation [here](https://docs.getdbt.com/reference/dbt-jinja-functions).

