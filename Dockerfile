FROM vincenzodb/ubuntu-apache2.4-pagespeed
MAINTAINER vinz@vincenzodb.com
ENV REFRESHED_AT 2016-12-1

# Set timezone env variable (used also by PHP).
ENV TIMEZONE UTC

# Run apache
#RUN service apache2 start

# Change Apache document root.
RUN echo 'DocumentRoot /var/www/html/web' >> "/etc/apache2/apache2.conf"

# Copy application.
COPY . /var/www/html

CMD exec supervisord -n
