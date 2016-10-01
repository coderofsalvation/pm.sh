#!/bin/bash
export PM_CONFIG=$(pwd)/.pm.sh
rm -rf $PM_CONFIG &>/dev/null
pid_webserver=""
bin/pm init
echo 'export PORT=8080' > $PM_CONFIG/apps/pmserver.pmserver

trap "kill -9 \$pid_webserver && wait" 0 1 2 3 4 5 6 SIGINT SIGTERM SIGHUP

{ bin/pm server start > test/testdata/log; } &
pid_webserver=$!
echo "OK: starting server"

sleep 1s
curl -X POST http://localhost:8080/pull/pmserver --data "flop"
sleep 1s
grep error test/testdata/log &>/dev/null || { echo "didnt throw error"; exit 1; }
echo "OK: posting to app without repo"

echo OK
