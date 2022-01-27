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
import adafruit_rfm9x
import math

q1 = digitalio.DigitalInOut(board.D9)
q1.direction = digitalio.Direction.OUTPUT
q1.value = True

RADIO_FREQ_MHZ = 915.0  # Frequency of the radio in Mhz. Must match your
CS = digitalio.DigitalInOut(board.D11)
RESET = digitalio.DigitalInOut(board.D6)

LED = digitalio.DigitalInOut(board.D13)
LED.direction = digitalio.Direction.OUTPUT

spi = busio.SPI(board.SCK, MOSI=board.MOSI, MISO=board.MISO)

# Initialze RFM radio
rfm9x = adafruit_rfm9x.RFM9x(spi, CS, RESET, RADIO_FREQ_MHZ)

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

# Initialize the GPS module by changing what data it sends and at what rate.
# These are NMEA extensions for PMTK_314_SET_NMEA_OUTPUT and
# PMTK_220_SET_NMEA_UPDATERATE but you can send anything from here to adjust
# the GPS module behavior:
#   https://cdn-shop.adafruit.com/datasheets/PMTK_A11.pdf

# Turn on the basic GGA and RMC info (what you typically want)
#gps.send_command(b"PMTK314,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0")


# Turn on just minimum info (RMC only, location):
# gps.send_command(b'PMTK314,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0')
# Turn off everything:
# gps.send_command(b'PMTK314,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0')
# Turn on everything (not all of it is parsed!)
# gps.send_command(b'PMTK314,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0')

# Set update rate to once a second (1hz) which is what you typically want.
#gps.send_command(b"PMTK220,1000")
PI = math.pi

def getBearing(rlat,rlon,blat,blon):
    lat1=float(blat)
    lon1=float(blon)
    lat2=float(rlat)
    lon2=float(rlon)
    phi1 = lat1 * PI/180.
    phi2 = lat2 * PI/180.
    lambda1 = lon1 * PI/180.
    lambda2 = lon2 * PI/180.
    y = math.sin(lambda2-lambda1)*math.cos(phi2)
    x = math.cos(phi1)*math.sin(phi2) - math.sin(phi1)*math.cos(phi2)*math.cos(lambda2-lambda1)
    theta = math.atan2(y,x)
    bearing = math.fmod((theta*180/PI + 360),360)
    
    distance_meters = math.acos(math.sin(lat1*PI/180.)*math.sin(lat2*PI/180.) + math.cos(lat1*PI/180.)*math.cos(lat2*PI/180.)*math.cos(lon2*PI/180.-lon1*PI/180.) ) * 6371000
    distance_feet = 3.281*distance_meters
    
    #degree_diff = heading-bearing
    return(bearing)
# Or decrease to once every two seconds by doubling the millisecond value.
# Be sure to also increase your UART timeout above!
# gps.send_command(b'PMTK220,2000')
# You can also speed up the rate, but don't go too fast or else you can lose
# data during parsing.  This would be twice a second (2hz, 500ms delay):
# gps.send_command(b'PMTK220,500')

# Main loop runs forever printing the location, etc. every second.
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
        if not gps.has_fix:
            # Try again if we don't have a fix yet.
            print("Waiting for fix...")
            continue
        # We have a fix! (gps.has_fix is true)
        # Print out details about the fix like location, date, etc.
        base_lat = "{0:.6f}".format(gps.latitude)
        base_lon = "{0:.6f}".format(gps.longitude)
        print("base:",base_lat,base_lon)
        
        packet=rfm9x.receive()
        if packet is not None:
            LED.value=True
            time.sleep(0.05)
            LED.value=False
            #print("Received (raw bytes): {0}".format(packet))
            packet_text = str(packet, "ascii")
            packet_parts = packet_text.split(",")
            r_lat = packet_parts[0]
            r_lon = packet_parts[1]
            print("remote:",r_lat,r_lon)
            rlat=42.41156609002178
            rlon=-71.16533434544752
            #r_lat=42.36055555884411
            #r_lon=-71.03715071463135
            bearing=getBearing(r_lat,r_lon,base_lat,base_lon)
            print("bearing:",bearing)
