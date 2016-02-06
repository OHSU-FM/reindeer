# Use phusion/passenger-full as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/passenger-docker/blob/master/Changelog.md for
# a list of version numbers.
#FROM phusion/passenger-full:0.9.18
# Or, instead of the 'full' variant, use one of these:
#FROM phusion/passenger-ruby19:<VERSION>
#FROM phusion/passenger-ruby20:<VERSION>
#FROM phusion/passenger-ruby21:<VERSION>
FROM phusion/passenger-ruby22:0.9.18
#FROM phusion/passenger-jruby90:<VERSION>
#FROM phusion/passenger-nodejs:<VERSION>
#FROM phusion/passenger-customizable:<VERSION>

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# If you're using the 'customizable' variant, you need to explicitly opt-in
# for features. Uncomment the features you want:
#
#   Build system and git.
#RUN /pd_build/utilities.sh
#   Ruby support.
#RUN /pd_build/ruby1.9.sh
#RUN /pd_build/ruby2.0.sh
#RUN /pd_build/ruby2.1.sh
#RUN /pd_build/ruby2.2.sh
#RUN /pd_build/jruby9.0.sh
#   Python support.
#RUN /pd_build/python.sh
#   Node.js and Meteor support.
#RUN /pd_build/nodejs.sh

# Enable nginx
RUN rm -f /etc/service/nginx/down

# ...put your own build instructions here...
RUN mkdir /home/app/reindeer
RUN mkdir /home/app/lime_survey
RUN curl -L -o /tmp/limesurvey.tar.gz \
    https://github.com/LimeSurvey/LimeSurvey/archive/2.06_plus_160123.tar.gz
RUN tar --strip-components=1 -C /home/app/lime_survey -xvzf /tmp/limesurvey.tar.gz
RUN rm /tmp/limesurvey.tar.gz

RUN apt-get update -qqy && apt-get install -y build-essential nodejs \
    libpq-dev php5 php5-ldap php5-curl php5-pgsql curl php5-gd \
    php5-ldap php5-imap

EXPOSE 80

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
