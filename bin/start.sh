#!/bin/bash

###
## services :
## d_esaksi esaksi_redis dev_proxy dev_mysql dev_adminer
###

TYPE=""

if [ $# -gt 0 ]; then
    #contain arguments
    if [ "$1" = "stop" ]; then
        printf "eSaksi Stop"
        printf "\n"
        TYPE="stop"
    fi
else
    #no arguments
    printf "eSaksi Start"
    printf "\n"
    TYPE="start"
fi

if [ $TYPE != "" ]; then
    printf "Trigger Docker $TYPE"
    printf "\n"
    docker $TYPE d_esaksi esaksi_redis dev_proxy dev_mysql dev_adminer
fi
