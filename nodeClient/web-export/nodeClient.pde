PVector mousePrev;
int boxSize;
boolean started = false;

void setup() {
  size(1024, 768);
  //size(320,320);
  
  boxSize = 50;
  mousePrev = new PVector(-1, -1);
  frameRate(30);
  smooth();
  
  refresh();
  fill(204, 50, 50, 255);
  
  strokeWeight(3);
}

void refresh() {
  background(54);
  noStroke();
  fill(255, 255, 255, 54);
  rect(0, 0, width, height);
  
  fill(200);
  rect(width - boxSize, height - boxSize, boxSize, boxSize);
}

void draw() {
}

void mousePressed() {
  if( !started ) {
    refresh();
    started = true;
    return;
  }
  
  if( mouseX > width - boxSize && mouseY > height - boxSize ) {
    refresh();
    emitErase();
  } else {
    emitPressed(mouseX, mouseY);
  }
}

void mouseDragged() {
  stroke(200);
  if( mousePrev.x >= 0 && mousePrev.y >= 0 ) {
    line(mousePrev.x, mousePrev.y, mouseX, mouseY);
    emitMouse(mouseX, mouseY);
  }
  mousePrev.x = mouseX;
  mousePrev.y = mouseY;
}

void mouseReleased() {
  mousePrev = new PVector(-1, -1);
  if( mouseX > width - boxSize && mouseY > height - boxSize ) {
  } else {
    emitReleased(mouseX, mouseY);
  }
}

