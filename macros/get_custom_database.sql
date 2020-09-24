{% macro generate_database_name(custom_database_name=none, node=none) -%}

    {#- Set the default database to the target database -#}
    {%- set default_database = target.database | trim -%}

    {#- Set the target name to the uppercase of target.name -#}
    {%- set target_name = target.name | upper -%}

    {#- Set deployment_prefix to blank for production deploys -#}
    {%- set deployment_prefix = '' -%}

    {#- If this is not a production deploy, prefix with target_name_ -#}
    {%- if target_name != 'PRODUCTION' -%}
        {%- set deployment_prefix = target_name ~ '_' -%}
    {%- endif -%}

    {#- Set the database name as prefix_name -#}
    {%- if custom_database_name is none -%}
        {{ deployment_prefix ~ default_database }}
    {%- else -%}
        {{ deployment_prefix ~ custom_database_name }}
    {%- endif -%}

{%- endmacro %}