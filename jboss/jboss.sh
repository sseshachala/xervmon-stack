#!/usr/bin/env bash

DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. ${DIR}/../etc/include.sh

read_config ${DIR}/jboss.conf
#install_packages fortune

#update_package_list

install_packages unzip

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

#wget -O ~/${jboss_file} http://download.jboss.org/jbossas/${major_version}/jboss-as-${jboss_version}/jboss-as-${jboss_version}.zip

#unpack it to the recommended location
${SUDO} unzip ~/${jboss_file} -d /usr/share/

#create jboss user
${SUDO} useradd -m -d /usr/share/jboss -s /bin/sh jboss

${SUDO} chown -R jboss:jboss /usr/share/jboss-as-${jboss_version}/

#create a simlink to it from where JBoss will expect it to be – /usr/share/jboss-as
${SUDO} rm -rf /usr/share/jboss-as
${SUDO} ln -s /usr/share/jboss-as-${jboss_version} /usr/share/jboss-as

#create additional directories
for dir in /var/run/jboss-as /var/log/jboss-as /etc/jboss-as; do
	if [[ ! -d ${dir} ]]; then
		${SUDO} mkdir -p ${dir}
		${SUDO} chown -R jboss:jboss ${dir}
	fi;
done

${SUDO} ln -s /usr/share/jboss-as/bin/init.d/jboss-as.conf /etc/jboss-as
${SUDO} ln -s /usr/share/jboss-as/bin/init.d/jboss-as-standalone.sh /etc/init.d/jboss

