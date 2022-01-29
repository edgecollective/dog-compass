import digitalio
import board
import time

fet = digitalio.DigitalInOut(board.A1)
fet.direction = digitalio.Direction.OUTPUT
fet.value = True

while True:
    for i in range(0,6):
        fet.value=False
        time.sleep(1)
        print("sleep")
    for i in range(0,6):
        fet.value=True
        time.sleep(1)
        print("wake")