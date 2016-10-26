#!/bin/bash

# 	Docs: https://linuxconfig.org/bash-scripting-tutorial
#	Assing permission to this file: ex. chmod +x install.sh 
#	Run as ./install.sh
#	
#

# variables
TODAYIS = date +%s
FINISHED = date +%s
NEWFOLDERIS = $1||"app$TODAYIS"

# Get folder from parameter, else create as default App123456789
directory=NEWFOLDERIS

echo "#Creando carpeta de proyecto: $directory"
# bash check if directory exists
if [ -d $directory ]; then
	echo "#Error: El Directorio ya existe!"
	echo ls -la $directory
	exit 1;
else 
	echo mkdir $directory
	echo cd $directory
fi

echo "#Descargando CodeIgniter de GitHub"
echo git clone https://github.com/danielnaranjo/CodeIgniter.git

echo "#Realizando un backup de config.php y database.php"
echo cd CodeIgniter
echo cp application/config/config.php application/config/config.php.bkp
echo cp application/config/database.php application/config/database.php.bkp

echo "#Reescribiendo database.php"
echo -e "Servidor (ej. localhost) y credenciales:\c "
read SERVER USERNAME PASSWORD DATABASE

echo touch application/config/database.php
echo cat "<?php 
		// Generado automaticamente el $TODAYIS
		defined('BASEPATH') OR exit('No direct script access allowed');
		$active_group = 'default';
		$query_builder = TRUE;
		$db['default'] = array(
			'dsn'	=> '',
			'hostname' => '$SERVER',
			'username' => '$USERNAME',
			'password' => '$PASSWORD',
			'database' => '$DATABASE',
			'dbdriver' => 'mysqli',
			'dbprefix' => '',
			'pconnect' => FALSE,
			'db_debug' => (ENVIRONMENT !== 'production'),
			'cache_on' => FALSE,
			'cachedir' => '',
			'char_set' => 'utf8',
			'dbcollat' => 'utf8_general_ci',
			'swap_pre' => '',
			'encrypt' => FALSE,
			'compress' => FALSE,
			'stricton' => FALSE,
			'failover' => array(),
			'save_queries' => TRUE
		);" > application/config/database.php

echo "#Verificar archivo database.php"
echo ls -lh application/config/database.php

echo "#Fin de prueba"
echo "#Finalizado a las $FINISHED"