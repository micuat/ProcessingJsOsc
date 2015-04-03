PVector prev;
PVector boxSize;
int mode = 0;
int numModes = 8;
int penColor = 0;

PFont f;

void setup() {
  size(640, 640);
  size(window.innerWidth, window.innerHeight);

  f = createFont("Optima", 36);
  textFont(f);

  boxSize = new PVector(window.innerWidth / 2, window.innerHeight / 8);
  prev = new PVector();
  frameRate(30);
  smooth();

  fill(204, 50, 50, 255);

  strokeWeight(3);

  drawSidebar();
}

void draw() {
}

void drawSidebar() {
  background(200);
  rectMode(CORNER);
  noFill();
  noStroke();
  colorMode(HSB, 16);
  int h = height / 16;
  for (int i = 0; i < 16; i++) {
    if ( i == penColor)
      fill(i, 15, 15);
    else
      fill(i, 2, 15);
    rect(0, h*i, boxSize.x, h);
  }
  colorMode(RGB, 255);
  //  for ( int i = 0; i < 4; i++ ) {
  //    stroke(i==0?255:0, i==1?255:0, i==2?255:0);
  //    if ( i == penColor ) fill(i==0?255:0, i==1?255:0, i==2?255:0);
  //    rect(0, boxSize.y * i + 1, boxSize.x - 2, boxSize.y - 3);
  //    if ( i == penColor ) noFill();
  //  }

  noFill();
  for ( int i = 0; i < numModes; i++ ) {
    if ( i == 0 || i == 2 || i == 3 || i == 4 || i == 5 || i == 6 ) {
      stroke(254);
      fill(254);
    } else if ( i == 1 || i == 7) {
      stroke(4);
      fill(4);
    }
    if ( i != mode ) noFill();
    rect(boxSize.x, boxSize.y * i + 1, boxSize.x - 2, boxSize.y - 3);
  }
  noFill();
  stroke(204);
}

void processMouse() {
  if ( mouseX > boxSize.x ) {
    // erase
    if ( mouseY > height - boxSize.y ) {
      emitErase();
    }
    // undo
    else if ( mouseY > height - boxSize.y * 3 && mouseY < height - boxSize.y * 2 ) {
      emitUndo();
    }
    // mode buttons
    else {
      for ( int i = 0; i < numModes; i++ ) {
        if ( boxSize.y * i <= mouseY && mouseY < boxSize.y * (i+1)) {
          if ( i <= 1 ) mode = i;
          emitModeChange(mouseX, mouseY, i);
          break;
        }
      }
    }
  }
  // pen color
  else {
    penColor = (int)map(mouseY, 0, height, 0, 16);
    mode = 0; // automatically select pen mode
    emitColorChange((float)penColor / 16.0f);
  }
  drawSidebar();
}

void mousePressed() {
  processMouse();
}

void mouseDragged() {
  processMouse();
}
