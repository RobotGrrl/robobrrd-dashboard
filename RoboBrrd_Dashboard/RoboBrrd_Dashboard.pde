/* RoboBrrd Dashboard v2
 * ------------------------
 *
 * Control your RoboBrrd and set its servo positions!
 *
 * To make RoboBrrd work with this app, be sure to upload the Boilerplate
 * code it it. It's included as an example in the RoboBrrd Arduino library!
 * For more information, please see here:
 * --> http://robobrrd.com/rb3d/programming1.php
 *
 * For more information about how to use the Dashboard app, check out its
 * webpage here:
 * --> http://robobrrd.com/dashboard
 *
 * Released under the MIT license, see license.txt for more info.
 *
 * By Erin Kennedy for RoboBrrd
 * Friday October 31, 2014
 */

import controlP5.*;
import proxml.*;
import processing.serial.*;

static boolean DEBUG = false;

// -- XML -- //
XMLElement settingsXml;
XMLInOut xmlInOut;

// -- GUI -- //
ControlP5 cp5;
ControlP5 cp5_v2;
DropdownList d1;

PFont titleFont;
ControlFont titleFontc5;


// -- POSITIONS -- //
int beakOpenPos = 180;
int beakClosedPos = 0;

int lwingUpPos = 180;
int lwingDownPos = 0;
int lwingHomePos = 90;

int rwingUpPos = 0;
int rwingDownPos = 180;
int rwingHomePos = 90;

// -- SLIDERS -- //
int beakPos;
int leftPos;
int rightPos;

// -- LEDs -- //
// these are true but set to false at the end of setup(), cP5 is weird
int redVal = 0;
int greenVal = 0;
int blueVal = 0;

int redVal_r = 0;
int greenVal_r = 0;
int blueVal_r = 0;

boolean eye_press = false;

boolean eye_changed = false;
long last_eye_change = 0;

color redOn = color(255, 0, 0);  
color greenOn = color(0, 255, 0);
color blueOn = color(0, 0, 255);

color redOff = color(100, 20, 20);  
color greenOff = color(20, 100, 20);
color blueOff = color(20, 20, 100);

color white = color(255, 255, 255);
color black = color(20, 20, 20);

// note: CColor(foreground (hover), background (normal), active (press down), caption label, value label )
CColor red1Colour = new CColor(redOn, redOff, color(255, 100, 100), color(255, 255, 255), color(255, 255, 255));
CColor green1Colour = new CColor(greenOn, greenOff, color(100, 255, 100), color(255, 255, 255), color(255, 255, 255));
CColor blue1Colour = new CColor(blueOn, blueOff, color(100, 100, 255), color(255, 255, 255), color(255, 255, 255));
CColor mix1Colour = new CColor(white, black, color(200, 200, 200), color(140, 140, 140), color(0, 0, 0));


// -- LDRs -- //
int leftLDRReading = 0;
int rightLDRReading = 0;
boolean refresh_ldrs = false;
long last_ldr = 0;


// -- THEMES -- //
boolean estop = false;
long last_estop_send = 0;

int chosenTheme = 0;
int readTheme = 0;
int numThemes = 3;

