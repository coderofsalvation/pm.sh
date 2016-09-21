<img src="doc/logo.png" width="120"/>

Philosophy: #unixy, #lightweight, #nodependencies, #commandline, #minimal
Basically it's pm2 without the fat, using simply ```ps``` and ```flock```

## Usage

    $ wget "http://sldfjlskdf" -O ~/bin/pm && chmod 755 ~/bin/pm
    $ pm init
    $ pm add ~/myapps/yourapp
    $ pm status

    $ pm start yourapp
    $ pm restart yourapp
    $ pm stop  yourapp
    $ pm status
    USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
    sqz      22314  0.0  0.0   5800  1776 pts/2    S+   20:35   0:00 flock -w 1 /tmp/.pm.yourapp.lock npm start

## Features

* automatically restart process
* forward stderr/stdout logs to separated error- and logfiles
* forward stderr/stdout to syslog (if installed)
* [TODO] app.sh support (native)
* [TODO] forward log regex-matches + start/stop/restart-events to custom webhook
* [TODO] forward log regex-matches + start/stop/restart-events to google analytics events
* [TODO] package.json support
* [TODO] automatically pull branch from github on github webhook
* [TODO] app.json support
* [TODO] composer.json support
* [TODO] pm2.json support

## Application definition-file: Custom

Put a `app.sh` or `app.bash` in your projectdir:

    #!/bin/bash
    export MY_ENV_VAR=foobar
    [[ -f app.bash.live ]] && source app.bash.live
    npm start

## Application definition-file: Nodejs (package.json)

Put a `package.json` in your projectdir:

    {
      "scripts":{
        "start": "{ source env.sh; source env.production.sh } 2>/dev/null ; source env.sh && node app.js"
      }
    }

And also an `env.sh`:

    export NODE_ENV=development
    export DEBUG=foo,*http*

And on a productionserver an `env.production.sh` too:

    export NODE_ENV=production
    export DEBUG=""
    export PASSWORD=XXXXXXXX

## Why

I love pm2 and other tools.
However, I've lost a lot of time on managing problems which are actually solved in unix already.
Instead of fiddling with upstart daemon-scripts, I wanted to keep the pm2 workflow, but using shellscript.
Shellscript/unix is well designed to manage unix processes, pm2 and pm.sh is just a wrapper.
