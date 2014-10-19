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
    if( data.s == -1 ) {
      client.send('/pen/coord', Number(data.x), Number(data.y), Number(data.m), hashCode(socket.id));
    } else {
      client.send('/stamp/coord', Number(data.x), Number(data.y), hashCode(socket.id), Number(data.s));
    }
  });
  socket.on('mousePressed', function (data) {
    console.log(socket.id);
    if( data.s == -1 ) {
      client.send('/pen/pressed', Number(data.x), Number(data.y), Number(data.m), hashCode(socket.id));
    } else {
      client.send('/stamp/pressed', Number(data.x), Number(data.y), hashCode(socket.id), Number(data.s));
      console.log(data.s);
    }
  });
  socket.on('mouseReleased', function (data) {
    if( data.s == -1 ) {
      client.send('/pen/released', Number(data.x), Number(data.y), Number(data.m), hashCode(socket.id));
    } else {
      client.send('/stamp/released', Number(data.x), Number(data.y), hashCode(socket.id), Number(data.s));
    }
  });
  socket.on('modeChange', function (data) {
    console.log('mode: ' + data.m.toString());
    client.send('/mode/change', data.x, data.y, hashCode(socket.id), data.m);
  });
  socket.on('eraseEvent', function (data) {
    console.log('erasing');
    client.send('/pen/erase', 0, 0, hashCode(socket.id));
  });
  socket.on('undoEvent', function (data) {
    console.log('undoing');
    client.send('/pen/undo', 0, 0, hashCode(socket.id));
  });
});
