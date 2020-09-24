## Cusotmizations from the original repo
### Environment-based Database Names
This repo demonstrates how DBT can be used in Snowflake with multiple target environments prefixed by the environment name.
All environments except for production will use {upper(target.name)}_{database_name} in place of the original database.
The original database is defined in `dbt_project.yml` in the root of the directory.

#### Profiles
A sample profiles.yml is provided as `profiles.template.yml`.
This contains placeholders for many of the required settings for connecting to Snowflake.
Modify this file's contents and place in `~/.dbt/profiles.yml`.

**Note:** As long as your database names are defined at the seed / model level, the default database is not important.
Additionally, it is impacted by `get_custom_database.sql` in the macros directory.

#### Running the project
Before running the project, you need to create three databases:
* {TARGET}_RAW_JAFFLE
* {TARGET}_STAGE_JAFFLE
* {TARGET}_PROCESSED_JAFFLE

`{TARGET}` should be the name of the default profile you configured in `profiles.yml`.
Ensure your user has full access to these databases.
It is advisable to NOT use the sysadmin role for this!

If you would like to test the production deployment, you will need three more databases.
* RAW_JAFFLE
* STAGE_JAFFLE
* PROCESSED_JAFFLE

### Macros
Two macros are provided in the repo.

* get_custom_schema.sql
* get_custom_database.sql

The custom schema macro overrides the default schema with the schema in your configuration.
This can be done either in `dbt_project.yml` or in a config block in the model file.
By partitioning your models into database/schema-specific directories, using `dbt_project.yml` allows configuring once for all models.

The custom database macro will override the default database.
If you are using any profile named other than `production` it will also append the profile name.

Example:
Profile is `DEVNAME`
Configured database is `YOUR_DB`
Output database is `DEVNAME_YOUR_DB`

### Dealing with multiple tables of the same name
The **core** mart was copied into **secondary**.
This simulates having multiple tables of the same name in different databases/schemas.
To overcome the constraint of unique model file names, model files are prefixed with their schema.
It may be wise to prefix with both database AND schema, if schema overlap is possible.

`core__dim_customers.sql`

As this makes listing files difficult, an alternative would be to use:

`{table}__{schema}__{database}.sql`

This will keep commands like `ls` easier, and based upon the below information on the model folder, should eliminate overlap while keeping sanity.

To ensure the correct table name, the file has a configuration at the top:

`{{ config(alias='dim_customers') }}`

You must make sure to update `schema.yml` in the same directory to reflect these new names.
Any reference to the table should use the _file name_ in the reference.

`{{ ref('core__dim_customers') }}`

This matches the forum discussion [here](https://discourse.getdbt.com/t/dbt-table-naming-conventions/647/2).

Additionally, the model folder has been reorganized into the following structure:
* models
  * db1
    * schema1
      * table1
    * schema2
      * table2
  * db2
    * schema3
      * table3

This directory structure simplifies database and schema configuration in the `dbt_project.yml` file.

### Playing with Packages
To explore the benefits between a monolith (all models in `models/`) versus using packages, the seeds are in a package.
This is stored in `packages/` in the root of the repo.
DBT packages are _full DBT projects_ referenced by other projects.

To install the package, you **must** run `dbt deps`.
This will symlink the package from the package directory into `dbt_modules`.

As we do not want to use multiple git repos to manage our work, this approach feels limited.
Every package needs a full configuration, greatly increasing the amount of work necessary for building a mart.

```
Begin Original Readme
```

## dbt models for `jaffle_shop`

`jaffle_shop` is a fictional ecommerce store. This dbt project transforms raw
data from an app database into a customers and orders model ready for analytics.

The raw data from the app consists of customers, orders, and payments, with the
following entity-relationship diagram:

![Jaffle Shop ERD](./etc/jaffle_shop_erd.png)

This [dbt](https://www.getdbt.com/) project has a split personality:

* **Tutorial**: The [master](https://github.com/fishtown-analytics/jaffle_shop/tree/master)
  branch is a useful minimum viable dbt project to get new dbt users up and
  running with their first dbt project. It includes [seed](https://docs.getdbt.com/docs/building-a-dbt-project/seeds)
  files with generated data so a user can run this project on their own warehouse.
* **Demo**: The [demo](https://github.com/fishtown-analytics/jaffle_shop/tree/demo/master)
  branch is used to illustrate how we (Fishtown Analytics) would structure a dbt
  project. The project assumes that your raw data is already in your warehouse,
  so therefore the repo cannot be run as a standalone project. The demo is more
  complex than the tutorial as it is structured in a way that can be extended for
  larger projects.

### Using this project as a tutorial

To get up and running with this project:

1. Install dbt using [these instructions](https://docs.getdbt.com/docs/installation).

2. Clone this repository. If you need extra help, see [these instructions](https://docs.getdbt.com/docs/use-an-existing-project).

3. Change into the `jaffle_shop` directory from the command line:

```bash
$ cd jaffle_shop
```

4. Set up a profile called `jaffle_shop` to connect to a data warehouse by
  following [these instructions](https://docs.getdbt.com/docs/configure-your-profile).
  If you have access to a data warehouse, you can use those credentials – we
  recommend setting your [target schema](https://docs.getdbt.com/docs/configure-your-profile#section-populating-your-profile)
  to be a new schema (dbt will create the schema for you, as long as you have
  the right priviliges). If you don't have access to an existing data warehouse,
  you can also setup a local postgres database and connect to it in your profile.

5. Ensure your profile is setup correctly from the command line:

```bash
$ dbt debug
```

6. Load the CSVs with the demo data set. This materializes the CSVs as tables in
  your target schema. Note that a typical dbt project **does not require this
  step** since dbt assumes your raw data is already in your warehouse.

```bash
$ dbt seed
```

7. Run the models:

```bash
$ dbt run
```

> **NOTE:** If this steps fails, it might be that you need to make small changes to the SQL in the models folder to adjust for the flavor of SQL of your target database. Definitely consider this if you are using a community-contributed adapter.

8. Test the output of the models:

```bash
$ dbt test
```

9. Generate documentation for the project:

```bash
$ dbt docs generate
```

10. View the documentation for the project:

```bash
$ dbt docs serve
```

### What is a jaffle?

A jaffle is a toasted sandwich with crimped, sealed edges. Invented in Bondi in 1949, the humble jaffle is an Australian classic. The sealed edges allow jaffle-eaters to enjoy liquid fillings inside the sandwich, which reach temperatures close to the core of the earth during cooking. Often consumed at home after a night out, the most classic filling is tinned spaghetti, while my personal favourite is leftover beef stew with melted cheese.

---
For more information on dbt:

* Read the [introduction to dbt](https://docs.getdbt.com/docs/introduction).
* Read the [dbt viewpoint](https://docs.getdbt.com/docs/about/viewpoint).
* Join the [chat](http://slack.getdbt.com/) on Slack for live questions and support.

---
