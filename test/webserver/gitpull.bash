#!/bin/bash
export PM_CONFIG=$(pwd)/.pm.sh
rm -rf $PM_CONFIG &>/dev/null
pid_webserver=""
bin/pm init
echo 'export PORT=8080' > $PM_CONFIG/apps/pmserver.pmserver
rm -rf bin/.git &>/dev/null

trap "kill -9 \$pid_webserver && wait" 0 1 2 3 4 5 6 SIGINT SIGTERM SIGHUP

{ timeout 20s bin/pm server start > test/testdata/log; } &
pid_webserver=$!
echo "OK: starting server"
sleep 1s
curl -X POST http://localhost:8080/pull/pmserver --data "flop"
sleep 1s
cat test/testdata/log
grep error test/testdata/log &>/dev/null || { echo "didnt throw error"; exit 1; }
echo "OK: posting to app without repo"

cd bin
git init
git remote add origin http://flop/foo.git
curl -X POST http://localhost:8080/pull/pmserver --data "flop"
sleep 1s
cd - 
cat test/testdata/log
echo "OK: posting to app with repo"

echo OK
killall gawk &>/dev/null
