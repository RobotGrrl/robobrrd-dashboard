/*
RoboBrrd Dashboard Beta!
------------------------
Control your RoboBrrd and set its servo positions!
robobrrd.com/dashboard

**This is a beta, if something is broken, let me know!**
Twitter: @RobotGrrl

This code is released under the BSD 3-Clause License.
See the bottom of sketch for license information!

Dec. 4, 2012
robobrrd.com/dashboard
*/

import controlP5.*;
import proxml.*;
import processing.serial.*;

static boolean DEBUG = false;

// -- XML -- //
XMLElement settingsXml;
XMLInOut xmlInOut;

// -- ARDUINO -- //
Serial arduino;
int port = 99;
boolean connected = false;

// -- GUI -- //
ControlP5 cp5;
ControlP5 cp5_v2;
DropdownList d1;

PFont titleFont;
ControlFont titleFontc5;

// areas // 
static String beakSerial = "BK";
static String lwingSerial = "LW";
static String rwingSerial = "RW";
static String actionSerial = "AX";
static String red1Serial = "R1";
static String green1Serial = "G1";
static String blue1Serial = "B1";
static String red2Serial = "R2";
static String green2Serial = "G2";
static String blue2Serial = "B2";
static String lldrSerial = "LD";
static String rldrSerial = "RD";

// actions //
static int bkOpenSerial = 0;
static int bkClosedSerial = 1;

static int lwingUpSerial = 2;
static int lwingDownSerial = 3;
static int lwingHomeSerial = 4;

static int rwingUpSerial = 5;
static int rwingDownSerial = 6;
static int rwingHomeSerial = 7;


// -- PARSING -- //

int msgLen = 12;
int msgIndex = 0;
char[] msg = new char[msgLen];
boolean reading = false;
boolean completed = false;

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
boolean red1 = true;
boolean green1 = true;
boolean blue1 = true;

boolean red2 = true;
boolean green2 = true;
boolean blue2 = true;

color redOn = color(255, 0, 0);  
color greenOn = color(0, 255, 0);
color blueOn = color(0, 0, 255);

color redOff = color(100, 20, 20);  
color greenOff = color(20, 100, 20);
color blueOff = color(20, 20, 100);

color white = color(255, 255, 255);
color black = color(20, 20, 20);

// note: CColor(foreground (hover), background (normal), active (press down), caption label, value label )
CColor red1Colour = new CColor(redOn, redOff, color(255, 100, 100), color(0, 0, 0), color(0, 0, 0));
CColor green1Colour = new CColor(greenOn, greenOff, color(100, 255, 100), color(0, 0, 0), color(0, 0, 0));
CColor blue1Colour = new CColor(blueOn, blueOff, color(100, 100, 255), color(0, 0, 0), color(0, 0, 0));
CColor mix1Colour = new CColor(white, black, color(200, 200, 200), color(140, 140, 140), color(0, 0, 0));

CColor red2Colour = new CColor(redOn, redOff, color(255, 100, 100), color(0, 0, 0), color(0, 0, 0));
CColor green2Colour = new CColor(greenOn, greenOff, color(100, 255, 100), color(0, 0, 0), color(0, 0, 0));
CColor blue2Colour = new CColor(blueOn, blueOff, color(100, 100, 255), color(0, 0, 0), color(0, 0, 0));
CColor mix2Colour = new CColor(white, black, color(200, 200, 200), color(140, 140, 140), color(0, 0, 0));


// -- LDRs -- //
int leftLDRReading = 0;
int rightLDRReading = 0;


// -- THEMES -- //
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

String[] allThemedElements = {"connect", "beakSlider", "leftSlider", "rightSlider", "beakopen", "beakclosed", "leftup", "leftdown", "lefthome", "rightup", "rightdown", "righthome", "beakopen_button", "beakclosed_button", "lwingup_button", "lwingdown_button", "lwinghome_button", "rwingup_button", "rwingdown_button", "rwinghome_button" };


