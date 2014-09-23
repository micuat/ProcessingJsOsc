PVector prev;
PVector stamp;
int boxSize;
int mode = 0;

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

  noStroke();
//  fill(255, 255, 255, 54);
//  rect(0, 0, width, height);

  fill(200, 50, 50);
  rect(width - boxSize, 0, boxSize, boxSize);
  fill(50, 200, 100);
  rect(width - boxSize, boxSize, boxSize, boxSize);
  fill(200);
  rect(width - boxSize, height - boxSize, boxSize, boxSize);
  
  rectMode(CENTER);
}

void draw() {
}

void mousePressed() {
  if ( mouseX > width - boxSize ) {
    if ( 0 <= mouseY && mouseY < boxSize ) {
      mode = 0;
    } 
    else if ( boxSize <= mouseY && mouseY < boxSize * 2 ) {
      mode = 1;
    } 
    else if ( mouseX > width - boxSize && mouseY > height - boxSize ) {
      emitErase();
      refresh();
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

