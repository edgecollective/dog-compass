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
def getBearing(rlat,rlon,blat,blon):
    lat1=float(blat)
    lon1=float(blon)
    lat2=float(rlat)
    lon2=float(rlon)
    print(lat1,lon1,lat2,lon2)

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
    print("ft:",distance_feet)

    return(bearing,distance_feet)


# main loop
last_print = time.monotonic()

while True:

    data = uart.readline() 
    #gps.update()
    if data is not None:
        r=str(data,"ascii").split(",")
        if(r[0]=='$GPGLL'):
            lon_str=r[1]
            lon_dir=r[2]
            lat_str=r[3]
            lat_dir=r[4]
            #print(r)
            if (lon_str!=''):
                last_print = time.monotonic()
                #print("listening ...")
                time.sleep(.1)
                current = time.monotonic()
                while (current - last_print <= 5):
                    #print("time:",current)
                    packet=rfm9x.receive()
                    if packet is not None:
                        LED.value=True
                        time.sleep(0.05)
                        LED.value=False
                        packet_text = str(packet, "ascii")
                        packet_parts = packet_text.split(",")
                        r_lat = packet_parts[0].replace("[","").rstrip('\x00')
                        r_lon = packet_parts[1].replace("]","").rstrip('\x00')
                        #print(r_lat)
                        #print("output:")
                        print(r_lat,r_lon,lat_str,lon_str)
                    current=time.monotonic()
        #base_lat = "{0:.6f}".format(gps.latitude)
        #base_lon = "{0:.6f}".format(gps.longitude)
        #print(base_lat,base_lon)
        
