-- this macro is important as it allows us to build tables in custom schemas
-- PLEASE BE MINDFUL THAT THIS CODE IS USED TO PRODUCE TABLES IN THE FRONTEND SCHEMA
-- DO NOT TOUCH UNLESS YOU HAVE SPOKEN TO RELEVANT TEAMS PRIOR

{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}
        {{ default_schema }}
    {%- else -%}
        {{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}