// -- LET'S GOOOOO!!! :D -- //
void setup() {

  size(1024, 700);
  noStroke();
  cp5 = new ControlP5(this);
  cp5_v2 = new ControlP5(this);
  cp5.setAutoDraw(false);
  cp5_v2.setAutoDraw(false);
  cp5.setMoveable(false);
  cp5_v2.setMoveable(false);
  
  titleFont = loadFont("Arista2.0Light-48.vlw");
  titleFontc5 = new ControlFont(titleFont, 30);
  
  
  xmlInOut = new XMLInOut(this);
  try{
    xmlInOut.loadElement(dataPath("settings.xml")); 
  }catch(Exception e){
    // derp?
  }
  
  
  // -- TITLE -- //
  
  Group g0 = cp5.addGroup("g0")
                .setPosition(45,10)
                .setWidth(955)
                .setHeight(60)
                .setBackgroundHeight(60)
                .activateEvent(true)
                .setBackgroundColor(color(255,80))
                .setLabel("")
                .disableCollapse()
                .hideBar()
                ;
  
  cp5.addTextlabel("title")
     .setText("RoboBrrd Dashboard")
     .setPosition(5,10)
     .setColorValue(titleCol[chosenTheme])
     .setGroup(g0)
     .setFont(titleFontc5)
     ;
  
   d1 = cp5_v2.addDropdownList("serialports")
          .setPosition(360, 55)
          .setSize(200,150)
          .setColor(buttonColour)
          .setBarHeight(30)
          .setCaptionLabel("Serial Ports")
          ;
          
  customize(d1);
  
  cp5.addButton("connect")
     .setValue(0)
     .setPosition(530,15)
     .setSize(100,30)
     .setColor(buttonColour)
     .setGroup(g0)
     .setCaptionLabel("Connect!")
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
     ;
  
  cp5.addButton("theme1_button")
     .setValue(0)
     .setPosition(850,20)
     .setSize(20,20)
     .setColor(theme1Colour)
     .setGroup(g0)
     .setCaptionLabel("")
     ;
  
  cp5.addButton("theme2_button")
     .setValue(0)
     .setPosition(875,20)
     .setSize(20,20)
     .setColor(theme2Colour)
     .setGroup(g0)
     .setCaptionLabel("")
     ;
  
  cp5.addButton("theme3_button")
     .setValue(0)
     .setPosition(900,20)
     .setSize(20,20)
     .setColor(theme3Colour)
     .setGroup(g0)
     .setCaptionLabel("")
     ;
  
  
  
  // -- SERVOS -- //
  
  Group g1 = cp5.addGroup("g1")
                .setPosition(45,80)
                .setWidth(300)
                .setHeight(260)
                .setBackgroundHeight(260)
                .activateEvent(true)
                .setBackgroundColor(color(255,80))
                .setLabel("")
                .disableCollapse()
                .hideBar()
                ;
  
  cp5.addTextlabel("servos")
     .setText("Servos")
     .setPosition(110,0)
     .setColorValue(titleCol[chosenTheme])
     .setGroup(g1)
     .setFont(titleFontc5)
     ;
  
  
  cp5.addSlider("beakSlider")
     .setPosition(25, 40)
     .setSize(50,200)
     .setColor(buttonColour)
     .setRange(beakClosedPos,beakOpenPos)
     .setValue(beakClosedPos)
     .setCaptionLabel("Beak")
     .setGroup(g1)
     ;
  
  cp5.getController("beakSlider").getValueLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-20);
  cp5.getController("beakSlider").getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE);

  cp5.addSlider("leftSlider")
     .setPosition(120, 40)
     .setSize(50,200)
     .setColor(buttonColour)
     .setRange(lwingDownPos,lwingUpPos)
     .setValue(lwingHomePos)
     .setCaptionLabel("Left Wing")
     .setGroup(g1)
     ;
  
  cp5.getController("leftSlider").getValueLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-20);
  cp5.getController("leftSlider").getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE);
  
  cp5.addSlider("rightSlider")
     .setPosition(220, 40)
     .setSize(50,200)
     .setColor(buttonColour)
     .setRange(rwingDownPos,rwingUpPos)
     .setValue(rwingHomePos)
     .setCaptionLabel("Right Wing")
     .setGroup(g1)
     ;
  
  cp5.getController("rightSlider").getValueLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-20);
  cp5.getController("rightSlider").getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE);

  
  // -- POSITIONS -- //
  
 Group g2 = cp5.addGroup("g2")
                .setPosition(45,360)
                .setWidth(300)
                .setHeight(300)
                .setBackgroundHeight(300)
                .activateEvent(true)
                .setBackgroundColor(color(255,80))
                .setLabel("")
                .disableCollapse()
                .hideBar()
                ;


  PFont textfieldFont = createFont("arial",20);

  cp5.addTextlabel("positions")
     .setText("Positions")
     .setPosition(100,0)
     .setColorValue(titleCol[chosenTheme])
     .setGroup(g2)
     .setFont(titleFontc5)
     ;

  cp5.addTextfield("beakopen")
     .setPosition(20,40)
     .setSize(50,40)
     .setFont(textfieldFont)
     .setColor(buttonColour)
     .setGroup(g2)
     .setAutoClear(false)
     .setText("" + beakOpenPos)
     .setCaptionLabel("Beak Open")
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE)
     ;
  
  cp5.addTextfield("beakclosed")
     .setPosition(20,110)
     .setSize(50,40)
     .setFont(textfieldFont)
     .setColor(buttonColour)
     .setGroup(g2)
     .setAutoClear(false)
     .setText("" + beakClosedPos)
     .setCaptionLabel("Beak Closed")
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE)
     ;
  
 
   cp5.addTextfield("leftup")
     .setPosition(120,40)
     .setSize(50,40)
     .setFont(textfieldFont)
     .setColor(buttonColour)
     .setGroup(g2)
     .setAutoClear(false)
     .setText("" + lwingUpPos)
     .setCaptionLabel("Left Up")
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE)
     ;
  
  cp5.addTextfield("leftdown")
     .setPosition(120,110)
     .setSize(50,40)
     .setFont(textfieldFont)
     .setColor(buttonColour)
     .setGroup(g2)
     .setAutoClear(false)
     .setText("" + lwingDownPos)
     .setCaptionLabel("Left Down")
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE)
     ;
     
  cp5.addTextfield("lefthome")
     .setPosition(120,180)
     .setSize(50,40)
     .setFont(textfieldFont)
     .setColor(buttonColour)
     .setGroup(g2)
     .setAutoClear(false)
     .setText("" + lwingHomePos)
     .setCaptionLabel("Left Home")
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE)
     ;
  
  
  
  cp5.addTextfield("rightup")
     .setPosition(220,40)
     .setSize(50,40)
     .setFont(textfieldFont)
     .setColor(buttonColour)
     .setGroup(g2)
     .setAutoClear(false)
     .setText("" + rwingUpPos)
     .setCaptionLabel("Right Up")
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE)
     ;
  
  cp5.addTextfield("rightdown")
     .setPosition(220,110)
     .setSize(50,40)
     .setFont(textfieldFont)
     .setColor(buttonColour)
     .setGroup(g2)
     .setAutoClear(false)
     .setText("" + rwingDownPos)
     .setCaptionLabel("Right Down")
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE)
     ;
     
  cp5.addTextfield("righthome")
     .setPosition(220,180)
     .setSize(50,40)
     .setFont(textfieldFont)
     .setColor(buttonColour)
     .setGroup(g2)
     .setAutoClear(false)
     .setText("" + rwingHomePos)
     .setCaptionLabel("Right Home")
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE)
     ;
  
  
  
  // -- ACTIONS -- //
  
  Group g3 = cp5.addGroup("g3")
                .setPosition(360,80)
                .setWidth(240)
                .setHeight(580)
                .setBackgroundHeight(580)
                .activateEvent(true)
                .setBackgroundColor(color(255,80))
                .setLabel("")
                .disableCollapse()
                .hideBar()
                ;
  
  
  cp5.addTextlabel("actions")
     .setText("Actions")
     .setPosition(70,0)
     .setColorValue(titleCol[chosenTheme])
     .setGroup(g3)
     .setFont(titleFontc5)
     ;
  
  cp5.addButton("beakopen_button")
     .setValue(0)
     .setPosition(40,40)
     .setSize(150,50)
     .setColor(buttonColour)
     .setGroup(g3)
     .setCaptionLabel("Beak Open")
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;
  
  cp5.addButton("beakclosed_button")
     .setValue(0)
     .setPosition(40,100)
     .setSize(150,50)
     .setColor(buttonColour)
     .setGroup(g3)
     .setCaptionLabel("Beak Closed")
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;
  
  
  cp5.addButton("lwingup_button")
     .setValue(0)
     .setPosition(40,180)
     .setSize(150,50)
     .setColor(buttonColour)
     .setGroup(g3)
     .setCaptionLabel("Left Wing Up")
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;
  
  cp5.addButton("lwingdown_button")
     .setValue(0)
     .setPosition(40,240)
     .setSize(150,50)
     .setColor(buttonColour)
     .setGroup(g3)
     .setCaptionLabel("Left Wing Down")
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;
  
  cp5.addButton("lwinghome_button")
     .setValue(0)
     .setPosition(40,300)
     .setSize(150,50)
     .setColor(buttonColour)
     .setGroup(g3)
     .setCaptionLabel("Left Wing Home")
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;
  
  
  cp5.addButton("rwingup_button")
     .setValue(0)
     .setPosition(40,380)
     .setSize(150,50)
     .setColor(buttonColour)
     .setGroup(g3)
     .setCaptionLabel("Right Wing Up")
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;
  
  cp5.addButton("rwingdown_button")
     .setValue(0)
     .setPosition(40,440)
     .setSize(150,50)
     .setColor(buttonColour)
     .setGroup(g3)
     .setCaptionLabel("Right Wing Down")
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;
  
  cp5.addButton("rwinghome_button")
     .setValue(0)
     .setPosition(40,500)
     .setSize(150,50)
     .setColor(buttonColour)
     .setGroup(g3)
     .setCaptionLabel("Right Wing Home")
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;
  
  
  // -- LEDs -- //
  
  Group g4 = cp5.addGroup("g4")
                .setPosition(620,80)
                .setWidth(380)
                .setHeight(180)
                .setBackgroundHeight(180)
                .activateEvent(true)
                .setBackgroundColor(color(255,80))
                .setLabel("")
                .disableCollapse()
                .hideBar()
                ;
  
  cp5.addTextlabel("leds")
     .setText("Eyes")
     .setPosition(155,0)
     .setColorValue(titleCol[chosenTheme])
     .setGroup(g4)
     .setFont(titleFontc5)
     ;
  
  cp5.addButton("red1_button")
     .setValue(0)
     .setPosition(30,40)
     .setSize(50,50)
     .setGroup(g4)
     .setColor(red1Colour)
     .setCaptionLabel("")
     ;
     
  cp5.addButton("green1_button")
     .setValue(0)
     .setPosition(100,40)
     .setSize(50,50)
     .setGroup(g4)
     .setColor(green1Colour)
     .setCaptionLabel("")
     ;
  
  cp5.addButton("blue1_button")
     .setValue(0)
     .setPosition(170,40)
     .setSize(50,50)
     .setGroup(g4)
     .setColor(blue1Colour)
     .setCaptionLabel("")
     ;
     
  cp5.addButton("lefteye_button")
     .setValue(0)
     .setPosition(260,40)
     .setSize(90,50)
     .setGroup(g4)
     .setColor(mix1Colour)
     .setCaptionLabel("Left eye")
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;
  
  
  
  cp5.addButton("red2_button")
     .setValue(0)
     .setPosition(30,110)
     .setSize(50,50)
     .setGroup(g4)
     .setColor(red2Colour)
     .setCaptionLabel("")
     ;
     
  cp5.addButton("green2_button")
     .setValue(0)
     .setPosition(100,110)
     .setSize(50,50)
     .setGroup(g4)
     .setColor(green2Colour)
     .setCaptionLabel("")
     ;
  
  cp5.addButton("blue2_button")
     .setValue(0)
     .setPosition(170,110)
     .setSize(50,50)
     .setGroup(g4)
     .setColor(blue2Colour)
     .setCaptionLabel("")
     ;
     
  cp5.addButton("righteye_button")
     .setValue(0)
     .setPosition(260,110)
     .setSize(90,50)
     .setGroup(g4)
     .setColor(mix2Colour)
     .setCaptionLabel("Right eye")
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;
  
  
  // -- LDRS -- //
  
  Group g5 = cp5.addGroup("g5")
                .setPosition(620,270)
                .setWidth(380)
                .setHeight(330)
                .setBackgroundHeight(330)
                .activateEvent(true)
                .setBackgroundColor(color(255,80))
                .setLabel("")
                .disableCollapse()
                .hideBar()
                ;
  
  cp5.addTextlabel("ldrs")
     .setText("Photocells")
     .setPosition(120,0)
     .setColorValue(titleCol[chosenTheme])
     .setGroup(g5)
     .setFont(titleFontc5)
     ;
  
  cp5.addTextlabel("leftldr")
     .setText("LEFT")
     .setPosition(100,300)
     .setGroup(g5)
     ;
  
  cp5.addTextlabel("rightldr")
     .setText("RIGHT")
     .setPosition(200,300)
     .setGroup(g5)
     ;
  
  
  // -- OTHER -- //
  
  frame.setBackground(new java.awt.Color(0,0,0));

  for (int i=0; i<Serial.list().length; i++) {
    println(Serial.list()[i]);
    d1.addItem("" + Serial.list()[i], i);
  }
  
  
  lefteye_button(0);
  righteye_button(0);
  
  red1 = false;
  green1 = false;
  blue1 = false;

  red2 = false;
  green2 = false;
  blue2 = false;
  
  chosenTheme = readTheme;
  updateTheme();
  
  
  for(int i=0; i<numThemes; i++) {
    bgImgs[i] = loadImage(dataPath(imgPaths[i]));
  }
  
  
}

