#!/bin/bash
export PM_CONFIG=$(pwd)/.pm.sh
rm -rf $PM_CONFIG &>/dev/null

bin/pm init
bin/pm add $(pwd)/test/testdata/app1 &>/dev/null   || exit 1
cp -R $(pwd)/test/testdata/app1 $(pwd)/test/testdata/app3
bin/pm add $(pwd)/test/testdata/app3 &>/dev/null   || exit 1
echo "OK: added app1 && app3"
bin/pm status
result="$(bin/pm startall 2>&1)"
[[ "$result" =~ "app1"    ]] && echo app1 found  || exit 1
[[ "$result" =~ "app3"    ]] && echo app3 found  || exit 1
[[ "$result" =~ "pmserver"    ]] && echo pmserver found  || exit 1
