#! /bin/sh

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

# Error Message
errorMsg (){
  echoColorText "$1" 'ERROR: ' $RED
  exit 1
}

type git >/dev/null 2>&1 || errorMsg "Please install git before continuing..."

BasePath=$(git rev-parse --show-toplevel)
repo="git@github.com:TrevorMW/bash_utils.git"
branch="master"

linkBin(){
  ln -s "$BasePath/bash_utils/bin" "$BasePath/bin"
}

downloadUtils(){
  git clone -b $branch $repo
}

attach(){

  downloadUtils

  linkBin
}

attach
