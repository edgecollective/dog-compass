#include <TinyGPS.h>

TinyGPS gps;

//static const uint32_t GPSBaud = 38400;
static const uint32_t GPSBaud = 9600;

void setup() {
  // put your setup code here, to run once:
Serial1.begin(GPSBaud);

Serial.begin(115200);

}

void loop() {

 
  while (Serial1.available() > 0)
  Serial.write(Serial1.read());


  // put your main code here, to run repeatedly:

/*
 bool newData = false;
  unsigned long chars;
  unsigned short sentences, failed;

  // For one second we parse GPS data and report some key values
  for (unsigned long start = millis(); millis() - start < 1000;)
  {
    while (Serial1.available())
    {
      char c = Serial1.read();
      // Serial.write(c); // uncomment this line if you want to see the GPS data flowing
      if (gps.encode(c)) // Did a new valid sentence come in?
        newData = true;
    }
  }

  if (newData)
  {
    
    float flat, flon;
    unsigned long age;
    gps.f_get_position(&flat, &flon, &age);
    Serial.print(flat == TinyGPS::GPS_INVALID_F_ANGLE ? 0.0 : flat, 6);
    Serial.print(",");
    Serial.println(flon == TinyGPS::GPS_INVALID_F_ANGLE ? 0.0 : flon, 6);

    Serial.print(flat);
    Serial.print(",");
    Serial.println(flon);
    
  delay(500);
  }

  gps.stats(&chars, &sentences, &failed);
  
  if (chars == 0)
    Serial.println("** No characters received from GPS: check wiring **");

    */
}
