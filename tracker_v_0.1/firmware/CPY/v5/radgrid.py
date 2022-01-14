# SPDX-FileCopyrightText: 2021 ladyada for Adafruit Industries
# SPDX-License-Identifier: MIT

# Simple GPS module demonstration.
# Will wait for a fix and print a message every second with the current location
# and other details.
import time
import board
import busio
import digitalio
import adafruit_gps
import displayio
import framebufferio
import sharpdisplay
import math
from adafruit_display_shapes.rect import Rect
from adafruit_display_shapes.circle import Circle
from adafruit_display_shapes.roundrect import RoundRect
from adafruit_display_shapes.triangle import Triangle
from adafruit_display_shapes.line import Line
from adafruit_display_shapes.polygon import Polygon
import terminalio
import adafruit_rfm9x

UNIT = 0.004166666666666667

displayio.release_displays()

bus = board.SPI()
chip_select_pin = board.D5

#gps fet
q1 = digitalio.DigitalInOut(board.D9)
q1.direction = digitalio.Direction.OUTPUT
q1.value = True

# display
framebuffer = sharpdisplay.SharpMemoryFramebuffer(bus, chip_select_pin, width=144, height=168, baudrate=8000000)

display = framebufferio.FramebufferDisplay(framebuffer)
display.rotation = 180 
from adafruit_display_text.label import Label
from terminalio import FONT
#label = Label(font=FONT, text="BLACK\nLIVES\nMATTER", x=120, y=120, scale=4, line_spacing=1.2)
#display.show(label)

splash = displayio.Group()

display.show(splash)

TEST_LAT = 42.411776
TEST_LON = -71.2978

max_x = display.width
may_y = round(display.width/1.5)

WHITE = 0x00FF00
BLACK = 0x0

rect = Rect(0, 0, 144, 168, fill=WHITE)

FONTSCALE = 2 
# Draw a label
text = "        "
text_area = Label(terminalio.FONT, text=text, color=BLACK)
text_gps = Label(terminalio.FONT,text="\n23.23232",color=BLACK)
text_width = text_area.bounding_box[2] * FONTSCALE
text_group = displayio.Group(
    scale=FONTSCALE,
    x=display.width // 2 - text_width // 2,
    y=round(display.width/1.5)+15
    #display.height * 3 // 4,
)
text_group.append(text_area)  # Subgroup for text scaling
text_group.append(text_gps)
cx = display.width // 2
cy = display.width // 4
r = 5 
circle = Circle(cx, cy, r, fill=BLACK, outline=BLACK)

#line = Line(cx, cy, cx, cy + r, BLACK)

line = Line(0,round(display.width/1.5),round(display.width),round(display.width/1.5),BLACK)
line2 = Line(0,round(display.width/1.5)+1,round(display.width),round(display.width/1.5)+1,BLACK)

splash.append(rect)
splash.append(circle)
splash.append(line)
splash.append(line2)
splash.append(text_group)

text_area.text="halibut"


# Create a serial connection for the GPS connection using default speed and
# a slightly higher timeout (GPS modules typically update once a second).
# These are the defaults you should use for the GPS FeatherWing.
# For other boards set RX = GPS module TX, and TX = GPS module RX pins.
uart = busio.UART(board.TX, board.RX, baudrate=9600, timeout=10)

# for a computer, use the pyserial library for uart access
# import serial
# uart = serial.Serial("/dev/ttyUSB0", baudrate=9600, timeout=10)

# If using I2C, we'll create an I2C interface to talk to using default pins
# i2c = board.I2C()

# Create a GPS module instance.
gps = adafruit_gps.GPS(uart, debug=False)  # Use UART/pyserial
# gps = adafruit_gps.GPS_GtopI2C(i2c, debug=False)  # Use I2C interface


# set up radio

RADIO_FREQ_MHZ = 915.0  # Frequency of the 
CS = digitalio.DigitalInOut(board.D11)
RESET = digitalio.DigitalInOut(board.D6)
rfm9x = adafruit_rfm9x.RFM9x(bus, CS, RESET, RADIO_FREQ_MHZ)
rfm9x.tx_power = 23

rfm9x.send(bytes("Hello world!\r\n", "utf-8"))
print("Sent Hello World message!")

LED = digitalio.DigitalInOut(board.D13)
LED.direction = digitalio.Direction.OUTPUT

