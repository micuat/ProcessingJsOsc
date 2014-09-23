ArrayList<PVector> points;
PVector stamp;
int boxSize;
int mode = 0;

void setup() {
  size(640,640);
  size(window.innerWidth, window.innerHeight);
  
  boxSize = 50;
  points = new ArrayList<PVector>();
  stamp = new PVector();
  frameRate(30);
  smooth();
  
  fill(204, 50, 50, 255);
  
  strokeWeight(3);
}

void draw() {
  background(54);
  
  stroke(200);
  int prevX = -1, prevY = -1;
  for( PVector p: points ) {
    if( prevX >= 0 && p.x >= 0 ) {
      line(prevX, prevY, p.x, p.y);
    }
    prevX = (int)p.x;
    prevY = (int)p.y;
  }

  ellipse(stamp.x, stamp.y, 30, 30);
  
  noStroke();
  fill(255, 255, 255, 54);
  rect(0, 0, width, height);
  
  fill(200, 50, 50);
  rect(width - boxSize, 0, boxSize, boxSize);
  fill(50, 200, 100);
  rect(width - boxSize, boxSize, boxSize, boxSize);
  fill(200);
  rect(width - boxSize, height - boxSize, boxSize, boxSize);

}

void mousePressed() {
  if( mouseX > width - boxSize ) {
    if( 0 <= mouseY && mouseY < boxSize ) {
      mode = 0;
    } else if( boxSize <= mouseY && mouseY < boxSize * 2 ) {
      mode = 1;
    } else if( mouseX > width - boxSize && mouseY > height - boxSize ) {
      emitErase();
      points.clear();
    }
  } else {
    if( mode == 0 ) {
      points.add(new PVector(mouseX, mouseY));
    } else if( mode == 1 ) {
      stamp.x = mouseX;
      stamp.y = mouseY;
    }
    emitPressed(mouseX, mouseY, mode);
  }
}

void mouseDragged() {
  stroke(200);
  emitMouse(mouseX, mouseY, mode);
//  if( mousePrev.x >= 0 && mousePrev.y >= 0 ) {
    if( mode == 0 ) {
      points.add(new PVector(mouseX, mouseY));
    } else if( mode == 1 ) {
      stamp.x = mouseX;
      stamp.y = mouseY;
    }
//  }
}

void mouseReleased() {
  points.add(new PVector(-1, -1));
  if( mouseX > width - boxSize && mouseY > height - boxSize ) {
  } else {
    emitReleased(mouseX, mouseY, mode);
  }
}

