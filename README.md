ProcessingJsOsc
===============

Processing.js - Node.js - OSC


Installation
--------

    $ cd ProcessingJsOsc/nodeServer
    $ npm install node-osc socket.io

Replace two `127.0.0.1`s in `nodeClient/template/template.html` where marked as `<!--should be server ip -->` to connect from remote devices.

oscReceiver requires [oscP5]( http://www.sojamo.de/libraries/oscP5/ ).

Launch
--------

    $ node server.js

Then, start nodeClient as JavaScript app and oscReceiver as Java app.
