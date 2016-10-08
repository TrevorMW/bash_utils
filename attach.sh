#! /bin/sh

#
# adds devops-skel to -develop branch -- imports to the skel/ directory.
# assumes CWD is a git repository, else pass target directory as first argument.
#

# utility
#########

error(){
  printf "\033[31m%s\n\033[0m" "$@" >&2
  exit 1
}

# sed_inplace : in place file substitution
############################################
#
# usage: sed_inplace "file" "sed substitution"
#    ex: sed_inplace "/tmp/file" "s/CLIENT_CODE/BA/g"
#

sed_inplace(){
  # linux
  local SED_CMD="sed"

  if [[ $OSTYPE == darwin* ]]; then
    if $(type gsed >/dev/null 2>&1); then
      local SED_CMD="gsed"
    elif $(type /usr/local/bin/sed >/dev/null 2>&1); then
      local SED_CMD="/usr/local/bin/sed"
    else
      sed -i '' -E "$2" $1
      return
    fi
  fi

  $SED_CMD -r -i "$2" $1
}


# line_in_file : ensure a line exists in a file
###############################################
#
# usage: line_in_file "file" "match" "line"
#    ex: line_in_file "varsfile" "^VARNAME=.*$" "VARNAME=value"
#

line_in_file(){
  local delim=${4:-"|"}
  grep -q "$2" $1 2>/dev/null && sed_inplace $1 "s$delim$2$delim$3$delim" || echo $3 >> $1
}


type git >/dev/null 2>&1 || errorMsg "please install git before continuing..."

# globals
#########
type greadlink >/dev/null 2>&1 && CWD="$(dirname "$(greadlink -f "$0")")" || \
  CWD="$(dirname "$(readlink -f "$0")")"

[ -z "$1" ] || CWD=$1
cd $CWD || error "cannot enter $CWD"

REPO_ROOT=$(git rev-parse --show-toplevel) || error \
    "$CWD does not belong to a git repository"

WORKING_BRANCH=$(git rev-parse --abbrev-ref HEAD)
REPO_HEAD="$(git rev-parse --short HEAD)"

# skelvars
##########

REMOTE=${SKEL_REMOTE:-"git@github.com:TrevorMW/bash_utils.git"}
BRANCH=${SKEL_BRANCH:-"production"}

# runtime
#########

git ls-remote --exit-code -h $SKEL_REMOTE $SKEL_REMOTE_REF >/dev/null || error \
  "SKEL_REMOTE_REF: $SKEL_REMOTE_REF missing from SKEL_REMOTE: $SKEL_REMOTE"

[ "$WORKING_BRANCH" = "$SKEL_BRANCH" ] || error \
  "You must attach skel from the $SKEL_BRANCH (currently on $WORKING_BRANCH)" \
  "please checkout $SKEL_BRANCH and try again, -or-" \
  "  alternatively set (export SKEL_BRANCH=branchname) the desired branch"

cd $REPO_ROOT

[ -z "$(git status -uno --porcelain --)" ] || error \
  "Uncommitted changes detected" "commit or stash before continuing..."

[ -d "$REPO_ROOT/$SKEL_DIR" ] && error \
  "$REPO_ROOT/$SKEL_DIR exists!" "backup+remove it before continuing"

printf "\n  registering skelvars to $SKELVARS ...\n"
line_in_file "$SKELVARS" "^SKEL_REMOTE=.*$" "SKEL_REMOTE=$SKEL_REMOTE"
line_in_file "$SKELVARS" "^SKEL_RELEASE=.*$" "SKEL_RELEASE=$SKEL_RELEASE"
line_in_file "$SKELVARS" "^SKEL_REMOTE_REF=.*$" "SKEL_REMOTE_REF=$SKEL_REMOTE_REF"
line_in_file "$SKELVARS" "^SKEL_DIR=.*$" "SKEL_DIR=$SKEL_DIR"
line_in_file "$SKELVARS" "^SKEL_BRANCH=.*$" "SKEL_BRANCH=$SKEL_BRANCH"
git add $SKELVARS && git commit -m "registering skelvars"

printf "\n  merging upstream-skel into $SKEL_DIR/...\n"
git subtree add --prefix=$SKEL_DIR/ --squash -m "attaching skel" \
  $SKEL_REMOTE $SKEL_REMOTE_REF || error "error attaching skel to project"

printf "\n  ************************************ \n"
printf "\n            skel attached\n"
printf "\n  git log $REPO_HEAD..HEAD   for a list of commits"
printf "\n  git diff --name-only $REPO_HEAD..HEAD   for a list of file changes"
printf "\n  git reset --hard $REPO_HEAD   to undo skel attachment"
printf "\n  git push origin HEAD   when you're ready to push skel attachment\n"
printf "\n  **don't forget to initialize the skel**: \n"
printf "\n    skel/bin/skel --help \n"
printf "\n  to initialize without blueacornui/pulling in green-pistachio: \n"
printf "\n    skel/bin/skel init --force --gp-skip --repo-remote $(git config --get remote.origin.url)\n"
printf "\n  also remember to 'bin/skel push' after making an environment."
printf "\n               thanks!\n\n"
