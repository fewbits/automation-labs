##################
# Image: rundeck #
##################

# Base Image
FROM jordan/rundeck:2.8.4

# Handling proxy information
ARG http_proxy
ARG https_proxy

# Copying Rundeck's SSH keys and Plugins
ADD files/rundeck-ssh/id_rsa /var/lib/rundeck/.ssh/id_rsa
ADD files/rundeck-ssh/id_rsa.pub /var/lib/rundeck/.ssh/id_rsa.pub
ADD files/rundeck-libext/LogstashPlugin.groovy /var/lib/rundeck/libext

# Correcting permissions of SSH files
RUN chmod 700 /var/lib/rundeck/.ssh
RUN chmod 600 /var/lib/rundeck/.ssh/id_rsa
RUN chmod 644 /var/lib/rundeck/.ssh/id_rsa.pub

# Changing Rundeck user's shell
RUN usermod -s /bin/bash rundeck
