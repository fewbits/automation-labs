#!/bin/bash
#
# automation-labs.sh - Script to create Automation Labs
#
# Author:   Eric Guimarães <eric.gssilva@gmail.com>
# Date:     2017-07-20
# Version:  0.1
#
# Description:
#
#   Automation Labs to help deciding between the following tools:
#   - Ansible Tower (future)
#   - Jenkins
#   - Rundeck
#   - Semaphore (future)
#
#   For more information, please refer to the README.md file.
#   Any doubts, feel free to mail me.
#

#############
# Functions #
#############

function labStart() {
  shift

  # Validating user arguments
  if [ $1 ]; then
    usrExternalIP=$1
    export usrExternalIP
  else
    printLog error "Wrong syntax. Try `basename $0` --help"
  fi

  printLog info "Correcting permissions of SSH files"
  chmod 700 docker/rundeck-ansible/volumes/rundeck-ssh
  chmod 600 docker/rundeck-ansible/volumes/rundeck-ssh/id_rsa
  chmod 644 docker/rundeck-ansible/volumes/rundeck-ssh/id_rsa.pub
  chmod 700 docker/ansible-core/files/home-ssh
  chmod 600 docker/ansible-core/files/home-ssh/id_rsa
  chmod 644 docker/ansible-core/files/home-ssh/id_rsa.pub
  chmod 640 docker/ansible-core/files/home-ssh/authorized_keys

  printLog info "Starting Automation Lab..."
  docker-compose --file ./docker/docker-compose.yml build
  docker-compose --file ./docker/docker-compose.yml up -d
  sleep 2
  docker-compose --file ./docker/docker-compose.yml logs

  # This will import the jobs...
  rundeckJobLoad "ansible-lab" "hello-world.yml" "yaml" "update"
  #rundeckJobLoad "ansible-lab" "ansible-command.yml" "yaml" "update"
  #rundeckJobLoad "ansible-lab" "ansible-module.yml" "yaml" "update"
  rundeckJobLoad "ansible-lab" "ansible-playbook.yml" "yaml" "update"
}

function labStop() {
  printLog info "Stopping all Automation Labs..."
  docker-compose --file ./docker/docker-compose.yml down
}

function labRestart() {
  labStop
  sleep 2
  labStart
}

function printHeader() {
  echo
  echo '//============================================================================\\'
  echo '|| AUTOMATION LABS - Starring: Ansible Tower | Jenkins | Rundeck | Semaphore  ||'
  echo '\\============================================================================//'
  echo
}

function printLog() {
  logType=$1    # Type of the log message
  logMessage=$2 # String of the log message

  echo -n "[`date '+%Y-%m-%d %H:%M:%S'`] "

  case $logType in
    "debug")
      echo "[debug] ${logMessage}"
      ;;
    "error")
      echo "[error] ${logMessage}"
      exit 1
      ;;
    "info")
      echo "[info] ${logMessage}"
      ;;
    *)
      echo "[error] System - printLog - Wrong value for variable 'logType'"
      exit 1
  esac
}

function printSyntax() {
  echo "Syntax:"
  echo "  `basename $0` start EXTERNAL_IP"
  echo "  `basename $0` stop"
  echo "  `basename $0` restart"
  echo "  `basename $0` [-h|--help]"
  echo "  `basename $0` [-v|--version]"
  echo
  exit 0
}

function printSyntaxWrong() {
    printLog error "Wrong syntax. Try `basename $0` --help"
    echo
    printSyntax
    exit
}

function printVersion() {
  grep "# Version:" "`basename $0`" | grep -v grep | sed s/'# '/''/g
}

function rundeckJobLoad() {
  jobProject=$1
  jobFile=$2
  jobFormat=$3
  jobDuplicate=$4

  if [ ! $4 ]; then
    printLog error "Internal error - rundeckJobCreate - Wrong argument number"
  fi

  rundeckWaitUp
  printLog info "Importing Job '${jobFile}'..."
  docker-compose --file docker/docker-compose.yml exec rundeck sh -c "rd jobs load --duplicate ${jobDuplicate} --file /etc/rundeck-jobs/${jobFile} --format ${jobFormat} --project ${jobProject}"
}

function rundeckWaitUp() {
  printLog info "Checking wheter Rundeck is fully up..."
  docker-compose --file docker/docker-compose.yml exec rundeck sh -c 'curl ${RD_URL}' >/dev/null 2>&1
  curlRC=$?
  
  until [ $curlRC -eq 0 ]
  do
    printLog info "Waiting Rundeck to be fully up..."
    sleep 4
    docker-compose --file docker/docker-compose.yml exec rundeck sh -c 'curl ${RD_URL}' >/dev/null 2>&1
    curlRC=$?
  done
}

################
# Beginning :) #
################

# Script Header
printHeader

# Validations
#validateService docker.service

if [ $1 ]; then
  usrAction=$1
else
  printSyntax
fi

case ${usrAction} in
  "start")          labStart $@   ;;
  "stop")           labStop       ;;
  "restart")        labRestart    ;;
  "--help"|"-h")    printSyntax   ;;
  "--version"|"-v") printVersion  ;;
  *)
    printSyntax
    ;;
esac

##############
# The End :( #
##############
