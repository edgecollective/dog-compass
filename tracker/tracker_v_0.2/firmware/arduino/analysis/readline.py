import serial
import time

with serial.Serial('/dev/ttyACM0', 9600, timeout=3) as ser:
    while True:
        line=ser.readline()
        print(line.split(","))
        with open('output.txt', 'a') as file:  # Use file to refer to the file object
            file.write(line)
            file.close()
