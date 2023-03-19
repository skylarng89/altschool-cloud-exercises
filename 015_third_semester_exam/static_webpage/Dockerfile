# Choose base image
FROM ubuntu:18.04  

# Maintainer info
LABEL maintainer="contact@devopscube.com" 

# Install Nginx
RUN  apt-get -y update && apt-get -y upgrade && apt-get -y install nginx

# Copy default Nginx configuration file
COPY default /etc/nginx/sites-available/default

# Copy index.html file
COPY index.html /usr/share/nginx/html/index.html

# Expose Nginx on port 80
EXPOSE 80

# Run Nginx
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]