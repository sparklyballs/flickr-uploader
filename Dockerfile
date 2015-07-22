# set base os
FROM phusion/baseimage:0.9.16

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# set volume
VOLUME /photos
VOLUME /folders2flickr

# Set the locale
RUN locale-gen en_US.UTF-8 && \

# Fix a Debianism of the nobody's uid being 65534
usermod -u 99 nobody && \
usermod -g 100 nobody && \

# Install python

apt-get update && \
sudo apt-get -y --force-yes install python-pip python-dev build-essential && \
sudo pip install --upgrade pip && \
sudo pip install --upgrade virtualenv && \
sudo apt-get -y --force-yes install git && \

# Install folders2flickr

pip install --user git+https://github.com/richq/folders2flickr.git && \
cp ~/.local/share/folders2flickr/uploadr.ini.sample ~/.uploadr.ini && \

#set start file
mv /root/.local/bin/folders2flickr /etc/my_init.d/folders2flickr && \
chmod +x /etc/my_init.d/folders2flickr && \

# Move conf to external volume

mv /root/.uploadr.ini /folders2flickr/ && \
ln -s /folders2flickr/.uploadr.ini /root && \

# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))
