##################
# Image: rundeck #
##################

# Base Image
FROM jordan/rundeck:2.8.4

# Handling proxy information
ARG http_proxy
ARG https_proxy

# Copying Rundeck's SSH keys and Plugins
COPY files/rundeck-ssh /etc/rundeck-keys
COPY files/rundeck-libext/LogstashPlugin.groovy /var/lib/rundeck/libext

# Correcting permissions of SSH files
RUN chown -R rundeck:rundeck /etc/rundeck-keys
RUN chmod 0700 /etc/rundeck-keys
RUN chmod 0600 /etc/rundeck-keys/id_rsa
RUN chmod 0644 /etc/rundeck-keys/id_rsa.pub

# Changing Rundeck user's shell
RUN usermod -s /bin/bash rundeck
