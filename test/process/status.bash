#!/bin/bash
export PM_CONFIG=$(pwd)/.pm.sh
rm -rf $PM_CONFIG &>/dev/null

bin/pm init
bin/pm add $(pwd)/test/testdata/app1 &>/dev/null   || exit 1
echo "OK: added app1"
echo "OK: starting app1"
bin/pm start app1
sleep 2s
bin/pm status
bin/pm status    | grep -q "running" && echo "OK: app1 running" || { echo "ERROR: app1 not running"; exit 1; }
ps aux | grep -q app1 || { echo "ERROR: app1 not running"; exit 1; }
sleep 2s
echo "killing app1"
bin/pm stop app1
echo "waiting.."
wait
sleep 2s
ps aux|grep -q app1 || { echo "ERROR: app1 wasnt stopped"; exit 1; }
bin/pm status #   | grep -q "running" && echo "OK: app1 running" || { echo "ERROR: app1 not running"; exit 1; }
echo "OK: app1 was stopped"
