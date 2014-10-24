/* @pjs preload="image.jpg, eye1r.png, eye1l.png, eye2r.png, eye2l.png, kizu.png, star.png, ball1.png, ball2.png, ball3.png"; */

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
int penColor = 0;
float imageScale = 0.6 * 0.33;

PFont f;

ArrayList points;
ArrayList colors;

float toImCoordX(float x) {
  return x / vZoom + viewportXY.x;
}

float toImCoordY(float y) {
  return y / vZoom + viewportXY.y;
}

void setup() {
  size(640, 640);
  size(window.innerWidth, window.innerHeight);

  f = createFont("Optima", 72);
  textFont(f);

  boxSize = 50;
  points = new ArrayList();
  colors = new ArrayList();
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
  stampImgs.add(loadImage("eye1r.png"));
  stampImgs.add(loadImage("eye1l.png"));
  stampImgs.add(loadImage("eye2r.png"));
  stampImgs.add(loadImage("eye2l.png"));
  stampImgs.add(loadImage("kizu.png"));
  stampImgs.add(loadImage("star.png"));
  stampImgs.add(loadImage("ball1.png"));
  stampImgs.add(loadImage("ball2.png"));
  stampImgs.add(loadImage("ball3.png"));

  for ( int i = 0; i < stampImgs.size(); i++ ) {
    stampXY.add(new PVector());
  }

  refresh(true);
}

void refresh(boolean hardReset) {
  rectMode(CORNER);
  imageMode(CORNER);

  background(54);
  if ( countToGood >= 2 ) {
    // cropping
    copy(img, viewportXY.x, viewportXY.y, viewportWH.x, viewportWH.y, 
    0, 0, vZoom * viewportWH.x, height);
  }
  else {
    image(img, 0, 0);
  }

  noStroke();

  int bw = (width - boxSize*2) / 16;
  for ( int i = 0; i < 16; i++ ) {
    if ( i % 2 == 0 )
      fill(0, 154);
    else fill(255, 100, 10, 154);
    rect(i * bw, height - 150, bw, 150);
  }
  fill(0, 154);
  rect(bw - 5, height - 120, bw*14+10, 100);
  fill(255);
  text("sharedFace @ IVRC 2014", 50, height - 50);


  drawSidebar();

  rectMode(CENTER);

  // restore lines and stamps

  // clear stamps when hard reset
  if ( hardReset ) {
    for (int i = 0; i < stampXY.size(); i++) {
      stampXY.get(i).x = 50 + i * 75;
      stampXY.get(i).y = 50 + 50 * (i%2==0?1:0);
    }
  }

  for (int i = 0; i < stampXY.size(); i++) {
    drawStamp(i);
  }

  int prevX = -1, prevY = -1;
  for ( int i = 0; i < points.size(); i++ ) {
    PVector p = points.get(i);
    if ( prevX >= 0 && p.x >= 0 ) {
      stroke(colors.get(i)==0?255:0, colors.get(i)==1?255:0, colors.get(i)==2?255:0);
      line(prevX, prevY, p.x, p.y);
    }
    prevX = (int)p.x;
    prevY = (int)p.y;
  }
}

void draw() {
}

void drawStamp(int index) {
  PImage s;
  s = stampImgs.get(index);

  float stampSizeX = s.width * vZoom;
  float stampSizeY = s.height * vZoom;

  pushMatrix();
  translate(stampXY.get(index).x, stampXY.get(index).y);
  scale(imageScale * vZoom, imageScale * vZoom);
  imageMode(CENTER);
  image(s, 0, 0);
  imageMode(CORNER);
  popMatrix();
}

void drawSidebar() {
  rectMode(CORNER);
  fill(54);
  noStroke();
  rect(width - boxSize * 2 - 1, 0, boxSize * 2, height - boxSize);

  fill(150);
  rect(width - boxSize, height - boxSize * 3, boxSize, boxSize);
  fill(200);
  rect(width - boxSize, height - boxSize, boxSize, boxSize);

  noFill();
  for ( int i = 0; i < 4; i++ ) {
    stroke(i==0?255:0, i==1?255:0, i==2?255:0);
    if ( i == penColor ) fill(i==0?255:0, i==1?255:0, i==2?255:0);
    rect(width - boxSize * 2 - 1, boxSize * i + 1, boxSize - 2, boxSize - 3);
    if ( i == penColor ) noFill();
  }

  noFill();
  for ( int i = 0; i < numModes; i++ ) {
    if ( i == 0 || i == 2 || i == 3 || i == 4 || i == 5 || i == 6 ) {
      stroke(254);
      fill(254);
    }
    else if ( i == 1 || i == 7) {
      stroke(4);
      fill(4);
    }
    if ( i != mode ) noFill();
    rect(width - boxSize, boxSize * i + 1, boxSize - 2, boxSize - 3);
  }
  noFill();
  stroke(204);
}

