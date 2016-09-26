#! /usr/bin/env bash

SCRIPTPATH=$(git rev-parse --show-toplevel)

. ./colors/.bashcolors.sh
. ./functions
. ./help

eval $( parseYaml config.yml )
