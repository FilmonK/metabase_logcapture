# Capturing Metabase Logs for Analysis and Debugging

This project provides a local setup for capturing and analyzing logs from a self-hosted **Metabase** instance using **Docker**. It’s designed for Metabase developers, power users, and support engineers who want deeper visibility into Metabase behavior during development, testing, or issue reproduction.

By piping Metabase logs into a dedicated volume, this environment makes it easy to:

- Troubleshoot query behavior and performance
- Capture errors or unexpected behavior during testing
- Inspect application-level logs without relying on cloud or external infrastructure

> Use this repo as a reference setup for debugging Metabase in development.


## Table of Contents
- [Technologies Used](#technologies-used)
- [Architecture](#architecture)
- [Getting Started](#getting-started)
- [Configuration](#configuration)
- [Exploring the Logs](#exploring-the-logs)
- [Extending the Project](#extending-the-project)

## Technologies Used
- Metabase
- Nginx
- Postgres
- Grafana
- Loki
- Promtail
- VisualVM

## Architecture

This project creates a local environment with the following components working together:

- **Metabase** – A business intelligence tool used to run queries and visualize data.
- **PostgreSQL** – The source database that Metabase queries.
- **Promtail** – A lightweight log shipping agent that tails PostgreSQL logs.
- **Loki** – A log aggregation system that receives logs from Promtail.
- **Grafana** – A visualization dashboard that queries Loki to display log activity.

Each query executed in Metabase is logged by PostgreSQL, captured by Promtail, and routed through Loki into Grafana — where it can be filtered, explored, and visualized in real time.

This setup is ideal for validating query behavior, debugging performance issues, or showcasing query patterns as part of a product or internal demo.

### Query Flow

1. A user runs a query in Metabase.
2. Metabase sends the query to the connected PostgreSQL container.
3. PostgreSQL logs the query activity to a file.
4. Promtail tails the log file and forwards log entries to Loki.
5. Grafana reads logs from Loki and displays them using prebuilt or custom dashboards.

### Docker Services

All components run as Docker containers and are orchestrated via `docker-compose`. The key services include:

| Service     | Role                              | Port(s)           |
|-------------|------------------------------------|-------------------|
| `metabase`  | Frontend for running queries       | `localhost:3000`  |
| `postgres`  | SQL database with logging enabled  | `localhost:5432`  |
| `promtail`  | Log shipping from PostgreSQL logs  | _not exposed_     |
| `loki`      | Log aggregation backend            | `localhost:3100`  |
| `grafana`   | Visualization dashboards           | `localhost:3001`  |


## Configuration
Once you've copied the entire folder structure locally, you may have or want to make some adjustments.  
Loki folder:  
You may have to make permissions adjustments similar to the following depending on existing permissions
```bash
  - mkdir -p ./loki/data/index
  - mkdir -p ./loki/data/cache
  - mkdir -p ./loki/data/chunks
  - mkdir -p ./loki/data/wal

  - sudo chown -R $USER:$USER ./loki/data
  - sudo chmod -R 755 ./loki/data
```
**Metabase folder:**
- .env folder to specify the environment variables, including your database configuration
- MB_DB_HOST=postgres ← this value must match the service name of the database within the main docker-compose.yml
- Dockerfile has a command to copy the log4j2.xml file, as well as set JAVA environment variables
- log4j2.xml file which can be adjusted to desired level of logging

**Nginx folder:**
- There are baseline configurations for permissions handled by the Dockerfile and entrypoint.sh
- nginx.conf file is setup to listen on port 8090 for Metabase running on port 5050
- There's a "proxy_set_header X-Request-ID $request_id" to assign an unique id to each call

**Main docker-compose.yml:**
| Service     | Container Port | Host Port |
|-------------|----------------|-----------|
| PostgreSQL  | 5452           | 5452      |
| Metabase    | 5050           | 5050      |
| Loki        | 9080           | 9080      |
| Grafana     | 3000           | 3000      |



## Exploring the Logs
![Grafana Dashboard 1](https://github.com/FilmonK/metabase-capture/blob/main/readme_images/grafana1.png?raw=true)
![Grafana Dashboard 2](https://github.com/FilmonK/metabase-capture/blob/main/readme_images/grafana2.png?raw=true)
![VisualVM](https://github.com/FilmonK/metabase-capture/blob/main/readme_images/VisualVM.png?raw=true)


## Extending the Project
- SQL engine agnostic 

