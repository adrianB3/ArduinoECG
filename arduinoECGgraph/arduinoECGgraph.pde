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
 //line(xPos - 1, height_old, xPos, height_new);
}

void serialEvent (Serial myPort) {
  String inString = myPort.readStringUntil('\n');

  if (inString != null) {
    inString = trim(inString);

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
     text(inString,50,50);
     line(xPos - 1, height_old, xPos, height_new);
     height_old = height_new;
  
      if (xPos >= width) {
        xPos = 0;
        background(0xff);
      } 
      else {
        xPos++;
      }
  }
}

void grid() {
    for (int i=0; i<width; i++) {
      for (int j=0; j<height; j++) {
        noFill();
        rect(i*width/8, j*height/8, width, height);
      }
    }
  }