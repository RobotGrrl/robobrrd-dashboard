void refreshSliders() {
 
 ((Slider)cp5.getController("redSlider")).setValue(redVal);
  ((Slider)cp5.getController("greenSlider")).setValue(greenVal);
  ((Slider)cp5.getController("blueSlider")).setValue(blueVal);
 
  ((Slider)cp5.getController("leftSlider")).setRange(lwingDownPos, lwingUpPos);
  ((Slider)cp5.getController("rightSlider")).setRange(rwingDownPos, rwingUpPos);
  ((Slider)cp5.getController("beakSlider")).setRange(beakOpenPos, beakClosedPos);

cp5.getController("beakSlider").getValueLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-20);
  cp5.getController("beakSlider").getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE);

  cp5.getController("leftSlider").getValueLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-20);
  cp5.getController("leftSlider").getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE);
  
  cp5.getController("rightSlider").getValueLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-20);
  cp5.getController("rightSlider").getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE);

  
}



void initGui() {
 
 
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
     .setPosition(5,10+8)
     .setColorValue(titleCol[chosenTheme])
     .setGroup(g0)
     .setFont(titleFontc5)
     ;
  
   cp5.addTextlabel("version")
     .setText("v2.0")
     .setPosition(925,45)
     .setColorValue(titleCol[chosenTheme])
     .setGroup(g0)
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
     
  cp5.addButton("estop_button")
     .setValue(0)
     .setPosition(700,15)
     .setSize(100,30)
     .setGroup(g0)
     .setColor(buttonColour)
     .setCaptionLabel("Emergency Stop")
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
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
     .setPosition(110,7)
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
     .setPosition(100,7)
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
     
  cp5.addButton("writevals_button")
     .setValue(0)
     .setPosition(75,250)
     .setSize(150,30)
     .setColor(buttonColour)
     .setGroup(g2)
     .setCaptionLabel("Write Values")
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
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
     .setPosition(70,7)
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
     .setPosition(155,7)
     .setColorValue(titleCol[chosenTheme])
     .setGroup(g4)
     .setFont(titleFontc5)
     ;
  
  cp5.addSlider("redSlider")
     .setPosition(30, 40)
     .setSize(50,100)
     .setColor(red1Colour)
     .setRange(0,255)
     .setValue(redVal)
     .setCaptionLabel("Red")
     .setGroup(g4)
     ;
  
  cp5.getController("redSlider").getValueLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-20);
  cp5.getController("redSlider").getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE);
  
  cp5.addSlider("greenSlider")
     .setPosition(100, 40)
     .setSize(50,100)
     .setColor(green1Colour)
     .setRange(0,255)
     .setValue(greenVal)
     .setCaptionLabel("Green")
     .setGroup(g4)
     ;
  
  cp5.getController("greenSlider").getValueLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-20);
  cp5.getController("greenSlider").getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE);
  
  cp5.addSlider("blueSlider")
     .setPosition(170, 40)
     .setSize(50,100)
     .setColor(blue1Colour)
     .setRange(0,255)
     .setValue(blueVal)
     .setCaptionLabel("Blue")
     .setGroup(g4)
     ;
  
  cp5.getController("blueSlider").getValueLabel().align(ControlP5.LEFT, ControlP5.LEFT_OUTSIDE).setPaddingX(-20);
  cp5.getController("blueSlider").getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE);
     
  cp5.addButton("eye_button")
     .setValue(0)
     .setPosition(260,60)
     .setSize(90,50)
     .setGroup(g4)
     .setColor(mix1Colour)
     .setCaptionLabel("All on / off")
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;
  
  
  
  // -- LDRS -- //
  
  Group g5 = cp5.addGroup("g5")
                .setPosition(620,270)
                .setWidth(380)
                .setHeight(390)
                .setBackgroundHeight(390)
                .activateEvent(true)
                .setBackgroundColor(color(255,80))
                .setLabel("")
                .disableCollapse()
                .hideBar()
                ;
  
  cp5.addTextlabel("ldrs")
     .setText("Photocells")
     .setPosition(120,7)
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
     
  cp5.addButton("enable_ldrs_button")
     .setValue(0)
     .setPosition(90,330)
     .setSize(200,30)
     .setGroup(g5)
     .setColor(buttonColour)
     .setCaptionLabel("Enable")
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;
  
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

void estop_button(int theValue) {
  
  estop = !estop;
  
  if(estop) {
    ((Button)cp5.getController("estop_button")).setCaptionLabel("Reset");
  } else {
    ((Button)cp5.getController("estop_button")).setCaptionLabel("Emergency Stop");
  }
  
}

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

void sendSerial(String s, int n) {
  
}

void beakSlider(int s) {
  beakPos = s;
  if(DEBUG) println("beak: " + beakPos);
  transmit_action('@', 'B', 5, beakPos, '!');
}

void leftSlider(int s) {
  leftPos = s;
  if(DEBUG) println("left wing: " + leftPos);
  transmit_action('@', 'L', 5, leftPos, '!');
}

