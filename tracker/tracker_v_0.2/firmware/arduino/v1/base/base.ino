#include <TinyGPS++.h>

#include <Wire.h>

#include <RHSoftwareSPI.h>  // http://www.airspayce.com/mikem/arduino/RadioHead/RadioHead-1.113.zip
#include <RHRouter.h>
#include <RHMesh.h>
#include <RH_RF95.h>
#include <SPI.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SharpMem.h>

#include <Adafruit_Sensor.h>
#include <Adafruit_BNO055.h>
#include <utility/imumaths.h>

/* Set the delay between fresh samples */
#define BNO055_SAMPLERATE_DELAY_MS (100)

// Check I2C device address and correct line below (by default address is 0x29 or 0x28)
//                                   id, address
Adafruit_BNO055 bno = Adafruit_BNO055(55, 0x28);



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

float heading=-1000; // our heading
float bearing=-1000; // bearing from remote node to us
float relative_bearing=-1000; // relative bearing between heading and bearing
float distance_feet = -1000;

// The serial connection to the GPS device
//SoftwareSerial ss(RXPin, TXPin);

#define gpsPowerPin 9

//Adafruit_SharpMem display(SHARP_SCK, SHARP_MOSI, SHARP_SS, 144, 168);
// The currently-available SHARP Memory Display (144x168 pixels)
// requires > 4K of microcontroller RAM; it WILL NOT WORK on Arduino Uno
// or other <4K "classic" devices!  The original display (96x96 pixels)
// does work there, but is no longer produced.

#define display_width 144
#define display_height 168

Adafruit_SharpMem display(&SPI, SHARP_SS, 144, 168,8000000);

#define BLACK 0
#define WHITE 1

#define r 30
#define mx int(display_width/2)
#define my int(display_height/3)
  
int minorHalfSize; // 1/2 of lesser of display width or height

void displaySensorDetails(void)
{
  sensor_t sensor;
  bno.getSensor(&sensor);
  Serial.println("------------------------------------");
  Serial.print  ("Sensor:       "); Serial.println(sensor.name);
  Serial.print  ("Driver Ver:   "); Serial.println(sensor.version);
  Serial.print  ("Unique ID:    "); Serial.println(sensor.sensor_id);
  Serial.print  ("Max Value:    "); Serial.print(sensor.max_value); Serial.println(" xxx");
  Serial.print  ("Min Value:    "); Serial.print(sensor.min_value); Serial.println(" xxx");
  Serial.print  ("Resolution:   "); Serial.print(sensor.resolution); Serial.println(" xxx");
  Serial.println("------------------------------------");
  Serial.println("");
  delay(500);
}

void displaySensorStatus(void)
{
  /* Get the system status values (mostly for debugging purposes) */
  uint8_t system_status, self_test_results, system_error;
  system_status = self_test_results = system_error = 0;
  bno.getSystemStatus(&system_status, &self_test_results, &system_error);

  /* Display the results in the Serial Monitor */
  Serial.println("");
  Serial.print("System Status: 0x");
  Serial.println(system_status, HEX);
  Serial.print("Self Test:     0x");
  Serial.println(self_test_results, HEX);
  Serial.print("System Error:  0x");
  Serial.println(system_error, HEX);
  Serial.println("");
  delay(500);
}

void displayCalStatus(void)
{
  /* Get the four calibration values (0..3) */
  /* Any sensor data reporting 0 should be ignored, */
  /* 3 means 'fully calibrated" */
  uint8_t system, gyro, accel, mag;
  system = gyro = accel = mag = 0;
  bno.getCalibration(&system, &gyro, &accel, &mag);

  /* The data should be ignored until the system calibration is > 0 */
  //Serial.print("\t");
  if (!system)
  {
    Serial.print("! ");
  }

  /* Display the individual values */
  Serial.print("Sys:");
  Serial.print(system, DEC);
  Serial.print(" G:");
  Serial.print(gyro, DEC);
  Serial.print(" A:");
  Serial.print(accel, DEC);
  Serial.print(" M:");
  Serial.print(mag, DEC);
}

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

// IMU

/* Initialise the sensor */
  if(!bno.begin())
  {
    /* There was a problem detecting the BNO055 ... check your connections */
    Serial.print("Ooops, no BNO055 detected ... Check your wiring or I2C ADDR!");
    while(1);
  }

  delay(1000);

  /* Display some basic information on this sensor */
  displaySensorDetails();

  /* Optional: Display current status */
  displaySensorStatus();

  bno.setExtCrystalUse(true);


  // radio

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

  display.clearDisplay();
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

