xervmon-stack
=============

Script Installers for Any Cloud and any OS Flavor

### Installation instructions ###
First step is to clone this repo on the machine on which it's going to be executed.
Each stack can be installed simply by executing the appropriate shell script, with some offering additional configuration files to set software versions.
Please note that the scripts should be executed from a user account which has either the sudo or root permissions.

#### JBoss ####
To install JBoss simply run the installation script in the jboss folder:

`./jboss/jboss.sh`

JBoss will be installed in the (default) /usr/share/jboss location, and it will be up on port 8080.

#### Tomcat ####
To install Tomcat, run:

`./tomcat/tomcat.sh`

Tomcat will be installed in the (default) /usr/share/tomcat location, and it will be up on port 8080.

#### LEMP ####
LEMP stack includes nginx, MySQL and PHP, all preconfigured. Root directory will be located at /usr/share/nginx/html for Debian/Ubuntu etc. or /usr/share/nginx/html for RHEL/Centos/OEL.
To install LEMP, run:

`./LEMP/LEMP.sh`
