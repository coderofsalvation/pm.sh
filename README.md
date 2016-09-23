<img src="doc/logo.png" width="120"/>

Philosophy: #unixy, #lightweight, #nodependencies, #commandline, #minimal
Basically it's pm2 without the fat written in bash, using simply ```ps``` and ```flock```

## Usage

    $ wget "http://sldfjlskdf" -O ~/bin/pm && chmod 755 ~/bin/pm
    $ pm
    Usage:                                                                                                          
                                                                                                                    
      pm init                                      create ~/.pm.conf.sh configfile                                  
      pm status                                    show app(names) and their status                                 
      pm add <appdir>                              add application(dir which contains application definition file)  
      pm remove <appdir>                           remove application                                               
      pm start <appname> [args] [..]               start app                                                        
      pm stop <appname>                            stop  app                                                        
                                                                                                                    

## Demo 
    $ pm init
    $ pm add ~/myapps/yourapp
    $ pm status
    APP        PID %CPU %MEM   PORT  RSS TTY      STAT START   TIME COMMAND
    
    yourapp                                                         
    
    $ pm start yourapp
    $ pm restart yourapp
    $ pm stop  yourapp
    $ pm status
    APP        PID %CPU %MEM   PORT  RSS TTY      STAT START   TIME COMMAND
    
    yourapp  22314  0.0  0.0   5800  1776 pts/2    S+   20:35   0:00 flock -w 1 /tmp/.pm.yourapp.lock npm start

## Features

* automatically restart process
* forward stderr/stdout logs to separated error- and logfiles
* forward stderr/stdout to syslog (if installed)
* support for [Application Definition-files](doc/application-definition.md)
* [TODO] app.sh support (native)
* [TODO] forward log regex-matches + start/stop/restart-events to custom webhook
* [TODO] forward log regex-matches + start/stop/restart-events to google analytics events
* [TODO] package.json support
* [TODO] automatically pull branch from github on github webhook
* [TODO] app.json support
* [TODO] composer.json support
* [TODO] pm2.json support

## Why

I love pm2 and other tools.
However, I've lost a lot of time on managing problems which are actually solved in unix already.
Instead of fiddling with upstart daemon-scripts or pids, I wanted to keep the pm2 workflow, but using shellscript.
Shellscript/unix is well designed to manage unix processes, pm2 and pm.sh is just a wrapper.
