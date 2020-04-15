#!/usr/bin/env bash

################################################################################
# Setup ANSI Colours
RCol='\e[0m' # Text Reset
# Regular       Bold             Underline        High Intensity   BoldHigh Intens   Background       High Intensity Backgrounds
Bla='\e[0;30m'; BBla='\e[1;30m'; UBla='\e[4;30m'; IBla='\e[0;90m'; BIBla='\e[1;90m'; On_Bla='\e[40m'; On_IBla='\e[0;100m'
Red='\e[0;31m'; BRed='\e[1;31m'; URed='\e[4;31m'; IRed='\e[0;91m'; BIRed='\e[1;91m'; On_Red='\e[41m'; On_IRed='\e[0;101m'
Gre='\e[0;32m'; BGre='\e[1;32m'; UGre='\e[4;32m'; IGre='\e[0;92m'; BIGre='\e[1;92m'; On_Gre='\e[42m'; On_IGre='\e[0;102m'
Yel='\e[0;33m'; BYel='\e[1;33m'; UYel='\e[4;33m'; IYel='\e[0;93m'; BIYel='\e[1;93m'; On_Yel='\e[43m'; On_IYel='\e[0;103m'
Blu='\e[0;34m'; BBlu='\e[1;34m'; UBlu='\e[4;34m'; IBlu='\e[0;94m'; BIBlu='\e[1;94m'; On_Blu='\e[44m'; On_IBlu='\e[0;104m'
Pur='\e[0;35m'; BPur='\e[1;35m'; UPur='\e[4;35m'; IPur='\e[0;95m'; BIPur='\e[1;95m'; On_Pur='\e[45m'; On_IPur='\e[0;105m'
Cya='\e[0;36m'; BCya='\e[1;36m'; UCya='\e[4;36m'; ICya='\e[0;96m'; BICya='\e[1;96m'; On_Cya='\e[46m'; On_ICya='\e[0;106m'
Whi='\e[0;37m'; BWhi='\e[1;37m'; UWhi='\e[4;37m'; IWhi='\e[0;97m'; BIWhi='\e[1;97m'; On_Whi='\e[47m'; On_IWhi='\e[0;107m'

################################################################################
# Some Handy Functions
function sanitise_string() {
    ## Clean out anything that's not alphanumeric or an underscore
    CLEAN=${1//[^a-zA-Z0-9_-]/}
    echo ${CLEAN}
}

function error() {
  echo -e "${Red}${1}${RCol}"
  exit 1
}

function notice() {
  echo -e "${Gre}$1${RCol}"
}

function info() {
  echo -e "${Cya}$1${RCol}"
}

function debug() {
  echo -e "\n${Red}DEBUG: ${Yel}$*${RCol}\n"
}

function warning() {
  echo -e "\n${Yel}$1${RCol}\n"
}

function task() {
  # echo -en "$1: "
  printf '%-70s' "$1: "
}

function stat_skip() {
  echo -e "[${Yel} Skip ${RCol}]"
}

function stat_ok() {
  echo -e "[${Gre}  OK  ${RCol}]"
}

function stat_fail() {
  echo -e "[${Red}Failed${RCol}]"
}

function ctrl_c() {
  error "CTRL-C Detected. Exiting...."
  do_exit 255
}