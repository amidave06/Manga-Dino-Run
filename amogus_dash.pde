import java.util.*;
import g4p_controls.*;
import processing.sound.*;

float yPos = 0;
float yVel = 0;
float gravity = 0.6;
float jumpHeight = 13;
float doubleJumpHeight = 13;
float squareSize = 60;
float floor = 400;
float speed = 5;
float acceleration = 0.08; //0.08
int coinCounter;
int totalCoins;
int gachaCost = 5;
boolean jumpPrimed = false;
boolean jumped = false;
PImage title;
PImage gameEnd;
PFont font;

int gameScreen = 0; // 0: title; 1: main; 2: game over; 3: gacha

GImageButton playButton;
String[] playButtonFiles;
GImageButton gachaButton;
String[] gachaButtonFiles;

GImageButton replayButton;
String[] replayButtonFiles;

// GACHA
ArrayList<skin> skins=new ArrayList<skin>();
GImageButton myButton;
GImageButton toCollection;
GImageButton exitGachaButton;
String[] rollButtonFiles;
String[] collectionButtonFiles;
String[] exitGachaButtonFiles;
float rouletteSpeed=0;
float dRouletteSpeed=0;
int pointerLocation=0;
boolean resultConfirmed=true;
skin reward;
ArrayList<skin> skinCollection=new ArrayList<skin>();
int screenNum=0;
PFont f;
PImage currentSkin;
int iterations=0;
boolean rouletteGenerated=false;
skin[] roulette;




coin[] coins = new coin[2];
obstacle o = new obstacle();

void setup() {
  size(600, 600);
  rollButtonFiles = new String [] { "roll.png", "rollh.png", "rollh.png" };
  collectionButtonFiles = new String [] {"back.png", "backh.png", "backh.png"};
  exitGachaButtonFiles = new String [] {"backleft.png", "backlefth.png", "backlefth.png"};
  resetMain();
  o.reset();
  title = loadImage("title_screen.png");
  gameEnd = loadImage("game_over.png");
  setTitleScreen();

  // GACHA
  skins.add(new skin("amogus.png"));
  skins.add(new skin("dragon.png"));
  skins.add(new skin("cate.png"));
  skins.add(new skin("quaso.png"));
  skins.add(new skin("cirno.png"));
  skins.add(new skin("pochita.png"));
  skins.add(new skin("rayo.png"));
  skins.add(new skin("New Piskel.gif"));
  skins.add(new skin("Skin.gif"));
  size(600, 600);
  f=createFont("Axolotl.ttf", 100);
  textFont(f);
  currentSkin=loadImage("default.png");
  roulette=new skin[12];
  populateRoulette();
}

void draw() {
  switch (gameScreen) {
  case 0:
    drawTitleScreen();
    break;
  case 1:
    drawMain();
    break;
  case 2:
    drawGameOver();
    break;
  case 3:
    drawGacha();
    break;
  }
}


void drawMain() {
  background(0);
  o.update();
  for (coin c : coins) {
    c.update();
  }

  yPos += yVel;
  yVel += gravity;

  if (yPos > floor - squareSize) {
    yPos = floor - squareSize;
    yVel = 0;
    jumpPrimed = false;
    jumped = false;
  }

  image(currentSkin, 50, yPos, squareSize, squareSize);

  fill(0);
  stroke(255);
  strokeWeight(5);
  //line(0, floor, width, floor);
  rect(0 - 20, floor, width + 40, height);

  fill(255);
  textAlign(LEFT);
  textSize(80);
  text("Coins: " + str(coinCounter), 4, 34);
}

void drawTitleScreen() {
  background(0);
  image(title, 0, 0, width, height);
}

void drawGameOver() {
  background(0);
  image(gameEnd, 0, 0, width, height);
}

