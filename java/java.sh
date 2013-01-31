#!/usr/bin/env bash

DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. ${DIR}/../etc/include.sh

echo "Installing Java..."
#install java
case ${OS_TYPE} in
		"apt")
			sudo apt-get install openjdk-6-jdk -y
			;;
		"yum")
			yum install java-1.6.0-openjdk -y
			;;
esac
