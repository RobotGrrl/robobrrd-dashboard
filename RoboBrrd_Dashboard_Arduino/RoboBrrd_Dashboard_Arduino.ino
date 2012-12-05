/*
RoboBrrd Dashboard Arduino!
---------------------------
This is the Arduino code used with the RoboBrrd Dashboard program.
It will listen for the data sent to it, and send back sensor data
over Serial.
robobrrd.com/dashboard

**This is a beta, if something is broken, let me know!**
Twitter: @RobotGrrl

This code is released under the BSD 3-Clause License.
See the bottom of sketch for license information!

Dec. 4, 2012
robobrrd.com/dashboard
*/

#include <Streaming.h>
#include <Servo.h> 

#define DEBUG false
int ticks = 0;
long lastSend = 0;

Servo rwing, lwing, beak;

// -- SERVO PINS -- //
// label your servo pin numbers here
const int rpin = 9;
const int lpin = 8;
const int bpin = 10;

// -- SERVO VALUES -- //
// determine the min and max values of
// your servos, and write them here
const int r_upper = 0;
const int r_lower = 40;

const int l_upper = 180;
const int l_lower = 110;

const int b_open = 80;
const int b_closed = 0;

int r_middle = 25;//(int)(abs(r_upper-r_lower)/2)+r_upper;
int l_middle = 130;//(int)(abs(l_upper-l_lower)/2)+l_lower;

// -- LED PINS -- //
// the rgb pins of your servos
const int rr = 4;
const int gr = 5;
const int br = 6;
const int rl = 11;
const int gl = 12;
const int bl = 13;

int leds[] = {
  rr, gr, br, rl, gl, bl};

boolean safe = false;
const int distPin = A0;

// -- lalalala -- //
boolean reading = false;
boolean completed = false;
int msgIndex = 0;
const int msgLen = 12;
char msg[msgLen];

char cmd[2];
char val[4];
int valLen = 0;
double valResult = 0;

// areas //
// !BK:180~
char allCmds[12][2] = { {'B', 'K'},
                        {'L', 'W'},
                        {'R', 'W'},
                        {'A', 'X'},
                        {'R', '1'},
                        {'G', '1'},
                        {'B', '1'},
                        {'R', '2'},
                        {'G', '2'},
                        {'B', '2'},                   
                        {'L', 'D'},
                        {'R', 'D'} };

int cmdCount = 12;
int cmdRow = 99;
                   
// actions //
static int bkOpenSerial = 0;
static int bkClosedSerial = 1;

static int lwingUpSerial = 2;
static int lwingDownSerial = 3;
static int lwingHomeSerial = 4;

static int rwingUpSerial = 5;
static int rwingDownSerial = 6;
static int rwingHomeSerial = 7;


void setup() {
  Serial.begin(9600);
  
  rwing.attach(rpin);
  lwing.attach(lpin);
  beak.attach(bpin); 

  rwing.write(r_middle);
  lwing.write(l_middle);
  beak.write(b_closed);


  if(safe) {
    pinMode(rr, INPUT);
    pinMode(gr, INPUT);
    pinMode(br, INPUT);
    pinMode(rl, INPUT);
    pinMode(gl, INPUT);
    pinMode(bl, INPUT);
  } 
  else {
    pinMode(rr, OUTPUT);
    pinMode(gr, OUTPUT);
    pinMode(br, OUTPUT);
    pinMode(rl, OUTPUT);
    pinMode(gl, OUTPUT);
    pinMode(bl, OUTPUT);
  }

  pinMode(distPin, INPUT);
  
}

