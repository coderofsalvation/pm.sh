Application definition files
============================

Just like pm2, pm.sh uses application definition files.

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
