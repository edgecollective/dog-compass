#include <TinyGPS++.h>

#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_LSM303_U.h>
#include <Adafruit_BMP085_U.h>
#include <Adafruit_L3GD20_U.h>
#include <Adafruit_10DOF.h>

#include <U8g2lib.h>



/* Assign a unique ID to the sensors */
Adafruit_10DOF                dof   = Adafruit_10DOF();
Adafruit_LSM303_Accel_Unified accel = Adafruit_LSM303_Accel_Unified(30301);
Adafruit_LSM303_Mag_Unified   mag   = Adafruit_LSM303_Mag_Unified(30302);
Adafruit_BMP085_Unified       bmp   = Adafruit_BMP085_Unified(18001);


/* Update this with the correct SLP for accurate altitude measurements */
float seaLevelPressure = SENSORS_PRESSURE_SEALEVELHPA;

U8G2_SSD1306_128X64_NONAME_F_HW_I2C u8g2(U8G2_R0, /* reset=*/ U8X8_PIN_NONE);


#include <RHSoftwareSPI.h>  // http://www.airspayce.com/mikem/arduino/RadioHead/RadioHead-1.113.zip
#include <RHRouter.h>
#include <RHMesh.h>
#include <RH_RF95.h>
#include <SPI.h>

#define RF95_FREQ 915.0
#define gatewayNode 1

RHMesh *manager;

static const uint32_t GPSBaud = 9600;
typedef struct {
  float lat;
  float lon;
} Payload;

Payload theData;

// Radio pins for feather M0
#define RFM95_CS A5
#define RFM95_RST A4
#define RFM95_INT A3

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

void initSensors()
{
  if(!accel.begin())
  {
    /* There was a problem detecting the LSM303 ... check your connections */
    Serial.println(F("Ooops, no LSM303 detected ... Check your wiring!"));
    while(1);
  }
  if(!mag.begin())
  {
    /* There was a problem detecting the LSM303 ... check your connections */
    Serial.println("Ooops, no LSM303 detected ... Check your wiring!");
    while(1);
  }
  if(!bmp.begin())
  {
    /* There was a problem detecting the BMP180 ... check your connections */
    Serial.println("Ooops, no BMP180 detected ... Check your wiring!");
    while(1);
  }
}

long lastReading = 0;

// The TinyGPS++ object
TinyGPSPlus gps;

float heading;
float bearing; 

#define r 22
#define mx 120-r
#define my 32

// The serial connection to the GPS device
//SoftwareSerial ss(RXPin, TXPin);

void setup()
{
  Serial.begin(115200);
  
  Serial1.begin(GPSBaud);

  initSensors();

u8g2.begin();
u8g2.clearBuffer();
  u8g2.setFontDirection(0);
   u8g2.setFont(u8g2_font_6x10_tf); 

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
  
  
  // This sketch displays information every time a new sentence is correctly encoded.
  while (Serial1.available() > 0)
    if (gps.encode(Serial1.read())) {
     // displayInfo();

      //do compass too

      

if ((millis()-lastReading)>500) {

  sensors_event_t accel_event;
  sensors_event_t mag_event;
  sensors_event_t bmp_event;
  sensors_vec_t   orientation;

  /* Calculate pitch and roll from the raw accelerometer data */
  accel.getEvent(&accel_event);
  if (dof.accelGetOrientation(&accel_event, &orientation))
  {
    /* 'orientation' should have valid .roll and .pitch fields */
    Serial.print(F("Roll: "));
    Serial.print(orientation.roll);
    Serial.print(F("; "));
    Serial.print(F("Pitch: "));
    Serial.print(orientation.pitch);
    Serial.print(F("; "));
  }
  
  /* Calculate the heading using the magnetometer */
  mag.getEvent(&mag_event);
  if (dof.magGetOrientation(SENSOR_AXIS_Z, &mag_event, &orientation))
  {
    /* 'orientation' should have valid .heading data now */
    Serial.print(F("Heading: "));
    Serial.print(orientation.heading);
    Serial.print(F("; "));

    // declination
    /*
    float myheading = orientation.heading + 14.22;
    if (myheading <0)
    myheading += 360;
    
    if (myheading > 360)
    myheading -=360;

    Serial.print(F("Corrected heading: "));
    Serial.print(myheading);
    Serial.print(F("; "));
    */
    u8g2.clearBuffer();

    u8g2.setCursor(0,05);
u8g2.print("compass:");
u8g2.setCursor(0,15);
u8g2.print(round(orientation.heading));
u8g2.print("");


    u8g2.drawCircle(mx,my,r);
    
heading = orientation.heading;

float heading_rad = (orientation.heading+90) * 0.0174533; // the '90' is a feature of how the compass chip is oriented
int cdx = round((r)*sin(heading_rad));
int cdy = round((r)*cos(heading_rad));

Serial.print("cdx:");
Serial.print(cdx);
Serial.print("; cdy:");
Serial.println(cdy);

u8g2.setCursor(mx+cdx, my+cdy);
u8g2.print("N");
u8g2.sendBuffer();

  }

  /* Calculate the altitude using the barometric pressure sensor */
  bmp.getEvent(&bmp_event);
  if (bmp_event.pressure)
  {
    /* Get ambient temperature in C */
    float temperature;
    bmp.getTemperature(&temperature);
    /* Convert atmospheric pressure, SLP and temp to altitude    */
    Serial.print(F("Alt: "));
    Serial.print(bmp.pressureToAltitude(seaLevelPressure,
                                        bmp_event.pressure,
                                        temperature)); 
    Serial.print(F(" m; "));
    /* Display the temperature */
    Serial.print(F("Temp: "));
    Serial.print(temperature);
    Serial.print(F(" C"));
  }
  
 
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
    Serial.print(gps.location.lng(), 6);

    lat1=gps.location.lat();
    lon1=gps.location.lng();
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

      Serial.println();
      Serial.print("lat2:");
      Serial.print(lat2);
      Serial.print("; lon2:");
      Serial.println(lon2);

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

        u8g2.setCursor(0,55);
        u8g2.print(round(distance_feet));
        u8g2.print(" ft away");

        int dx = round(r*sin((degree_diff+90)*PI/180.));
        int dy = round(r*cos((degree_diff+90)*PI/180. ));
        
        u8g2.drawLine(mx, my, mx+dx, my+dy);
        
        u8g2.sendBuffer();


        u8g2.sendBuffer();
        delay(4000);
        
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
