PVector prev;
PVector boxSize;
int mode = 0;
int penColor = 0;

PFont f;

void setup() {
  size(640, 640);
  size(window.innerWidth, window.innerHeight);

  f = createFont("Optima", 72);
  textFont(f);

  boxSize = new PVector(window.innerWidth / 2, window.innerHeight / 3);
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

  noFill();
  for ( int i = 0; i < 3; i++ ) {
    stroke(150, 170, 254);
    fill(150, 170, 254);
    if ( i != mode ) noFill();
    rect(boxSize.x, boxSize.y * i + 1, boxSize.x - 2, boxSize.y - 3);
    pushMatrix();
    translate(boxSize.x * 1.5f, boxSize.y * (i + 0.5f));
    rotate(PI/2);
    textAlign(CENTER, CENTER);
    fill(0);
    if ( i == 0 ) {
      text("oil", 0, 0);
    } else if ( i == 1) {
      text("water", 0, 0);
    } else {
      text("wipe", 0, 0);
    }
    popMatrix();
  }
  noFill();
  stroke(204);
}

void processMouse() {
  if ( mouseX > boxSize.x ) {
    if ( mouseY < boxSize.y ) {
      // oil
      emitColorChange((float)penColor / 16.0f);
      emitViscosityChange(0.8f, 0.1f);
      mode = 0;
    } else if ( mouseY < boxSize.y * 2 ) {
      // water
      emitColorChange((float)penColor / 16.0f);
      emitViscosityChange(0.99f, 1.0f);
      mode = 1;
    } else {
      emitViscosityChange(0.99f, 0.1f);
      emitErase();
      mode = 2;
    }
  }
  // pen color
  else {
    penColor = (int)map(mouseY, 0, height, 0, 16);
    emitColorChange((float)penColor / 16.0f);
    if ( mode == 2 ) {
      emitViscosityChange(0.8f, 0.1f);
      mode = 0;
    }
  }
  drawSidebar();
}

void mousePressed() {
  processMouse();
}

void mouseDragged() {
  processMouse();
}

