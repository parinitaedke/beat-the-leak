char[] keys = {'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', 'a', 's', 'd', 'e', 'f', 'g', 'h', 'j', 'k', 'l', 'z', 'x', 'c', 'v', 'b', 'n', 'm'};
char[] keysDown = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

float fixSpeed = 1;
Hole[] holeArray = new Hole[25];

int holeTimer = 0;
int holeTimerMax = 60;

float holeTimerReduce = 0;

float water;
float waterFill;

boolean water0Rise = true;
boolean water1Rise = true;

float water0 = 0;
float water1 = 5;
int waterVar = 10;
float waterVarSpeed = 0.25;

int windowWidth = 1200;
int windowHeight = 800;

PImage imageHole;
PImage imageBarrel;

int holesFixed = -holeArray.length-1;
int holesFixedMax = 10;

int waterReward = 100;

int score;

boolean instructions, gameOver, start;

PImage startScreen, EndScreen, instructionScreen;

String [] facts;
String factText;
import ddf.minim.*;
AudioPlayer drip;
AudioPlayer ding;
Minim minim;

void setup() {
  size(1200, 800);
  for (int i = 0; i < holeArray.length; i++) {
    holeArray[i] = new Hole(0, 0, 0);
  }
  println(keys.length);
  water = windowHeight;
  imageHole = loadImage("hole.png");
  imageBarrel = loadImage("barrel.png");
  start=true;
  instructions=false;
  gameOver=false;
  startScreen=loadImage("homescreen.png");
  EndScreen=loadImage("endscreen.png");
  instructionScreen =loadImage("instructions.png");

  facts = new String [5];
  facts[0] ="A garden hose or sprinkler can use almost as much water in an hour as an average family of four uses in one day.";
  facts[1] = "Many people in the world exist on 3 gallons of water per day or less. We can use that amount in one flush of the toilet.";
  facts[2] = "Over 1.5 billion people do not have access to clean, safe water.";
  facts[3] = "The average dishwasher uses over 100 litres per cycle.";
  facts[4] ="On average, women in Africa and Asia have to walk 3.7 miles to collect water.";

  minim = new Minim(this);
  drip = minim.loadFile("drip.mp3");
  ding = minim.loadFile("Ding.mp3");
  drip.loop();
}

void draw() {

  if (start && !instructions &&!gameOver) {
    startScreen();
  } else if (!start && instructions && !gameOver) {
    instructionsScreen();
  } else if (!start && !instructions && !gameOver) {
    playStuff();
  } else if (!start && !instructions && gameOver) {
    gameOverScreen();
  }
}
void init() {
  holeArray = new Hole[25];
  for (int i = 0; i < holeArray.length; i++) {
    holeArray[i] = new Hole(0, 0, 0);
  }
  holeTimer = 0;

  holeTimerReduce = 0;

  water = windowHeight;
  waterFill = 0;

  water0Rise = true;
  water1Rise = true;

  water0 = 0;
  water1 = 5;


  holesFixed = -holeArray.length-1;

  score = 0;
}

void playStuff() {
  background(255);
  imageMode(CORNER);
  alpha(100);
  noTint();
  image(imageBarrel, 0, 0);

  //println(holeTimer);
  fill(0, 150, 255, 60);
  //rectMode(CORNER);
  //rect(0, windowHeight-water, windowWidth, windowHeight);
  animateWater();
  beginShape();
  vertex(0, windowHeight-water-water0);
  vertex(windowWidth, windowHeight-water-water1);
  vertex(windowWidth, windowHeight);
  vertex(0, windowHeight);
  endShape();
  fillWater();

  if (holesFixed == holesFixedMax) {
    waterFill += waterReward;
    holeTimerReduce += 2;
    if (holeTimerReduce > 40) {
      holeTimerReduce = 40;
    }
    holesFixed = 0;
  }



  createHoleLoop();
  for (int i = 0; i < holeArray.length; i++) {
    if (holeArray[i].leakLevel > 0) {
      holeArray[i].loop();
    } else {
      if (!holeArray[i].fixed) {
        score += ceil(holeArray[i].originalLeakLevel);
        ding.rewind();
        ding.play();
        holesFixed++;
        holeArray[i].fixed = true;
      }
    }
  }

  textMode(CORNER);
  fill(255, 115, 0, 255);
  textSize(60);
  text("Score: "+str(score), 5, 60);
  println(score);

  if (water <= 0) {
    gameOver=true;
    start=false;
    factText = facts[floor(random(facts.length-1))];
  }
}

void createHole() {
  Hole newHole;
  float newX = random(50, windowWidth-50);
  float newY = random(windowHeight-water, windowHeight-50);
  if (newY < 50) {
    newY = 50;
  }
  println(newX, newY);
  newHole = new Hole(newX, newY, floor(random(25)+25));
  int i = 0;
  while (holeArray[i].leakLevel > 0) {
    if (i == holeArray.length-1) {  
      break;
    }
    i++;
  }
  if (holeArray[i].leakLevel <= 0) {
    holeArray[i] = newHole;
  }
}