void rightSlider(int s) {
  rightPos = s;
  if(DEBUG) println("right wing: " + rightPos);
  transmit_action('@', 'R', 5, rightPos, '!');
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


public void writevals_button(int theValue) {
  println("writeevals pressed");
  saveXml();
  
  println("Writing the values to RoboBrrd's EEPROM...");
  
  // there will be a delay of ~200ms while all of the messages transfer over
  
  //transmit_action('^', 'E', 1, beak servo home, '!'); // beak servo home
  //delay(20);
  
  transmit_action('^', 'E', 2, rwingHomePos, '!'); // right wing servo home
  delay(20);
  
  transmit_action('^', 'E', 3, lwingHomePos, '!'); // left wing servo home
  delay(20);
  
  transmit_action('^', 'E', 5, beakOpenPos, '!'); // beak servo open
  delay(20);
  
  transmit_action('^', 'E', 6, rwingUpPos, '!'); // right wing servo up
  delay(20);
  
  transmit_action('^', 'E', 7, lwingUpPos, '!'); // left wing servo up
  delay(20);
  
  transmit_action('^', 'E', 9, beakClosedPos, '!'); // beak servo closed
  delay(20);
  
  transmit_action('^', 'E', 10, rwingDownPos, '!'); // right wing down
  delay(20);
  
  transmit_action('^', 'E', 11, lwingDownPos, '!'); // left wing down
  delay(20);
  
  transmit_action('^', 'E', 14, 0, '!'); // leds
  delay(20);
  
  println("...Done writing!");
  
}


// -- BUTTONS -- //

public void beakopen_button(int theValue) {
  if(DEBUG) println("beakopen pressed");
  transmit_action('#', 'B', 0, 0, '!');
}

public void beakclosed_button(int theValue) {
  if(DEBUG) println("beakclosed pressed");
  transmit_action('#', 'B', 1, 0, '!');
}


public void lwingup_button(int theValue) {
  if(DEBUG) println("lwingup pressed");
  transmit_action('#', 'L', 0, 0, '!');
}

public void lwingdown_button(int theValue) {
  if(DEBUG) println("lwingdown pressed");
  transmit_action('#', 'L', 1, 0, '!');
}

public void lwinghome_button(int theValue) {
  if(DEBUG) println("lwinghome pressed");
  transmit_action('#', 'L', 2, 0, '!');
}


public void rwingup_button(int theValue) {
  if(DEBUG) println("rwingup pressed");
  transmit_action('#', 'R', 0, 0, '!');
}

public void rwingdown_button(int theValue) {
  if(DEBUG) println("rwingdown pressed");
  transmit_action('#', 'R', 1, 0, '!');
}

public void rwinghome_button(int theValue) {
  if(DEBUG) println("rwinghome pressed");
  transmit_action('#', 'R', 2, 0, '!');
}


// -- LEDs -- //

void redSlider(int s) {
  redVal = s;
  if(DEBUG) println("red: " + redVal);
  transmit_action('@', 'E', 0, redVal, '!');
  last_eye_change = millis();
  eye_changed = true;
  //saveXml();
}

void greenSlider(int s) {
  greenVal = s;
  if(DEBUG) println("green: " + greenVal);
  transmit_action('@', 'E', 1, greenVal, '!');
  last_eye_change = millis();
  eye_changed = true;
  //saveXml();
}

void blueSlider(int s) {
  blueVal = s;
  if(DEBUG) println("blue: " + blueVal);
  transmit_action('@', 'E', 2, blueVal, '!');
  last_eye_change = millis();
  eye_changed = true;
  //saveXml();
}

public void eye_button(int theValue) {
  if(DEBUG) println("eye button pressed");
  
  if(eye_press) {
    redSlider(255);
    delay(20);
    greenSlider(255);
    delay(20);
    blueSlider(255);
    delay(20);
    
    mix1Colour.setBackground(white);
    mix1Colour.setForeground(black);
    
  } else {
    redSlider(0);
    delay(20);
    greenSlider(0);
    delay(20);
    blueSlider(0);
    delay(20);
    
    mix1Colour.setBackground(black);
    mix1Colour.setForeground(white);
    
  }
  
  eye_press = !eye_press;
  
  cp5.getController("eye_button").setColor(mix1Colour);
  
  
  ((Slider)cp5.getController("redSlider")).setValue(redVal);
  ((Slider)cp5.getController("greenSlider")).setValue(greenVal);
  ((Slider)cp5.getController("blueSlider")).setValue(blueVal);
  
  last_eye_change = millis();
  eye_changed = true;
  
}


// -- LDRS -- //

public void enable_ldrs_button(int theValue) {
  if(DEBUG) println("enable_ldrs_button pressed");
  refresh_ldrs = !refresh_ldrs;
  
  if(refresh_ldrs) {
    ((Button)cp5.getController("enable_ldrs_button")).setCaptionLabel("Disable");  
  } else {
    ((Button)cp5.getController("enable_ldrs_button")).setCaptionLabel("Enable"); 
  }
  
}


