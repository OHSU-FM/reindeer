# Base image used in production
FROM phusion/passenger-ruby22:0.9.18

# Set correct environment variables.
ENV HOME /root
ENV TERM xterm


# Configure init system
## Enable ssh
RUN rm -f /etc/service/sshd/down
## Generate new ssh keys for container
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh
RUN mkdir /etc/service/apache2
## Set apache2 to start when image starts
ADD build/docker-app-etc-service-apache2-run /etc/service/apache2/run

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# Install required software
RUN apt-get update -qqy && apt-get install -y \
    apache2 \
    build-essential \
    curl \
    git \
    libapache2-mod-php5 \
    libapache2-mod-passenger \
    libpq-dev \
    nodejs \
    php5 \
    php5-cgi \
    php5-cli \
    php5-curl \
    php5-gd \
    php5-imap \
    php5-ldap \
    php5-pgsql \
    postgresql-client \ 
    python-software-properties \
    software-properties-common 

RUN php5enmod imap

# Modify apache config
ADD build/docker-app-etc-apache2-sites-enabled-000-default.conf /etc/apache2/sites-available/000-default.conf
ADD build/docker-app-var-www-html-index.html /var/www/html/index.html


# Make home, install lime_survey
RUN mkdir -p /home/app/reindeer && \
    mkdir /home/app/lime_survey && \
    curl -L -o /tmp/limesurvey.tar.gz \
    https://github.com/LimeSurvey/LimeSurvey/archive/2.06_plus_160123.tar.gz && \
    tar --strip-components=1 -C /home/app/lime_survey -xvzf /tmp/limesurvey.tar.gz && \
    rm /tmp/limesurvey.tar.gz && \
    chown -R www-data:www-data /home/app/lime_survey

# Link sites to apache
RUN ln -s /home/app/lime_survey /var/www/html/lime_survey && \
    ln -s /home/app/reindeer/public /var/www/html/reindeer

# Modify lime_survey database config
ADD build/docker-app-home-lime_survey-application-config-config.php /home/app/lime_survey/application/config/config.php

# App app user to www-data
RUN usermod -a -G www-data app

# Run lime_survey installer to create sql
WORKDIR /home/app/lime_survey/application/commands
#RUN su app -c "php console.php install admin adminpass a_admin admin@example.com"
# TODO: sql for lime_survey installation at: 
#   /home/app/lime_survey/installer/sql/create-pgsql.sql

# Install ruby gems
WORKDIR /home/app/reindeer
ADD Gemfile .
ADD Gemfile.lock .
RUN bundle install

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose ports
EXPOSE 80
EXPOSE 2222
EXPOSE 3000
