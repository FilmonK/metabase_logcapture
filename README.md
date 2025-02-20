# Log capturing configuration for a Metabase, postgres, nginx setup
Rather than going back and forth between the the separate logs, I wanted to create an aggregator to view all of them in a single place.
As the logs are being generated, it's using Promtail to scrape each of them.
This is simply a baseline environment and no reason other reverse proxies and SQL engines couldn't be used in a similiar configuration.


## Table of Contents
* [Technologies Used](#technologies-used)
* [Screenshots](#screenshots)
* [Configuration](#configuration)
* [Room for Improvement](#room-for-improvement)


## Technologies Used
- Metabase
- Nginx
- Postgres
- Grafana
- Loki
- Promtail


## Screenshots
![Grafana Dashboard 1](https://github.com/FilmonK/metabase-capture/blob/main/readme_images/grafana1.png?raw=true)
![Grafana Dashboard 2](https://github.com/FilmonK/metabase-capture/blob/main/readme_images/grafana2.png?raw=true)

## Configuration
Once you've copied the entire folder structure locally, you may have or want to make some adjustments.
Loki folder:
You may have to make permissions adjustments similar to the following depending on existing permissions
  - mkdir -p ./loki/data/index
  - mkdir -p ./loki/data/cache
  - mkdir -p ./loki/data/chunks
  - mkdir -p ./loki/data/wal

  - sudo chown -R $USER:$USER ./loki/data
  - sudo chmod -R 755 ./loki/data

Metabase folder:
- .env folder to specify the environment variables, including your database configuration
- MB_DB_HOST=postgres ← this value must match the service name of the database within the main docker-compose.yml
- Dockerfile has a command to copy the log4j2.xml file, as well as set JAVA environment variables
- log4j2.xml file which can be adjusted to desired level of logging

Nginx folder:
- There are baseline configurations for permissions handled by the Dockerfile and entrypoint.sh
- nginx.conf file is setup to listen on port 8090 for Metabase running on port 5050
- There's a "proxy_set_header X-Request-ID $request_id" to assign an unique id to each call

Main docker-compose.yml:
- All the services should be running on the same network ("app-network")
- Postgres is running on 5452 in the container
- Metabase is running on 5050 in the container
- Loki is running on 9080
- Grafana is running on 3000


## Room for Improvement
- SQL engine agnostic 

