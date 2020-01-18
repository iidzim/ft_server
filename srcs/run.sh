#!/bin/sh
mysql -u root -e" CREATE DATABASE wordpress;
CREATE USER username@localhost IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON *.* TO username@localhost;
FLUSH PRIVILEGES;"
mysql -uusername -ppassword wordpress < wordpress.sql
/bin/bash