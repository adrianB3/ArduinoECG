

void setup()
{
	Serial.begin(9600);
	pinMode(2, OUTPUT);

}

void loop()
{
	Serial.println(analogRead(A1));
	digitalWrite(2, HIGH);

}
