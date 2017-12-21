
#include <LiquidCrystal_I2C.h>
#include <Wire.h>
// Above for testing purposes

//#include <LiquidCrystal.h>
//LiquidCrystal lcd(12, 11, 10, 5, 4, 3, 2);

LiquidCrystal_I2C lcd(0x27, 2, 1, 0, 4, 5, 6, 7, 3, POSITIVE);  // Set the LCD I2C address

typedef enum {on, off, wait}sysState;

class componentaSistem {
protected:
	uint8_t pin;
public:
	componentaSistem(uint8_t pin) {
		this->pin = pin;
	}

	virtual uint8_t getPin() {
		return pin;
	}

	virtual void setOn() {};
	virtual void setOff() {};
};

class led:public componentaSistem {
	sysState ledState;
public:
	led(uint8_t pin, sysState ledState) :componentaSistem(pin) {
		this->ledState = ledState;
		pinMode(pin, OUTPUT);
	}

	void setOn() {
		digitalWrite(pin, HIGH);
		this->ledState = on;
	}

	void setOff() {
		digitalWrite(pin, LOW);
		this->ledState = off;
	}
};

class ecgSensor : public componentaSistem {
	sysState state;
	int value, loPlus, loMinus;
	int loPlusPin, loMinusPin;
public:
	ecgSensor(uint8_t pin, int loPlusPin, int loMinusPin) :componentaSistem(pin) {
		this->pin = pin;
		this->loPlusPin = loPlusPin;
		this->loMinusPin = loMinusPin;

		pinMode(pin, INPUT);
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
			value = -1;
			Serial.println(float(value));
			state = wait;
		}
		else {
			value = analogRead(pin);
			Serial.println(float(value));
			state = on;
		}
	}

	sysState getState() {
		return state;
	}
};

led ledRosu(2, off); //real 13
led ledAlbastru(3, off); //real 12
ecgSensor ecg(A1, 10, 11);

void setup()
{
	Serial.begin(9600);
	lcd.begin(16, 2);
	lcd.clear();
}

void loop()
{
	sysState state;
	ecg.readData();
	state = ecg.getState();
	switch (state)
	{
	case wait: 
		ledRosu.setOn();
		ledAlbastru.setOff();
		lcd.setCursor(0, 0);
		lcd.write("Waiting..");
		break;
	case on: 
		lcd.setCursor(0, 0);
		lcd.write("Reading data");
		ledRosu.setOff();
		ledAlbastru.setOn();
		ecg.readData();
		break;
	}
}
