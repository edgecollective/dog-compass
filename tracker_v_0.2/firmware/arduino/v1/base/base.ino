#include <TinyGPS++.h>

#include <Wire.h>

#include <RHSoftwareSPI.h>  // http://www.airspayce.com/mikem/arduino/RadioHead/RadioHead-1.113.zip
#include <RHRouter.h>
#include <RHMesh.h>
#include <RH_RF95.h>
#include <SPI.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SharpMem.h>

#define RF95_FREQ 915.0
#define gatewayNode 1

#define LED 13

// any pins can be used
#define SHARP_SCK  25
#define SHARP_MOSI 24
#define SHARP_SS   5

RHMesh *manager;

static const uint32_t GPSBaud = 9600;
typedef struct {
  float lat;
  float lon;
} Payload;

Payload theData;

// Radio pins for feather M0
#define RFM95_CS 11
#define RFM95_RST 6
#define RFM95_INT 12

#define LED 13

RH_RF95 rf95(RFM95_CS, RFM95_INT);

#define waitTime 1000

float flat=0.;
float flon=0.;
float lat1;
float lon1;
float lat2;
float lon2;

int everGotGPS=0;

long lastReading = 0;

// The TinyGPS++ object
TinyGPSPlus gps;

float heading; // our heading
float bearing; // bearing from remote node to us

#define r 22
#define mx 120-r
#define my 32

// The serial connection to the GPS device
//SoftwareSerial ss(RXPin, TXPin);

#define gpsPowerPin 9

//Adafruit_SharpMem display(SHARP_SCK, SHARP_MOSI, SHARP_SS, 144, 168);
// The currently-available SHARP Memory Display (144x168 pixels)
// requires > 4K of microcontroller RAM; it WILL NOT WORK on Arduino Uno
// or other <4K "classic" devices!  The original display (96x96 pixels)
// does work there, but is no longer produced.

Adafruit_SharpMem display(&SPI, SHARP_SS, 144, 168,8000000);

#define BLACK 0
#define WHITE 1

int minorHalfSize; // 1/2 of lesser of display width or height


void setup()
{

  pinMode(gpsPowerPin,OUTPUT);
  digitalWrite(gpsPowerPin, HIGH);

  pinMode(LED,OUTPUT);
  
  delay(1); // give gps time to boot up

  // start & clear the display
  display.begin();
  display.clearDisplay();
  // text display tests
  display.setTextSize(1);
  display.setTextColor(BLACK);
  display.setCursor(20,20);
  display.println("Hello, world!");
  display.refresh();
  
  delay(2000);
      
  
  Serial.begin(115200);
  
  Serial1.begin(GPSBaud);



 manager = new RHMesh(rf95, gatewayNode);

   if (!manager->init()) {
    Serial.println(F("mesh init failed"));
    
  }
  rf95.setTxPower(23, false);
  rf95.setFrequency(915.0);
  rf95.setCADTimeout(500);

    // long range configuration requires for on-air time
  boolean longRange = false;
  if (longRange) {
    RH_RF95::ModemConfig modem_config = {
      0x78, // Reg 0x1D: BW=125kHz, Coding=4/8, Header=explicit
      0xC4, // Reg 0x1E: Spread=4096chips/symbol, CRC=enable
      0x08  // Reg 0x26: LowDataRate=On, Agc=Off.  0x0C is LowDataRate=ON, ACG=ON
    };
    rf95.setModemRegisters(&modem_config);
    if (!rf95.setModemConfig(RH_RF95::Bw125Cr48Sf4096)) {
      Serial.println(F("set config failed"));
    }
  }

  Serial.println("RF95 ready");


  delay(1500);
  
}

