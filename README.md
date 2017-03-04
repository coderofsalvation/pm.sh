<img src="doc/logo.png" width="120"/>
![Build Status](https://travis-ci.org/coderofsalvation/pm.sh.svg?branch=master)


Philosophy: #unixy, #lightweight, #webhooks, #nodependencies, #docker, #commandline, #minimal, #github, #bitbucket
Basically it's pm2 without the fat, and `ps`+`flock` wrapped in bash.

## Usage

    $ wget "https://raw.githubusercontent.com/coderofsalvation/pm.sh/master/bin/pm" -O ~/bin/pm && chmod 755 ~/bin/pm
    $ pm
    Usage:                                                                                                          
                                                                                                                    
      pm init                                      create ~/.pm.conf.sh configfile                                  
      pm list                                      list appnames                                                    
      pm add <appdir> [appname] [cmd]              add application(dir which contains application definition file)  
      pm remove <appdir>                           remove application                                               
      pm status                                    show app(names) and their status                                 
      pm start <appname> [--log]                   start app (and tail logs)                                        
      pm stop <appname>                            stop  app                                                        
      pm startall                                  start all applications                                           
      pm stopall                                   stop all applications                                            
      pm tail <appname>                            monitor logs                                                     
      pm inspect <appname>                         show all related files, startcmds, env-vars                      
      pm debug <appname>                           start application in foreground (for testing purposes)           
                                                                                                                    
      type 'pm -h' to see all options: receiving github/bitbucket webhooks, pushing to google analytics etc
                                                   ┌─────────────────────────────────────────────────┐              
                                                   │ docs: https://github.com/coderofsalvation/pm.sh │              
                                                                                                                

## Demo 

    $ pm init
    $ pm add . pinger 'sleep 5m && curl http://foo.com/ping'
    $ pm add /apps/nodejs/proxy
    $ pm add /apps/nodejs/app1
    $ pm add /apps/nodejs/dbworker dbworker1
    $ pm add /apps/nodejs/dbworker dbworker2
    $ pm add /apps/nodejs/dbworker dbworker3
    $ pm status
    APP        STATUS     PORT       RESTARTS USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND

    proxy      running      80       0        foo      24900  1.6 10.0   5800  1744 pts/2    S    19:15   0:00 npm start
    app1       stopped    3001       0        foo      24901  1.0 20.0   5800  1744 pts/2    S    19:19   0:00 npm start
    pinger     stopped    none       0        foo      24909  1.0 20.0   5800  1744 pts/2    S    19:19   0:00 npm start
    dbworker1  stopped    none       0        foo      24903  4.0 30.0   5800  1744 pts/2    S    19:35   0:00 ./dbworker
    dbworker2  stopped    none       0        foo      24904  1.0 10.0   5800  1744 pts/2    S    19:45   0:00 ./dbworker
    dbworker3  stopped    none       12       foo      24905  0.0  0.0   5800  1744 pts/2    S    19:55   0:00 ./dbworker
    
    $ pm start app1
    $ pm start pinger
    $ pm status

    APP        STATUS     PORT       RESTARTS USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND

    proxy      stopped      80       0        foo      24900  1.6 10.0   5800  1744 pts/2    S    19:15   0:00 npm start
    app1       running    3001       0        foo      24901  1.0 20.0   5800  1744 pts/2    S    19:19   0:00 npm start
    pinger     running    none       0        foo      24909  1.0 20.0   5800  1744 pts/2    S    19:19   0:00 npm start
    dbworker1  stopped    none       0        foo      24903  4.0 30.0   5800  1744 pts/2    S    19:35   0:00 ./dbworker
    dbworker2  stopped    none       0        foo      24904  1.0 10.0   5800  1744 pts/2    S    19:45   0:00 ./dbworker
    dbworker3  stopped    none       12       foo      24905  0.0  0.0   5800  1744 pts/2    S    19:55   0:00 ./dbworker

## Features

* automatically restart process
* forward stderr/stdout logs to separated error- and logfiles
* forward stderr/stdout to syslog (if installed: see `tail -f /var/log/syslog`)
* support for [Application Definition-files](doc/application-definition.md)
* nodejs `package.json` support
* inbound / outbound custom webhooks (per application-config)
* events can be pushed to google analytics (per application-config)
* [TODO] automatically pull branch from github on github webhook
* [TODO] app.json support
* [TODO] composer.json support
* [TODO] pm2.json support
* [BETA] multiple configurations using `PM_CONFIG=alternate_config_dir pm.sh`

## Git / Bitbucket / Anywhere push webhooks

Automatically update your running application ('app1' for example) when you push to Github/Bitbucket.

    $ pm config pmserver 8080 
    $ pm start pmserver 
    
* specify *http://yourdomain.com:8080/pull/{yourappname}* as webhookurl in Github/BB (only push!)

Or call from another service:

    $ curl -X POST -H 'Content-Type: application/json' http://localhost:8080/pull/app1
    $ curl -X POST -H 'Content-Type: application/json' http://localhost:8080/start/app1
    $ curl -X POST -H 'Content-Type: application/json' http://localhost:8080/stop/app1
    $ curl -X POST -H 'Content-Type: application/json' http://localhost:8080/restart/app1

## Trigger a Dockercontainer rebuild using webhooks

Here's a quick way to achieve this:

> Put a `Dockerfile` and this script in `webhook.sh` in your repo :

    #!/bin/bash
    set -e
    rollback(){
      docker rename yourcontainer.bak yourcontainer
      docker start yourcontainer
    }

    trap rollback ERR                # rollback if any error

    docker stop yourcontainer
    docker rename yourcontainer yourcontainer.bak
    docker build -t yourcontainer .
    docker run -d yourcontainer 
    docker rm -f yourcontainer.bak    

    tail -f /dev/null                # do nothing until next webhook

Then install the repo on your liveserver:

    $ git clone git@github.com/myusername/foo.git
    $ cd foo
    $ pm add $(pwd) docker.myproject bin/webhook.sh
    $ pm status
    APP                  STATUS   PORT   RESTARTS   USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND

    docker.myproject     running  none   0          docker    9904  0.0  0.0  10256   860 pts/0    S    10:23   0:00 flock -n /home/docker/.pm.sh/apps/docker.myproject.lock bin/webhook.sh
    pmserver             running  8080   0          docker    7665  0.0  0.0  10256   768 pts/0    S    09:50   0:00 flock -n /home/docker/.pm.sh/apps/pmserver.lock /opt/pm.sh/bin/pm server start 90
    $ pm start docker.myproject

> Voila! Now configure 'http://yourliveserver.com:8080/pull/docker.myproject' in the `webhooks`-session of your repo.
 

## Why

I love pm2, docker and other tools.
However, I've wasted lots of time on managing problems which are actually solved in unix already.
Instead of fiddling with upstart daemon-scripts or pm2's codebase, I longed for a unixy pm2 workflow.
Eventhough i love nodejs, in some cases shellscript/unix seems more appropriate.

## Server installation 

Upstart job:

    # /etc/init/pm.conf
    start on (local-filesystems and net-device-up IFACE!=lo)
    exec sudo -u feelgood /home/feelgood /usr/bin/pm startall

## Docker image

There's a [ready-to-go](https://hub.docker.com/r/coderofsalvation/pm.sh-nodejs) nodejs-docker image.
Put this in your `Dockerfile`:

    # Usage:
    #   docker build -t playterm .
    #   docker run -it -e PROXY_PORT=8080 -e WEBHOOK_PORT=8080 -v $(pwd)/data:/data yourproject
    FROM coderofsalvation/pm.sh-nodejs:latest

    MAINTAINER Coder Of Salvation <info@leon.vankammen.eu>

    ENV VERSION=v4.1.1

    RUN echo 'http://dl-3.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories
    RUN apk upgrade --update
    RUN apk add mongodb

    ADD . /srv/apps/yourproject
    VOLUME data /data

    EXPOSE 8080 80 8081 4000 4001 4002 4003

    CMD [ "sh","-c","/data/Dockerboot; cat" ]

And put this in `data/Dockerboot`:

    #!/bin/bash
    export PROXY_PORT=8080
    export WEBHOOK_PORT=8081
    cp /srv/apps/playterm/lib/proxytable.js /srv/apps/proxytable.js
    mongod &
    /install/boot
    su -c 'pm startall' nodejs 
