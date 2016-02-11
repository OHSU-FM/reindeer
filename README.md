# Project Reindeer

[![Code Climate](https://codeclimate.com/github/OHSU-FM/reindeer/badges/gpa.svg)](https://codeclimate.com/github/OHSU-FM/reindeer)

## About

Project Reindeer is a portal website for LimeSurvey that allows you to control, share, monitor, filter, restrict and explore data that is collected with LimeSurvey.

**Dashboard**
![Image of Daskboard](https://github.com/OHSU-FM/reindeer/blob/master/doc/dashboard.png)

**Early Release**
This project is ready to share, but requires a little work to get everything started. See notes below for details.

## Features

**Data exploration**

 - *Spreadsheets*: View collected data in a row and column format
 - *Reports*: Statistics and charts related to collected data
 - *Chart builde*r: Create custom charts and graphs out of collected data

**Assignments**

An interface for managing and participating in multiple surveys, with features for discussing projects and communicating between participants.

**Pinnable dashboard**

Save interesting pieces of data, surveys, reports and charts to a central dashboard for easy viewing at a later time.

**Admin Interface**

A central interface for exploring the lower lever details of the application.

**LDAP**

LDAP authentication is supported


## Quick Start Guide

Database note: Current development uses PostgreSQL, but other database types will probably also work as long as it is also supported by LimeSurvey.

### Create a development environment

#### Option I: Ubuntu

1. **Install ruby 1.9.3 or higher**
```bash
sudo apt-get install ruby
```
2. **Install dependencies**
 ```bash
 sudp apt-get update
 sudo apt-get install git php5 build_essential php5-ldap php5-curl php5-pgsql apache2
 # Additionally add any other LimeSurvey specific dependencies you might have
 ```

3. **Clone this repository**
 ```bash
 git clone https://github.com/OHSU-FM/reindeer.git
 ```

4. **Download and install [LimeSurvey](https://www.limesurvey.org/en/#download)**

5. **Configure reindeer yml files**
There are several yml.example files in the config directory. These files need to be copied and have the .example extension removed. Look inside of each file and make the appropriate changes for your needs.

6. **Configure reindeer database.yml**
Project Reindeer is a companion application to LimeSurvey and because of this it requires a shared database with limeSurvey to function. Be sure to copy the database information that was entered into LimeSurvey and use it when you are modifying the ./config/database.yml file in reindeer.

7. **Setup database**
```bash
# From the base directory

# Initialize database
rake db:setup
```
8. **Create Admin User**
```bash
# From project root directory
rails c
user = User.new
user.password = 'somepassword'
user.password_confirmation = 'somepassword'
user.username = 'admin'
user.email = 'user@example.com'
user.save!
```
9. **Start rails**
```bash
rails s
```