color[] buttonFg = { color(0, 139, 214), color(30, 255, 0), #FF7300 };
color[] buttonBg = { color(36, 99, 133), color(18, 18, 18), #0077FF };
color[] buttonAct = { color(255, 217, 0), color(112, 189, 102), #9000FF };
color[] captionCol = { color(255, 255, 255), color(255, 255, 255), #00FF08 };
color[] valueCol = { color(255, 255, 255), color(255, 255, 255), #00FF08 };

color[] titleCol = { color(255, 234, 0), color(30, 255, 0), #AA00FF };
color[] bgCol = { color(25, 186, 255), color(0, 0, 0), #008CFF };

boolean[] bgImg = { true, true, true };
String[] imgPaths = { "theme1bg.jpg", "theme2bg.jpg", "theme3bg.jpg" };
PImage[] bgImgs = new PImage[numThemes];

CColor buttonColour = new CColor(buttonFg[chosenTheme], buttonBg[chosenTheme], buttonAct[chosenTheme], captionCol[chosenTheme], valueCol[chosenTheme]);

CColor theme1Colour = new CColor(buttonFg[0], buttonBg[0], buttonAct[0], captionCol[0], valueCol[0]);
CColor theme2Colour = new CColor(buttonFg[1], buttonBg[1], buttonAct[1], captionCol[1], valueCol[1]);
CColor theme3Colour = new CColor(buttonFg[2], buttonBg[2], buttonAct[2], captionCol[2], valueCol[2]);

String[] allThemedElements = {"connect", "beakSlider", "leftSlider", "rightSlider", "beakopen", "beakclosed", "leftup", "leftdown", "lefthome", "rightup", "rightdown", "righthome", "beakopen_button", "beakclosed_button", "lwingup_button", "lwingdown_button", "lwinghome_button", "rwingup_button", "rwingdown_button", "rwinghome_button", "writevals_button", "enable_ldrs_button", "estop_button" };


// -- LET'S GOOOOO!!! :D -- //
void setup() {

  size(1024, 680);
  noStroke();
  cp5 = new ControlP5(this);
  cp5_v2 = new ControlP5(this);
  cp5.setAutoDraw(false);
  cp5_v2.setAutoDraw(false);
  cp5.setMoveable(false);
  cp5_v2.setMoveable(false);
  
  titleFont = loadFont("Arista2.0Light-48.vlw");
  titleFontc5 = new ControlFont(titleFont, 30);
  
  println("-------------------- " + redVal + " " + redVal_r);
  
  startXml();
  
  initGui();

  // controlp5 is weird sometimes, this is just to fix the coloured sliders  
  redVal = redVal_r;
  greenVal = greenVal_r;
  blueVal = blueVal_r;
  estop = false;
  refresh_ldrs = false;
  
  ((Slider)cp5.getController("redSlider")).setValue(redVal);
  ((Slider)cp5.getController("greenSlider")).setValue(greenVal);
  ((Slider)cp5.getController("blueSlider")).setValue(blueVal);
 
  ((Slider)cp5.getController("leftSlider")).setRange(lwingDownPos, lwingUpPos);
  ((Slider)cp5.getController("rightSlider")).setRange(rwingDownPos, rwingUpPos);
  ((Slider)cp5.getController("beakSlider")).setRange(beakOpenPos, beakClosedPos);
  
  cp5.getController("leftSlider").getValueLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-20);
  cp5.getController("leftSlider").getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE);
  
  cp5.getController("rightSlider").getValueLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-20);
  cp5.getController("rightSlider").getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE);
  
  cp5.getController("beakSlider").getValueLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-20);
  cp5.getController("beakSlider").getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE);
  
  refreshSliders();
  
  
  
  
  // -- OTHER -- //
  
  frame.setBackground(new java.awt.Color(0,0,0));

  for (int i=0; i<Serial.list().length; i++) {
    println(Serial.list()[i]);
    d1.addItem("" + Serial.list()[i], i);
  }
  
   
  chosenTheme = readTheme;
  updateTheme();

  
  for(int i=0; i<numThemes; i++) {
    bgImgs[i] = loadImage(dataPath(imgPaths[i]));
  }
  
  
}


// -- DRAW -- //
void draw() {
  
  if(connected) {
    readData();  
  }
  
  drawBackground();
  
  cp5.draw();
  cp5_v2.draw();
  
  
  if(millis()-last_ldr >= 100 && refresh_ldrs == true) {
    transmit_action('@', 'I', 0, 0, '!');
    delay(20);
    transmit_action('@', 'J', 0, 0, '!');
    delay(20);
    last_ldr = millis();
  }
  drawSensors();
  
  
  if(millis()-last_eye_change >= 1000 && eye_changed == true) {
    saveXml();
    eye_changed = false;
  }
  
  if(millis()-last_estop_send >= 80 && estop == true) {
    transmit_action('#', 'O', 0, 0, '!');
    last_estop_send = millis();
  }
  
}


void drawBackground() {
 
 background(bgCol[chosenTheme]);
  
  if(bgImg[chosenTheme]) {
    image(bgImgs[chosenTheme], 0, 0);
  }
  
}

void drawSensors() {
 
 int lbar = (int)map(leftLDRReading, 0, 1023, 0, 250);
 int rbar = (int)map(rightLDRReading, 0, 1023, 0, 250);
  
  //println("rbar: " + rbar);
  
  // left ldr
  fill(buttonBg[chosenTheme]);
  rect(720, 310, 80, 250);
  
  fill(buttonFg[chosenTheme]);
  rect(720, 560, 80, -1*lbar); // 310 + 250 = 560
  
  
  // right ldr 
  fill(buttonBg[chosenTheme]);
  rect(820, 310, 80, 250);
  
  fill(buttonFg[chosenTheme]);
  rect(820, 560, 80, -1*rbar);
  
}


