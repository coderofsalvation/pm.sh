#!/bin/bash
export PM_CONFIG=$(pwd)/.pm.sh
rm -rf $PM_CONFIG &>/dev/null
pid_webserver=""
[[ -d $PM_CONFIG ]] && rm -rf $PM_CONFIG
bin/pm init
echo 'export PORT=8080' > $PM_CONFIG/apps/pmserver.pmserver
rm -rf bin/.git &>/dev/null

bin/pm config pmserver 8080
echo "OK: starting server"
bin/pm restart pmserver

sleep 2s
curl -X POST http://localhost:8080/pull/pmserver --data "flop"
sleep 1s
if grep error $PM_CONFIG/apps/pmserver.log.stdout; then
  echo "OK: posting to app without repo"
else
  echo "didnt throw error"
  exit 1
fi

\cd test/testdata/app1 
git init
git remote add origin http://flop/foo.git
cd -
bin/pm add $(pwd)/test/testdata/app1
curl -X POST http://localhost:8080/pull/app1 --data "flop"
sleep 1s
if grep "performing git pull" $PM_CONFIG/apps/pmserver.log.stdout &>/dev/null; then
  echo "OK: posting to app with repo"
else
   echo "ERROR: didnt pull"; 
   exit 1;
fi

bin/pm stop pmserver
exit 0
