

#include <SPI.h>
#include "wiring_private.h" // pinPeripheral() function
#include <ArduinoHttpClient.h>
#include <WiFiNINA.h>
#include <ArduinoJson.h> //https://arduinojson.org/v6/doc/installation/
#include <SdFat.h>
#include <Adafruit_SPIFlash.h>
#include <U8x8lib.h>
#include <Wire.h>
#include <Bounce2.h> // https://github.com/thomasfredericks/Bounce2
//#include <ArduinoHttpClient.h>
#include "SparkFun_SCD30_Arduino_Library.h"  //  https://github.com/sparkfun/SparkFun_SCD30_Arduino_Library
//#include "arduino_secrets.h"
#include <Adafruit_NeoPixel.h>

SCD30 airSensor;

#define LED_PIN    5 // for neopixels
// How many NeoPixels are attached to the Arduino?
#define LED_COUNT 8

Adafruit_NeoPixel strip(LED_COUNT, LED_PIN, NEO_GRB + NEO_KHZ800);

U8X8_SSD1306_128X64_NONAME_HW_I2C u8x8(/* reset=*/ U8X8_PIN_NONE);

const int chipSelect = A1;

#define SPIWIFI       SPI  // The SPI port
#define SPIWIFI_SS    13   // Chip select pin
#define ESP32_RESETN  12   // Reset pin
#define SPIWIFI_ACK   11   // a.k.a BUSY or READY pin
#define ESP32_GPIO0   -1

#define LED 13



#define gatewayNode 1


// buttons
#define BUTTON_A_PIN A4
// buttons
Bounce2::Button button_A = Bounce2::Button();

int status = WL_IDLE_STATUS;
const char server[] = "bayou.pvos.org";    // name address for adafruit test

// Initialize the Ethernet client library
// with the IP address and port of the server
// that you want to connect to (port 80 is default for HTTP):
WiFiClient client;

HttpClient http = HttpClient(client, server, 80);

#if defined(EXTERNAL_FLASH_USE_QSPI)
  Adafruit_FlashTransport_QSPI flashTransport;

#elif defined(EXTERNAL_FLASH_USE_SPI)
  Adafruit_FlashTransport_SPI flashTransport(EXTERNAL_FLASH_USE_CS, EXTERNAL_FLASH_USE_SPI);

#else
  #error No QSPI/SPI flash are defined on your board variant.h !
#endif

Adafruit_SPIFlash flash(&flashTransport);

// file system object from SdFat
FatFileSystem fatfs;

const char configfile[] = "config.json";

struct Config {
  char ssid[64];
  char pswd[64];
  char pubkey[64];
  char privkey[64];
  char server[64];
  char path[64];
  int interval_sec;
  int forcePPM;
  char loranet_pubkey[13]; //pubkey for this lora network (same as bayou pubkey of node #1 / the gateway node)
  int max_wifi_attempts;
};

Config config;   

typedef struct {
  int co2;
  float temperature;
  float humidity;
  float light;
  char loranet_pubkey[13]; //pubkey for this lora network (same as bayou pubkey of node #1 / the gateway node)
  int node_id; 
  int next_hop;
  int next_rssi;
  int logcode;
} Payload;

Payload theData;

long measureDelay;

int co2;
float temperature;
float humidity;
float light;
int node_id;

