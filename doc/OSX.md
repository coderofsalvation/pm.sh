## OSX users

OSX might protest since it isn't quite GNU focused. Please run these commands after installing:

    $ brew install bash
    $ brew install coreutils gnu-sed grep gawk --default-names
    $ echo 'export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH' >> ~/.bashrc
    $ sed -i 's|#!/bin/bash|#!/usr/local/bin/bash|g' pm

> NOTE: please create an issue if this doesn't work