def split(word):
    return [char for char in word]

def getLocator(lat, lon, precision):
    print(lat,lon,precision)
    ydiv_arr = [10,1,0.04166666666,0.00416666666,0.00017361111]
    d1 = split("ABCDEFGHIJKLMNOPQR")
    d2 = split("ABCDEFGHIJKLMNOPQRSTUVWX")
    #d4 = [0,1,1,1,1,1,2,2,2,2,3,3,3,3,3,4,4,4,4,5,5]
    precision = 4
    locator=""
    x = lon
    y = lat
    while (x < -180):
        x = x + 360
    while (x > 180):
        x = x - 360
    x = x + 180
    y = y + 90
    locator = locator + d1[math.floor(x/20)] + d1[math.floor(y/10)]
    for i in range(0,4):
        if (precision > i + 1):
            rlon = x%(ydiv_arr[i]*2)
            rlat = y%(ydiv_arr[i])
            if ((i%2)==0):
                locator += str(math.floor(rlon/(ydiv_arr[i+1]*2))) + str(math.floor(rlat/(ydiv_arr[i+1])))
            else:
                locator += d2[math.floor(rlon/(ydiv_arr[i+1]*2))] + d2[math.floor(rlat/(ydiv_arr[i+1]))]
    print ("locator=",locator)
    text_area.text = locator

def showRect(lat,lon):
    max_x = display.width
    max_y = round(display.width/1.5)
    
    myLat = lat
    if (myLat > 85):
        myLat = 85
    if (myLat < -85):
        myLat = -85

    lon_left = math.floor(lon/(UNIT*2))*UNIT*2
    lon_right = math.ceil(lon/(UNIT*2))*UNIT*2
    lat_top = math.ceil(myLat/UNIT)*UNIT
    lat_bottom = math.floor(myLat/UNIT)*UNIT

    xfrac = (lon-lon_left)/(lon_right-lon_left)
    yfrac = 1-(lat-lat_bottom)/(lat_top-lat_bottom)

    print("lat:",lat,"lon:",lon)
    print("corners:",lon_left,lon_right,lat_top,lat_bottom)

    x = round(xfrac*max_x)
    y = round(yfrac*max_y)
    #r = 10

    print(x,y,r)
    circle.x=x
    circle.y=y
    #circle.r=r


last_print = time.monotonic()


while True:
    # Make sure to call gps.update() every loop iteration and at least twice
    # as fast as data comes from the GPS unit (usually every second).
    # This returns a bool that's true if it parsed new data (you can ignore it
    # though if you don't care and instead look at the has_fix property).
    
    gps.update()
    # Every second print out current location details if there's a fix.
    current = time.monotonic()
    if current - last_print >= 1.0:
        last_print = current

        LED.value=False
        rfm9x.send(bytes("Hello world!\r\n", "utf-8"))
        LED.value=True
        time.sleep(0.05)
        LED.value=False
        print("Sent Hello World message!")

        if not gps.has_fix:
            # Try again if we don't have a fix yet.
            print("Waiting for fix...")

            getLocator(TEST_LAT,TEST_LON,4)
            
            showRect(TEST_LAT,TEST_LON)


            continue
        # We have a fix! (gps.has_fix is true)
        # Print out details about the fix like location, date, etc.
        print("=" * 40)  # Print a separator line.
        print(
            "Fix timestamp: {}/{}/{} {:02}:{:02}:{:02}".format(
                gps.timestamp_utc.tm_mon,  # Grab parts of the time from the
                gps.timestamp_utc.tm_mday,  # struct_time object that holds
                gps.timestamp_utc.tm_year,  # the fix time.  Note you might
                gps.timestamp_utc.tm_hour,  # not get all data like year, day,
                gps.timestamp_utc.tm_min,  # month!
                gps.timestamp_utc.tm_sec,
            )
        )
        print("Lat: {0:.6f} degrees".format(gps.latitude))
        print("Lon: {0:.6f} degrees".format(gps.longitude))
        print("Fix quality: {}".format(gps.fix_quality))
        # Some attributes beyond latitude, longitude and timestamp are optional
        # and might not be present.  Check if they're None before trying to use!
        #text_area.text = "lat: {0:.6f}".format(gps.latitude)
        getLocator(gps.latitude,gps.longitude,4)
        showRect(gps.latitude,gps.longitude)