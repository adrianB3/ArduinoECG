import processing.serial.*; //librarie folosita pentru a accesa interfata seriala

Serial myPort;        
int xPos = 1;        
float height_old = 0;
float height_new = 0;
float inByte = 0;


void setup () {
  // set the window size:
  size(1000, 400);        

  // Afisarea porturilor seriale disponibile
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600); //initializare port
  myPort.bufferUntil('\n'); // citire port serial pana la intalnire newline
  background(0xff); //setarea backgroundului
  grid(); // desenare grid
}

void draw () {
   serialEvent(myPort);
   fill(255);
   rect(0,0,80,30);
   drawText(str(inByte)); // afisare valoare curenta
}

void serialEvent (Serial myPort) {
  String inString = myPort.readStringUntil('\n');
  if (inString != null) {
  inString = trim(inString); // eliminare spatii
  
  if (xPos >= width) {
        xPos = 0;
        background(0xff);
        grid(); // daca s-a ajuns la margina ferestrei se reia de la inceput
      } 
      else {
        xPos++; // creste pozitia pe axa x
      }

    if (float(inString) == -1) { 
      stroke(0, 0, 0xff); // setare culoare albastra (R, G, B)
      inByte = 512;  // middle of the ADC range (Flat Line)
    }
    else {
      stroke(0xff, 0, 0); // setare culoare rosie ( R, G, B)
      inByte = float(inString); 
     }
     strokeWeight(2); // setare grosime drawer
     inByte = map(inByte, 0, 1023, 0, height); // maparea valorilor analogice pentru a incapea in fereastra
     height_new = height - inByte; 
     line(xPos - 1, height_old, xPos, height_new); // desenare linie pe axa x intre amplitudinea semnalului anterior si curent
     height_old = height_new; // semnalul anterior devine cel curent
  }
}

void grid() {
  // desenare grid
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
 //afisare text
  fill(0);
  text(content,10,20);
}