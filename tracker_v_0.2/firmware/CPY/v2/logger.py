import time

import adafruit_sdcard
import board
import busio
import digitalio
import microcontroller
import storage
import adafruit_pcf8523
import adafruit_scd30

import displayio
import terminalio
#import neopixel
from adafruit_display_text import label
import adafruit_displayio_ssd1306

scd = adafruit_scd30.SCD30(board.I2C())

displayio.release_displays()

i2c = board.I2C()
display_bus = displayio.I2CDisplay(i2c, device_address=0x3C)
display = adafruit_displayio_ssd1306.SSD1306(display_bus, width=128, height=64)

text = "PVOS.ORG\nCO2 Monitor\nREV_L"
text_area = label.Label(terminalio.FONT, text=text, color=0xFFFF00, x=20, y=15)
display.show(text_area)

try:
    f=open('config.json')
    config=json.load(f)
except:
    print("error opening config.json!")

#myI2C = busio.I2C(board.SCL, board.SDA)
rtc = adafruit_pcf8523.PCF8523(board.I2C())

days = ("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")

if False:   # change to True if you want to write the time!
    #                     year, mon, date, hour, min, sec, wday, yday, isdst
    t = time.struct_time((2021,  11,   12,   14,  19,  00,    0,   -1,    -1))
    # you must set year, mon, date, hour, min, sec and weekday
    # yearday is not supported, isdst can be set but we don't do anything with it at this time
    
    print("Setting time to:", t)     # uncomment for debugging
    rtc.datetime = t
    print()



# Use any pin that is not taken by SPI
SD_CS = board.D10

led = digitalio.DigitalInOut(board.D13)
led.direction = digitalio.Direction.OUTPUT

# Connect to the card and mount the filesystem.
spi = busio.SPI(board.SCK, board.MOSI, board.MISO)
cs = digitalio.DigitalInOut(SD_CS)
sdcard = adafruit_sdcard.SDCard(spi, cs)
vfs = storage.VfsFat(sdcard)
storage.mount(vfs, "/sd")

# Use the filesystem as normal! Our files are under /sd

print("Logging temperature to filesystem")
# append to the file!
while True:
    # open file for append

    t = rtc.datetime
    #print(t)     # uncomment for debugging

    print("The date is %s %d/%d/%d" % (days[t.tm_wday], t.tm_mday, t.tm_mon, t.tm_year))
    print("The time is %d:%02d:%02d" % (t.tm_hour, t.tm_min, t.tm_sec))
    
    print("unixtime is %d" % (time.mktime(t)))

    with open("/sd/temperature.txt", "a") as f:
        led.value = True  # turn on LED to indicate we're writing to the file
        t = microcontroller.cpu.temperature
        print("Temperature = %0.1f" % t)
        f.write("%d,%0.1f\n" % (time.mktime(t),t))
        led.value = False  # turn off LED to indicate we're done
    # file is saved
    time.sleep(1)
