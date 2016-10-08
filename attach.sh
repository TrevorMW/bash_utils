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

# Generic separator, to make bash output more dilimited
separator (){
  local delim="$1"

  if [ -z $1 ]; then
    delim="-"
  fi;

  echoColorText $( printf "%*s" "${COLUMNS:-$(tput cols)}" " " | tr ' ' "$delim" ) $GRAY
}

################################################################################################
################################ Runtime #######################################################
################################################################################################

type git >/dev/null 2>&1 || errorMsg "Please install git before continuing..."

type greadlink >/dev/null 2>&1 && CWD="$(dirname "$(greadlink -f "$0")")" || \
  CWD="$(dirname "$(readlink -f "$0")")"

repo="git@github.com:TrevorMW/bash_utils.git"
branch="master"

echoColorText "Attaching $YELLOW\"bash_utils\"$BLUE toolkit" "Task: " $BLUE

linkBin(){
  echoColorText "Creating symlink to access $CYAN\"bash_utils\"$YELLOW bin folder." " - " $YELLOW
  separator
  echo
  ln -s ./bash_utils/bin bin
}

downloadUtils(){
  echoColorText "Cloning $CYAN\"bash_utils\"$YELLOW repository." " - " $YELLOW
  separator
  echo
  git clone -b $branch $repo
}

removeExtraGit(){
  echoColorText "Removing .git folder from $CYAN\"bash_utils\"$YELLOW" " - " $YELLOW
  rm -rf "./bash_utils/.git"
}

attach(){

  downloadUtils
  linkBin
  removeExtraGit
}

attach
