FROM nginx:latest

# Copy the custom Nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /entrypoint.sh

# Create the log directory and set the correct permissions
RUN mkdir -p /var/tmp/nginx && \
    touch /var/tmp/nginx/error.log /var/tmp/nginx/metabase_access.log && \
    chown -R www-data:www-data /var/tmp/nginx && \
    chmod -R 755 /var/tmp/nginx

# Use the entrypoint script to start Nginx
ENTRYPOINT ["/entrypoint.sh"]
