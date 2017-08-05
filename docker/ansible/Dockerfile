##################
# Image: ansible #
##################

# Base Image
FROM alpine:3.6

# Handling proxy information
ARG http_proxy
ARG https_proxy

# Installing Ansible and dependencies
RUN apk add --update ansible openssh

# Copying configuration files
COPY files/etc-ssh /etc/ssh
COPY files/root-ssh /root/.ssh
COPY files/docker-entrypoint.sh /docker-entrypoint.sh

# Correcting permissions on SSH files
RUN chmod -R 0600 /etc/ssh
RUN chmod 0700 /root/.ssh
RUN chmod 0600 /root/.ssh/id_rsa
RUN chmod 0644 /root/.ssh/id_rsa.pub
RUN chmod 0640 /root/.ssh/authorized_keys

# Exposing SSH port
EXPOSE 22

# Configuring Docker Entrypoint script
ENTRYPOINT ["/docker-entrypoint.sh"]
