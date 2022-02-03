// Feather9x_TX
// -*- mode: C++ -*-
// Example sketch showing how to create a simple messaging client (transmitter)
// with the RH_RF95 class. RH_RF95 class does not provide for addressing or
// reliability, so you should only use RH_RF95 if you do not need the higher
// level messaging abilities.
// It is designed to work with the other example Feather9x_RX

#include <SPI.h>
#include <RH_RF95.h>
#include <TinyGPS.h> //https://github.com/mikalhart/TinyGPSPlus

// Radio pins for feather M0 on Node
#define RFM95_CS 5
#define RFM95_RST 6
#define RFM95_INT 9 
#define bufflength 100

#define LED 13

#define gpsPowerPin A4

// Change to 434.0 or other frequency, must match RX's freq!
#define RF95_FREQ 915.0

// Singleton instance of the radio driver
RH_RF95 rf95(RFM95_CS, RFM95_INT);



char buf[bufflength];
// gps stuff
static const uint32_t GPSBaud = 9600;
float flat;
float flon;

// The TinyGPS++ object
TinyGPS gps;

// The serial connection to the GPS device

void getGPSInfoString(char *p, size_t len) {

String lon_value = String(flat,6);
String lat_value = String(flon,6);
Serial.println("getting");
Serial.print(lon_value);
Serial.println(lat_value);

sprintf(p, "[%s,%s]",lat_value.c_str(),lon_value.c_str());

}

void setup() 
{

    pinMode(gpsPowerPin,OUTPUT);
  digitalWrite(gpsPowerPin, HIGH);
  
  pinMode(LED, OUTPUT);
  
  pinMode(RFM95_RST, OUTPUT);
  digitalWrite(RFM95_RST, HIGH);

  Serial.begin(9600);
  Serial1.begin(GPSBaud);
  /*while (!Serial) {
    delay(1);
  }
  */

  delay(100);

  Serial.println("Feather LoRa TX Test!");

  // manual reset
  digitalWrite(RFM95_RST, LOW);
  delay(10);
  digitalWrite(RFM95_RST, HIGH);
  delay(10);

  while (!rf95.init()) {
    Serial.println("LoRa radio init failed");
    Serial.println("Uncomment '#define SERIAL_DEBUG' in RH_RF95.cpp for detailed debug info");
    while (1);
  }
  Serial.println("LoRa radio init OK!");

  // Defaults after init are 434.0MHz, modulation GFSK_Rb250Fd250, +13dbM
  if (!rf95.setFrequency(RF95_FREQ)) {
    Serial.println("setFrequency failed");
    while (1);
  }
  Serial.print("Set Freq to: "); Serial.println(RF95_FREQ);
  
  // Defaults after init are 434.0MHz, 13dBm, Bw = 125 kHz, Cr = 4/5, Sf = 128chips/symbol, CRC on

  // The default transmitter power is 13dBm, using PA_BOOST.
  // If you are using RFM95/96/97/98 modules which uses the PA_BOOST transmitter pin, then 
  // you can set transmitter powers from 5 to 23 dBm:
  rf95.setTxPower(23, false);
}

int16_t packetnum = 0;  // packet counter, we increment per xmission

void loop() {

  bool newData = false;
  unsigned long chars;
  unsigned short sentences, failed;

  // For one second we parse GPS data and report some key values
  for (unsigned long start = millis(); millis() - start < 1000;)
  {
    while (Serial1.available())
    {
      char c = Serial1.read();
       //Serial.write(c); // uncomment this line if you want to see the GPS data flowing
      if (gps.encode(c)) // Did a new valid sentence come in?
        newData = true;
    }
  }

  if (newData)
  {
    
    
    unsigned long age;
    gps.f_get_position(&flat, &flon, &age);
    //Serial.print(flat == TinyGPS::GPS_INVALID_F_ANGLE ? 0.0 : flat, 6);
    //Serial.print(",");
    //Serial.println(flon == TinyGPS::GPS_INVALID_F_ANGLE ? 0.0 : flon, 6);

   // message buffer
      

      getGPSInfoString(buf, bufflength);

   delay(1000); // Wait 1 second between transmits, could also 'sleep' here!
  Serial.println("Transmitting..."); // Send a message to rf95_server
  
  //char radiopacket[20] = "Hello World #      ";
  //itoa(packetnum++, radiopacket+13, 10);
  Serial.print("Sending "); Serial.println(buf);
  //radiopacket[19] = 0;
  
  //Serial.println("Sending...");
  delay(10);
  
  rf95.send((uint8_t *)buf, bufflength);

  Serial.println("Waiting for packet to complete..."); 
  delay(10);
  digitalWrite(LED, HIGH);
  rf95.waitPacketSent();
  digitalWrite(LED, LOW);
  
  delay(500);
  }

  gps.stats(&chars, &sentences, &failed);
  
  if (chars == 0)
    Serial.println("** No characters received from GPS: check wiring **");


}
