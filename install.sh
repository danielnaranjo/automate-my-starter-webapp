#!/usr/bin/env bash

# 	Docs: https://linuxconfig.org/bash-scripting-tutorial
#	Assing permission to this file: ex. chmod +x install.sh 
#	Run as ./install.sh


clear
# Get folder from parameter, else create as default App123456789
if [[ -z "$1" ]]; then
	FOLDER="app$(date +'%s')"
else 
	FOLDER=$1
fi
echo "# Project: $FOLDER"

if [[ -z "$2" ]]; then
	CONTAINER="yyd"
else 
	CONTAINER=$2
fi
echo "# Repo: $CONTAINER"

echo "#"
echo "#"
echo "# Making a work folder: $FOLDER"
echo "#"

if [ -d $FOLDER ]; then
	echo "#"
	echo "# Error: Directory already exists.. "
	echo "#"
	sleep 1
	ls -la $FOLDER
	exit 1;

else 

	echo "#"
	echo "#"
	echo "# Creando la carpeta"
	
	if mkdir $FOLDER | grep -q COMMAND_FAILED ; then
		echo "# Failure cd $FOLDER"
		exit 1;
	fi
	
	cd $FOLDER
	echo "#"
	echo "#"
	echo "#"
	echo "# Downloading Seed project from GitHub"
	echo "#"

	if git clone https://github.com/danielnaranjo/$CONTAINER.git | grep -q COMMAND_FAILED ; then
		echo "# Failure downloading from GitHub, please check it out "
		exit;
	fi

	echo "#"
	echo "#"
	echo "git clone https://github.com/danielnaranjo/CodeIgniter.git"
	echo "#"
	echo "#"
	echo "#"
	echo "# Security backup to some critical files "
	sleep 1
	
	if cd $CONTAINER | grep -q COMMAND_FAILED ; then
		echo "# Failure to get access to work folder"
		exit 1;
	fi
	
	echo "#"
	echo "#"
	echo "#"
	
	sleep 1
	cd $CONTAINER
	
	if cp application/config/config.php application/config/config.php.bkp | grep -q COMMAND_FAILED ; then
		echo "# Failure copying somes files"
		exit 1;
	fi
	
	if cp application/config/database.php application/config/database.php.bkp | grep -q COMMAND_FAILED ; then
		echo "# Failure copying somes files"
		exit 1;
	fi
	
	echo "# Rewrite database.php configuration"
	echo "#"
	echo "#"
	
	echo -e " Add your database credentials: (ex. server user pass database): \c "
	read SERVER USERNAME PASSWORD DATABASE

	if rm application/config/database.php | grep -q COMMAND_FAILED ; then
		echo "# Failure rewriting database.php"
		exit 1;
	fi
	
	echo "#"
	echo "#"

	echo "" >> application/config/database.php
	echo "# For security reason, database.php is a empty file. "
	echo "<?php " >> application/config/database.php
	echo "	defined('BASEPATH') OR exit('No direct script access allowed');" >> application/config/database.php
	echo "	\$active_group = 'default';" >> application/config/database.php
	echo "	\$query_builder = TRUE;" >> application/config/database.php
	echo "	\$db['default'] = array(" >> application/config/database.php
	echo "		'dsn'	=> ''," >> application/config/database.php
	echo "		'hostname' => '$SERVER'," >> application/config/database.php
	echo "		'username' => '$USERNAME'," >> application/config/database.php
	echo "		'password' => '$PASSWORD'," >> application/config/database.php
	echo "		'database' => '$DATABASE'," >> application/config/database.php
	echo "		'dbdriver' => 'mysqli'," >> application/config/database.php
	echo "		'dbprefix' => ''," >> application/config/database.php
	echo "		'pconnect' => FALSE," >> application/config/database.php
	echo "		'db_debug' => (ENVIRONMENT !== 'production')," >> application/config/database.php
	echo "		'cache_on' => FALSE," >> application/config/database.php
	echo "		'cachedir' => ''," >> application/config/database.php
	echo "		'char_set' => 'utf8'," >> application/config/database.php
	echo "		'dbcollat' => 'utf8_general_ci'," >> application/config/database.php
	echo "		'swap_pre' => ''," >> application/config/database.php
	echo "		'encrypt' => FALSE," >> application/config/database.php
	echo "		'compress' => FALSE," >> application/config/database.php
	echo "		'stricton' => FALSE," >> application/config/database.php
	echo "		'failover' => array()," >> application/config/database.php
	echo "		'save_queries' => TRUE" >> application/config/database.php
	echo "	);" >> application/config/database.php
	echo "	//Generate on $(date) by Daniel Naranjo" >> application/config/database.php

	sleep 1
	echo "#"
	echo "#"

	if ls -lh application/config/database.php | grep -q COMMAND_FAILED ; then
		echo "# Failure on verication files"
	fi

	echo "# Verication task is running.."
	echo "#"
	ls -lh application/config/config.php
	ls -lh application/config/database.php

	echo "#"
	echo "#"
	echo "# All task was done!"
	echo "#"
	echo "#"
	echo "# Completed on "$(date)
fi