// -- XML HANDLING -- //
void xmlEvent(XMLElement element){
  settingsXml = element;
  initXml();
}

void initXml() {
  //settingsXml.printElementTree(" ");
  
  XMLElement servosXml;
  XMLElement beakXml;
  XMLElement lwingXml;
  XMLElement rwingXml;
  XMLElement themeXml;
  XMLElement position;
  
  themeXml = settingsXml.getChild(0);
  readTheme = themeXml.getIntAttribute("num");

  servosXml = settingsXml.getChild(1);

  beakXml = servosXml.getChild(0);
  lwingXml = servosXml.getChild(1);
  rwingXml = servosXml.getChild(2);
  
  position = beakXml.getChild(0);
  beakOpenPos = position.getIntAttribute("up");
  beakClosedPos = position.getIntAttribute("down");
  
  position = lwingXml.getChild(0);
  lwingUpPos = position.getIntAttribute("up");
  lwingDownPos = position.getIntAttribute("down");
  lwingHomePos = position.getIntAttribute("home");

  position = rwingXml.getChild(0);
  rwingUpPos = position.getIntAttribute("up");
  rwingDownPos = position.getIntAttribute("down");
  rwingHomePos = position.getIntAttribute("home");

  println("read xml");
  
}

void saveXml() {
 
  ((Slider)cp5.getController("leftSlider")).setRange(lwingDownPos, lwingUpPos);
  ((Slider)cp5.getController("rightSlider")).setRange(rwingDownPos, rwingUpPos);
  ((Slider)cp5.getController("beakSlider")).setRange(beakOpenPos, beakClosedPos);
  
  cp5.getController("leftSlider").getValueLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-20);
  cp5.getController("leftSlider").getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE);
  
  cp5.getController("rightSlider").getValueLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-20);
  cp5.getController("rightSlider").getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE);
  
  cp5.getController("beakSlider").getValueLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-20);
  cp5.getController("beakSlider").getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE);
  
  
  XMLElement settingsXml0 = new XMLElement("settings");
 
  XMLElement themeXml0 = new XMLElement("theme");
  XMLElement servosXml0 = new XMLElement("servos");
  
  themeXml0.addAttribute("num", chosenTheme);
  
  settingsXml0.addChild(themeXml0); 
  
  //--
  XMLElement beakXml0 = new XMLElement("beak");
  XMLElement lwingXml0 = new XMLElement("lwing");
  XMLElement rwingXml0 = new XMLElement("rwing");
  
  XMLElement posXml0 = new XMLElement("position");
  
  posXml0.addAttribute("up", beakOpenPos);
  posXml0.addAttribute("down", beakClosedPos);
  
  beakXml0.addChild(posXml0);
  servosXml0.addChild(beakXml0);
  
  //--
  XMLElement posXml1 = new XMLElement("position");
  
  posXml1.addAttribute("up", lwingUpPos);
  posXml1.addAttribute("down", lwingDownPos);
  posXml1.addAttribute("home", lwingHomePos);
  
  lwingXml0.addChild(posXml1);
  servosXml0.addChild(lwingXml0);
  
  //--
  XMLElement posXml2 = new XMLElement("position");
  
  posXml2.addAttribute("up", rwingUpPos);
  posXml2.addAttribute("down", rwingDownPos);
  posXml2.addAttribute("home", rwingHomePos);
  
  rwingXml0.addChild(posXml2);
  servosXml0.addChild(rwingXml0);
  
  //--
  settingsXml0.addChild(servosXml0);
  xmlInOut.saveElement(settingsXml0, "settings.xml");
  
}


