# Base image used in production
FROM ubuntu:14.04

# Set environment variables.
ENV HOME /root
ENV TERM xterm
RUN useradd -ms /bin/bash app

# Install required software
RUN apt-get update -qqy && apt-get install -y \
    apache2 \
    build-essential \
    curl \
    git \
    libapache2-mod-php5 \
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

# Modify default site 
ADD build/000-default.conf /etc/apache2/sites-available/000-default.conf
ADD build/docker-web-var-www-html-index.html /var/www/html/index.html

# Install ruby, passenger phusion, mod-passenger, restart apache
RUN apt-add-repository -y ppa:brightbox/ruby-ng-experimental && \
    apt-get -y update && \
    # Passenger Phusion
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7 &&\
    apt-get install -y apt-transport-https ca-certificates && \
    # Add our APT repository
    sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main > /etc/apt/sources.list.d/passenger.list' && \
    apt-get update && \
    # Install and enable Passenger + Apache module
    apt-get -y install ruby2.2 ruby2.2-dev bundler libapache2-mod-passenger && \
    a2enmod passenger && \
    apache2ctl restart && \
    service apache2 start

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

# Install ruby gems
WORKDIR /home/app/reindeer
ADD Gemfile .
ADD Gemfile.lock .
RUN bundle install

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose ports
EXPOSE 80
EXPOSE 3000

CMD service apache2 start
