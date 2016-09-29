#!/bin/bash
export PM_CONFIG=.pm.sh
rm -rf .pm.sh &>/dev/null

bin/pm init
bin/pm add test/testdata/app.empty        | grep -q "couldn"    && echo "OK: refused adding empty app" || { echo "ERROR"; exit 1; }
bin/pm add $(pwd)/test/testdata/app.empty | grep -q "couldn"    && echo "OK: refused adding empty app (abs path)" || { echo "ERROR"; exit 1; }
bin/pm add $(pwd)/test/testdata/app1      | grep -q "added"     && echo "OK: add nonemty app (package.json)" || { echo "ERROR"; exit 1; }

[[ ! -f $PM_CONFIG/apps/app1.def ]]        && { echo "error: could not find $PM_CONFIG/apps/app1"; exit 1; }
[[ ! -f $(cat $PM_CONFIG/apps/app1.def) ]] && { echo "error: could not find package.json"; exit 1; }

bin/pm remove asdkfhaklsjdfas    | grep -q "couldn"    && echo "OK: refused removing nonexisting app" || { echo "ERROR"; exit 1; }
bin/pm remove app1               | grep -q "removed"   && echo "OK: removed existing app"             || { echo "ERROR"; exit 1; }