/* Get a new sensor event */
  sensors_event_t event;
  bno.getEvent(&event);
  heading = event.orientation.x;

  displayCalStatus();
  Serial.println();
  Serial.print("heading:");
  Serial.println(heading);

  // display updates ...
  display.clearDisplay();
  
  drawCompass(heading);
  
  if(relative_bearing != -1000) {
  drawRemote(relative_bearing);
  }

  if(distance_feet != -1000) {
    drawStats();
  }
  

  display.refresh();
  
  delay(BNO055_SAMPLERATE_DELAY_MS);

    
    
    Serial.println("=======");
  

    
 // get our own heading
 //heading = 0.;
 
  if (gps.location.isValid())
  {
    /*u8x8.setCursor(0,4);
    u8x8.print("lat:");
    u8x8.print(gps.location.lat(),6);
    u8x8.setCursor(0,6);
    u8x8.print("lon:");
    u8x8.print(gps.location.lng(),6);
    */
    
    /*
     Serial.print(gps.location.lat(), 6);
    Serial.print(F(","));
    Serial.println(gps.location.lng(), 6);
    */

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

      //lat2 = 42.410533785024185;
      //lon2 = -71.13293291015793;

      Serial.println();
      Serial.print("lat2:");
      Serial.print(lat2);
      Serial.print("; lon2:");
      Serial.println(lon2);

      //display.clearDisplay();

      bearing = getBearing(lat1,lon1,lat2,lon2);
  
      Serial.print("bearing:");
      Serial.println(bearing);
  
      relative_bearing = bearing-heading;
  
      Serial.print("relative_bearing:");
      Serial.println(relative_bearing);

      //drawCompass(heading);

      //drawRemote(relativeBearing);

      
      /// TWERK
      //heading=0.;
      
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

        //int dx = round(r*sin((degree_diff+90)*PI/180.));
        //int dy = round(r*cos((degree_diff+90)*PI/180. ));
        
       
        //delay(4000);
        
      }
}

}

void drawCompass(float heading) {

  // some graphics constants
  //display.drawCircle(mx,my,r);
  display.fillCircle(mx,my,r, BLACK);
  display.fillCircle(mx,my,int(r*.9), WHITE);

  if (heading!=-1000) { // then draw the compass heading
  
  int dx = round(r*sin((heading+180)*PI/180.));
  int dy = round(r*cos((heading+180)*PI/180. ));
  
  display.drawLine(mx, my, mx+dx, my+dy, BLACK);

  //float north_heading = - heading;
  dx = round((r+15)*cos((heading-90)*PI/180.));
  dy = round((r+15)*sin((heading-90)*PI/180. ));
  }

  
  //display.setTextSize(2);
  //display.setTextColor(BLACK);
  //display.setCursor(mx,my-(r+15));
  //display.write('N');
  
  //display.refresh();
}

void drawStats(){

  display.setTextSize(2);
  display.setTextColor(BLACK);
  display.setCursor(0,display_height/2+30);
  display.print("  ");
  display.print(distance_feet);
  display.print("ft");
  
  //display.refresh();
}

void drawRemote(float relativeBearing) {

  int remoteRadius=8;
  float radial_expansion = 1.2;

  int dx = round(r*radial_expansion*cos((relativeBearing-90)*PI/180.));
  int dy = round(r*radial_expansion*sin((relativeBearing-90)*PI/180. ));
  
  display.fillCircle(mx+dx, my+dy, remoteRadius, BLACK);
  display.fillCircle(mx+dx, my+dy, int(remoteRadius*.7), WHITE);
  //display.refresh();
  
}


float getBearing (float lat1, float lon1, float lat2, float lon2) { 

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
        distance_feet = 3.281*distance_meters;
        
        float degree_diff = heading-bearing;

        Serial.print("degree_diff:");
        Serial.println(degree_diff);
        Serial.print("distance_feet:");
        Serial.println(distance_feet);

        //int dx = round(r*sin((degree_diff+90)*PI/180.));
        //int dy = round(r*cos((degree_diff+90)*PI/180. ));
        
        return(bearing);
        //delay(4000);
        
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
