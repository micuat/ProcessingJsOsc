// note, io.listen(<port>) will create a http server for you
var io = require('socket.io').listen(8080);
var osc = require('node-osc');
var client = new osc.Client('127.0.0.1', 57121);

hashCode = function(str){
    var hash = 0;
    if (str.length == 0) return hash;
    for (i = 0; i < str.length; i++) {
        char = str.charCodeAt(i);
        hash = ((hash<<5)-hash)+char;
        hash = hash & hash; // Convert to 32bit integer
    }
    return hash;
}

io.sockets.on('connection', function (socket) {
  
  socket.on('colorChange', function (data) {
    console.log('color: ' + data.c.toString());
    client.send('/sharedFace/canvas/nodejs/color/hue', data.c);
  });
  socket.on('viscosityChange', function (data) {
    console.log('viscosity: ' + data.v.toString() + ' ' + data.g.toString());
    client.send('/sharedFace/canvas/nodejs/viscosity', data.v, data.g);
  });
  socket.on('modeChange', function (data) {
    console.log('mode: ' + data.m.toString());
    client.send('/mode/change', data.x, data.y, hashCode(socket.id), data.m);
  });
  socket.on('eraseEvent', function (data) {
    console.log('erasing');
    client.send('/sharedFace/canvas/nodejs/wipe', 0, 0, hashCode(socket.id));
  });
  socket.on('undoEvent', function (data) {
    console.log('undoing');
    client.send('/pen/undo', 0, 0, hashCode(socket.id));
  });
});
