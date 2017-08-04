#######################
# Image: ansible-core #
#######################

# Base Image
FROM alpine:3.6

# Handling proxy information
ARG http_proxy
ARG https_proxy

# Installing Ansible and dependencies
RUN apk add --update ansible bash openssh openjdk8

# Copying configuration files
COPY files/etc-ssh /etc/ssh
COPY files/home-ssh /root/.ssh
COPY files/docker-entrypoint.sh /docker-entrypoint.sh

# Correcting permissions on SSH files
RUN chmod -R 0600 /etc/ssh

# Changing default SHELL from ASH to BASH
RUN sed -i s/'\/bin\/ash'/'\/bin\/bash'/g /etc/passwd

# Exposing SSH port
EXPOSE 22

# Configuring Docker Entrypoint script
ENTRYPOINT ["/docker-entrypoint.sh"]
