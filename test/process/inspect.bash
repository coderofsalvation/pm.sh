#!/bin/bash
export PM_CONFIG=$(pwd)/.pm.sh
rm -rf $PM_CONFIG &>/dev/null

bin/pm init
bin/pm add $(pwd)/test/testdata/app1 &>/dev/null   || exit 1
echo "OK: added app1"
output="$(bin/pm inspect app1)"

[[ ! "$output" =~ APPNAME       ]] && { echo "ERROR"; exit 1; }
[[ ! "$output" =~ GA_TOKEN      ]] && { echo "ERROR"; exit 1; }
[[ ! "$output" =~ "npm start"   ]] && { echo "ERROR"; exit 1; }
[[ ! "$output" =~ "created yet" ]] && { echo "ERROR"; exit 1; }

echo "OK: inspect output was fine"