// -- DRAW -- //
void draw() {
  
  if(connected) {
  
    // let's read the data
    
    char m;
    
    while(arduino.available() > 0) {
      
      m = arduino.readChar();
     
      if(m == '!') {
        if(DEBUG) println("\nping");
        reading = true;
      }
      
      if(DEBUG) print(m + " ");
      
      if(reading) {
        if(msgIndex < msgLen) msg[msgIndex++] = m;
      }
      
      if(m == '~') {
        if(DEBUG) println("\nding");
        reading = false;
        completed = true;
      }
      
    }
    
    if(completed) {
      if(DEBUG) println("\ngood job");
      
      for(int i=0; i<msgIndex; i++) {
        if(DEBUG) print(msg[i] + " "); 
      }
      if(DEBUG) print("\n");
      
      String cmd = "";
      if(msg[0] == '!') {
        cmd += ("" + msg[1] + "" + msg[2]);
      }
      if(DEBUG) println("cmd: " + cmd);
      
      String val = "";
      if(msg[3] == ':') {
        
        for(int i=4; i<(msgIndex-1); i++) {
          val += msg[i];
        }
        
      }
      if(DEBUG) println("val: " + val);
      
      boolean good = false;
      if(msg[(msgIndex-1)] == '~') {
        good = true;
      }
      
      if(good) {
        if(DEBUG) println("good!");
        
        if(cmd.equals(lldrSerial)) {
          if(val != "" && val.length() < 5) leftLDRReading = (int)Integer.parseInt(val);
        } else if(cmd.equals(rldrSerial)) {
          if(val != "" && val.length() < 5) rightLDRReading = (int)Integer.parseInt(val);
        }
        
      }
      
      msgIndex = 0;
      completed = false;
      
    }
    
  }
  
  background(bgCol[chosenTheme]);
  
  if(bgImg[chosenTheme]) {
    image(bgImgs[chosenTheme], 0, 0);
  }
  
  cp5.draw();
  cp5_v2.draw();
  
  
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


// -- GUI -- //

void controlEvent(ControlEvent theEvent) {
  // DropdownList is of type ControlGroup.
  // A controlEvent will be triggered from inside the ControlGroup class.
  // therefore you need to check the originator of the Event with
  // if (theEvent.isGroup())
  // to avoid an error message thrown by controlP5.

  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    //println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
    
    if(theEvent.getGroup().getName().equals("serialports")) {
      port = (int)theEvent.getGroup().getValue();
      println("selected port: " + port);
    }
    
  } 
  else if (theEvent.isController()) {
    //println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController());
  }
}


