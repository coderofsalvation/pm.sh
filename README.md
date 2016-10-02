<img src="doc/logo.png" width="120"/>
![Build Status](https://travis-ci.org/coderofsalvation/pm.sh.svg?branch=master)


Philosophy: #unixy, #lightweight, #nodependencies, #commandline, #minimal, #github, #bitbucket
Basically it's pm2 without the fat, and `ps`+`flock` wrapped in bash.

## Usage

    $ wget "https://github.com/coderofsalvation/pm.sh/blob/master/bin/pm" -O ~/bin/pm && chmod 755 ~/bin/pm
    $ pm
    Usage:                                                                                                          
                                                                                                                    
      pm init                                      create ~/.pm.conf.sh configfile                                  
      pm list                                      list appnames                                                    
      pm add <appdir> [cmd]                        add application(dir which contains application definition file)  
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
    
* Now you can enter __ttp://yourdomain.com:8080/pull/{yourappname}_ as Github/BB webhook value (only push!)

Or call from another service:

    $ curl -X POST -H 'Content-Type: application/json' http://localhost:8080/pull/app1
    $ curl -X POST -H 'Content-Type: application/json' http://localhost:8080/start/app1
    $ curl -X POST -H 'Content-Type: application/json' http://localhost:8080/stop/app1
    $ curl -X POST -H 'Content-Type: application/json' http://localhost:8080/restart/app1

## Why

I love pm2 and other tools.
However, I've lost a lot of time on managing problems which are actually solved in unix already.
Instead of fiddling with upstart daemon-scripts or pm2's codebase, I longed for a unixy pm2 workflow.
Eventhough i love nodejs, in some cases shellscript/unix seems more appropriate.
