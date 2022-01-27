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
import adafruit_bno055
from adafruit_display_shapes.rect import Rect
from adafruit_display_shapes.circle import Circle
from adafruit_display_shapes.roundrect import RoundRect
from adafruit_display_shapes.triangle import Triangle
from adafruit_display_shapes.line import Line
from adafruit_display_shapes.polygon import Polygon
import terminalio
import adafruit_rfm9x
import random
from adafruit_debouncer import Debouncer

i2c = board.I2C()
imu = adafruit_bno055.BNO055_I2C(i2c)

button_A_pin = digitalio.DigitalInOut(board.A2)
button_A_pin.direction = digitalio.Direction.INPUT
button_A_pin.pull = digitalio.Pull.UP
button_A = Debouncer(button_A_pin)

button_B_pin = digitalio.DigitalInOut(board.A3)
button_B_pin.direction = digitalio.Direction.INPUT
button_B_pin.pull = digitalio.Pull.UP
button_B = Debouncer(button_B_pin)

button_C_pin = digitalio.DigitalInOut(board.A4)
button_C_pin.direction = digitalio.Direction.INPUT
button_C_pin.pull = digitalio.Pull.UP
button_C = Debouncer(button_C_pin)

current_locator = "..."

traceCounter = 0
TRACESKIP = 5
SHOWTRACE = True
MAXTRACE = 50
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
#display.rotation = 180 
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
#text_gps = Label(terminalio.FONT,text="\n23.23232",color=BLACK)
text_width = text_area.bounding_box[2] * FONTSCALE
text_group = displayio.Group(
    scale=FONTSCALE,
    x=display.width // 2 - text_width // 2,
    y=round(display.width/1.5)+15
    #display.height * 3 // 4,
)
text_group.append(text_area)  # Subgroup for text scaling

coords_text_group = displayio.Group(
    scale=1,
    x=display.width // 2 - text_width // 2,
    y=round(display.width/1.5)+30
    #display.height * 3 // 4,
)

text_gps = Label(terminalio.FONT,text="",color=BLACK)
coords_text_group.append(text_gps)

cx = display.width // 2
cy = display.width // 4
cx= 0
cy = 0
r = 2 
circle = Circle(cx, cy, r, fill=WHITE, outline=BLACK,stroke=1)

compass_x=10
compass_y=110
compass_r=8

compass_circle = Circle(compass_x, compass_y, compass_r, fill=WHITE, outline=BLACK,stroke=1)

dx=0
dy=0

compass_arrow = Circle(compass_x, compass_y+compass_r, 2, fill=BLACK, outline=BLACK,stroke=1)
#line = Line(cx, cy, cx, cy + r, BLACK)

line = Line(0,round(display.width/1.5),round(display.width),round(display.width/1.5),BLACK)
line2 = Line(0,round(display.width/1.5)+1,round(display.width),round(display.width/1.5)+1,BLACK)
line3 = Line(0,round(display.width/1.5/2),round(display.width),round(display.width/1.5/2),BLACK)
line4 = Line(round(display.width/2),0,round(display.width/2),round(display.width/1.5),BLACK)

trace = []
#screen_trace = [(0,0),(50,0),(75,75),(100,0)]
#traceline = Polygon(screen_trace,outline=BLACK)
trace_balls = displayio.Group()
for i in range(MAXTRACE):
    fill=WHITE
    b = Circle(0,0, 1, fill=fill, outline=1,stroke=1)
    trace_balls.append(b)
    trace.append((0,0))

splash.append(rect)
#splash.append(circle)
splash.append(line)
splash.append(line2)
splash.append(line3)
splash.append(line4)
splash.append(text_group)
splash.append(coords_text_group)
splash.append(trace_balls)#splash.append(traceline)
splash.append(circle)
splash.append(compass_circle)
splash.append(compass_arrow)

text_area.text=current_locator


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

#rfm9x.send(bytes("Hello world!\r\n", "utf-8"))
#print("Sent Hello World message!")

