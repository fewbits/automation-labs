#!/bin/bash
#
# automation-labs.sh - Script to create Automation Labs
#
# Description:
#
#   Automation Labs to help deciding between the tools:
#   - Ansible Tower
#   - Rundeck
#   - Semaphore
#
#   For more information, please refer to the README.md file.
#   Any doubts, feel free to mail me.
#
# Author:   Eric Guimaraes <eric.gssilva@gmail.com>
# Date:     2017-07-20
# Version:  0.1

#############
# Functions #
#############

function labStart() {
  shift
  
  if [ $1 ]; then
    labTool=$1
  else
    printLog error "Wrong syntax. Try `basename $0` --help"
  fi

  case ${labTool} in
    "ansible-tower")  labStartAnsibleTower  ;;
    "rundeck")        labStartRundeck       ;;
    "semaphore")      labStartSemaphore     ;;
    *)
      printLog error "Wrong syntax. Try `basename $0` --help"
      ;;
  esac

}

function labStartAnsibleTower() {
  printLog info "Starting Automation Lab (Ansible Tower)..."
}

function labStartRundeck() {
  printLog info "Starting Automation Lab (Rundeck)..."
}

function labStartSemaphore() {
  printLog info "Starting Automation Lab (Semaphore)..."
}

function printHeader() {
  echo
  echo '//============================================================================\\'
  echo '|| AUTOMATION LABS - Competitors are: Ansible Tower | Rundeck | Semaphore     ||'
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
  echo "  `basename $0` start [ansible-tower|rundeck|semaphore]"
  echo "  `basename $0` stop"
  echo "  `basename $0` [-h|--help]"
  echo "  `basename $0` [-v|--version]"
  echo
  exit 0
}

function printVersion() {
  grep "# Version:" "`basename $0`" | grep -v grep | sed s/'# '/''/g
}

################
# Beginning :) #
################

printHeader

if [ $1 ]; then
  usrAction=$1
else
  printSyntax
fi

case ${usrAction} in
  "start")          labStart $@   ;;
  "stop")           labStop       ;;
  "--help"|"-h")    printSyntax   ;;
  "--version"|"-v") printVersion  ;;
  *)
    printLog error "Wrong syntax. Try `basename $0` --help"
    echo
    printSyntax
    exit
    ;;
esac

##############
# The End :( #
##############
