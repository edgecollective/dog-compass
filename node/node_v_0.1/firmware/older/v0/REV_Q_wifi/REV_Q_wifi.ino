
/*
  Firmware for PVOS CO2 Monitor Gateway Hardware Rev. L
 */


#include <SPI.h>
#include "wiring_private.h" // pinPeripheral() function
#include <ArduinoHttpClient.h>
#include <WiFiNINA.h>
#include <ArduinoJson.h> //https://arduinojson.org/v6/doc/installation/
#include <SdFat.h>
#include <Adafruit_SPIFlash.h>
#include <U8x8lib.h>  //U8g2 (regular not Adafruit flavor)
#include <Wire.h>
#include <Bounce2.h> // https://github.com/thomasfredericks/Bounce2
#include "SparkFun_SCD30_Arduino_Library.h"  //  https://github.com/sparkfun/SparkFun_SCD30_Arduino_Library
#include <Adafruit_NeoPixel.h> // for NeoPixel Strip
#include <SerialCommand.h>  /* https://github.com/p-v-o-s/Arduino-SerialCommand */


#define LED_PIN   5 // for neopixels
// How many NeoPixels are attached to the Arduino?
#define LED_COUNT 8

#include <RH_RF95.h>
#include <RHSoftwareSPI.h>
#include <RHRouter.h>
#include <RHMesh.h>

#define LORA_IRQ A2
#define LORA_CS A4
#define LORA_RST A5

#define LORA_SCK 13 
#define LORA_MOSI 11
#define LORA_MISO 12 

#define LORA_FREQ 915.0

// change this to match your SD shield or module;
// Arduino Ethernet shield: pin 4
// Adafruit SD shields and modules: pin 10
// Sparkfun SD shield: pin 8
// MKRZero SD: SDCARD_SS_PIN
const int chipSelect = A1;

// Configure the pins used for the ESP32 connection
#if defined(ADAFRUIT_FEATHER_M4_EXPRESS) || \
  defined(ADAFRUIT_FEATHER_M0_EXPRESS) || \
  defined(ADAFRUIT_FEATHER_M0) || \
  defined(ARDUINO_AVR_FEATHER32U4) || \
  defined(ARDUINO_NRF52840_FEATHER) || \
  defined(ADAFRUIT_ITSYBITSY_M0) || \
  defined(ADAFRUIT_ITSYBITSY_M4_EXPRESS) || \
  defined(ARDUINO_AVR_ITSYBITSY32U4_3V) || \
  defined(ARDUINO_NRF52_ITSYBITSY)
  // Configure the pins used for the ESP32 connection
  #define SPIWIFI       SPI  // The SPI port
  #define SPIWIFI_SS    10   // Chip select pin
  #define ESP32_RESETN  7   // Reset pin
  #define SPIWIFI_ACK   9   // a.k.a BUSY or READY pin
  #define ESP32_GPIO0   -1
#elif defined(ARDUINO_AVR_FEATHER328P)
  #define SPIWIFI       SPI  // The SPI port
  #define SPIWIFI_SS     4   // Chip select pin
  #define ESP32_RESETN   3   // Reset pin
  #define SPIWIFI_ACK    2   // a.k.a BUSY or READY pin
  #define ESP32_GPIO0   -1
#elif defined(TEENSYDUINO)
  #define SPIWIFI       SPI  // The SPI port
  #define SPIWIFI_SS     5   // Chip select pin
  #define ESP32_RESETN   6   // Reset pin
  #define SPIWIFI_ACK    9   // a.k.a BUSY or READY pin
  #define ESP32_GPIO0   -1
#elif defined(ARDUINO_NRF52832_FEATHER)
  #define SPIWIFI       SPI  // The SPI port
  #define SPIWIFI_SS    16   // Chip select pin
  #define ESP32_RESETN  15   // Reset pin
  #define SPIWIFI_ACK    7   // a.k.a BUSY or READY pin
  #define ESP32_GPIO0   -1
#elif !defined(SPIWIFI_SS)   // if the wifi definition isnt in the board variant
  // Don't change the names of these #define's! they match the variant ones
  #define SPIWIFI       SPI
  #define SPIWIFI_SS    10   // Chip select pin
  #define SPIWIFI_ACK    7   // a.k.a BUSY or READY pin
  #define ESP32_RESETN   5   // Reset pin
  #define ESP32_GPIO0   -1   // Not connected
#endif

#define LED 13

#define gatewayNode 1
#define MAX_CONFIG_SIZE 1024

// buttons
#define BUTTON_A_PIN A3 

// other consts
const char IDN_STRING[] = "PVOS CO2 Monitor Rev. L";
/******************************************************************************/
// Global Objects
//------------------------------------------------------------------------------
// serial command parser
SerialCommand sCmd_USB(Serial, 20);         // (Stream, int maxCommands)
// sensor
SCD30 airSensor;

// Onboard RGB LED
#if defined(ADAFRUIT_ITSYBITSY_M4_EXPRESS)
  #include <Adafruit_DotStar.h>
  #define RGB_LED_CLOCK_PIN 6
  #define RGB_LED_DATA_PIN 8
Adafruit_DotStar  rgbLED(1,RGB_LED_DATA_PIN,RGB_LED_CLOCK_PIN,DOTSTAR_BGR);
#endif