// -- TITLE -- //

void customize(DropdownList ddl) {
  // a convenience function to customize a DropdownList
  ddl.setBackgroundColor(color(190));
  ddl.setItemHeight(30);
  //ddl.setBarHeight(15);
  ddl.getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
  //ddl.captionLabel().style().marginTop = 3;
  //ddl.captionLabel().style().marginLeft = 3;
  ddl.valueLabel().style().marginTop = 3;
}

void connect(int theValue) {
  
  if(!connected) {
  
  if(port != 99) {
    println("connected");
    connected = true;
    arduino = new Serial(this, Serial.list()[port], 9600);
    cp5.getController("connect").setCaptionLabel("Disconnect");
  } else {
   println("need to select a port!"); 
  }
  
  } else {
    
    arduino.clear();
    arduino.stop();
    
    cp5.getController("connect").setCaptionLabel("Connect!");
    //port = 99;
    connected = false;
    
  }
  
}


// -- THEMES -- //

void theme1_button(int theValue) {
  chosenTheme = 0;
  updateTheme();
}

void theme2_button(int theValue) {
  chosenTheme = 1;
  updateTheme();
}

void theme3_button(int theValue) {
  chosenTheme = 2;
  updateTheme();
}


void updateTheme() {
  
  if(DEBUG) println("updating theme!");
  
  buttonColour = new CColor(buttonFg[chosenTheme], buttonBg[chosenTheme], buttonAct[chosenTheme], captionCol[chosenTheme], valueCol[chosenTheme]);
  
  if(cp5.getController("title") != null) cp5.getController("title").setColorValue(titleCol[chosenTheme]);
  if(cp5.getController("servos") != null) cp5.getController("servos").setColorValue(titleCol[chosenTheme]);
  if(cp5.getController("positions") != null) cp5.getController("positions").setColorValue(titleCol[chosenTheme]);
  if(cp5.getController("actions") != null) cp5.getController("actions").setColorValue(titleCol[chosenTheme]);
  if(cp5.getController("leds") != null) cp5.getController("leds").setColorValue(titleCol[chosenTheme]);
  if(cp5.getController("ldrs") != null) cp5.getController("ldrs").setColorValue(titleCol[chosenTheme]);
  
  for(int i=0; i<allThemedElements.length; i++) {
    if(cp5.getController(allThemedElements[i]) != null) cp5.getController(allThemedElements[i]).setColor(buttonColour);
  }
  
  if(d1 != null) d1.setColor(buttonColour);
  
  saveXml();
  
}


