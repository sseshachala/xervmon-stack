#!/usr/bin/env bash

#check package manager used on the system
if [[ `which apt-get` ]]; then
	export OS_TYPE="apt"
	export SUDO="sudo"
elif [[ `which yum` ]]; then
	export OS_TYPE="yum"
else
	echo "Unsuported OS. Exiting now..."
	exit 1
fi;

#get detailed OS info
DISTRIBIUTOR=`lsb_release -i -r | grep "Distributor" | awk '{print $3}'`
RELEASE=`lsb_release -i -r | grep "Release" | awk '{print $2}'`
MAJOR_RELEASE=`echo ${RELEASE} | cut -d"." -f 1`
MINOR_RELEASE=`echo ${RELEASE} | cut -d"." -f 1`

#function for installing packages independent of OS
function install_packages {
	case ${OS_TYPE} in
		"apt")
			sudo apt-get install $* -y
			;;
		"yum")
			yum install $* -y
			;;
	esac
}

#function for refreshing package list
function update_package_list {
	case ${OS_TYPE} in
		"apt")
			sudo apt-get update
			;;
		"yum")
			yum check-update
			;;
	esac
}

#function for reading local config files
function read_config {
	conf_file=${1}
	export major_version=`grep major_version ${conf_file} | awk '{print $2}'`
	export minor_version=`grep minor_version ${conf_file} | awk '{print $2}'`
}

#function for installing startup scripts
function install_startup {
	case ${OS_TYPE} in
		"apt")
			sudo update-rc.d $* defaults
			;;
		"yum")
			chkconfig --level 345 $* on
			;;
	esac
}