LED = digitalio.DigitalInOut(board.D13)
LED.direction = digitalio.Direction.OUTPUT

def split(word):
    return [char for char in word]

def updateCompass():
    heading=math.radians(imu.euler[0]-180)
    dx=compass_r*math.sin(heading)
    dy=compass_r*math.cos(heading)
    compass_arrow.x=round(compass_x+dx)
    compass_arrow.y=round(compass_y+dy)

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
    return(locator)
    #print ("locator=",locator)
    #text_area.text = locator

def updateScreenCoords():
    lat=gps.latitude
    lon=gps.longitude
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

    x = round(xfrac*max_x)
    y = round(yfrac*max_y)

    #circle.x=x
    #circle.y=y

    if (traceCounter % TRACESKIP ==0):
        trace.append((x,y))
        print("appending!")

    if(len(trace)>MAXTRACE):
        trace.pop(0)

    for i in range(len(trace)):
        b = trace_balls[i] # get a ball
        if SHOWTRACE:
            b.x = trace[i][0]
            b.y = trace[i][1]
        else:
            b.x = 0
            b.y = 0

    circle.x=x
    circle.y=y

    text_area.text=current_locator

last_print = time.monotonic()



while True:
    button_A.update()
    button_B.update()
    button_C.update()
    # Make sure to call gps.update() every loop iteration and at least twice
    # as fast as data comes from the GPS unit (usually every second).
    # This returns a bool that's true if it parsed new data (you can ignore it
    # though if you don't care and instead look at the has_fix property).
    if button_A.fell:
        print('A!')
        SHOWTRACE = not SHOWTRACE

    if button_B.fell:
        print("B!")
        for i in range(len(trace)):
            b = trace_balls[i] # get a ball
            b.x = 0
            b.y = 0
    
    if button_C.fell:
        print("C!")

    gps.update()
    # Every second print out current location details if there's a fix.
    current = time.monotonic()
    if current - last_print >= 1.0:

        print("Euler angle: {}".format(imu.euler))
        updateCompass()

        last_print = current

        traceCounter=traceCounter+1
             
        #LED.value=False
        #rfm9x.send(bytes("Hello world!\r\n", "utf-8"))
        #LED.value=True
        #time.sleep(0.05)
        #LED.value=False
        #print("Sent Hello World message!")

        if not gps.has_fix:
            # Try again if we don't have a fix yet.
            print("Waiting for fix...")

            getLocator(TEST_LAT,TEST_LON,4)
            
            #showRect(TEST_LAT,TEST_LON)


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

        #lat_str = "{:.6f}".format(gps.latitude)
        #lon_str = "{:.6f}".format(gps.longitude)
        #trace.append((lat_str,lon_str))
        #if(len(trace)>MAXTRACE):
        #    trace.pop(0)

        #update the user position
        #user_coords = getScreenCoords(gps.latitude,gps.longitude)

        #circle.x=user_coords[0]
        #circle.y=user_coords[1]
        
        # update the ball positions
        
        #print(trace)

        print("Lat: {0:.6f} degrees".format(gps.latitude))
        print("Lon: {0:.6f} degrees".format(gps.longitude))
        print("Fix quality: {}".format(gps.fix_quality))
        # Some attributes beyond latitude, longitude and timestamp are optional
        # and might not be present.  Check if they're None before trying to use!
        #text_area.text = "lat: {0:.6f}".format(gps.latitude)

        # update status bar
        status = 'calib:' + str(imu.calibration_status[3])+str("/3 | ")
        if (SHOWTRACE):
            status += "Traces"
        text_gps.text=status+'\nLat:{0:.6f}'.format(gps.latitude)+'\nLon:{0:.6f}'.format(gps.longitude)
        new_locator=getLocator(gps.latitude,gps.longitude,4)
        if(new_locator != current_locator):
            current_locator = new_locator
            for i in range(len(trace)):
                b = trace_balls[i] # get a ball
                b.x = 0
                b.y = 0 
        updateScreenCoords()
        #showRect(gps.latitude,gps.longitude)