void mousePressed() {
  if ( countToGood >= 2 ) {
    if ( mouseX > width - boxSize ) {
      drawingValid = false;
      // erase
      if ( mouseY > height - boxSize ) {
        emitErase();
        points.clear();
        colors.clear();
        refresh(true);
      }
      // undo
      else if ( mouseY > height - boxSize * 3 && mouseY < height - boxSize * 2 ) {
        emitUndo();
        points.remove(points.size() - 1);
        colors.remove(points.size() - 1);
        for ( int i = points.size() - 1; i >= 0; i-- ) {
          PVector p = points.get(i);
          if ( p.x >= 0 && p.y >= 0 ) {
            points.remove(i);
            colors.remove(i);
          } 
          else {
            break;
          }
        }
        refresh(false);
      }
      // mode buttons
      else {
        for ( int i = 0; i < numModes; i++ ) {
          if ( boxSize * i <= mouseY && mouseY < boxSize * (i+1)) {
            if ( i <= 1 ) mode = i;
            emitModeChange(toImCoordX(mouseX), toImCoordY(mouseY), i);
            break;
          }
        }
        drawSidebar();
      }
    }
    // pen color
    else if ( mouseX > width - boxSize*2 - 1 ) {
      for ( int i = 0; i < 4; i++ ) {
        if ( boxSize * i <= mouseY && mouseY < boxSize * (i+1)) {
          penColor = i;
          mode = 0; // automatically select pen mode
          break;
        }
      }
      drawSidebar();
    }
    else { //if (mouseX < viewportWH.x) {
      drawingValid = true;
      // pen
      if ( mode == 0 ) {
        curStamp = -1;
        prev.x = mouseX;
        prev.y = mouseY;
        points.add(new PVector(mouseX, mouseY));
        colors.add(penColor);
      } 
      // update stamp
      else if ( mode == 1 ) {
        curStamp = -1;
        for (int i = 0; i < stampXY.size(); i++ ) {
          if (stampXY.get(i).dist(new PVector(mouseX, mouseY)) < 50) {
            stampXY.get(i).x = mouseX;
            stampXY.get(i).y = mouseY;
            drawStamp(i);
            curStamp = i;
            break;
          }
        }
      }
      emitPressed(toImCoordX(mouseX), toImCoordY(mouseY), penColor, curStamp);
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
    emitMouse(toImCoordX(mouseX), toImCoordY(mouseY), penColor, curStamp);
    if ( mode == 0 ) {
      points.add(new PVector(mouseX, mouseY));
      colors.add(penColor);
      if ( prev.x >= 0 ) {
        stroke(penColor==0?255:0, penColor==1?255:0, penColor==2?255:0);
        line(prev.x, prev.y, mouseX, mouseY);
        prev.x = mouseX;
        prev.y = mouseY;
      }
    } 
    else if ( mode == 1 ) {
      if ( curStamp >= stampXY.size() || curStamp < 0) return;
      stampXY.get(curStamp).x = mouseX;
      stampXY.get(curStamp).y = mouseY;
      //drawStamp(curStamp);
      refresh(false);
    }
  }
}

void mouseReleased() {
  if ( countToGood >= 2 && drawingValid ) {
    prev.x = -1;
    prev.y = -1;
    if ( mode == 0 ) {
      points.add(new PVector(-1, -1));
      colors.add(0);
    }
    if ( mouseX > width - boxSize && mouseY > height - boxSize ) {
    } 
    else {
      emitReleased(toImCoordX(mouseX), toImCoordY(mouseY), mode);
    }
  }
  if ( countToGood >= 2 && mode == 1 && curStamp >= 0) {
    refresh(false); // soft reset
  }
}


