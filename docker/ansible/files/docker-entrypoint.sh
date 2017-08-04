#!/bin/sh

#while [ true ]; do
#  echo "Starting SSH Server..."
#  sleep 60
#done

echo "Starting SSH Server..."
/usr/sbin/sshd -D
