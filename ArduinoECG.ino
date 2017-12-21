#include <LiquidCrystal_I2C.h>
#include <Wire.h>
// Above for testing purposes

//#include <LiquidCrystal.h>
//LiquidCrystal lcd(7, 6, 5, 4, 3, 2);

LiquidCrystal_I2C lcd(0x27, 2, 1, 0, 4, 5, 6, 7, 3, POSITIVE);  // Set the LCD I2C address

typedef enum {on, off, wait}sysState; //definire stari sistem

class sysComponent {
protected:
	uint8_t pin,IO;
public:
	sysComponent(uint8_t pin) {
		this->pin = pin; //definire pin folosit de componenta
	}
	
	virtual void setIO(uint8_t IO) {
		this->IO = IO; //definire tip pin intrare/iesire
	}

	virtual uint8_t getPin() {
		return pin; // returnare pin folosit de componenta
	}

	virtual void setOn() {};
	virtual void setOff() {};
};

class led:public sysComponent {
	sysState ledState;
public:
	led(uint8_t pin,sysState ledState) :sysComponent(pin) {
		this->ledState = ledState;
	}

	void setOn() {
		digitalWrite(pin, HIGH); // activarea unui led
		this->ledState = on;
	}

	void setOff() {
		digitalWrite(pin, LOW); // dezactivarea unui led
		this->ledState = off;
	}
};

class ecgSensor : public sysComponent {
	sysState ecgState;
	int value;
	int loPlus, loMinus;
	int loPlusPin, loMinusPin;
public:
	ecgSensor(uint8_t pin, int loPlusPin, int loMinusPin) :sysComponent(pin) {
		this->pin = pin;
		this->loPlusPin = loPlusPin;
		this->loMinusPin = loMinusPin; // definire pini folositi de senzorul ecg

		pinMode(loPlusPin, INPUT);
		pinMode(loMinusPin, INPUT);
	}

	void readData() {
		//this->loPlus = digitalRead(loPlusPin);
		//this->loMinus = digitalRead(loMinusPin);
		//for testing
		loPlus = 0;
		loMinus = 0;

		if (loPlus == 1 || loMinus == 1) { 
			// daca exista interferente sau un conector este desprins
			// este returnata valoarea -1 si sistemul este in asteptare
			value = -1;						
			Serial.println(value);
			ecgState = wait;
		}
		else {
			// se trimit date in interfata seriala spre a fi prelucrate de Processing
			value = analogRead(pin);
			Serial.println(int(value));
			ecgState = on;
		}
	}

	sysState getState() {
		return ecgState; // returneaza starea curenta a senzorului
	}
};

led ledRosu(2,off); //real 13
led ledAlbastru(3,off); //real 12
ecgSensor ecg(A1, 10, 11);

void setup()
{	//initializari
	Serial.begin(9600); //comunicare la 9600 baud
	lcd.begin(16, 2);
	lcd.clear();
	ledRosu.setIO(OUTPUT);
	ledAlbastru.setIO(OUTPUT);
	ecg.setIO(INPUT);
}

void loop()
{
	sysState state;
	ecg.readData(); // citire date
	state = ecg.getState(); 
	switch (state) // se efectueaza actiuni in functie de starea in care se afla sistemul
	{
	case wait: 
		ledRosu.setOn();
		ledAlbastru.setOff();
		lcd.setCursor(0, 0);
		lcd.print("Waiting for");
		lcd.setCursor(0, 1);
		lcd.print("signal...");
		break;
	case on: 
		lcd.setCursor(0, 0);
		lcd.write("Getting signal!");
		lcd.setCursor(0, 1);
		lcd.print(analogRead(ecg.getPin()));
		ledRosu.setOff();
		ledAlbastru.setOn();
		ecg.readData();
		break;
	}
}
