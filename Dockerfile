FROM debian:buster

ENV DEBIAN_FRONTEND=noninteractive
RUN echo "mysql-apt-config mysql-apt-config/select-server select mysql-5.7" | debconf-set-selections

EXPOSE 80 443
RUN apt-get update
RUN apt-get install -y wget vim 
#COPY srcs/config.sh /config.sh



#nginx
RUN apt-get install -y nginx
COPY srcs/default /etc/nginx/sites-available/
COPY srcs/localhost.crt /etc/ssl/certs
COPY srcs/localhost.key /etc/ssl/private

#wordpress 
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xvf latest.tar.gz
RUN rm -rf latest.tar.gz
RUN cp -rf wordpress /var/www/html/
COPY srcs/wp-config.php /var/www/html/wordpress
RUN chown -R www-data:www-data /var/www/html/wordpress
COPY srcs/wordpress.sql /


#phpMyAdmin 
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-english.tar.gz
RUN apt-get install -y php7.3 php7.3-common php7.3-mbstring php7.3-fpm php7.3-mysql 
RUN tar -xvf phpMyAdmin-4.9.0.1-english.tar.gz
RUN rm -rf phpMyAdmin-4.9.0.1-english.tar.gz                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
RUN mv phpMyAdmin-4.9.0.1-english phpmyadmin
RUN cp -rf phpmyadmin /var/www/html/
COPY srcs/run.sh /


#MySQl
RUN wget https://dev.mysql.com/get/mysql-apt-config_0.8.14-1_all.deb
RUN apt-get update
RUN apt-get install -y lsb-release gnupg 
RUN dpkg -i mysql-apt-config_0.8.14-1_all.deb
RUN apt-get update
RUN apt-get install -y mysql-server
#RUN echo "daemon off;" >> /etc/nginx/nginx.conf


ENTRYPOINT service php7.3-fpm start \
    && chown -R mysql:mysql /var/lib/mysql \
	&& service mysql start \
    && service nginx restart \
    && sh run.sh 