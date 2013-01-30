#!/usr/bin/env bash

DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. ${DIR}/../etc/include.sh

update_package_list

#install required packages
case ${OS_TYPE} in
		"apt")
			export DEBIAN_FRONTEND=noninteractive
			sudo apt-get install mysql-server nginx php5 php5-fpm php5-mysql -y -q
			sudo cp ${DIR}/conf/default /etc/nginx/sites-available/default
			sudo service nginx start
			;;
		"yum")
			rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
			rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
			rpm -Uvh http://dl.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm
			rpm -Uvh http://dl.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm
			rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
			yum --enablerepo=remi install -y mysql mysql-server php php-mysql php-fpm
			cp ${DIR}/conf/default.conf /etc/nginx/conf.d/default.conf
			service ngninx start
			service php-fpm start
			chkconfig --levels 235 mysqld on
			chkconfig --levels 235 mysql on
			chkconfig --levels 235 nginx on
			chkconfig --levels 235 php-fpm on
			;;
esac