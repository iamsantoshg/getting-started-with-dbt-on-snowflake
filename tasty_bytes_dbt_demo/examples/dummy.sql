execute dbt project from workspace "USER$"."PUBLIC"."getting-started-with-dbt-on-snowflake" project_root='/tasty_bytes_dbt_demo' args='run --target dev --select \'models/marts/orders.sql\'';

EXECUTE DBT PROJECT tasty_bytes_dbt_project
  ARGS = '--select orders --target dev';

  select system$get_dbt_log('01c4a3ca-3205-ff3b-0001-f67201e2559e');