void drawGacha() {
  background(0);
  image(currentSkin, width/2-50, height-150, 100, 100);
  if (screenNum==0) {
    if (skins.size()==0) {
      fill(255);
      textAlign(CENTER);
      textSize(100);
      text("All skins found.", width/2, height/2 - 30);
      text("Congratulations!", width/2, height/2 + 30);
      if (myButton!=null) {
        myButton.dispose();
        myButton=null;
      }
    } else {
      fill(255);
      rect(0, height/2-height/8, width, height/8);
      float x=0;
      int nextSkin=0;
      while (x<width) {
        if (nextSkin>=roulette.length)
          nextSkin=0;
        image(roulette[nextSkin].img, x, height/2-height/12, 50, 50);
        x+=50;
        nextSkin++;
      }
      rouletteGenerated=true;
      if (rouletteSpeed>0) {
        pointerLocation+=rouletteSpeed;
        if (pointerLocation>width) {
          pointerLocation=pointerLocation-width+10;
        }
        iterations++;
        if (iterations==1) {
          rouletteSpeed-=Math.min(dRouletteSpeed, rouletteSpeed);
          dRouletteSpeed-=random(0, 2);
          dRouletteSpeed=Math.max(dRouletteSpeed, 1);
          iterations=0;
        }
      } else if (!resultConfirmed) {
        int index=(pointerLocation/50)%roulette.length;
        reward=roulette[index];
        resultConfirmed=true;
        skinCollection.add(reward);
        skins.remove(reward);
        rouletteGenerated=false;
      }
      noStroke();
      fill(255, 0, 0);
      triangle(pointerLocation-20, height/2-height/8-20, pointerLocation, height/2-height/8, pointerLocation+20, height/2-height/8-20);
    }
  }
  if (screenNum==1) {
    int x=50;
    int y=50;
    for (skin s : skinCollection) {
      image(s.img, x, y, 50, 50);
      x+=50;
      if (x+100>=width) {
        x=100;
        y+=50;
      }
    }
  }
  fill(255);
  textAlign(CENTER);
  textSize(70);
  text("Total Coins: " + str(totalCoins), width/2, height - 10);
}

void resetMain() {
  yPos = floor - squareSize;
  yVel = 0;
  speed = 5;
  coinCounter = 0;
  for (int i = 0; i < coins.length; i++) {
    coins[i] = null;
  }
  for (int i = 0; i < coins.length; i++) {
    coins[i] = new coin(750 + (i * 300), random(30, floor - 30));
  }
  o.reset();
}

void setTitleScreen() {
  gameScreen = 0;
  playButtonFiles = new String [] { "play.png", "playh.png", "playh.png" };
  playButton = new GImageButton(this, width/2-(300/2), height/2, 300, 80, playButtonFiles);
  gachaButtonFiles = new String [] { "gacha.png", "gachah.png", "gachah.png" };
  gachaButton = new GImageButton(this, width/2-(300/2), height/2 + 100, 300, 80, gachaButtonFiles);
}

void setGameOver() {
  gameScreen = 2;
  totalCoins += coinCounter;
  replayButtonFiles = new String [] { "replay.png", "replayh.png", "replayh.png" };
  replayButton = new GImageButton(this, width/2-(300/2), height/2, 300, 80, replayButtonFiles);
}

void setGacha() {
  gameScreen = 3;
  screenNum = 0;
  toCollection = new GImageButton(this, width-100, height-100, 60, 60, collectionButtonFiles);
  myButton=new GImageButton(this, width/2 - 150, height/2 + 30, 300, 80, rollButtonFiles);
  exitGachaButton = new GImageButton(this, 40, height-100, 60, 60, exitGachaButtonFiles);
}


void keyPressed() {
  if (key == ' ' && yPos == floor - squareSize) {
    yVel = -jumpHeight;
  }
  if (key == ' ' && jumpPrimed) {
    yVel = -doubleJumpHeight;
    jumpPrimed = false;
    jumped = true;
  }
}

void keyReleased() {
  if (key == ' ' && !jumped) {
    jumpPrimed = true;
  }
}

void handleButtonEvents(GImageButton button, GEvent event) {
  if (button == playButton) {
    playButton.dispose();
    playButton = null;
    gachaButton.dispose();
    gachaButton = null;
    gameScreen = 1;
    resetMain();
  }
  if (button == replayButton) {
    replayButton.dispose();
    replayButton = null;
    gameScreen = 0;
    setTitleScreen();
  }
  if (button == gachaButton) {
    gachaButton.dispose();
    gachaButton = null;
    playButton.dispose();
    playButton = null;
    gameScreen = 3;
    setGacha();
  }
  if (button == exitGachaButton) {
    if (myButton != null) {
      myButton.dispose();
      myButton = null;
    }
    toCollection.dispose();
    toCollection = null;
    exitGachaButton.dispose();
    exitGachaButton = null;
    gameScreen = 0;
    setTitleScreen();
  }



  //GACHA
  if (gameScreen == 3) {
    if (button==myButton&&resultConfirmed) {
      if (totalCoins >= gachaCost) {
        populateRoulette();
        pointerLocation=0;
        rouletteSpeed=width/5;
        dRouletteSpeed=10;
        resultConfirmed=false;
        totalCoins -= gachaCost;
      }
    } else if (button==toCollection&&resultConfirmed) {
      if (screenNum==0) {
        screenNum=1;
        if (myButton!=null) {
          myButton.dispose();
          myButton=null;
        }
      } else if (screenNum==1) {
        screenNum=0;
        myButton=new GImageButton(this, width/2 - 150, height/2 + 30, 300, 80, rollButtonFiles);
      }
    }
  }
}