void setup() {


  pinMode(LED, OUTPUT);
  
  //Initialize serial and wait for port to open:
  Serial.begin(9600);
  //while(!Serial) delay(10); 

  //Serial.println("FLASH_CS:");
  //Serial.println(EXTERNAL_FLASH_USE_CS);
  
  /*while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }
  */

  
  digitalWrite(SPIWIFI_SS,HIGH);
  pinMode(SPIWIFI_SS,OUTPUT);
  
 button_A.attach( A4, INPUT ); // USE EXTERNAL PULL-UP
  button_A.interval(5); 
  button_A.setPressedState(LOW);
  

  u8x8.begin();
  
  u8x8.setFont(u8x8_font_7x14B_1x2_f);
   u8x8.clear();
   u8x8.setCursor(0,0); 
   u8x8.print("Starting...");
   delay(1000);

    u8x8.clear();
   Wire.begin();

  u8x8.setCursor(0,0); 
  if (airSensor.begin() == false)
  {
     
   u8x8.print("SCD30 missing?");
   delay(1000);
    Serial.println("Air sensor not detected. Please check wiring.");
    //while (1)
    //  ;
  } else {
    u8x8.print("SCD30 works!");
    Serial.println("SCD30 works!");
   delay(1000);

  }



  

// Initialize flash library and check its chip ID.
  if (!flash.begin()) {
    Serial.println("Error, failed to initialize flash chip!");
    while(1);
  }
  Serial.print("Flash chip JEDEC ID: 0x"); Serial.println(flash.getJEDECID(), HEX);

  // First call begin to mount the filesystem.  Check that it returns true
  // to make sure the filesystem was mounted.
  if (!fatfs.begin(&flash)) {
    Serial.println("Failed to mount filesystem!");
    Serial.println("Was CircuitPython loaded on the board first to create the filesystem?");
    while(1);
  }
  Serial.println("Mounted filesystem!");

  // Check if a boot.py exists and print it out.
  if (fatfs.exists(configfile)) {
    File file = fatfs.open(configfile, FILE_READ);

StaticJsonDocument<512> doc;

DeserializationError error = deserializeJson(doc, file);
  if (error) {
    Serial.println(F("Failed to read file, using default configuration"));
  u8x8.setFont(u8x8_font_7x14B_1x2_f);
  u8x8.setCursor(0,4);
  u8x8.print("config json?");
  }
  // Copy values from the JsonDocument to the Config
  config.interval_sec = doc["interval_seconds"] | 3;
  
  strlcpy(config.ssid,                  // <- destination
          doc["wifi_ssid"] ,  // <- source
          sizeof(config.ssid));         // <- destination's capacity

  strlcpy(config.pswd,                  // <- destination
          doc["wifi_password"] ,  // <- source
          sizeof(config.pswd));         // <- destination's capacity     

             
  strlcpy(config.pubkey,                  // <- destination
          doc["public_key"] ,  // <- source
          sizeof(config.pubkey));         // <- destination's capacity 

  strlcpy(config.privkey,                  // <- destination
        doc["private_key"] ,  // <- source
        sizeof(config.privkey));         // <- destination's capacity 

  strlcpy(config.server,                  // <- destination
      doc["server"] ,  // <- source
      sizeof(config.server));         // <- destination's capacity 


  strlcpy(config.path,                  // <- destination
      doc["path"] ,  // <- source
      sizeof(config.path));         // <- destination's capacity 

      
  strlcpy(config.loranet_pubkey,                  // <- destination
      doc["loranet_pubkey"] ,  // <- source
      sizeof(config.loranet_pubkey));         // <- destination's capacity 


      config.max_wifi_attempts = doc["max_wifi_attempts"];

  config.forcePPM = doc["forcePPM"];

      
  config.interval_sec = doc["interval_seconds"];

  Serial.print("interval:");
  Serial.println(config.interval_sec);

        u8x8.setFont(u8x8_font_7x14B_1x2_f);
  u8x8.setCursor(0,4);
  u8x8.print("config ok!");
  
  // Close the file (Curiously, File's destructor doesn't close the file)
  //fatfs.close();

  
    /*
    Serial.println("Printing config file...");
    while (bootPy.available()) {
      char c = bootPy.read();
      //int r = atoi(c);
      //int sum = r + 3;
      Serial.print(c);
      //Serial.print("Sum:");
      //Serial.println(sum);
    }
    Serial.println();
*/


    
  }
  else {
    Serial.println("No config file found...");
      u8x8.setFont(u8x8_font_7x14B_1x2_f);
  u8x8.setCursor(0,4);
  u8x8.print("config file?");
  }

//Serial.println("got:");
//Serial.println(config.port);
//Serial.println(config.hostname);
    
//
//SPI.endTransaction();

 //digitalWrite(SPIWIFI_SS,LOW);
 // pinMode(SPIWIFI_SS,OUTPUT);
  
delay(1000);
  
  Serial.println("trying ...");
  // check for the WiFi module:
  WiFi.setPins(SPIWIFI_SS, SPIWIFI_ACK, ESP32_RESETN, ESP32_GPIO0, &SPIWIFI);
  
  while (WiFi.status() == WL_NO_MODULE) {
    Serial.println("Communication with WiFi module failed!");
    // don't continue
    u8x8.setCursor(0,6); 
    u8x8.print("wifi module?");
    delay(1000);
  }

  String fv = WiFi.firmwareVersion();
  if (fv < "1.0.0") {
    Serial.println("Please upgrade the firmware");
  }
  Serial.print("Found firmware "); Serial.println(fv);

  u8x8.setCursor(0,6); 
    u8x8.print("wifi works!");
    delay(3000);
    
  // attempt to connect to Wifi network:
 // Serial.print("Attempting to connect to SSID: ");
 // Serial.println(config.ssid);
  // Connect to WPA/WPA2 network. Change this line if using open or WEP network:


  measureDelay=config.interval_sec*1000;


Serial.println("listening ...");
  u8x8.clear();
   u8x8.setFont(u8x8_font_7x14B_1x2_f);
  u8x8.setCursor(0,0);
  u8x8.print("Listening...");
    
}