void createHoleLoop() {
  if (holeTimer == holeTimerMax-floor(holeTimerReduce)) {
    createHole();
    holeTimer = 0;
  } else {
    holeTimer++;
  }
}

void keyPressed() {
  if (start && !instructions && !gameOver) {
    if (keyPressed) {
      if ( key == ' ') {
        start = false;
        instructions=false;
        gameOver= false;
      }
      if (keyCode == 'Q' || keyCode =='q') {
        start =false;
        instructions = true;
        gameOver=false;
      }
    }
  } 
  if (!start && instructions && !gameOver) {
    if (keyPressed) {
      if (keyCode =='B' || keyCode =='b') {
        start =true;
        instructions=false;
      }
    }
  }  
  if (!start && !instructions && !gameOver) {
    for (int i = 0; i < keys.length; i++) {
      if (key == keys[i]) {
        keysDown[i] = 1;
      }
    }
  }  
  if (!start &&!instructions && gameOver) { //gotta figure this part out

    if (keyCode=='B' || keyCode=='b') {
      init();
      start=true;
      gameOver=false;
      instructions=false;
    } else if (keyCode ==' ') {
      init();
      start = false;
      gameOver = false;
      instructions=false;
    }
  }
}


void keyReleased() {
  for (int i = 0; i < keys.length; i++) {
    if (key == keys[i]) {
      keysDown[i] = 0;
    }
  }
}

void animateWater() {
  if (water0Rise) {
    water0 += waterVarSpeed;
  } else {
    water0 -= waterVarSpeed;
  }
  if (water0 > waterVar) {
    water0Rise = false;
  } else if (water0 < 0) {
    water0Rise = true;
  }

  if (water1Rise) {
    water1 += waterVarSpeed;
  } else {
    water1 -= waterVarSpeed;
  }
  if (water1 > waterVar) {
    water1Rise = false;
  } else if (water1 < 0) {
    water1Rise = true;
  }
}

void fillWater() {
  float addWater = waterFill/30;
  if (addWater < 0.05) {
    water += waterFill;
    waterFill = 0;
  } else {
    textMode(CENTER);
    textSize(50);
    fill(255, 255, 255, 255*addWater);
    text("Extra water!", windowWidth/2-150+1, windowHeight/2+1);
    fill(0, 255, 0, 255*addWater);
    text("Extra water!", windowWidth/2-150, windowHeight/2);
    water += addWater;
    waterFill -= addWater;
  }
  if (water > windowHeight) { 
    water = windowHeight;
  }
  fill(0, 150, 255, 60);
  rectMode(CENTER);
  rect(windowWidth/2, (windowHeight-water+waterVar)/2, addWater*10, (windowHeight-water+waterVar/2));
}

void startScreen() {
  imageMode(CORNER);
  noTint();
  image (startScreen, 0, 0, width, height);
}

void instructionsScreen() {
  imageMode(CORNER);
  noTint();
  image(instructionScreen, 0, 0, width, height);
}

void gameOverScreen() {
  imageMode(CORNER);
  noTint();
  image(EndScreen, 0, 0, width, height);
  textMode(CENTER);
  textSize(60);
  fill(255, 255, 255, 255);
  text( str(score), windowWidth/2-20, windowHeight/2 -90);

  textMode(CENTER);

  textSize(20);
  //fill(255, 255, 255, 255);

  fill(255);
  textSize(25);
  text(factText, width/2, height/2+200, 900, 300);
}
class Hole {
  float x;  
  float y;
  float leakLevel;
  float originalLeakLevel;
  int Key = floor(random(keys.length));
  boolean fixed = false;
  int tint = 0;
  float fallDepth = 0;

  Hole(float X, float Y, float LeakLevel) {
    x = X;
    y = Y;
    leakLevel = LeakLevel;
    originalLeakLevel = LeakLevel;
  }

  void loop() {

    if (keysDown[Key] == 1) {
      leakLevel -= fixSpeed;
      tint = 255;
    } else {
      if (leakLevel > 0) {
        water -= leakLevel/150;
      }
      tint = 0;
    }

    fallDepth += 6;

    display();
  }

  void display() {
    noStroke();
    imageMode(CENTER);
    tint(tint, 0, 0);
    image(imageHole, x, y, leakLevel*5, leakLevel*5);
    fill(255, 255, 255, 255);
    textSize(30);
    textMode(CENTER);
    text(keys[Key], x, y);
    rectMode(CENTER);
    fill(0, 150, 255, 150);
    rect(x+10, y+(fallDepth/2), leakLevel, fallDepth);
  }

  void reset() {
    score = 0;
  }
}