void loop()
{
  
  //display.refresh();
  // This sketch displays information every time a new sentence is correctly encoded.
  while (Serial1.available() > 0)
    if (gps.encode(Serial1.read())) {
     // displayInfo();

      //do compass too

      

if ((millis()-lastReading)>500) {


 // get our own heading
 heading = 0.;
 
  if (gps.location.isValid())
  {
    /*u8x8.setCursor(0,4);
    u8x8.print("lat:");
    u8x8.print(gps.location.lat(),6);
    u8x8.setCursor(0,6);
    u8x8.print("lon:");
    u8x8.print(gps.location.lng(),6);
    */
    Serial.print(gps.location.lat(), 6);
    Serial.print(F(","));
    Serial.println(gps.location.lng(), 6);

    lat1=gps.location.lat();
    lon1=gps.location.lng();

    /*display.clearDisplay();
    display.setTextSize(1);
    display.setTextColor(BLACK);
    display.setCursor(20,20);
    display.print(lat1);
    display.refresh();
    */
      
    everGotGPS=1;
    
  }

  lastReading=millis();
    }


    }

  if (millis() > 5000 && gps.charsProcessed() < 10)
  {
    Serial.println(F("No GPS detected: check wiring."));
    while(true);
  }

uint8_t buf[sizeof(Payload)];
  uint8_t len = sizeof(buf);
  uint8_t from;
  
// listen for lora message
  if (manager->recvfromAckTimeout((uint8_t *)buf, &len, waitTime, &from)) {  // this runs until we receive some message
      // entering this block means the message is for us

    digitalWrite(LED, HIGH);   // turn the LED on (HIGH is the voltage level)
    delay(10);                       // wait for a second
    digitalWrite(LED, LOW);    // turn the LED off by making the voltage LOW
    delay(10);                       // wait for a second
    
     // the rest of this code only runs if we were the intended recipient; which means we're the gateway
      theData = *(Payload*)buf;

      
      lat2 = theData.lat;
      lon2 = theData.lon;

      lat2 = 42.410533785024185;
      lon2 = -71.13293291015793;

      Serial.println();
      Serial.print("lat2:");
      Serial.print(lat2);
      Serial.print("; lon2:");
      Serial.println(lon2);

      display.clearDisplay();
      display.setTextSize(1);
      display.setTextColor(BLACK);
      display.setCursor(20,20);
      display.print(lat1,6);
      display.refresh();

      
      /// TWERK
      heading=0.;
      
      if(everGotGPS) { //then update graphic circle

        float R = 6371000; // metres
        float phi1 = lat1 * PI/180.; // φ, λ in radians
        float phi2 = lat2 * PI/180.;
        float lambda1 = lon1 * PI/180.;
        float lambda2 = lon2 * PI/180.;
        float y = sin(lambda2-lambda1)*cos(phi2);
        float x = cos(phi1)*sin(phi2) - sin(phi1)*cos(phi2)*cos(lambda2-lambda1);
        float theta = atan2(y,x);
        bearing = fmod((theta*180/PI + 360),360);
        
        float distance_meters = acos(sin(lat1*PI/180.)*sin(lat2*PI/180.) + cos(lat1*PI/180.)*cos(lat2*PI/180.)*cos(lon2*PI/180.-lon1*PI/180.) ) * 6371000;
        float distance_feet = 3.281*distance_meters;
        
        float degree_diff = heading-bearing;

        Serial.print("degree_diff:");
        Serial.println(degree_diff);
        Serial.print("distance_feet:");
        Serial.println(distance_feet);

        int dx = round(r*sin((degree_diff+90)*PI/180.));
        int dy = round(r*cos((degree_diff+90)*PI/180. ));
        
       
        //delay(4000);
        
      }
}

}

void displayInfo()
{
  Serial.print(F("Location: ")); 
  if (gps.location.isValid())
  {
    Serial.print(gps.location.lat(), 6);
    Serial.print(F(","));
    Serial.print(gps.location.lng(), 6);
  }
  else
  {
    Serial.print(F("INVALID"));
  }

  Serial.print(F("  Date/Time: "));
  if (gps.date.isValid())
  {
    Serial.print(gps.date.month());
    Serial.print(F("/"));
    Serial.print(gps.date.day());
    Serial.print(F("/"));
    Serial.print(gps.date.year());
  }
  else
  {
    Serial.print(F("INVALID"));
  }

  Serial.print(F(" "));
  if (gps.time.isValid())
  {
    if (gps.time.hour() < 10) Serial.print(F("0"));
    Serial.print(gps.time.hour());
    Serial.print(F(":"));
    if (gps.time.minute() < 10) Serial.print(F("0"));
    Serial.print(gps.time.minute());
    Serial.print(F(":"));
    if (gps.time.second() < 10) Serial.print(F("0"));
    Serial.print(gps.time.second());
    Serial.print(F("."));
    if (gps.time.centisecond() < 10) Serial.print(F("0"));
    Serial.print(gps.time.centisecond());
  }
  else
  {
    Serial.print(F("INVALID"));
  }

  Serial.println();
}

void testdrawchar(void) {
  display.setTextSize(1);
  display.setTextColor(BLACK);
  display.setCursor(0,0);
  display.cp437(true);

  for (int i=0; i < 256; i++) {
    if (i == '\n') continue;
    display.write(i);
  }
  display.refresh();
}
