#!/usr/bin/env bash

DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. ${DIR}/../etc/include.sh

read_config ${DIR}/jboss.conf

update_package_list

echo "Installing unzip..."
install_packages unzip

#install java
echo "Installing Java..."
case ${OS_TYPE} in
		"apt")
			sudo apt-get install openjdk-6-jdk -y
			;;
		"yum")
			yum install java-1.6.0-openjdk -y
			;;
esac

echo "Downloading JBoss..."
#download jboss
jboss_version=${major_version}.${minor_version}
jboss_file=jboss-as-distribution-${jboss_version}.zip

wget -O ~/${jboss_file} http://download.jboss.org/jbossas/${major_version}/jboss-as-${jboss_version}/jboss-as-${jboss_version}.zip

#unpack it to the recommended location
${SUDO} unzip ~/${jboss_file} -d /usr/share/

echo "Adding JBoss user..."
#create jboss user
${SUDO} useradd -m -d /usr/share/jboss -s /bin/sh jboss

${SUDO} chown -R jboss:jboss /usr/share/jboss-as-${jboss_version}/

#create a simlink to it from where JBoss will expect it to be – /usr/share/jboss-as
${SUDO} rm -rf /usr/share/jboss-as
${SUDO} rm -rf /etc/init.d/jboss
${SUDO} ln -s /usr/share/jboss-as-${jboss_version} /usr/share/jboss-as

echo "Creating additional directories for JBoss"
#create additional directories
for dir in /var/run/jboss-as /var/log/jboss-as /etc/jboss-as; do
	if [[ ! -d ${dir} ]]; then
		${SUDO} mkdir -p ${dir}
		${SUDO} chown -R jboss:jboss ${dir}
	fi;
done

echo "Copying JBoss init script"
${SUDO} cp ${DIR}/init/jboss-as.conf /etc/jboss-as
case ${OS_TYPE} in
		"apt")
			${SUDO} cp ${DIR}/init/jboss_init.sh /etc/init.d/jboss
			;;
		"yum")
			ln -s /usr/share/jboss-as/bin/init.d/jboss-as-standalone.sh /etc/init.d/jboss
			;;
esac

sed -i 's+${jboss.bind.address:127.0.0.1}+0.0.0.0+g' /usr/share/jboss-as/standalone/configuration/standalone.xml

install_startup jboss

${SUDO} /etc/init.d/jboss start

