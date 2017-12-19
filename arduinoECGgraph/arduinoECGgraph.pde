import processing.serial.*;

Serial myPort;        
int xPos = 1;        
float height_old = 0;
float height_new = 0;
float inByte = 0;


void setup () {
  // set the window size:
  size(1000, 400);        

  // List all the available serial ports
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.bufferUntil('\n');
  background(0xff);
  grid();
}

void draw () {
   serialEvent(myPort);
   fill(255);
   rect(0,0,80,30);
   drawText(str(inByte));
}

void serialEvent (Serial myPort) {
  String inString = myPort.readStringUntil('\n');
  if (inString != null) {
  inString = trim(inString);
  
  if (xPos >= width) {
        xPos = 0;
        background(0xff);
        grid();
      } 
      else {
        xPos++;
      }

    if (float(inString) == -1) { 
      stroke(0, 0, 0xff); //Set stroke to blue ( R, G, B)
      inByte = 512;  // middle of the ADC range (Flat Line)
    }
    else {
      stroke(0xff, 0, 0); //Set stroke to red ( R, G, B)
      inByte = float(inString); 
     }
     inByte = map(inByte, 0, 1023, 0, height);
     height_new = height - inByte; 
     strokeWeight(2); 
     line(xPos - 1, height_old, xPos, height_new);
     height_old = height_new;
  }
}

void grid() {
    for (int i=0; i<width; i++) {
      for (int j=0; j<height; j++) {
        strokeWeight(1);
        stroke(0,0,0);
        noFill();
        rect(i*width/8, j*height/8, width/8, height/8);
      }
    }
}

void drawText(String content) {
  fill(0);
  text(content,10,20);
}