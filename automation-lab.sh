#!/bin/bash
#
# automation-lab.sh - Script to create an Automation Lab
#
# Authors:
#   - Eric Guimarães  <eric.gssilva@gmail.com>
#   - Gabriel Lopes   <gabrielrrlopes@gmail.com>
#
# Date: 2017-07-20
# Version: 0.1
#
# Description:
#
#   An Automation Lab to help deciding between:
#   - Ansible Tower (future)
#   - OpenSource Tools
#
#   For more information, please refer to the included 'README.md' file.
#   Any doubts, feel free to mail us.
#

#############
# Variables #
#############
sysDockerComposePath="docker/docker-compose.yml"

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
  chmod 700 docker/rundeck/volumes/rundeck-ssh
  chmod 600 docker/rundeck/volumes/rundeck-ssh/id_rsa
  chmod 644 docker/rundeck/volumes/rundeck-ssh/id_rsa.pub
  chmod 700 docker/ansible/files/home-ssh
  chmod 600 docker/ansible/files/home-ssh/id_rsa
  chmod 644 docker/ansible/files/home-ssh/id_rsa.pub
  chmod 640 docker/ansible/files/home-ssh/authorized_keys

  printLog info "Building the Automation Lab..."
  docker-compose --file ${sysDockerComposePath} build 2>/dev/null

  printLog info "Starting the Automation Lab..."
  docker-compose --file ${sysDockerComposePath} up -d 2>/dev/null
  labStartRC=$?
  if [ ${labStartRC} -eq 0 ]; then
    printLog info "Automation Lab started"
  else
    printLog error "Failed to start the Automation Lab"
  fi

  sleep 3
  docker-compose --file ${sysDockerComposePath} logs --tail 80 2> /dev/null

  # Configuring Rundeck
  ## Waiting Rundeck to start
  waitForRundeck
  ## Importing Rundeck Jobs
  rundeckJobLoad "ansible-lab" "hello-world.yml" "yaml" "update"
  #rundeckJobLoad "ansible-lab" "ansible-command.yml" "yaml" "update"
  #rundeckJobLoad "ansible-lab" "ansible-module.yml" "yaml" "update"
  rundeckJobLoad "ansible-lab" "ansible-playbook.yml" "yaml" "update"

  # OK - We are all set
  printLog info "The lab is ready to use - Go to http://${usrExternalIP} and have fun :)"
}

function labStop() {
  printLog info "Stopping the Automation Lab..."
  docker-compose --file ${sysDockerComposePath} down 2> /dev/null
  labStopRC=$?

  if [ ${labStopRC} -eq 0 ]; then
    printLog info "Automation Lab stopped"
  else
    printLog error "Failed to stop the Automation Lab"
  fi
}

function labRestart() {
  labStop
  sleep 2
  labStart
}

function printHeader() {
  echo
  echo '//============================================================================\\'
  echo '|| AUTOMATION LAB - Tonight: Ansible Tower X OpenSource | Make your bets!     ||'
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

function printHelp() {
  echo "Help:"
  echo "  This script is used to control the Automation Lab implemented on this"
  echo "  repository."
  echo
  echo "  This Lab is based on Docker so, in order to be able of running it,"
  echo "  you must have:"
  echo "    - A functional Docker Engine environment"
  echo "    - The 'docker-compose' package/binary installed"
  echo
  echo "  To start the environment, use:"
  echo "    `basename $0` start EXTERNAL_IP"
  echo
  echo "  The EXTERNAL_IP must be the address or IP used to access the"
  echo "  environment (for example, your local IP or the external IP of your"
  echo "  cloud provider."
  echo
  echo "  To stop the environment, use:"
  echo "    `basename $0` stop"
  echo
  echo "  This will stop and remove all containers created for the lab."
  echo
  echo "  To get the full possible syntaxes, just run the script without any"
  echo "  arguments. For more help, please refer to the main 'README.md' file"
  echo "  included in this folder."
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

  printLog info "Importing Job '${jobFile}'..."
  docker-compose --file ${sysDockerComposePath} exec rundeck sh -c "rd jobs load --duplicate ${jobDuplicate} --file /etc/rundeck-jobs/${jobFile} --format ${jobFormat} --project ${jobProject}" 2>/dev/null
}

function waitForRundeck() {
  printLog info "Checking wheter Rundeck is fully up..."
  docker-compose --file ${sysDockerComposePath} exec rundeck sh -c 'curl ${RD_URL}' >/dev/null 2>&1
  curlRC=$?
  
  until [ $curlRC -eq 0 ]
  do
    printLog info "Waiting Rundeck to be fully up..."
    sleep 4
    docker-compose --file ${sysDockerComposePath} exec rundeck sh -c 'curl ${RD_URL}' >/dev/null 2>&1
    curlRC=$?
  done
}

################
# Beginning :) #
################

# Script Header
printHeader

# Checking user args - Must have at least one
if [ $1 ]; then
  usrAction=$1
else
  printSyntax
fi

# Script actions/modes
case ${usrAction} in
  "start")          labStart $@   ;;
  "stop")           labStop       ;;
  "restart")        labRestart    ;;
  "--help"|"-h")    printHelp   ;;
  "--version"|"-v") printVersion  ;;
  *)
    printSyntax
    ;;
esac

##############
# The End :( #
##############