void loop() {

  // -- LISTEN -- //
  char m;
  if(Serial.available() > 0) {
    while(Serial.available() > 0) {
    
      m = Serial.read();
      
      if(m == '!') {
        reading = true;
      }
      
      if(reading) {
        if(msgIndex < msgLen) msg[msgIndex++] = m; 
      }
      
      if(m == '~') {
        reading = false;
        completed = true;
      }
      
    }
  }
  
  if(completed) {
   if(DEBUG) Serial << "good job" << endl; 
   
   for(int i=0; i<msgIndex; i++) {
     if(DEBUG) Serial << msg[i];
   }
   if(DEBUG) Serial << "\n";
   
   if(msg[0] == '!') {
     cmd[0] = msg[1];
     cmd[1] = msg[2];
   }
   
   if(msg[3] == ':') {
     for(int i=4; i<(msgIndex-1); i++) {
       val[i-4] = msg[i];
     }
     valLen = msgIndex-5;
   }
   
   boolean good = false;
   if(msg[(msgIndex-1)] == '~') {
     good = true;
   }
   
   if(good) {
     if(DEBUG) Serial << "good!" << endl;
     
     boolean match = false;
       for(int j=0; j<cmdCount; j++) {
         if(cmd[0] == allCmds[j][0]) {
           if(cmd[1] == allCmds[j][1]) {
             if(DEBUG) Serial << "match!" << j << endl;
             match = true;
             cmdRow = j;
           }
         }
       }
       
       if(match) {
           
           for(int i=0; i<valLen; i++) {
             if(DEBUG) Serial << val[i] << " ";
           }
           if(DEBUG) Serial << endl;
           
           for(int i=0; i<valLen; i++) {
               valResult += (val[(valLen-1)-i] - '0')*pow(10, i);
               if(DEBUG) Serial << i << ": " << val[(valLen-1)-i] << " " << (val[(valLen-1)-i] - '0') << " " << pow(10, i) << "=" << (val[(valLen-1)-i] - '0')*pow(10, i) << endl;
           }
           
           /*  
           if(valLen > 3) {
             valResult += (val[0] - '0')*1000;
             valResult += (val[1] - '0')*100;
             valResult += (val[2] - '0')*10;
             valResult += (val[3] - '0')*1;
           } else if(valLen > 2) {
             valResult += (val[0] - '0')*100;
             valResult += (val[1] - '0')*10;
             valResult += (val[2] - '0')*1;
           } else if(valLen > 1) {
             valResult += (val[1] - '0')*10;
             valResult += (val[2] - '0')*1;
           } else {
             valResult += (val[0] - '0')*1;
           }
           */
           
           if(DEBUG) Serial << "Result: " << (int)valResult << endl;
           
           // do something with result
           
           switch(cmdRow) {
             case 0: // beak
             beak.write((int)valResult);
             break;
             case 1: // left wing
             lwing.write((int)valResult);
             break;
             case 2: // right wing
             rwing.write((int)valResult);
             break;
             case 3: // action
             break;
             case 4: {// red1
             
             if((int)valResult == 1) {
                digitalWrite(rl, HIGH);
              } else {
                digitalWrite(rl, LOW);
              }
             
             break;
             }
             case 5: {// green1
             
             if((int)valResult == 1) {
                digitalWrite(gl, HIGH);
              } else {
                digitalWrite(gl, LOW);
              }
             
             break;
             }
             case 6: {// blue1
             
             if((int)valResult == 1) {
                digitalWrite(bl, HIGH);
              } else {
                digitalWrite(bl, LOW);
              }
             
             break;
             }
             case 7: {// red2
             
             if((int)valResult == 1) {
                digitalWrite(rr, HIGH);
              } else {
                digitalWrite(rr, LOW);
              }
             
             break;
             }
             case 8: {// green2
             
             if((int)valResult == 1) {
                digitalWrite(gr, HIGH);
              } else {
                digitalWrite(gr, LOW);
              }
             
             break;
             }
             case 9: {// blue2
             
             if((int)valResult == 1) {
                digitalWrite(br, HIGH);
              } else {
                digitalWrite(br, LOW);
              }
             
             break;
             }
           }
           
           
           // at the end, clean!
           valResult = 0;
           valLen = 0;

       }
     
   }
   
   msgIndex = 0;
   completed = false;
   
  }
  
  
  // -- SENSORS -- //
  if(millis()-lastSend >= 20) {
  
  if(ticks%2 == 0) {
    Serial << "!" << "LD" << ":" << analogRead(A0) << "~" << endl;
  } else {
    Serial << "!" << "RD" << ":" << analogRead(A1) << "~" << endl;
  }
  
  lastSend = millis();
  
  }
  
  ticks++;
  
}



// -- WINGS -- //

void leftWave(int repeat, int d) {
  for(int i=0; i<repeat; i++) {
    lwing.write(l_upper);
    delay(d);
    lwing.write(l_lower);
    delay(d);
  }
  lwing.write(l_middle);
}

void rightWave(int repeat, int d) {
  for(int i=0; i<repeat; i++) {
    rwing.write(r_upper);
    delay(d);
    rwing.write(r_lower);
    delay(d);
  }
  rwing.write(r_middle);
}

void bothWave(int repeat, int d, boolean alt) {
  for(int i=0; i<repeat; i++) {
    rwing.write(r_upper);
    if(alt) {
      lwing.write(l_lower);
    } 
    else {
      lwing.write(l_upper); 
    }
    delay(d);
    rwing.write(r_lower);
    if(alt) {
      lwing.write(l_upper);
    } 
    else {
      lwing.write(l_lower); 
    }
    delay(d);
  }
  rwing.write(r_middle);
  lwing.write(l_middle);
}


// -- BEAK -- //

void beakOpen(int s) {
  beak.write(b_open);
  delay(s);
}

void beakClose(int s) {
  beak.write(b_closed);
  delay(s);
}

// -- EYES -- //

void eyes(int rr0, int gr0, int br0, int rl0, int gl0, int bl0) {

  //Serial << rr0 << gr0 << br0 << rl0 << gl0 << bl0 << endl;

  if(rr0 == 1) {
    digitalWrite(rr, HIGH);
  } 
  else if(rr0 == 0) {
    digitalWrite(rr, LOW);
  }

  if(gr0 == 1) {
    digitalWrite(gr, HIGH);
  } 
  else if(gr0 == 0) {
    digitalWrite(gr, LOW);
  }

  if(br0 == 1) {
    digitalWrite(br, HIGH);
  } 
  else if(br0 == 0) {
    digitalWrite(br, LOW);
  }

  if(rl0 == 1) {
    digitalWrite(rl, HIGH);
  } 
  else if(rl0 == 0) {
    digitalWrite(rl, LOW);
  }

  if(gl0 == 1) {
    digitalWrite(gl, HIGH);
  } 
  else if(gl0 == 0) {
    digitalWrite(gl, LOW);
  }

  if(bl0 == 1) {
    digitalWrite(bl, HIGH);
  } 
  else if(bl0 == 0) {
    digitalWrite(bl, LOW);
  }

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