long lastMeasureTime = 0;  // the last time the output pin was toggled


//long measureDelay = config.interval_sec*1000;
//long measureDelay = 5*1000;


int firstLoop = 1;

void loop() {


 button_A.update();
 
  if ( button_A.pressed() ) {
  
  Serial.println("button A!");

  long pressTime = millis();
    int pressCount = 5;

    u8x8.clear();
u8x8.setFont(u8x8_font_7x14B_1x2_f);
u8x8.setCursor(0,0); 
 u8x8.print("Keep pressing");
 u8x8.setCursor(0,2); 
 u8x8.print("to calibrate:");
 
   int buttonA_state = digitalRead(BUTTON_A_PIN);

    while (((millis() - pressTime) < 5000) && (buttonA_state==0)) {

  buttonA_state = digitalRead(BUTTON_A_PIN);
  u8x8.setCursor(0,4);
  u8x8.print(pressCount);
  u8x8.print(" ...");
  pressCount--;
  delay(1000);
  
}

if (pressCount==0) {
  
    u8x8.clear();
u8x8.setFont(u8x8_font_7x14B_1x2_f);
u8x8.setCursor(0,0); 
 u8x8.print("Please step away");
 u8x8.setCursor(0,2);
  u8x8.print("from sensor! ");
   u8x8.setCursor(0,4);
  u8x8.print("Calibrating in:");

for (int i=30;i>0;i--) {

digitalWrite(LED, HIGH);   // turn the LED on (HIGH is the voltage level)
  delay(10);                       // wait for a second
  digitalWrite(LED, LOW);    // turn the LED off by making the voltage LOW
  delay(10);  
  
  u8x8.setCursor(0,6);
  u8x8.print(i);
  u8x8.print(" ...");
  delay(1000);  
}

// force calibrate
airSensor.setForcedRecalibrationFactor(config.forcePPM);
u8x8.clear();
u8x8.setFont(u8x8_font_7x14B_1x2_f);
u8x8.setCursor(0,0); 
 u8x8.print("Force calibrated");
  u8x8.setCursor(0,2); 
   u8x8.print("to:");
     u8x8.setCursor(0,4); 
 u8x8.print(config.forcePPM);
 u8x8.print(" ppm");
 delay(3000);
 
}
else {
      u8x8.clear();
u8x8.setFont(u8x8_font_7x14B_1x2_f);
u8x8.setCursor(0,0); 
 u8x8.print("Calibration");
 u8x8.setCursor(0,2); 
 u8x8.print("canceled.");
 delay(3000);
 firstLoop = 1;
}

   
}

// end button code


// send measurement if it's past time to do so:

if (  ( (millis() - lastMeasureTime) > measureDelay) || firstLoop) {


 if (airSensor.dataAvailable())
  {

    if (firstLoop) firstLoop = 0;

//u8x8.setFont(u8x8_font_chroma48medium8_r);
 // u8x8.setCursor(10,2);
 // u8x8.print("...");
  
  co2 = airSensor.getCO2();
    temperature = roundf(airSensor.getTemperature()* 100) / 100;
    humidity = roundf(airSensor.getHumidity()* 100) / 100;
    node_id = 0;
    
    u8x8.clear();
    //u8x8.setFont(u8x8_font_7x14B_1x2_f);
    //u8x8.setFont(u8x8_font_inr33_3x6_f);
    //u8x8.setFont(u8x8_font_inb21_2x4_n);
    //u8x8.setFont(u8x8_font_courB24_3x4_f);
    //u8x8.setFont(u8x8_font_inr46_4x8_n);
    u8x8.setFont(u8x8_font_inb33_3x6_f);
    u8x8.setCursor(0,0); 
    u8x8.print(co2);
    //u8x8.print(" ppm");

    /*
    u8x8.setFont(u8x8_font_7x14B_1x2_f);
    u8x8.setCursor(8,0); 
    u8x8.print(temperature);
    u8x8.print(" C");
    u8x8.setCursor(8,2); 
    u8x8.print(humidity);
    u8x8.print(" RH");
    */
    postToBayou();

  }

    lastMeasureTime = millis(); //set the current time
    
}

// check if new messages from remote lora nodes
//relayFromMesh(5000); // wait for 5000 ms for msgs from remote nodes

  
} // end loop


