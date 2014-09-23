// note, io.listen(<port>) will create a http server for you
var io = require('socket.io').listen(8080);
var osc = require('node-osc');
var client = new osc.Client('127.0.0.1', 57130);

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
  
  socket.on('mouseEvent', function (data) {
    if( data.m == 0 ) {
      client.send('/pen/coord', data.x, data.y, hashCode(socket.id), data.m);
    } else {
      client.send('/stamp/coord', data.x, data.y, hashCode(socket.id), data.m);
    }
  });
  socket.on('mousePressed', function (data) {
    console.log(socket.id);
    if( data.m == 0 ) {
      client.send('/pen/pressed', data.x, data.y, hashCode(socket.id), data.m);
    } else {
      client.send('/stamp/pressed', data.x, data.y, hashCode(socket.id), data.m);
    }
  });
  socket.on('mouseReleased', function (data) {
    if( data.m == 0 ) {
      client.send('/pen/released', data.x, data.y, hashCode(socket.id), data.m);
    } else {
      client.send('/stamp/released', data.x, data.y, hashCode(socket.id), data.m);
    }
  });
  socket.on('eraseEvent', function (data) {
    console.log('erasing');
    client.send('/pen/erase', 0, 0, hashCode(socket.id));
  });
});
