import time
import board
import busio
import digitalio
q1 = digitalio.DigitalInOut(board.D9)
q1.direction = digitalio.Direction.OUTPUT
q1.value = True
import adafruit_gps
RX = board.RX
TX = board.TX
uart = busio.UART(TX, RX, baudrate=9600, timeout=30)
while True:
    data = uart.readline()  # read up to 32 bytes
    if data is not None:
        #print(data)
        r=str(data,"ascii").split(",")
        if(r[0]=='$GPGLL'):
            lat_str=r[1]
            lat_dir=r[2]
            lon_str=r[3]
            lon_dir=r[4]
            #print(lat_str+" "+lat_dir+",",lon_str+" "+lon_dir)
            #print(lat_str+" "+lon_str)
            lat_str_int=lat_str.replace(".","")
            lon_str_int=lon_str.replace(".","")
            print(lat_str_int,lon_str_int)
        #data_string = ''.join([chr(b) for b in data])
        #print(data_string, end="")
