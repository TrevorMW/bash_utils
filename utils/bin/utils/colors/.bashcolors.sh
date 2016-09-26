#!/usr/bin/env bash

CLR_ESC=$'\033['
NOCOLOR=$'\033[0m'

# All these variables has a with the same name, but in lower case.
RED=${CLR_ESC}$'31m'              # set red foreground
GREEN=${CLR_ESC}$'32m'            # set green foreground
YELLOW=${CLR_ESC}$'33m'           # set brown foreground
BLUE=${CLR_ESC}$'34m'             # set blue foreground
PURPLE=${CLR_ESC}$'35m'           # set magenta foreground
CYAN=${CLR_ESC}$'36m'             # set cyan foreground
WHITE=${CLR_ESC}$'37m'            # set white foreground
GRAY=${CLR_ESC}$'90m'             # set gray foreground

# for spitting out colorized text
echoColorText (){
  echo ${CLR_ESC}$3"$2$1"${NOCOLOR}
}

# Success Message
successMsg (){
  echoColorText "$1" 'SUCCESS: ' $GREEN
}

# Error Message
errorMsg (){
  echoColorText "$1" 'ERROR: ' $RED
}

# Info Message
infoMsg (){
  echoColorText "$1" 'INFO: ' $YELLOW
}

# Warning Message
warningMsg (){
  echoColorText "$1" 'WARNING: ' $PURPLE
}

# Notice Message
noticeMsg (){
  echoColorText "$1" 'NOTICE: ' $BLUE
}

# Generic separator, to make bash output more dilimited
separator (){
  declare CHAR='-'

  if [ ! -z $1 ];then
    CHAR=$1
  fi;

  echoColorText $( printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' $CHAR ) $GRAY
}
