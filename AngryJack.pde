PImage farm;
PImage pumpkin;
PImage scarecrow;

final static float pumpkinStartX = 4;
final static float pumpkinStartY = 650;
float pX = pumpkinStartX;
float pY = pumpkinStartY;

float vX = 15;
float vY = -30;

float scarecrowX = 700;
float scarecrowY = 440;
boolean scarecrowAlive = true;
float scarecrowAngle=1;

static final float GRAVITY = -1;

static final int READY = 0;
static final int FIRE = 1;
static final int HIT = 2;
static final int DEAD = 3;
static final int MISS = 4;

int mode = READY;

color red;

void setup() {
  red = color(255, 0, 0);
  size (1024, 768);
  farm = loadImage("Background.png");
  pumpkin = loadImage("Pumpkin.png");
  scarecrow = loadImage("Scarecrow.png");
}

void draw() {
  background (farm);
  if (mode == FIRE || mode == HIT) {
    pX += vX;
    pY += vY;
    vY -= GRAVITY;

    if (pY + pumpkin.height >= scarecrowY + scarecrow.height) {
      vY /= -1.5;
      vX /= 1.5;
      if (Math.abs(vY) < 1) vY = 0;
      if (Math.abs(vX) < 1) vX = 0;

      if (pX < 0 || pX > width) {
        mode = MISS;
      }

      if (vX == 0 && vY == 0) {
        mode = DEAD;
      }
    }
  }

  if (mode == READY) {
    drawVector();
  }

  if (mode == FIRE) {
    if ((pX + pumpkin.width >= scarecrowX)&&
      (pX < scarecrowX + scarecrow.width)&&
      (pY + pumpkin.height >= scarecrowY)&&
      (pY < scarecrowY + scarecrow.height)) {
      mode = HIT;
      scarecrowAlive = false;

      vX /= -1.5;
    }
  } else if (mode == DEAD || mode == MISS) {
    if (scarecrowAlive) {
      textSize(28);
      text("Scarecrow survived, click to try again.", width/3, height/2);
    } else {
      textSize(28);
      text("Nice smash!", width/3, height/2);
    }
  }

  image (pumpkin, pX, pY);
  drawScarecrow();
}

void drawScarecrow() {
  if (scarecrowAlive) {
    image (scarecrow, scarecrowX, scarecrowY);
  } else {
    scarecrowAngle = Math.min(scarecrowAngle * 2, 90);
    translate(scarecrowX+scarecrow.width/2, scarecrowY+scarecrow.height);
    rotate(scarecrowAngle * PI/180);
    translate(-scarecrow.width/2, -scarecrow.height);
    image(scarecrow, 0, 0);
  }
}

void drawVector() {
  stroke(red);
  fill(red);
  float rise = Math.abs(mouseY - (pY+pumpkin.height/2));
  float run = Math.abs(mouseX - (pX+pumpkin.width/2));

  if (rise < 400 && run < 400) {
    float angle=atan(rise/run);

    line(pX+pumpkin.width/2, pY+pumpkin.height/2, mouseX, mouseY);
    float p1X = mouseX - 15 * sin(angle + PI/3);
    float p1Y = mouseY - 15 * cos(angle + PI/3);
    float p2X = mouseX + 15 * sin(angle - PI/3);
    float p2Y = mouseY + 15 * cos(angle - PI/3);
    println("["+angle*180/PI+"]");
    println(String.format("(%d, %d) (%f, %f) (%f, %f)", mouseX, mouseY, p1X, p1Y, p2X, p2Y));
    triangle(mouseX, mouseY, p1X, p1Y, p2X, p2Y);
  } else {
    textSize(28);
    text("Move closer to the pumpkin.", width/3, height/2);
  }
}

void mousePressed() {
  if (mode == MISS || mode == DEAD) {
    mode = READY;
    pX = pumpkinStartX;
    pY = pumpkinStartY;

    vX = 15;
    vY = -30;

    scarecrowAlive = true;
    scarecrowAngle = 1;
  } else if (mode == READY) {
    mode = FIRE;
    vX = (mouseX - (pX + pumpkin.width/2))/10;
    vY = (mouseY - (pY + pumpkin.height/2))/10;
  }
}

