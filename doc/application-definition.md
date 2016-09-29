Application definition files
============================

Just like pm2, pm.sh uses application definition files.


## Nodejs (package.json)

Put a `package.json` in your projectdir (foo/app1 etc):

    {
      "scripts":{
        "start": "node app.js"
      }
    }

And also an `env.sh`:

    export NODE_ENV=development
    export DEBUG=foo,*http*

And on a productionserver an `env.production.sh` too:

    export NODE_ENV=production
    export DEBUG=""
    export PASSWORD=XXXXXXXX

> `env.sh` and `env.production.sh` are automatically sourced if present

Then add the projectdir

    $ pm add foo/app1
    $ pm inspect app1
    $ pm start app1

## Custom

[TODO: implementation]
Put a `app.sh` or `app.bash` in your projectdir:

    #!/bin/bash
    export MY_ENV_VAR=foobar
    [[ -f app.bash.live ]] && source app.bash.live
    npm start
