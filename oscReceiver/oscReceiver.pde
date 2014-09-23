import oscP5.*;
import netP5.*;
  
OscP5 oscP5;

int x, y, prevX = -1, prevY = -1;
int id;
int mode;
int stampX = 0, stampY = 0;

void setup() {
  size(640, 640);
  background(54);
  
  oscP5 = new OscP5(this,57130);
}


void draw() {
  background(54);
  ellipse(stampX, stampY, 30, 30);
}

void oscEvent(OscMessage theOscMessage) {
  if( theOscMessage.addrPattern().equals("/pen/coord") == true ) {
    x = theOscMessage.get(0).intValue();
    y = theOscMessage.get(1).intValue();
    id = theOscMessage.get(2).intValue();
    mode = theOscMessage.get(3).intValue();
    stroke(200);
    
    if( mode == 0 ) {
      if( prevX >= 0 ) line(prevX, prevY, x, y);
      prevX = x;
      prevY = y;
    }
  }
  else if( theOscMessage.addrPattern().equals("/pen/pressed") == true ) {
    prevX = theOscMessage.get(0).intValue();
    prevY = theOscMessage.get(1).intValue();
    mode = theOscMessage.get(3).intValue();
  }
  if( theOscMessage.addrPattern().equals("/pen/released") == true ) {
    prevX = -1;
    prevY = -1;
    mode = theOscMessage.get(3).intValue();
  }
  if( theOscMessage.addrPattern().equals("/pen/erase") == true ) {
    background(54);
  }
  
  
  if( theOscMessage.addrPattern().equals("/stamp/coord") == true ||
      theOscMessage.addrPattern().equals("/stamp/pressed") == true ) {
    stampX = theOscMessage.get(0).intValue();
    stampY = theOscMessage.get(1).intValue();
    mode = theOscMessage.get(3).intValue();
  }
}

