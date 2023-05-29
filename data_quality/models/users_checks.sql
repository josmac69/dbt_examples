-- users_checks model

SELECT * FROM {{ source('data_quality', 'users')}}