// -- SLIDERS -- //
// !BK:180~

void sendSerial(String sl, int val) {
  arduino.write("!" + sl + ":" + val + "~");
}

void beakSlider(int s) {
  beakPos = s;
  if(DEBUG) println("beak: " + beakPos);
  if(connected) sendSerial(beakSerial, s);
}

void leftSlider(int s) {
  leftPos = s;
  if(DEBUG) println("left wing: " + leftPos);
  if(connected) sendSerial(lwingSerial, s);
}

void rightSlider(int s) {
  rightPos = s;
  if(DEBUG) println("right wing: " + rightPos);
  if(connected) sendSerial(rwingSerial, s);
}


// -- TEXTFIELDS -- //

public void beakopen(String theText) {
  beakOpenPos = (int)parseInt(theText);
  if(DEBUG) println("beakopen: "+ beakOpenPos);
  saveXml();
}

public void beakclosed(String theText) {
  beakClosedPos = (int)parseInt(theText);
  if(DEBUG) println("beakclosed: "+ beakClosedPos);
  saveXml();
}


public void leftup(String theText) {
  lwingUpPos = (int)parseInt(theText);
  if(DEBUG) println("leftup: "+ lwingUpPos);
  saveXml();
}

public void leftdown(String theText) {
  lwingDownPos = (int)parseInt(theText);
  if(DEBUG) println("leftdown: "+ lwingDownPos);
  saveXml();
}