// Neopixel display
Adafruit_NeoPixel strip(LED_COUNT, LED_PIN, NEO_GRB + NEO_KHZ800);
// OLED display
U8X8_SSD1306_128X64_NONAME_HW_I2C u8x8(/* reset=*/ U8X8_PIN_NONE);
//virtual SPI bus for LoRa radio
SPIClass mySPI (&sercom1, 12, 13, 11, SPI_PAD_0_SCK_1, SERCOM_RX_PAD_3);
// do this first, for Reasons
//------------------------------------------------------------------------------
//radio
RHSoftwareSPI sx1278_spi;
RH_RF95 rf95(LORA_CS, LORA_IRQ, sx1278_spi);
//RHMesh *manager;
//------------------------------------------------------------------------------
// buttons
Bounce2::Button button_A = Bounce2::Button();
//------------------------------------------------------------------------------
// WIFI
int wifi_status = WL_IDLE_STATUS;
WiFiClient wifiClient;
//------------------------------------------------------------------------------
// Flash Storage
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
//------------------------------------------------------------------------------
// Data Structure definitions
struct Config {
  char ssid[64];
  char pswd[64];
  char pubkey[64];
  char privkey[64];
  char server[64];
  char path[64];
  int  interval_sec;
  int  forcePPM;
  char loranet_pubkey[13]; //pubkey for this lora network (same as bayou pubkey of node #1 / the gateway node)
  int  max_wifi_attempts;
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



/******************************************************************************/
// Setup

void setup() {
  //initialize pins
  pinMode(SPIWIFI_SS,OUTPUT);
  digitalWrite(SPIWIFI_SS,HIGH);
  pinMode(LED, OUTPUT);
  digitalWrite(LED, LOW);
  
  //----------------------------------------------------------------------------
  // setup buttons
  button_A.attach( BUTTON_A_PIN, INPUT ); // USE EXTERNAL PULL-UP
  button_A.interval(5); 
  button_A.setPressedState(LOW);

  
  //Initialize serial
  Serial.begin(9600);
  
  /*while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }
  */
  //============================================================================
  // Setup SerialCommand for USB interface
  //----------------------------------------------------------------------------
  sCmd_USB.setDefaultHandler(UNRECOGNIZED_sCmd_default_handler);
  sCmd_USB.addCommand("IDN?", IDN_sCmd_query_handler);
  sCmd_USB.addCommand("CONFIG.DUMP",   CONFIG_DUMP_sCmd_query_handler);
  sCmd_USB.addCommand("CONFIG.READ",   CONFIG_READ_sCmd_query_handler);
  sCmd_USB.addCommand("CONFIG.WRITE",  CONFIG_WRITE_sCmd_action_handler);
  sCmd_USB.addCommand("CONFIG.DELETE", CONFIG_DELETE_sCmd_action_handler);
  sCmd_USB.addCommand("MEASURE.FORCE", MEASURE_FORCE_sCmd_action_handler);
  
  
  //----------------------------------------------------------------------------
  //initialize comms
  mySPI.begin(); // SPI for LoRa radio?
  Wire.begin();  // I2C bus
  
  //setup display
  u8x8.begin();
  u8x8.clear();            //clear the display
  
  Serial.println(F("########################################################"));
  Serial.println(F(IDN_STRING));
  Serial.println(F("--------------------------------------------------------"));
  Serial.println(F("Starting..."));
  u8x8.setFont(u8x8_font_7x14B_1x2_f);
  u8x8.clear();
  u8x8.setCursor(0,0);
  u8x8.print(F("Starting..."));
  delay(1000);
  
  Serial.print(F("Testing lights"));
  u8x8.clear();
  u8x8.setCursor(0,0);
  u8x8.print(F("Testing\nlights..."));
  delay(1000);
  
  //test neopixel strip
  strip.begin();           // INITIALIZE NeoPixel strip object (REQUIRED)
  strip.show();            // Turn OFF all pixels ASAP
  strip.setBrightness(50); // Set BRIGHTNESS to about 1/5 (max = 255)
  colorWipe(strip.Color(  0, 255,   0), 50); // Green
  colorWipe(strip.Color(  0, 0,   0), 50); // Black
  
  
  //test onboard RGB LED
  #if defined(ADAFRUIT_ITSYBITSY_M4_EXPRESS)
  rgbLED.begin();
  rgbLED.show(); // Initialize all pixels to 'off'
  //flash red, green, blue
  rgbLED.setPixelColor(0, 255, 0, 0); //red
  rgbLED.show();
  delay(1000);
  rgbLED.setPixelColor(0, 0, 255, 0); //green
  rgbLED.show();
  delay(1000);
  rgbLED.setPixelColor(0, 0, 0, 255); //blue
  rgbLED.show();
  delay(1000);
  rgbLED.setPixelColor(0, 0, 0, 0);   //off
  rgbLED.show();
  #endif
  u8x8.clear();
  u8x8.setCursor(0,0);
  u8x8.print(F("Testing\nmodules..."));
  delay(1000);
  
  Serial.print(F("Checking for SDC30 air sensor..."));
  u8x8.clear();
  u8x8.setCursor(0,0); 
  if (airSensor.begin() == false)
  {  
    u8x8.print(F("SCD30 missing?"));
    delay(1000);
    Serial.println(F("\nERROR: Air sensor not detected. Please check wiring."));
    indicateErrorLEDstayOn();
    while(1); //HALT!
  } else {
    u8x8.print(F("SCD30 works!"));
    Serial.println(F(" working!"));
    delay(1000);
  }

  // Assign pins 11, 12, 13 to SERCOM functionality
  pinPeripheral(11, PIO_SERCOM);
  pinPeripheral(12, PIO_SERCOM);
  pinPeripheral(13, PIO_SERCOM);

  
  //----------------------------------------------------------------------------
  //LoRa Radio 
  // set the pins for the virtual SPI explicitly to the internal connection
  Serial.print(F("Checking for LoRa radio module..."));
  sx1278_spi.setPins(LORA_MISO, LORA_MOSI, LORA_SCK);
  pinMode(LORA_RST, OUTPUT);
  digitalWrite(LORA_RST, HIGH);
  if (rf95.init()){
    Serial.println(F(" init OK!"));
    // Defaults after init are 434.0MHz, modulation GFSK_Rb250Fd250, +13dbM
    // Bw = 125 kHz, Cr = 4/5, Sf = 128chips/symbol, CRC on
    if (rf95.setFrequency(LORA_FREQ)) {
      Serial.print(F("\tSet Freq to: ")); Serial.println(LORA_FREQ);
      // The default transmitter power is 13dBm, using PA_BOOST.
      // If you are using RFM95/96/97/98 modules which uses the PA_BOOST
      // transmitter pin, then you can set transmitter powers from 5 to 23 dBm
      rf95.setTxPower(23, false);
      u8x8.setFont(u8x8_font_7x14B_1x2_f);
      u8x8.setCursor(0,2);
      u8x8.print(F("LoRa ok!"));
    } else{
      Serial.println(F("\tERROR: setFrequency failed!"));
      indicateErrorLEDblink(5000);
    }
  }
  else{
    Serial.println(F("\nERROR: LoRa radio init failed!"));
    Serial.println(F("Uncomment '#define SERIAL_DEBUG' in RH_RF95.cpp for detailed debug info"));
    u8x8.setFont(u8x8_font_7x14B_1x2_f);
    u8x8.setCursor(0,2);
    u8x8.print(F("LoRa ?"));
    indicateErrorLEDblink(5000);
  }
  
  //----------------------------------------------------------------------------
  // Initialize flash library and check its chip ID.
  Serial.print(F("Checking flash memory..."));
  if (!flash.begin()) {
    Serial.println(F("\nERROR, failed to initialize flash chip!"));
    indicateErrorLEDstayOn();
    while(1); //HALT!
  } else{
    Serial.println(F(" OK!"));
  }
  Serial.print(F("\tFlash chip JEDEC ID: 0x")); Serial.println(flash.getJEDECID(), HEX);

  // First call begin to mount the filesystem.  Check that it returns true
  // to make sure the filesystem was mounted.
  Serial.print(F("Checking filesystem..."));
  if (!fatfs.begin(&flash)) {
    Serial.println(F("\tERROR: Failed to mount filesystem!"));
    Serial.println(F("\tWas CircuitPython loaded on the board first to create the filesystem?"));
    indicateErrorLEDstayOn();
    while(1); //HALT!
  } else{
    Serial.println(F(" mounted OK!"));
  }
  // Check if "config.json" exists and read in values
  Serial.print(F("Checking file 'config.json'..."));
  if (fatfs.exists(configfile)) {
    File file = fatfs.open(configfile, FILE_READ);
    DynamicJsonDocument doc(MAX_CONFIG_SIZE);
    DeserializationError error = deserializeJson(doc, file);
    file.close(); //close the file
    if (error) {
      Serial.println(F("\tERROR: Failed to read file, check JSON formatting;\n\tusing default configuration!"));
      u8x8.setFont(u8x8_font_7x14B_1x2_f);
      u8x8.setCursor(0,4);
      u8x8.print(F("Config json?"));
      indicateErrorLEDblink(5000);
    }
    loadConfigFromJsonDoc(doc,true);
    //display OK
    u8x8.setFont(u8x8_font_7x14B_1x2_f);
    u8x8.setCursor(0,4);
    u8x8.print(F("Config ok!"));
    // Close the file (Curiously, File's destructor doesn't close the file)
    //fatfs.close();
  }
  else {
    Serial.println(F("\tERROR: No config file found, using default configuration!"));
    indicateErrorLEDblink(5000);
    u8x8.setFont(u8x8_font_7x14B_1x2_f);
    u8x8.setCursor(0,4);
    u8x8.print(F("Config file?"));
  }
  
  delay(1000);
  Serial.println(F("Checking WiFi module..."));
  // check for the WiFi module:
  WiFi.setPins(SPIWIFI_SS, SPIWIFI_ACK, ESP32_RESETN, ESP32_GPIO0, &SPIWIFI);
  
  while (WiFi.status() == WL_NO_MODULE) {
    Serial.println(F("\tERROR: Communication failed! Check orientation in socket."));
    u8x8.setCursor(0,6); 
    u8x8.print(F("WiFi module?"));
    indicateErrorLEDblink(5000);
  } 

  String fv = WiFi.firmwareVersion();
  if (fv < "1.0.0") {
    Serial.println(F("\tWARNING: Please upgrade the firmware on the WIFI device"));
    indicateWarningLEDblink(5000);
  }
  Serial.print(F("\tFound WIFI firmware: ")); Serial.println(fv);

  u8x8.setCursor(0,6); 
  u8x8.print(F("WiFi ok!"));
  #if defined(ADAFRUIT_ITSYBITSY_M4_EXPRESS)
  rgbLED.setPixelColor(0, 0, 255, 0); //green
  rgbLED.show();
  #endif
  delay(5000);
  #if defined(ADAFRUIT_ITSYBITSY_M4_EXPRESS)
  rgbLED.setPixelColor(0, 0, 0, 0);   //off
  rgbLED.show();
  #endif
  Serial.println(F("Listening ..."));
  u8x8.clear();
  u8x8.setFont(u8x8_font_7x14B_1x2_f);
  u8x8.setCursor(0,0);
  u8x8.print(F("Listening..."));  
}

/******************************************************************************/
// MAIN LOOP

long lastMeasureTimeMillis   = 0;    // the last time the output pin was toggled
long lastDisplayUpdateMillis = 0;    // the last display was updated
bool firstLoop     = true;
int  wifi_connect_attempt = 0;
volatile bool measureForce = false;
bool postWasSuccess = true;

void loop() {
  // Compute and display the Countdown clock
  int nowMillis = millis();
  int timeUntilNextMeasurementSeconds = (firstLoop)? -1 : config.interval_sec - (nowMillis - lastMeasureTimeMillis)/1000;
  if ( nowMillis-lastDisplayUpdateMillis > 1000){
    displayCountDown(timeUntilNextMeasurementSeconds);
    lastDisplayUpdateMillis = nowMillis;
  }
  //----------------------------------------------------------------------------
  //process Serial commands over USB
  size_t num_bytes = sCmd_USB.readSerial();
  if (num_bytes > 0){
    sCmd_USB.processCommand();
  }
  //----------------------------------------------------------------------------
  // Forced CO2 Calibration On button A pressed
  button_A.update();
  if ( button_A.pressed() ) {
    forceCalibrateRoutine();
  }
  //----------------------------------------------------------------------------
  // Maintain connection with Wifi
  if (wifi_status != WL_CONNECTED){
    if(wifi_connect_attempt < config.max_wifi_attempts) {
      wifi_connect_attempt++;
      Serial.print(F("Attempt #"));Serial.print(wifi_connect_attempt);Serial.print(F(" to connect to Wifi network named: "));
      Serial.println(config.ssid);
      wifi_status = WiFi.begin(config.ssid, config.pswd);
      if (wifi_status == WL_CONNECTED){
        Serial.println(F("\tConnected!"));
        wifi_connect_attempt = 0; //reset attempts
        printWifiStatus("\t");
      } else{
        Serial.println(F("\tWARNING: failed to connect!"));
        //flash warning
        indicateWarningLEDblink(1000);
      }
    }else if (wifi_connect_attempt == config.max_wifi_attempts){
      wifi_connect_attempt++;
      indicateErrorLEDstayOn();
      //this message should only happen once per measurement cycle
      Serial.println(F("\tERROR: connection attempts maxed out, please check network settings;"));
      Serial.println(F("\t       will try again after next measurement period!"));
      //TODO maybe flash a warning?
    }
  } else{
    if (postWasSuccess){ indicateLEDturnOff();} //clear error state only if last post was successfull
    wifi_connect_attempt = 0; //reset attempts
  }

  //----------------------------------------------------------------------------
  // check if new messages from remote lora nodes
  //relayFromMesh(5000); // wait for 5000 ms for msgs from remote nodes
  if (rf95.available()){
    // Should be a message for us now
    uint8_t buf[sizeof(Payload)];
    uint8_t len = sizeof(buf);
    if (rf95.recv(buf, &len)){
      digitalWrite(LED, HIGH);
      // the rest of this code only runs if we were the intended recipient;
      // which means we're the gateway
      theData = *(Payload*)buf;
      Serial.print(F("LoRa Message Received: "));
      Serial.print(F("node_id = "));
      Serial.print(theData.node_id);
      Serial.print(F("; next_hop = "));
      Serial.println(theData.next_hop);
      Serial.print(F("loranet:"));
      Serial.println(theData.loranet_pubkey);
      //unpack the data
      Serial.print(F("co2         = "));Serial.println(theData.co2);
      Serial.print(F("temperature = "));Serial.println(theData.temperature);
      Serial.print(F("humidity    = "));Serial.println(theData.humidity);
      Serial.print(F("light       = "));Serial.println(theData.light);
      neoBlink(strip.Color(  0, 255,   0), strip.Color(  0, 0,   255), theData.node_id, 5);
      displayData(theData);
      displayCountDown(timeUntilNextMeasurementSeconds);
      exportOrQueueData(theData);
    }else{
      Serial.println(F("ERROR: LoRa receive failed"));
    }
  } 
  //----------------------------------------------------------------------------
  // Make measurement if its past time
  int timeDeltaMillis = millis() - lastMeasureTimeMillis;
  if (  ( timeDeltaMillis > measureDelay ) || firstLoop || measureForce) {
    wifi_connect_attempt = 0; //reset attempts
    //check the sensor
    if (airSensor.dataAvailable()){
      measureForce = false;              //clear force signal
      if (firstLoop){firstLoop = false;} //clear firstloop status
      int co2;
      float temperature;
      float humidity;
      float light;
      int node_id;
      //read CO2 sensor daya
      co2         = airSensor.getCO2();
      temperature = roundf(airSensor.getTemperature()* 100.0) / 100.0;
      humidity    = roundf(airSensor.getHumidity()* 100.0) / 100.0;
      node_id     = 0; //FIXME is gateway always node 0?
      
      //pack the data
      theData.co2         = co2;
      theData.temperature = temperature;
      theData.humidity    = humidity;
      theData.light       = 0; //FIXME where is the light reading from?
      theData.node_id     = node_id;
      theData.next_rssi   = WiFi.RSSI(); //also do a WiFi signal test
      //try to export the data
      postWasSuccess = exportOrQueueData(theData);
      //display data
      if (postWasSuccess){displayData(theData);} //if false don't overwrite the error message
      displayCountDown(timeUntilNextMeasurementSeconds);

    }
    lastMeasureTimeMillis = millis(); //set the current time
  }
  
} // end loop

/******************************************************************************/
// Helper Functions
//------------------------------------------------------------------------------

void indicateWarningLEDblink(int durationMillis){
  neoBlink(strip.Color(  255, 255,   0), strip.Color(  0, 0,   0), 0, 1);
  #if defined(ADAFRUIT_ITSYBITSY_M4_EXPRESS)
  rgbLED.setPixelColor(0, 255, 255, 0); //yellow
  rgbLED.show();
  #endif
  delay(durationMillis);
  #if defined(ADAFRUIT_ITSYBITSY_M4_EXPRESS)
  rgbLED.setPixelColor(0, 0, 0, 0);   //off
  rgbLED.show();
  #endif
}

void indicateErrorLEDblink(int durationMillis){
  neoBlink(strip.Color(  255, 0,   0), strip.Color(  0, 0,   0), 0, 1);
  #if defined(ADAFRUIT_ITSYBITSY_M4_EXPRESS)
  rgbLED.setPixelColor(0, 255, 0, 0); //red
  rgbLED.show();
  #endif
  delay(durationMillis);
  #if defined(ADAFRUIT_ITSYBITSY_M4_EXPRESS)
  rgbLED.setPixelColor(0, 0, 0, 0);   //off
  rgbLED.show();
  #endif
}

void indicateErrorLEDstayOn(){
  #if defined(ADAFRUIT_ITSYBITSY_M4_EXPRESS)
  rgbLED.setPixelColor(0, 255, 0, 0); //red
  rgbLED.show();
  #endif
}

void indicateLEDturnOff(){
  #if defined(ADAFRUIT_ITSYBITSY_M4_EXPRESS)
  rgbLED.setPixelColor(0, 0, 0, 0); //off
  rgbLED.show();
  #endif
}

const char* getStrFromJsonDoc(DynamicJsonDocument& doc, 
                              const char* key, const char* default_,
                              bool verbose){
  if (doc.containsKey(key)) {
    const char* val = doc[key];
    if (verbose) {Serial.print(F("\t"));Serial.print(key);
                  Serial.print(F(" = "));Serial.println(val);}
    return val;
  } else{
    doc[key] = default_;
    if (verbose) {Serial.print(F("\t"));Serial.print(key);
                  Serial.print(F(" = "));Serial.print(default_);
                  Serial.println(" (default)");}
    return default_;
  }
}

int getIntFromJsonDoc(DynamicJsonDocument& doc,
                      const char* key, int default_,
                      bool verbose){
  if (doc.containsKey(key)) {
    int val = doc[key];
    if (verbose) {Serial.print(F("\t"));Serial.print(key);
                  Serial.print(F(" = "));Serial.println(val);}
    return val;
  } else{
    doc[key] = default_;
    if (verbose) {Serial.print(F("\t"));Serial.print(key);
                  Serial.print(F(" = "));Serial.print(default_);
                  Serial.println(" (default)");}
    return default_;
  }
}

void loadConfigFromJsonDoc(DynamicJsonDocument doc, bool verbose){
    // Copy values from the JsonDocument to the Config
    if (verbose) {Serial.println(F("Loading config:"));}
    strlcpy(config.ssid,                                    // <- destination
            getStrFromJsonDoc(doc,"wifi_ssid", "unknown", verbose),  // <- source
            sizeof(config.ssid));                           // <- destination's capacity
    strlcpy(config.pswd,         
            getStrFromJsonDoc(doc,"wifi_password", "unknown", verbose),
            sizeof(config.pswd));
    strlcpy(config.pubkey,
            getStrFromJsonDoc(doc,"public_key", "unknown_12chars", verbose),
            sizeof(config.pubkey));
    strlcpy(config.privkey,
            getStrFromJsonDoc(doc,"private_key", "unknown_12chars", verbose),
            sizeof(config.privkey));
    strlcpy(config.server,
            getStrFromJsonDoc(doc,"server", "bayou.pvos.org", verbose),
            sizeof(config.server));
    strlcpy(config.path,
            getStrFromJsonDoc(doc,"path", "/data/", verbose),
            sizeof(config.path));
    strlcpy(config.loranet_pubkey,
            getStrFromJsonDoc(doc,"loranet_pubkey", "unknown_12chars", verbose),
            sizeof(config.loranet_pubkey));
    config.max_wifi_attempts = getIntFromJsonDoc(doc,"max_wifi_attempts",1, verbose);
    config.forcePPM          = getIntFromJsonDoc(doc,"forcePPM",410, verbose);
    config.interval_sec      = getIntFromJsonDoc(doc,"interval_seconds",10, verbose);
    measureDelay=config.interval_sec*1000;
}

void printWifiStatus(char* prefix) {
  // print the SSID of the network you're attached to:
  Serial.print(prefix);Serial.print(F("SSID: "));Serial.println(WiFi.SSID());
  // print your board's IP address:
  IPAddress ip = WiFi.localIP();
  Serial.print(prefix);Serial.print(F("IP Address: "));Serial.println(ip);
  // print the received signal strength:
  long rssi = WiFi.RSSI();
  Serial.print(prefix);Serial.print(F("signal strength (RSSI):"));Serial.print(rssi);Serial.println(F(" dBm"));
}
//------------------------------------------------------------------------------
void forceCalibrateRoutine(){
  Serial.println(F("button A!"));
  long pressTime = millis();
  int pressCount = 5;
  //display calibrate prompt
  u8x8.clear();
  u8x8.setFont(u8x8_font_7x14B_1x2_f);
  u8x8.setCursor(0,0); 
  u8x8.print(F("Keep pressing"));
  u8x8.setCursor(0,2); 
  u8x8.print(F("to calibrate:"));
  int buttonA_state = digitalRead(BUTTON_A_PIN);
  while (((millis() - pressTime) < 5000) && (buttonA_state==0)) {
    buttonA_state = digitalRead(BUTTON_A_PIN);
    u8x8.setCursor(0,4);
    u8x8.print(pressCount);
    u8x8.print(F(" ..."));
    pressCount--;
    delay(1000); 
  }
  if (pressCount==0) {
    u8x8.clear();
    u8x8.setFont(u8x8_font_7x14B_1x2_f);
    u8x8.setCursor(0,0); 
    u8x8.print(F("Please step away"));
    u8x8.setCursor(0,2);
    u8x8.print(F("from sensor! "));
    u8x8.setCursor(0,4);
    u8x8.print(F("Calibrating in:"));
    for (int i=30;i>0;i--) {
      digitalWrite(LED, HIGH);  // turn the LED on (HIGH is the voltage level)
      delay(10);                 
      digitalWrite(LED, LOW);   // turn the LED off by making the voltage LOW
      delay(10);  
      u8x8.setCursor(0,6);
      u8x8.print(i);
      u8x8.print(F(" ..."));
      delay(1000);              // wait for a second
    }

    // do force calibrate
    airSensor.setForcedRecalibrationFactor(config.forcePPM);
    u8x8.clear();
    u8x8.setFont(u8x8_font_7x14B_1x2_f);
    u8x8.setCursor(0,0); 
    u8x8.print(F("Force calibrated"));
    u8x8.setCursor(0,2); 
    u8x8.print(F("to:"));
    u8x8.setCursor(0,4); 
    u8x8.print(config.forcePPM);
    u8x8.print(F(" ppm"));
    delay(3000);
   
  }else{ //cancel calibration
    u8x8.clear();
    u8x8.setFont(u8x8_font_7x14B_1x2_f);
    u8x8.setCursor(0,0); 
    u8x8.print(F("Calibration"));
    u8x8.setCursor(0,2); 
    u8x8.print(F("canceled."));
    delay(3000);
    firstLoop = true;
  }  
}
//------------------------------------------------------------------------------
bool exportOrQueueData(Payload data){
  //check to see if there is data to export
  bool success = postData(data); //try posting data
  if (!success){
    Serial.println(F("\tWARNING: data was not successfully posted, queuing..."));
    //TODO queue the data
    return false;
  }
  return true;
}
//------------------------------------------------------------------------------
bool postData(Payload data) {
  Serial.println(F("Posting data..."));
  if (wifi_status == WL_CONNECTED) {
    // if you don't want to use DNS (and reduce your sketch size)
    // use the numeric IP instead of the name for the server:
    //IPAddress server(74,125,232,128);  // numeric IP for Google (no DNS)
    // Initialize the Ethernet client library
    // with the IP address and port of the server
    // that you want to connect to (port 80 is default for HTTP):
    HttpClient http = HttpClient(wifiClient, config.server, 80);
    
    strip.setPixelColor(0, strip.Color(  255, 255,   0));
    strip.show();   
    //u8x8.setCursor(0,4);
    //u8x8.print(F("wifi:connected"));
    char full_path [60];
    strcpy(full_path,config.path);
    strcat(full_path,config.pubkey);
    Serial.print(F("\turl:         "));
    Serial.print(F("http://"));Serial.print(config.server);Serial.println(full_path);
    //Form the JSON:
    DynamicJsonDocument doc(MAX_CONFIG_SIZE);
    //  Serial.println(post_url);
    doc["private_key"]   = config.privkey;
    doc["co2_ppm"]       = data.co2;
    doc["temperature_c"] = data.temperature;
    doc["humidity_rh"]   = data.humidity;
    doc["node_id"]       = data.node_id;
    doc["log"]           = "OK"; 
    String json;
    serializeJson(doc, json);
    Serial.print(F("\tData:        "));serializeJson(doc, Serial);Serial.println();
    String contentType = "application/json";
    http.post(full_path, contentType, json);
    // read the status code and body of the response
    int statusCode = http.responseStatusCode();
    Serial.print(F("\tStatus code: "));
    Serial.println(statusCode);
    String response = http.responseBody();
    Serial.print(F("\tResponse:    "));
    Serial.print(response);  
    if(statusCode==200) {
      Serial.println(F("\tSuccess!"));
      strip.setPixelColor(data.node_id, strip.Color(  0, 255,   0));
      strip.show();  
      return true; 
    }else{
      Serial.println(F("\tERROR: Failed to post, check status code!"));
      indicateErrorLEDstayOn();
      strip.setPixelColor(0, strip.Color(  0, 0,   255));
      strip.show(); 
      //show status code on screen
      u8x8.clear();
      u8x8.setFont(u8x8_font_7x14B_1x2_f);
      u8x8.setCursor(0,0);
      u8x8.print(F("ERROR!"));
      u8x8.setFont(u8x8_font_chroma48medium8_r);
      u8x8.setCursor(2,4);
      u8x8.print(F("http:"));
      u8x8.print(statusCode);
      displayWifiSignalStrength(data); //may be useful for debugging
      return false;
    }
  }else{
    Serial.println(F("\tERROR: Failed to post, check wifi status!"));
    indicateErrorLEDstayOn();
    strip.setPixelColor(0, strip.Color(  0, 0,   255));
    strip.show();
    //show wifi connection proble on screen
    u8x8.clear();
    u8x8.setFont(u8x8_font_7x14B_1x2_f);
    u8x8.setCursor(0,0);
    u8x8.print(F("ERROR!"));
    u8x8.setFont(u8x8_font_chroma48medium8_r);
    u8x8.setCursor(2,6);
    u8x8.print(F("wifi: ?"));
    //signal connection error
    return false;
  }  
}
//------------------------------------------------------------------------------
void displayData(Payload data){
  u8x8.clear();
  //u8x8.setFont(u8x8_font_7x14B_1x2_f);
  //u8x8.setFont(u8x8_font_inr33_3x6_f);
  u8x8.setFont(u8x8_font_5x7_f);
  u8x8.setCursor(14,0);
  u8x8.print(F("#"));
  u8x8.print(data.node_id); 
  displayWifiSignalStrength(data);
  u8x8.setFont(u8x8_font_inb21_2x4_n);
  u8x8.setCursor(0,0); 
  u8x8.print(data.co2);
  u8x8.setFont(u8x8_font_7x14B_1x2_f);
  u8x8.setCursor(0,4); 
  u8x8.print(data.temperature);
  u8x8.print(F(" C"));
  u8x8.setCursor(0,6); 
  u8x8.print(data.humidity);
  u8x8.print(F(" RH"));
}

void displayWifiSignalStrength(Payload data){
  u8x8.setFont(u8x8_font_5x7_f);
  const int buffsize = 8;
  char buffer[buffsize];
  itoa(data.next_rssi,buffer,10);
  int len = strlen(buffer);
  if (wifi_status == WL_CONNECTED){
    u8x8.setCursor(7,1);
    //pad with spaces to overwrite previous numbers
    for (int i=0; i < buffsize -len; i++){
      u8x8.print(F(" "));
    }
    u8x8.print(F("W"));
    u8x8.print(data.next_rssi);
  } else{
    u8x8.print(F("W?"));
  }
}

void displayCountDown(int secondsLeft){
  u8x8.setFont(u8x8_font_5x7_f);
  const int buffsize = 8;
  char buffer[buffsize];
  itoa(secondsLeft,buffer,10);
  int len = strlen(buffer);
  u8x8.setCursor(8,7);
  //pad with spaces to overwrite previous numbers
  for (int i=0; i < buffsize -len; i++){
    u8x8.print(F(" "));
  }
  u8x8.print(secondsLeft);
}
//------------------------------------------------------------------------------
void neoBlink(uint32_t color_1, uint32_t color_2, int node_id, int numBlinks) {
  int wait = 100; //ms
  for (int i=0; i < numBlinks;i++) {
    strip.setPixelColor(node_id, color_1); //  Set pixel's color (in RAM)
    strip.show();                          //  Update strip to match
    delay(wait);                           //  Pause for a moment
    strip.setPixelColor(node_id, color_2);
    strip.show();
    delay(wait);
  }
}
//------------------------------------------------------------------------------
void colorWipe(uint32_t color, int wait) {
  for(int i=0; i<strip.numPixels(); i++) { // For each pixel in strip...
    strip.setPixelColor(i, color);         //  Set pixel's color (in RAM)
    strip.show();                          //  Update strip to match
    delay(wait);                           //  Pause for a moment
  }
}
//------------------------------------------------------------------------------
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
//------------------------------------------------------------------------------
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

//------------------------------------------------------------------------------
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
/******************************************************************************/
// SerialCommand Handlers
void IDN_sCmd_query_handler(SerialCommand this_sCmd){
  this_sCmd.print(F("#OK: IDN = "));this_sCmd.println(F(IDN_STRING));
}

void CONFIG_DUMP_sCmd_query_handler(SerialCommand this_sCmd){
    // Check if "config.json" exists and read in values
    if (fatfs.exists(configfile)) {
      File file_in = fatfs.open(configfile, FILE_READ);
      StaticJsonDocument<MAX_CONFIG_SIZE> doc;
      DeserializationError error = deserializeJson(doc, file_in);
      if (error) {
        Serial.println(F("#ERROR: Failed to read file"));
        indicateErrorLEDblink(1000);
        return;
      }
      file_in.close();
      this_sCmd.println(F("#OK: CONFIG.DUMP --------------------------------"));
      serializeJsonPretty(doc, this_sCmd);
      this_sCmd.println(F("\n#END: CONFIG.DUMP -------------------------------"));
      return;
    }
    else {
      Serial.println(F("#ERROR: No config file found..."));
      indicateErrorLEDblink(1000);
      return;
    }
}

void CONFIG_READ_sCmd_query_handler(SerialCommand this_sCmd){
  char *arg1 = this_sCmd.next();
  if (arg1 == NULL){
    this_sCmd.print(F("#ERROR: CONFIG.READ requires 1 arguments (str key), none given\n"));
    indicateErrorLEDblink(1000);
  }
  else{
    // Check if "config.json" exists and read in values
    if (fatfs.exists(configfile)) {
      File file_in = fatfs.open(configfile, FILE_READ);
      StaticJsonDocument<MAX_CONFIG_SIZE> doc;
      DeserializationError error = deserializeJson(doc, file_in);
      if (error) {
        Serial.println(F("#ERROR: Failed to read file"));
        indicateErrorLEDblink(1000);
        return;
      }
      file_in.close();
      const char* val = doc[arg1];
      this_sCmd.print(F("#OK: CONFIG.READ "));
      this_sCmd.print(arg1);
      this_sCmd.print(" = ");
      this_sCmd.println(val);
      return;
    }
    else {
      Serial.println(F("#ERROR: No config file found..."));
      return;
    }
  }
}

void CONFIG_WRITE_sCmd_action_handler(SerialCommand this_sCmd){
  char *arg1 = this_sCmd.next();
  if (arg1 == NULL){
    this_sCmd.print(F("#ERROR: CONFIG.WRITE requires 2 arguments (str key, str value), none given\n"));
    indicateErrorLEDblink(1000);
  }
  else{
    char *arg2 = this_sCmd.next();
    if (arg2 == NULL){
        this_sCmd.print(F("#ERROR: CONFIG.WRITE requires 2 arguments (str key, str value), 1 given\n"));
        indicateErrorLEDblink(1000);
    }
    else{ //OK to proceed
      // Check if "config.json" exists and read in values
      if (fatfs.exists(configfile)) {
        File file_in = fatfs.open(configfile, FILE_READ);
        DynamicJsonDocument doc(MAX_CONFIG_SIZE);
        DeserializationError error = deserializeJson(doc, file_in);
        if (error) {
          Serial.println(F("#ERROR: Failed to read file"));
          indicateErrorLEDblink(1000);
          return;
        }
        file_in.close();
        doc[arg1] = arg2;             //set the field
        loadConfigFromJsonDoc(doc,false);   //update the config
        //write the file back
        fatfs.remove(configfile);     //IMPORTANT remove existing file, or write mode open will fail
        File file_out = fatfs.open(configfile, FILE_WRITE);
        serializeJson(doc, file_out); //write-back
        file_out.close(); //close the file
      }
      else {
        Serial.println(F("#ERROR: No config file found..."));
        indicateErrorLEDblink(1000);
        return;
      }
      this_sCmd.print(F("#OK: CONFIG.WRITE "));
      this_sCmd.print(arg1);
      this_sCmd.print(" ");
      this_sCmd.println(arg2);
    }
  }
}

void CONFIG_DELETE_sCmd_action_handler(SerialCommand this_sCmd){
  char *arg1 = this_sCmd.next();
  if (arg1 == NULL){
    this_sCmd.print(F("#ERROR: CONFIG.DELETE requires 1 arguments (str key), none given\n"));
    indicateErrorLEDblink(1000);
  }
  else{
    // Check if "config.json" exists and read in values
    if (fatfs.exists(configfile)) {
      File file_in = fatfs.open(configfile, FILE_READ);
      DynamicJsonDocument doc(MAX_CONFIG_SIZE);
      DeserializationError error = deserializeJson(doc, file_in);
      if (error) {
        Serial.println(F("#ERROR: Failed to read file"));
        indicateErrorLEDblink(1000);
        return;
      }
      file_in.close();
      doc.remove(arg1);             //delete the field
      loadConfigFromJsonDoc(doc,false);   //update the config
      //write the file back
      fatfs.remove(configfile);     //IMPORTANT remove existing file, or write mode open will fail
      File file_out = fatfs.open(configfile, FILE_WRITE);
      serializeJson(doc, file_out); //write-back
      file_out.close(); //close the file
    }
    else {
      Serial.println(F("#ERROR: No config file found!"));
      indicateErrorLEDblink(1000);
      return;
    }
    this_sCmd.print(F("#OK: CONFIG.DELETE "));
    this_sCmd.println(arg1);
  }
}

void MEASURE_FORCE_sCmd_action_handler(SerialCommand this_sCmd){
  measureForce = true;
  this_sCmd.println(F("#OK: MEASURE.FORCE"));
}

//------------------------------------------------------------------------------
// Unrecognized command
void UNRECOGNIZED_sCmd_default_handler(SerialCommand this_sCmd)
{
  SerialCommand::CommandInfo command = this_sCmd.getCurrentCommand();
  this_sCmd.print(F("#ERROR: command '"));
  this_sCmd.print(command.name);
  this_sCmd.print(F("' not recognized ###\n"));
  indicateErrorLEDblink(1000);
}
/******************************************************************************/
