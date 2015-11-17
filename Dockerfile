# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:0.9.17
MAINTAINER Michael Holt <mike@holtit.com>

#Enable SSH
RUN rm -f /etc/service/sshd/down

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

#make all init.d scripts executable
RUN chmod +x /etc/my_init.d/*.sh

#Ensure OS is up-to-date
RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Use the runit init system.
CMD ["/sbin/my_init"]
