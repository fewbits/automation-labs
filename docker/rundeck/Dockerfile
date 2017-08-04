##########################
# Image: rundeck-ansible #
##########################

# Base Image
FROM jordan/rundeck:2.8.4

# Handling proxy information
ARG http_proxy
ARG https_proxy

# Copying Rundeck configurations and plugins
COPY files/rundeck-libext/LogstashPlugin.groovy /var/lib/rundeck/libext

# Changing Rundeck user Shell
RUN usermod -s /bin/bash rundeck
