#!/usr/bin/env bash

# description
#   Runs or tests this jekyll website

#set -x #echo all commands
#!/bin/bash

cd "${0%/*}"  # cd to website directory

REPO_ROOT=$(git rev-parse --show-toplevel)

if [[ $1 == "run" ]]; then
    # Run the website with auto update one
    ${REPO_ROOT}/tools/run.sh -r

elif [[ $1 == "test" ]]; then
    ${REPO_ROOT}/tools/build.sh
    ${REPO_ROOT}/tools/test.sh
    jekyll clean

else
    echo "Command not found. Please only use \"run\" or \"test\" "
fi