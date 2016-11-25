Application definition files
============================

Just like pm2, pm.sh uses application definition files.

## Environment

> `env.sh` and `env.production.sh` are automatically sourced if present

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

Ultimate freedom lies within adding the application to pm with a startcmd:

    $ pm add /srv/app/myapp myapp './mystartupscript'
