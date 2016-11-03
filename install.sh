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

if [[ -z "$2" ]]; then
	CONTAINER="seed-project-codeigniter"
else 
	CONTAINER=$2
fi

echo -e " Do you want to create a new database.php? (Just press enter to skip): \c "
read SKIP

if [ "$SKIP" ] ; then
	echo -e " Add your database credentials: (ex. server user pass database): \c "
	read SERVER USERNAME PASSWORD DATABASE
else
	echo "#"
	echo "#"
	echo "# Skipping overwrite database.php"
	echo "#"
	echo "#"
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
	echo "# Making a folder"
	
	if mkdir $FOLDER | grep -q COMMAND_FAILED ; then
		echo "# Failure cd $FOLDER"
		exit 1;
	fi
	
	cd $FOLDER
	echo "#"
	echo "#"
	echo "#"
	echo "# Downloading Seed project from GitHub"
	echo "git clone https://github.com/danielnaranjo/$CONTAINER.git"
	echo "#"

	if git clone https://github.com/danielnaranjo/$CONTAINER.git | grep -q COMMAND_FAILED ; then
		echo "# Failure downloading from GitHub, please check it out "
		exit;
	fi

	echo "#"
	echo "#"
	sleep 1
	
	if cd $CONTAINER | grep -q COMMAND_FAILED ; then
		echo "# Failure to get access to work folder"
		exit;
	fi
	
	echo "#"
	echo "#"
	echo "#"
	
	sleep 1
	cd $CONTAINER

	if [ "$SKIP" ] ; then # if skip is true, do a backup else continue!

		echo "#"
		echo "#"
		echo "# Security backup to some critical files "
	
		if cp application/config/config.php application/config/config.php.bkp | grep -q COMMAND_FAILED ; then
			echo "# Failure copying somes files"
			exit;
		fi
		
		if cp application/config/database.php application/config/database.php.bkp | grep -q COMMAND_FAILED ; then
			echo "# Failure copying somes files"
			exit;
		fi
		
		echo "# Rewrite database.php configuration"
		echo "#"
		echo "#"

		if rm application/config/database.php | grep -q COMMAND_FAILED ; then
			echo "# Failure rewriting database.php"
			exit;
		fi
		
		echo "#"
		echo "#"

		echo "" >> application/config/database.php
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

	else 
		echo "# Tasking is on fire! "
	fi # end skipping backup

	echo "# Create main controller and model "
	echo "#"
	echo "" >> application/controllers/Starter.php
	echo "<?php " >> application/controllers/Starter.php
	echo "	defined('BASEPATH') OR exit('No direct script access allowed');" >> application/controllers/Starter.php
	echo " " >> application/controllers/Starter.php
	echo "	class Starter extends CI_Controller { " >> application/controllers/Starter.php
	echo " " >> application/controllers/Starter.php
	echo "		public function __construct() { " >> application/controllers/Starter.php
	echo "			parent::__construct(); " >> application/controllers/Starter.php
	echo "		} " >> application/controllers/Starter.php
	echo "	} " >> application/controllers/Starter.php
	echo " " >> application/controllers/Starter.php
	echo " " >> application/controllers/Starter.php
	echo "	public function index() { "  >> application/controllers/Starter.php
	echo " " >> application/controllers/Starter.php
	echo "		\$tables = \$this->db->list_tables(); " >> application/controllers/Starter.php
	echo " " >> application/controllers/Starter.php
	echo " 		foreach (\$tables as \$table) { " >> application/controllers/Starter.php
	echo " 			\$fields = \$this->db->list_fields(\$table);" >> application/controllers/Starter.php
	echo " 			foreach (\$fields as \$field) { " >> application/controllers/Starter.php
	echo " 				echo \$table .'/'. \$field; " >> application/controllers/Starter.php
	echo " 			} " >> application/controllers/Starter.php
	echo " 		}" >> application/controllers/Starter.php
	echo " " >> application/controllers/Starter.php
	echo "		\$this->load->view('starter'); " >> application/controllers/Starter.php
	echo " 	} " >> application/controllers/Starter.php
	echo " " >> application/controllers/Starter.php
	echo "	// Generate on $(date) by Daniel Naranjo" >> application/controllers/Starter.php

	echo "#"

	echo "# For security reason, files are empty "
	echo "" >> application/models/Starter_model.php
	echo "<?php " >> application/models/Starter_model.php
	echo "	defined('BASEPATH') OR exit('No direct script access allowed');" >> application/models/Starter_model.php
	echo " "
	echo "	class Starter_model extends CI_Model { " >> application/models/Starter_model.php
	echo " "
	echo "		public function __construct() { " >> application/models/Starter_model.php
	echo "			\$this->load->database(); " >> application/models/Starter_model.php
	echo "		} " >> application/models/Starter_model.php
	echo "	} " >> application/models/Starter_model.php
	echo " "
	echo "	// magic controllers and models creator " >> application/models/Starter_model.php
	echo "	public function getFields() { "  >> application/models/Starter_model.php
	echo "		\$query = \$this->db->field_data(); " >> application/models/Starter_model.php
	echo " 		return \$query;" >> application/models/Starter_model.php
	echo " 	} " >> application/models/Starter_model.php
	echo " "
	echo " "
	echo "	// Generate on $(date) by Daniel Naranjo" >> application/models/Starter_model.php

	echo "#"
	sleep 1

	echo "# Creating views/starter"
	echo "#"
	echo "# Getting into the views folder"	
	cd application

	sleep 1
	
	if touch views/starter.php  | grep -q COMMAND_FAILED ; then
		echo "Failure on creating starter.php"
	fi

	echo "# Creating views/starter"
	echo ""  >> views/starter.php
	echo "<h1> Hello World $(date +'%s') </h1>" >> views/starter.php
	echo "<!-- Generate on $(date) by Daniel Naranjo -->" >> views/starter.php
	sleep 1

	cd ..
	echo "# Getting back"

	echo "# Downloading Base project from GitHub"
	if git clone https://github.com/danielnaranjo/seed-project-base.git | grep -q COMMAND_FAILED ; then
		echo "# Failure downloading from GitHub, please check it out "
		exit;
	fi

	#echo "# renaming seed-project-base to assets"
	#if mv seed-project-base base | grep -q COMMAND_FAILED ; then
	#	echo "# Failure renaming seed-project-base to assets "
	#	exit;
	#fi

	if mv seed-project-base/assets assets | grep -q COMMAND_FAILED ; then
		echo "# Failure moving seed-project-base/assets to assets "
		exit;
	fi

	if mv seed-project-base/admin demo | grep -q COMMAND_FAILED ; then
		echo "# Failure moving seed-project-base/admin to demo "
		exit;
	fi

	if rm seed-project-base -rf | grep -q COMMAND_FAILED ; then
		echo "# Failure remove seed-project-base folder "
		exit;
	fi

	echo "#"
	echo "#"
	echo "# All task was done!"
	echo "#"
	echo "#"
	echo "# Completed on "$(date)
	echo "#"
	echo "# Go to your local server (ex. http://localhost/starter/fields)"
fi