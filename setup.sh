#! /usr/bin/env bash

BasePath=$(git rev-parse --show-toplevel)

. $BasePath/tools/functions

gatherInfo (){

  declare -a envs=('local' 'staging' 'production')
  local newConfig="$BasePath/config.yml"

  if [ ! -f $newConfig ]; then

    cp "$BasePath/config.yml.sample" $newConfig

    for env in ${envs[@]}; do

      if prompt_confirm "Does this site have $env configuration? "; then

        echo

        echoColorText "Gathering config for the $CYAN\"$env\"$YELLOW environment..." "" $YELLOW;

        separator

        read -p $CYAN" - $env Base Path? "$NOCOLOR          BasePath
        read -p $CYAN" - $env Database Name? "$NOCOLOR      DbName
        read -p $CYAN" - $env Database User? "$NOCOLOR      DbUser
        read -p $CYAN" - $env Database Password? "$NOCOLOR  DbPass

        read -p $CYAN" - $env SSH user? "$NOCOLOR           SshUser
        read -p $CYAN" - $env SSH password? "$NOCOLOR       SshPass
        read -p $CYAN" - $env SSH IP address? "$NOCOLOR     SshIp

        echo
        separator
        echoColorText "Populating config.yml with $PURPLE${env}$YELLOW data" "" $YELLOW
        echo

        bp="@${env}BasePath";
        dbN="@${env}DbName";
        dbU="@${env}DbUser";
        dbP="@${env}DbPass";
        sshU="@${env}SshUser";
        sshP="@${env}SshPass";
        sshI="@${env}SshIp";

        local replaceString="s|${bp}|${BasePath}|g;";
              replaceString+="s|${dbN}|${DbName}|g;";
              replaceString+="s|${dbU}|${DbUser}|g;";
              replaceString+="s|${dbP}|${DbPass}|g;";
              replaceString+="s|${sshU}|${SshUser}|g;";
              replaceString+="s|${sshP}|${SshPass}|g;";
              replaceString+="s|${sshI}|${SshIp}|g;";

        sed_inplace $newConfig $replaceString

      fi;

    done;

  else

    echoColorText "Configuration detected; Skipping configuration prompts." " - " $YELLOW
    echo
    echo

  fi;
}

makeUtilsSymlink (){
  if [ ! -h 'bin' ]; then
    ln -s $BasePath/bash_utils/bin bin
  fi;
}

updateModules (){

  taskMsg "Updating Node Modules"
  separator

  if [ -d "$BasePath/node_modules" ]; then
    echoColorText 'Updating Node Modules' ' - ' $YELLOW
    echo
    npm update
  else
    echoColorText 'Installing Node Modules' ' - ' $YELLOW
    echo
    npm install
  fi
}


initSetup(){

  echo
  taskMsg "Starting Setup"
  separator "="
  echo

  gatherInfo

  #makeUtilsSymlink

  #updateModules
}


# Start script
initSetup
