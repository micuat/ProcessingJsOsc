PVector prev;
PVector stamp;
int boxSize;
int mode = 0;
int numModes = 8;

void setup() {
  size(640, 640);
  size(window.innerWidth, window.innerHeight);

  boxSize = 50;
  prev = new PVector();
  stamp = new PVector();
  frameRate(30);
  smooth();

  fill(204, 50, 50, 255);

  strokeWeight(3);

  refresh();
}

void refresh() {
  rectMode(CORNER);
  
  background(54);

//  fill(255, 255, 255, 54);
//  rect(0, 0, width, height);
  
  colorMode(HSB, numModes - 1);
  noFill();
  for( int i = 0; i < numModes; i++ ) {
    stroke(i, numModes - 1, numModes - 1);
    rect(width - boxSize, boxSize * i + 1, boxSize - 2, boxSize - 3);
  }
  noStroke();
  colorMode(RGB, 255);
  fill(200);
  rect(width - boxSize, height - boxSize, boxSize, boxSize);
  
  rectMode(CENTER);
}

void draw() {
}

void mousePressed() {
  if ( mouseX > width - boxSize ) {
    if ( mouseX > width - boxSize && mouseY > height - boxSize ) {
      emitErase();
      refresh();
    }
    else {
      for( int i = 0; i < numModes; i++ ) {
        if ( boxSize * i <= mouseY && mouseY < boxSize * (i+1)) {
          mode = i;
          emitModeChange(mouseX, mouseY, mode);
          break;
        }
      }
    }
  } 
  else {
    if ( mode == 0 ) {
      prev.x = mouseX;
      prev.y = mouseY;
    } 
    else if ( mode == 1 ) {
      noStroke();
      fill(54);
      rect(stamp.x, stamp.y, 30, 30);
      stamp.x = mouseX;
      stamp.y = mouseY;
      fill(200);
      ellipse(stamp.x, stamp.y, 30, 30);
    }
    emitPressed(mouseX, mouseY, mode);
  }
}

void mouseDragged() {
  emitMouse(mouseX, mouseY, mode);
  if ( mode == 0 ) {
    if ( prev.x >= 0 ) {
      stroke(200);
      line(prev.x, prev.y, mouseX, mouseY);
      prev.x = mouseX;
      prev.y = mouseY;
    }
  } 
  else if ( mode == 1 ) {
    noStroke();
    fill(54);
    rect(stamp.x, stamp.y, 30, 30);
    stamp.x = mouseX;
    stamp.y = mouseY;
    fill(200);
    ellipse(stamp.x, stamp.y, 30, 30);
  }
}

void mouseReleased() {
  prev.x = -1;
  prev.y = -1;
  if ( mouseX > width - boxSize && mouseY > height - boxSize ) {
  } 
  else {
    emitReleased(mouseX, mouseY, mode);
  }
}