void printWifiStatus() {
  // print the SSID of the network you're attached to:
  Serial.print("SSID: ");
  Serial.println(WiFi.SSID());

  // print your board's IP address:
  IPAddress ip = WiFi.localIP();
  Serial.print("IP Address: ");
  Serial.println(ip);

  // print the received signal strength:
  long rssi = WiFi.RSSI();
  Serial.print("signal strength (RSSI):");
  Serial.print(rssi);
  Serial.println(" dBm");
}

void postToBayou() {

// Connect to wifi ...
Serial.print("Connecting to wifi ...");

 /* 
 u8x8.clear();
  
u8x8.setFont(u8x8_font_7x14B_1x2_f);
   u8x8.setCursor(0,0);
  u8x8.print("----> ");
  u8x8.print("node ");
  u8x8.print(node_id);
  u8x8.setCursor(6,2);
  u8x8.print("co2:");
  u8x8.print(co2);
  */
  //u8x8.setCursor(0,6);
  //u8x8.print("wifi:");

  int connect_attempt = 0;
  
  
while (status != WL_CONNECTED && connect_attempt < config.max_wifi_attempts) {

    Serial.print("Attempting to connect to Network named: ");
//    Serial.println(ssid);
  Serial.println(config.ssid);
  
   
    status = WiFi.begin(config.ssid, config.pswd);

   neoBlink(strip.Color(  255, 255,   0), strip.Color(  0, 0,   0), 0, 1);

u8x8.setFont(u8x8_font_7x14B_1x2_f);
   u8x8.setCursor(0,6);
  u8x8.print("wifi:");
  u8x8.print(connect_attempt);
  u8x8.print("/");
  u8x8.print(config.max_wifi_attempts);
   connect_attempt++;
   
   
  }

if (status == WL_CONNECTED) {

  strip.setPixelColor(0, strip.Color(  255, 255,   0));         //  Set pixel's color (in RAM)
  strip.show();   
    
   // u8x8.setCursor(0,4);
  //u8x8.print("wifi:connected");

Serial.print("SSID: ");
  Serial.println(WiFi.SSID());
  IPAddress ip = WiFi.localIP();
  IPAddress gateway = WiFi.gatewayIP();
  Serial.print("IP Address: ");
  Serial.println(ip);


Serial.println(config.path);
Serial.println(config.pubkey);

char full_path [60];
strcpy(full_path, config.path);
strcat(full_path,config.pubkey);

Serial.println(full_path);


//Form the JSON:
  DynamicJsonDocument doc(1024);
  
//  Serial.println(post_url);

  
  doc["private_key"] = config.privkey;
  doc["co2_ppm"] =  co2;
  doc["temperature_c"]=temperature;
  doc["humidity_rh"]=humidity;
  doc["node_id"]=node_id;
  doc["log"]="OK";
   
  String json;
  serializeJson(doc, json);
  serializeJson(doc, Serial);
  Serial.println("\n");

    String contentType = "application/json";


  http.post(full_path, contentType, json);

  // read the status code and body of the response
  int statusCode = http.responseStatusCode();
  Serial.print("Status code: ");
  Serial.println(statusCode);
  String response = http.responseBody();
  Serial.print("Response: ");
  Serial.println(response);

   //u8x8.setFont(u8x8_font_chroma48medium8_r);

   //u8x8.setFont(u8x8_font_chroma48medium8_r);
   //u8x8.setFont(u8x8_font_8x13B_1x2_n);
   
   u8x8.setFont(u8x8_font_7x14B_1x2_f);
  u8x8.setCursor(0,6);
  u8x8.print("             ");
    u8x8.setCursor(0,6);
  u8x8.print("http:");
  u8x8.print(statusCode);

  if(statusCode==200) {
    strip.setPixelColor(node_id, strip.Color(  0, 255,   0));         //  Set pixel's color (in RAM)
    strip.show();   
  }
}

else{
   strip.setPixelColor(0, strip.Color(  0, 0,   255));         //  Set pixel's color (in RAM)
    strip.show(); 
     u8x8.setCursor(0,4);
  u8x8.print("wifi: ??");
}
  
  //delay(config.interval_sec*1000);
 
        
}




