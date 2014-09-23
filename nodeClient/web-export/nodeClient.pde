PVector mousePrev;
int boxSize;
int mode = 0;

void setup() {
  size(640,640);
  size(window.innerWidth, window.innerHeight);
  
  boxSize = 50;
  mousePrev = new PVector(-1, -1);
  frameRate(30);
  smooth();
  
  fill(204, 50, 50, 255);
  
  strokeWeight(3);
}

void draw() {
  background(54);
  noStroke();
  fill(255, 255, 255, 54);
  rect(0, 0, width, height);
  
  fill(200, 50, 50);
  rect(width - boxSize, 0, boxSize, boxSize);
  fill(50, 200, 100);
  rect(width - boxSize, boxSize, boxSize, boxSize);
  fill(200);
  rect(width - boxSize, height - boxSize, boxSize, boxSize);
  
  if( mode == 0 ) {
    line(mousePrev.x, mousePrev.y, mouseX, mouseY);
  } else if( mode == 1 ) {
    ellipse(mouseX, mouseY, 30, 30);
  }
}

void mousePressed() {
  if( mouseX > width - boxSize ) {
    if( 0 <= mouseY && mouseY < boxSize ) {
      mode = 0;
    } else if( boxSize <= mouseY && mouseY < boxSize * 2 ) {
      mode = 1;
    } else if( mouseX > width - boxSize && mouseY > height - boxSize ) {
      emitErase();
    }
  } else {
    emitPressed(mouseX, mouseY, mode);
  }
}

void mouseDragged() {
  stroke(200);
  if( mousePrev.x >= 0 && mousePrev.y >= 0 ) {
    emitMouse(mouseX, mouseY, mode);
  }
  mousePrev.x = mouseX;
  mousePrev.y = mouseY;
}

void mouseReleased() {
  mousePrev = new PVector(-1, -1);
  if( mouseX > width - boxSize && mouseY > height - boxSize ) {
  } else {
    emitReleased(mouseX, mouseY, mode);
  }
}


