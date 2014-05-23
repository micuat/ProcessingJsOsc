import oscP5.*;
import netP5.*;
  
OscP5 oscP5;

int x, y, prevX = -1, prevY = -1;
int id;

void setup() {
  size(640, 640);
  background(54);
  colorMode(HSB, 100);
  
  oscP5 = new OscP5(this,57130);
}


void draw() {
}

void oscEvent(OscMessage theOscMessage) {
  if( theOscMessage.addrPattern().equals("/pen/coord") == true ) {
    x = theOscMessage.get(0).intValue();
    y = theOscMessage.get(1).intValue();
    id = theOscMessage.get(2).intValue();
    stroke(id % 100, 100, 100);
    
    if( prevX >= 0 ) line(prevX, prevY, x, y);
    prevX = x;
    prevY = y;
  }
  else if( theOscMessage.addrPattern().equals("/pen/pressed") == true ) {
    prevX = theOscMessage.get(0).intValue();
    prevY = theOscMessage.get(1).intValue();
  }
  if( theOscMessage.addrPattern().equals("/pen/released") == true ) {
    prevX = -1;
    prevY = -1;
  }
  if( theOscMessage.addrPattern().equals("/pen/erase") == true ) {
    colorMode(RGB, 256);
    background(54);
  }
}