void neoBlink(uint32_t color_1, uint32_t color_2, int node_id, int numBlinks) {
  int wait = 100; //ms
  
  for (int i=0; i<numBlinks;i++) {
    strip.setPixelColor(node_id, color_1);         //  Set pixel's color (in RAM)
    strip.show();                          //  Update strip to match
    delay(wait);                           //  Pause for a moment
    strip.setPixelColor(node_id, color_2);         //  Set pixel's color (in RAM)
    strip.show();                          //  Update strip to match
    delay(wait);                           //  Pause for a moment
  }
}

void colorWipe(uint32_t color, int wait) {
  for(int i=0; i<strip.numPixels(); i++) { // For each pixel in strip...
    strip.setPixelColor(i, color);         //  Set pixel's color (in RAM)
    strip.show();                          //  Update strip to match
    delay(wait);                           //  Pause for a moment
  }
}

// Theater-marquee-style chasing lights. Pass in a color (32-bit value,
// a la strip.Color(r,g,b) as mentioned above), and a delay time (in ms)
// between frames.
void theaterChase(uint32_t color, int wait) {
  for(int a=0; a<10; a++) {  // Repeat 10 times...
    for(int b=0; b<3; b++) { //  'b' counts from 0 to 2...
      strip.clear();         //   Set all pixels in RAM to 0 (off)
      // 'c' counts up from 'b' to end of strip in steps of 3...
      for(int c=b; c<strip.numPixels(); c += 3) {
        strip.setPixelColor(c, color); // Set pixel 'c' to value 'color'
      }
      strip.show(); // Update strip with new contents
      delay(wait);  // Pause for a moment
    }
  }
}

// Rainbow cycle along whole strip. Pass delay time (in ms) between frames.
void rainbow(int wait) {
  // Hue of first pixel runs 5 complete loops through the color wheel.
  // Color wheel has a range of 65536 but it's OK if we roll over, so
  // just count from 0 to 5*65536. Adding 256 to firstPixelHue each time
  // means we'll make 5*65536/256 = 1280 passes through this outer loop:
  for(long firstPixelHue = 0; firstPixelHue < 5*65536; firstPixelHue += 256) {
    for(int i=0; i<strip.numPixels(); i++) { // For each pixel in strip...
      // Offset pixel hue by an amount to make one full revolution of the
      // color wheel (range of 65536) along the length of the strip
      // (strip.numPixels() steps):
      int pixelHue = firstPixelHue + (i * 65536L / strip.numPixels());
      // strip.ColorHSV() can take 1 or 3 arguments: a hue (0 to 65535) or
      // optionally add saturation and value (brightness) (each 0 to 255).
      // Here we're using just the single-argument hue variant. The result
      // is passed through strip.gamma32() to provide 'truer' colors
      // before assigning to each pixel:
      strip.setPixelColor(i, strip.gamma32(strip.ColorHSV(pixelHue)));
    }
    strip.show(); // Update strip with new contents
    delay(wait);  // Pause for a moment
  }
}

// Rainbow-enhanced theater marquee. Pass delay time (in ms) between frames.
void theaterChaseRainbow(int wait) {
  int firstPixelHue = 0;     // First pixel starts at red (hue 0)
  for(int a=0; a<30; a++) {  // Repeat 30 times...
    for(int b=0; b<3; b++) { //  'b' counts from 0 to 2...
      strip.clear();         //   Set all pixels in RAM to 0 (off)
      // 'c' counts up from 'b' to end of strip in increments of 3...
      for(int c=b; c<strip.numPixels(); c += 3) {
        // hue of pixel 'c' is offset by an amount to make one full
        // revolution of the color wheel (range 65536) along the length
        // of the strip (strip.numPixels() steps):
        int      hue   = firstPixelHue + c * 65536L / strip.numPixels();
        uint32_t color = strip.gamma32(strip.ColorHSV(hue)); // hue -> RGB
        strip.setPixelColor(c, color); // Set pixel 'c' to value 'color'
      }
      strip.show();                // Update strip with new contents
      delay(wait);                 // Pause for a moment
      firstPixelHue += 65536 / 90; // One cycle of color wheel over 90 frames
    }
  }
}

   
