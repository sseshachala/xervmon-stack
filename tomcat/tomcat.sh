#!/usr/bin/env bash

DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. ${DIR}/../etc/include.sh

read_config ${DIR}/tomcat.conf

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

#download tomcat
tomcat_version=${major_version}.${minor_version}
tomcat_file=tomcat-${tomcat_version}.zip

#http://www.us.apache.org/dist/tomcat/tomcat-7/v7.0.35/bin/apache-tomcat-7.0.35.zip
#http://mirror.nexcess.net/apache/tomcat/tomcat-${major_version}/v${major_version}.${minor_version}/bin/apache-tomcat-${major_version}.${minor_version}.zip
wget -O ~/${tomcat_file} http://www.us.apache.org/dist//tomcat/tomcat-${major_version}/v${major_version}.${minor_version}/bin/apache-tomcat-${major_version}.${minor_version}.zip

#unpack it to the recommended location
${SUDO} unzip ~/${tomcat_file} -d /usr/share/

#create tomcat user
${SUDO} useradd -m -d /usr/share/tomcat -s /bin/sh tomcat

${SUDO} chown -R tomcat:tomcat /usr/share/apache-tomcat-${tomcat_version}/

#create a simlink to it from where tomcat will expect it to be – /usr/share/tomcat-as
${SUDO} rm -rf /usr/share/tomcat
${SUDO} rm -rf /etc/init.d/tomcat
${SUDO} ln -s /usr/share/apache-tomcat-${tomcat_version}/ /usr/share/tomcat
${SUDO} chmod +x /usr/share/tomcat/bin/*.sh

#create additional directories
#for dir in /var/run/tomcat /var/log/tomcat-as /etc/tomcat-as; do
#	if [[ ! -d ${dir} ]]; then
#		${SUDO} mkdir -p ${dir}
#		${SUDO} chown -R tomcat:tomcat ${dir}
#	fi;
#done

#${SUDO} cp ${DIR}/init/tomcat-as.conf /etc/tomcat-as
#case ${OS_TYPE} in
#		"apt")
#			${SUDO} cp ${DIR}/init/tomcat_init.sh /etc/init.d/tomcat
#			;;
#		"yum")
#			ln -s /usr/share/tomcat-as/bin/init.d/tomcat-as-standalone.sh /etc/init.d/tomcat
#			;;
#esac

${SUDO} cp ${DIR}/init/tomcat_init.sh /etc/init.d/tomcat

install_startup tomcat

${SUDO} /etc/init.d/tomcat start

