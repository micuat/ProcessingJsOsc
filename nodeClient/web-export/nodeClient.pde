/* @pjs preload="image.jpg, eye.png"; */

PImage img;
ArrayList stampImgs;
PVector prev;
ArrayList stampXY;
int boxSize;
int mode = 0;
int numModes = 8;
int countToGood = 0;
PVector viewportXY, viewportWH;
float vZoom; // zoom rate compared to window height
boolean drawingValid = false;
int curStamp;

ArrayList points;

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
  points = new ArrayList();
  stampImgs = new ArrayList();
  stampXY = new ArrayList();
  prev = new PVector();
  viewportXY = new PVector();
  viewportWH = new PVector();
  frameRate(30);
  smooth();

  fill(204, 50, 50, 255);

  strokeWeight(3);

  img = loadImage("image.jpg");
  stampImgs.add(loadImage("eye.png"));

  stampXY.add(new PVector());
  stampXY.add(new PVector());

  refresh(true);
}

void refresh(boolean hardReset) {
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

  colorMode(HSB, numModes);
  noFill();
  for ( int i = 0; i < numModes; i++ ) {
    stroke(i, numModes, numModes);
    rect(width - boxSize, boxSize * i + 1, boxSize - 2, boxSize - 3);
  }
  noStroke();
  colorMode(RGB, 255);
  fill(200);
  rect(width - boxSize, height - boxSize, boxSize, boxSize);

  rectMode(CENTER);

  // restore lines and stamps
  stroke(200);
  int prevX = -1, prevY = -1;
  for ( int i = 0; i < points.size(); i++ ) {
    PVector p = points.get(i);
    if ( prevX >= 0 && p.x >= 0 ) {
      line(prevX, prevY, p.x, p.y);
    }
    prevX = (int)p.x;
    prevY = (int)p.y;
  }

  // clear stamps when hard reset
  if ( hardReset ) {
    for (int i = 0; i < stampXY.size(); i++) {
      stampXY.get(i).x = i * 100;
      stampXY.get(i).y = 50;
    }
  }

  drawStamp(0);
  drawStamp(1);
}

void draw() {
}

void drawStamp(int index) {
  PImage s;
  if ( index == 0 ) s = stampImgs.get(0);
  if ( index == 1 ) s = stampImgs.get(0);

  float stampSizeX = s.width * vZoom;
  float stampSizeY = s.height * vZoom;

  pushMatrix();
  translate(stampXY.get(index).x, stampXY.get(index).y);
  if ( index == 1 ) scale(-1, 1);
  image(s, - stampSizeX/2, - stampSizeY/2, 
  stampSizeX, stampSizeY);
  popMatrix();
}

void mousePressed() {
  if ( countToGood >= 2 ) {
    if ( mouseX > width - boxSize ) {
      drawingValid = false;
      // erase
      if ( mouseX > width - boxSize && mouseY > height - boxSize ) {
        emitErase();
        points.clear();
        refresh(true);
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
    else { //if (mouseX < viewportWH.x) {
      drawingValid = true;
      // pen
      if ( mode == 0 ) {
        prev.x = mouseX;
        prev.y = mouseY;
        points.add(new PVector(mouseX, mouseY));
      } 
      // update stamp
      else if ( mode == 1 ) {
        curStamp = -1;
        for (int i = 0; i < stampXY.size(); i++ ) {
          if (stampXY.get(i).dist(new PVector(mouseX, mouseY)) < 100) {
            stampXY.get(i).x = mouseX;
            stampXY.get(i).y = mouseY;
            drawStamp(i);
            curStamp = i;
            break;
          }
        }
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
    refresh(true);
  }
}

void mouseDragged() {
  if ( countToGood >= 2 && drawingValid ) {
    emitMouse(toImCoordX(mouseX), toImCoordY(mouseY), mode);
    if ( mode == 0 ) {
      points.add(new PVector(mouseX, mouseY));
      if ( prev.x >= 0 ) {
        stroke(200);
        line(prev.x, prev.y, mouseX, mouseY);
        prev.x = mouseX;
        prev.y = mouseY;
      }
    } 
    else if ( mode == 1 ) {
      if ( curStamp >= stampXY.size() || curStamp < 0) return;
      stampXY.get(curStamp).x = mouseX;
      stampXY.get(curStamp).y = mouseY;
      drawStamp(curStamp);
    }
  }
}

void mouseReleased() {
  if ( countToGood >= 2 && drawingValid ) {
    prev.x = -1;
    prev.y = -1;
    if ( mode == 0 ) {
      points.add(new PVector(-1, -1));
    }
    if ( mouseX > width - boxSize && mouseY > height - boxSize ) {
    } 
    else {
      emitReleased(toImCoordX(mouseX), toImCoordY(mouseY), mode);
    }
  }
  if ( countToGood >= 2 && mode == 1 ) {
    refresh(false); // soft reset
  }
}


