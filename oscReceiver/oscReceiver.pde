import oscP5.*;
import netP5.*;
  
OscP5 oscP5;

ArrayList<PVector> points;
int id;
int mode;
int stampX = 0, stampY = 0;

void setup() {
  size(640, 640);
  background(54);
  
  oscP5 = new OscP5(this,57130);
  
  points = new ArrayList<PVector>();
}


void draw() {
  background(54);
  ellipse(stampX, stampY, 30, 30);
  
  int prevX = -1, prevY = -1;
  ArrayList<PVector> pointsCopied = (ArrayList<PVector>)points.clone();
  for( PVector p: pointsCopied ) {
    if( prevX >= 0 && p.x >= 0 ) {
      line(prevX, prevY, p.x, p.y);
    }
    prevX = (int)p.x;
    prevY = (int)p.y;
  }
}

void oscEvent(OscMessage theOscMessage) {
  if( theOscMessage.addrPattern().equals("/pen/coord") == true ) {
    int x = theOscMessage.get(0).intValue();
    int y = theOscMessage.get(1).intValue();
    id = theOscMessage.get(2).intValue();
    mode = theOscMessage.get(3).intValue();
    stroke(200);
    
    points.add(new PVector(x, y));
    
//      if( prevX >= 0 ) line(prevX, prevY, x, y);
//      prevX = x;
//      prevY = y;
  }
  else if( theOscMessage.addrPattern().equals("/pen/pressed") == true ) {
    int x = theOscMessage.get(0).intValue();
    int y = theOscMessage.get(1).intValue();
    mode = theOscMessage.get(3).intValue();
    
    points.add(new PVector(x, y));
  }
  if( theOscMessage.addrPattern().equals("/pen/released") == true ) {
    points.add(new PVector(-1, -1));
    mode = theOscMessage.get(3).intValue();
  }
  if( theOscMessage.addrPattern().equals("/pen/erase") == true ) {
    background(54);
    points.clear();
  }
  
  
  if( theOscMessage.addrPattern().equals("/stamp/coord") == true ||
      theOscMessage.addrPattern().equals("/stamp/pressed") == true ) {
    stampX = theOscMessage.get(0).intValue();
    stampY = theOscMessage.get(1).intValue();
    mode = theOscMessage.get(3).intValue();
  }
}

