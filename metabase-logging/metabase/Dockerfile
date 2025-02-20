FROM metabase/metabase-enterprise:v1.53.2

# Copy log4j2.xml into the image
COPY log4j2.xml /etc/metabase/log4j2.xml

# Set the JAVA_OPTS environment variable
ENV JAVA_OPTS="-Dlog4j.configurationFile=file:/etc/metabase/log4j2.xml"
