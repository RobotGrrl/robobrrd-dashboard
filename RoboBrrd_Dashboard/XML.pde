
// -- XML HANDLING -- //

void startXml() {
 
 xmlInOut = new XMLInOut(this);
  try{
    xmlInOut.loadElement(dataPath("settings.xml")); 
  }catch(Exception e){
    // derp?
  }
  
  
}


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
  XMLElement ledsXml;
  
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

  ledsXml = settingsXml.getChild(2);
  redVal_r = ledsXml.getIntAttribute("red");
  greenVal_r = ledsXml.getIntAttribute("green");
  blueVal_r = ledsXml.getIntAttribute("blue");
  
  println("read xml" + redVal_r);
  
}

void saveXml() {
  
  if(millis() <= 1000) return; // WTF
  
  XMLElement settingsXml0 = new XMLElement("settings");
 
  XMLElement themeXml0 = new XMLElement("theme");
  XMLElement servosXml0 = new XMLElement("servos");
  
  XMLElement ledsXml0 = new XMLElement("leds");
  
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
  
  ledsXml0.addAttribute("red", redVal);
  ledsXml0.addAttribute("green", greenVal);
  ledsXml0.addAttribute("blue", blueVal);
  
  settingsXml0.addChild(ledsXml0);
  
  xmlInOut.saveElement(settingsXml0, "settings.xml");
  
  
  println("wrote xml");
  
}

