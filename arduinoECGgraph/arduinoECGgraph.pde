import processing.serial.*; //librarie folosita pentru a accesa interfata seriala

Serial myPort;        
int xPos = 1;        
float height_old = 0;
float height_new = 0;
float inByte = 0;

void setup () {
  // set the window size:
  //size(1000, 400);
  //surface.setSize(1300,400);
  fullScreen();
  //surface.setResizable(true);
  frameRate(190);
  // Afisarea porturilor seriale disponibile
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600); //initializare port
  myPort.bufferUntil('\n'); // asteptare port serial pana la intalnire newline
  background(0); //setarea backgroundului
  grid(); // desenare grid
}

void draw () {
   fill(0);
   stroke(0,255,0);
   rect(0,0,80,30);
   drawText(str(inByte)); // afisare valoare curenta
   
   String inString = myPort.readStringUntil('\n');
   if (inString != null) {
   inString = trim(inString); // eliminare spatii
  
   if (xPos >= width) {
     xPos = 0;
     background(0);
     grid(); // daca s-a ajuns la margina ferestrei se reia de la inceput
   } 
   else {
     xPos++; // creste pozitia pe axa x
   }

   if (int(inString) == -1) { 
     stroke(0, 0, 0xff); // setare culoare albastra (R, G, B)
     inByte = 512;  // middle of the ADC range (Flat Line)
   }
   else if(float(inString)!= -1){
     stroke(255, 150, 150); // setare culoare rosie ( R, G, B)
     inByte = int(inString); 
   }
    
   float center = height/2;
   inByte = map(int(inByte), 0, 1023, center-200, center+200); // maparea valorilor analogice pentru a incapea in fereastra
   height_new = height - inByte; 
   strokeWeight(2); // setare grosime drawer
   line(xPos - 1, height_old, xPos, height_new); // desenare linie pe axa x intre amplitudinea semnalului anterior si curent
   height_old = height_new; // semnalul anterior devine cel curent
  }
   
}

/*void serialEvent (Serial myPort) {
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

    if (int(inString) == -1) { 
      stroke(0, 0, 0xff); // setare culoare albastra (R, G, B)
      inByte = 512;  // middle of the ADC range (Flat Line)
    }
    else if(float(inString)!= -1){
      stroke(0xff, 0, 0); // setare culoare rosie ( R, G, B)
      inByte = int(inString); 
     }
     inByte = map(int(inByte), 0, 1023, 0, height); // maparea valorilor analogice pentru a incapea in fereastra
     height_new = height - inByte; 
     strokeWeight(2); // setare grosime drawer
     line(xPos - 1, height_old, xPos, height_new); // desenare linie pe axa x intre amplitudinea semnalului anterior si curent
     height_old = height_new; // semnalul anterior devine cel curent
  }
}*/

void grid() {
  // desenare grid
    for (int i=0; i<width; i++) {
      for (int j=0; j<height; j++) {
        strokeWeight(0);
        stroke(0,255,0);
        noFill();
        rect(i*width/16, j*height/16, width/16, height/16);
      }
    }
}

void drawText(String content) {
 //afisare text
  fill(255);
  text(int(content),10,20);
}