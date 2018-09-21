#!/usr/bin/env bash

set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value

source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.config.sh"

###
## SERVICES :
###
DC_FILE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.services.sh"
if [ ! -f $DC_FILE ]; then
    echo "$DC_FILE file not found!"
    exit 1;
fi
source $DC_FILE

###
## START
###
logMsg "Start"

if [ -z ${DC_SERVICES+x} ]; then
  logMsg "No services(DC_SERVICES) defined";
  exit 1;
else
  logMsg "Services : $DC_SERVICES"
fi

TYPE=""

if [ $# -gt 0 ]; then
    #contain arguments
    if [ "$1" = "stop" ]; then
        logMsg "Containers Stop"
        logMsg ""
        TYPE="stop"
    fi
else
    #no arguments
    logMsg "Containers Start"
    logMsg ""
    TYPE="start"
fi

if [ $TYPE != "" ]; then
    logMsg "Trigger Docker $TYPE"
    logMsg ""
    docker $TYPE $DC_SERVICES
fi
