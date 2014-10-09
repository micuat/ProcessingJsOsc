/* @pjs preload="image.jpg"; */

PImage img;
PVector prev;
PVector stamp;
int boxSize;
int mode = 0;
int numModes = 8;
int countToGood = 0;
PVector viewportXY, viewportWH;
float vZoom; // zoom rate compared to window height
boolean drawingValid = false;

float toImCoordX(float x) {
  return x / vZoom + viewportXY.x;
}

float toImCoordY(float y) {
  return y / vZoom + viewportXY.y;
}

void setup() {
  size(640, 640);
  size(window.innerWidth, window.innerHeight);

  boxSize = 50;
  prev = new PVector();
  stamp = new PVector();
  viewportXY = new PVector();
  viewportWH = new PVector();
  frameRate(30);
  smooth();

  fill(204, 50, 50, 255);

  strokeWeight(3);

  img = loadImage("image.jpg");

  refresh();
}

void refresh() {
  rectMode(CORNER);

  background(54);
  if ( countToGood >= 2 ) {
    // cropping
    copy(img, viewportXY.x, viewportXY.y, viewportWH.x, viewportWH.y, 
    0, 0, vZoom * viewportWH.x, height);
  }
  else {
    image(img, 0, 0);
  }
  //fill(0, 104);
  //rect(0, 0, width, height);

  colorMode(HSB, numModes - 1);
  noFill();
  for ( int i = 0; i < numModes; i++ ) {
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
  if ( countToGood >= 2 ) {
    if ( mouseX > width - boxSize ) {
      drawingValid = false;
      // erase
      if ( mouseX > width - boxSize && mouseY > height - boxSize ) {
        emitErase();
        refresh();
      }
      // buttons
      else {
        for ( int i = 0; i < numModes; i++ ) {
          if ( boxSize * i <= mouseY && mouseY < boxSize * (i+1)) {
            mode = i;
            emitModeChange(toImCoordX(mouseX), toImCoordY(mouseY), mode);
            break;
          }
        }
      }
    } 
    else {
      drawingValid = true;
      // pen
      if ( mode == 0 ) {
        prev.x = mouseX;
        prev.y = mouseY;
      } 
      // update stamp
      else if ( mode == 1 ) {
        noStroke();
        fill(54);
        rect(stamp.x, stamp.y, 30, 30);
        stamp.x = mouseX;
        stamp.y = mouseY;
        fill(200);
        ellipse(stamp.x, stamp.y, 30, 30);
      }
      emitPressed(toImCoordX(mouseX), toImCoordY(mouseY), mode);
    }
  }
  // top left
  else if ( countToGood == 0 ) {
    viewportXY.x = mouseX;
    viewportXY.y = mouseY;
    rect(viewportXY.x, viewportXY.y, 2, 2);
    countToGood += 1;
  }
  // bottom right
  else if ( countToGood == 1 ) {
    viewportWH.x = mouseX - viewportXY.x;
    viewportWH.y = mouseY - viewportXY.y;
    vZoom = height / viewportWH.y; 
    countToGood += 1;
    refresh();
  }
}

void mouseDragged() {
  if ( countToGood >= 2 && drawingValid ) {
    emitMouse(toImCoordX(mouseX), toImCoordY(mouseY), mode);
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
}

void mouseReleased() {
  if ( countToGood >= 2 && drawingValid ) {
    prev.x = -1;
    prev.y = -1;
    if ( mouseX > width - boxSize && mouseY > height - boxSize ) {
    } 
    else {
      emitReleased(toImCoordX(mouseX), toImCoordY(mouseY), mode);
    }
  }
}