public void lefthome(String theText) {
  lwingHomePos = (int)parseInt(theText);
  if(DEBUG) println("lefthome: "+ lwingHomePos);
  saveXml();
}


public void rightup(String theText) {
  rwingUpPos = (int)parseInt(theText);
  if(DEBUG) println("rightup: "+ rwingUpPos);
  saveXml();
}

public void rightdown(String theText) {
  rwingDownPos = (int)parseInt(theText);
  if(DEBUG) println("rightdown: "+ rwingDownPos);
  saveXml();
}

public void righthome(String theText) {
  rwingHomePos = (int)parseInt(theText);
  if(DEBUG) println("righthome: "+ rwingHomePos);
  saveXml();
}


// -- BUTTONS -- //

public void beakopen_button(int theValue) {
  if(DEBUG) println("beakopen pressed");
  if(connected) sendSerial(beakSerial, beakOpenPos);
}

public void beakclosed_button(int theValue) {
  if(DEBUG) println("beakclosed pressed");
  if(connected) sendSerial(beakSerial, beakClosedPos);
}


public void lwingup_button(int theValue) {
  if(DEBUG) println("lwingup pressed");
  if(connected) sendSerial(lwingSerial, lwingUpPos);
}

public void lwingdown_button(int theValue) {
  if(DEBUG) println("lwingdown pressed");
  if(connected) sendSerial(lwingSerial, lwingDownPos);
}

public void lwinghome_button(int theValue) {
  if(DEBUG) println("lwinghome pressed");
  if(connected) sendSerial(lwingSerial, lwingHomePos);
}


public void rwingup_button(int theValue) {
  if(DEBUG) println("rwingup pressed");
  if(connected) sendSerial(rwingSerial, rwingUpPos);
}

public void rwingdown_button(int theValue) {
  if(DEBUG) println("rwingdown pressed");
  if(connected) sendSerial(rwingSerial, rwingDownPos);
}

public void rwinghome_button(int theValue) {
  if(DEBUG) println("rwinghome pressed");
  if(connected) sendSerial(rwingSerial, rwingHomePos);
}


// -- LEDs -- //

public void red1_button(int theValue) {
  if(DEBUG) println("red1 pressed");
  red1 = !red1;
  red1_action();
}

public void green1_button(int theValue) {
  if(DEBUG) println("green1 pressed");
  green1 = !green1;
  green1_action();
}

public void blue1_button(int theValue) {
  if(DEBUG) println("blue1 pressed");
  blue1 = !blue1;
  blue1_action();
}

