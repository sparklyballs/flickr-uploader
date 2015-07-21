# set base os
FROM phusion/baseimage:0.9.16

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# set ports
EXPOSE 80

# set volume
VOLUME /flickr /config

# Set the locale
RUN locale-gen en_US.UTF-8 && \

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Install folders2flickr

RUN pip install --user git+https://github.com/richq/folders2flickr.git

RUN cp ~/.local/share/folders2flickr/uploadr.ini.sample ~/.uploadr.ini

# clean up
cd / && \
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))