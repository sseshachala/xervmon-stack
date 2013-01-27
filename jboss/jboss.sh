#!/usr/bin/env bash

DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. ${DIR}/../etc/include.sh

read_config ${DIR}/jboss.conf
#install_packages fortune

#http://sourceforge.net/projects/jboss/files/JBoss/JBoss-6.0.0.Final/jboss-as-distribution-6.0.0.Final.zip/download

update_package_list

#install java
case ${OS_TYPE} in
		"apt")
			sudo apt-get install openjdk-6-jdk -y
			;;
		"yum")
			yum install java-1.6.0-openjdk -y
			;;
esac

#download jboss
jboss_version=${major_version}.${minor_version}
jboss_file=jboss-as-distribution-${jboss_version}.zip
wget -O ~/${jboss_file} http://sourceforge.net/projects/jboss/files/JBoss/JBoss-${jboss_version}/{jboss_file}/download

#unpack it to the recommended location
${SUDO} unzip ~/${jboss_file} -d /usr/local/

#create jboss user
${SUDO} useradd -m -d /usr/local/jboss -s /bin/sh jboss

${SUDO} chown -R jboss:jboss /usr/local/jboss-${jboss_version}/

#create a simlink to it from where JBoss will expect it to be – /usr/local/jboss

${SUDO} rm -rf /usr/local/jboss
${SUDO} ln -s /usr/local/jboss-${jboss_version} /usr/local/jboss