public void lefteye_button(int theValue) {
  if(DEBUG) println("lefteye pressed");
  
  if(red1 == false || green1 == false || blue1 == false) {
    // turn them all on
    red1 = true;
    green1 = true;
    blue1 = true;
    
    mix1Colour.setBackground(white);
    mix1Colour.setForeground(black);
    
  } else {
    // turn them all off
    red1 = false;
    green1 = false;
    blue1 = false;
    
    mix1Colour.setBackground(black);
    mix1Colour.setForeground(white);
    
  }
  
  cp5.getController("lefteye_button").setColor(mix1Colour);
  
  red1_action();
  green1_action();
  blue1_action();
  
}


void red1_action() {
  
  if(connected) {
    int woo = red1? 1 : 0;
    sendSerial(red1Serial, woo);
  }
  
  if(red1) {
    red1Colour.setBackground(redOn);
    red1Colour.setForeground(redOff);
  } else {
    red1Colour.setBackground(redOff);
    red1Colour.setForeground(redOn);
  }
  cp5.getController("red1_button").setColor(red1Colour);
}

void green1_action() {
  
  if(connected) {
    int woo = green1? 1 : 0;
    sendSerial(green1Serial, woo);
  }
  
  if(green1) {
    green1Colour.setBackground(greenOn);
    green1Colour.setForeground(greenOff);
  } else {
    green1Colour.setBackground(greenOff);
    green1Colour.setForeground(greenOn);
  }
  
  cp5.getController("green1_button").setColor(green1Colour);
}

void blue1_action() {
  
  if(connected) {
    int woo = blue1? 1 : 0;
    sendSerial(blue1Serial, woo);
  }
  
  if(blue1) {
    blue1Colour.setBackground(blueOn);
    blue1Colour.setForeground(blueOff);
  } else {
    blue1Colour.setBackground(blueOff);
    blue1Colour.setForeground(blueOn);
  }
  
  cp5.getController("blue1_button").setColor(blue1Colour);
}



public void red2_button(int theValue) {
  if(DEBUG) println("red2 pressed");
  red2 = !red2;
  red2_action();
}

public void green2_button(int theValue) {
  if(DEBUG) println("green2 pressed");
  green2 = !green2;
  green2_action();
}

public void blue2_button(int theValue) {
  if(DEBUG) println("blue2 pressed");
  blue2 = !blue2;
  blue2_action();
}

public void righteye_button(int theValue) {
  if(DEBUG) println("righteye pressed");
  
  if(red2 == false || green2 == false || blue2 == false) {
    // turn them all on
    red2 = true;
    green2 = true;
    blue2 = true;
    
    mix2Colour.setBackground(white);
    mix2Colour.setForeground(black);
    
  } else {
    // turn them all off
    red2 = false;
    green2 = false;
    blue2 = false;
    
    mix2Colour.setBackground(black);
    mix2Colour.setForeground(white);
    
  }
  
  cp5.getController("righteye_button").setColor(mix2Colour);
  
  red2_action();
  green2_action();
  blue2_action();
  
}

void red2_action() {
  
  if(connected) {
    int woo = red2? 1 : 0;
    sendSerial(red2Serial, woo);
  }
  
  if(red2) {
    red2Colour.setBackground(redOn);
    red2Colour.setForeground(redOff);
  } else {
    red2Colour.setBackground(redOff);
    red2Colour.setForeground(redOn);
  }
  cp5.getController("red2_button").setColor(red2Colour);
}

void green2_action() {
  
  if(connected) {
    int woo = green2? 1 : 0;
    sendSerial(green2Serial, woo);
  }
  
  if(green2) {
    green2Colour.setBackground(greenOn);
    green2Colour.setForeground(greenOff);
  } else {
    green2Colour.setBackground(greenOff);
    green2Colour.setForeground(greenOn);
  }
  
  cp5.getController("green2_button").setColor(green2Colour);
}

void blue2_action() {
  
  if(connected) {
    int woo = blue2? 1 : 0;
    sendSerial(blue2Serial, woo);
  }
  
  if(blue2) {
    blue2Colour.setBackground(blueOn);
    blue2Colour.setForeground(blueOff);
  } else {
    blue2Colour.setBackground(blueOff);
    blue2Colour.setForeground(blueOn);
  }
  
  cp5.getController("blue2_button").setColor(blue2Colour);
}




/*
License info- http://opensource.org/licenses/BSD-3-Clause

Copyright (c) 2012, RoboBrrd.com
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this 
list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this 
list of conditions and the following disclaimer in the documentation and/or other 
materials provided with the distribution.
Neither the name of the RoboBrrd.com nor the names of its contributors may be
used to endorse or promote products derived from this software without specific
prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
OF SUCH DAMAGE.
*/

