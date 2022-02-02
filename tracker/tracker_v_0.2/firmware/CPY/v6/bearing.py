import time
import board
import busio
import digitalio
import adafruit_gps
import adafruit_rfm9x
import math

PI = math.pi

# mosfet to turn on the GPS module
q1 = digitalio.DigitalInOut(board.D9)
q1.direction = digitalio.Direction.OUTPUT
q1.value = True

# LoRa radio 
RADIO_FREQ_MHZ = 915.0  # Frequency of the radio in Mhz. Must match your
CS = digitalio.DigitalInOut(board.D11)
RESET = digitalio.DigitalInOut(board.D6)

spi = busio.SPI(board.SCK, MOSI=board.MOSI, MISO=board.MISO)
rfm9x = adafruit_rfm9x.RFM9x(spi, CS, RESET, RADIO_FREQ_MHZ)

# on-board LED
LED = digitalio.DigitalInOut(board.D13)
LED.direction = digitalio.Direction.OUTPUT

# GPS 
uart = busio.UART(board.TX, board.RX, baudrate=9600, timeout=10)
gps = adafruit_gps.GPS(uart, debug=False)  # Use UART/pyserial

PI = math.pi

# function to get bearing from remote node to base node, given each node's lat and lon
# 'rlat, rlon' -- 'remote' node lat and lon
# 'blat, blon' -- 'base' node (i.e., this node)'s lat and lon
def getInt(fstr):
    parts=fstr.split(".")
    a=int(parts[0])
    b=int(parts[1])
    c=len(parts[1])
    d=len(parts[0])
    e=a*10**c+b
    return(e)

def getBearing(rlat,rlon,blat,blon):
    lat1=float(blat)
    lon1=float(blon)
    lat2=float(rlat)
    lon2=float(rlon)
    #print(lat1,lon1,lat2,lon2)

    phi1 = lat1 * PI/180.
    phi2 = lat2 * PI/180.
    lambda1 = lon1 * PI/180.
    lambda2 = lon2 * PI/180.
    y = math.sin(lambda2-lambda1)*math.cos(phi2)
    x = math.cos(phi1)*math.sin(phi2) - math.sin(phi1)*math.cos(phi2)*math.cos(lambda2-lambda1)
    
    print(y,x) 
    theta = math.atan2(y,x)
    bearing = math.fmod((theta*180/PI + 360),360)
    
    distance_meters = math.acos(math.sin(lat1*PI/180.)*math.sin(lat2*PI/180.) + math.cos(lat1*PI/180.)*math.cos(lat2*PI/180.)*math.cos(lon2*PI/180.-lon1*PI/180.) ) * 6371000
    distance_feet = 3.281*distance_meters
    print("ft:",distance_feet)

    return(bearing)

def getBearingInt(rlat,rlon,blat,blon):
    lat1=getInt(blat)
    lon1=getInt(blon)
    lat2=getInt(rlat)
    lon2=getInt(rlon)
    #print(lat1,lon1,lat2,lon2)

    phi1 = lat1 * PI/180.
    phi2 = lat2 * PI/180.
    lambda1 = lon1 * PI/180.
    lambda2 = lon2 * PI/180.
    y = math.sin(lambda2-lambda1)*math.cos(phi2)
    x = math.cos(phi1)*math.sin(phi2) - math.sin(phi1)*math.cos(phi2)*math.cos(lambda2-lambda1)
    print(y,x)
    theta = math.atan2(y,x)
    bearing = math.fmod((theta*180/PI + 360),360)
    
    distance_meters = math.acos(math.sin(lat1*PI/180.)*math.sin(lat2*PI/180.) + math.cos(lat1*PI/180.)*math.cos(lat2*PI/180.)*math.cos(lon2*PI/180.-lon1*PI/180.) ) * 6371000
    distance_feet = 3.281*distance_meters
    print("ft:",distance_feet)

    return(bearing)

while True:
    lat1="42.411602"
    lon1="-71.297781"
    lat2="42.415013"
    lon2="-71.204878"
    #print(lat1,getInt(lat1))
    print(getBearing(lat1,lon1,lat2,lon2))
    print("=======") 
    print(getBearingInt(lat1,lon1,lat2,lon2))
    time.sleep(100)