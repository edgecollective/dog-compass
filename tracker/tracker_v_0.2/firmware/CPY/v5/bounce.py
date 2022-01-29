import board
import digitalio
from adafruit_debouncer import Debouncer

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

while True:
    button_A.update()
    button_B.update()
    button_C.update()

    #if (button_A.value==False):
    #    print('pressed')

    if button_A.fell:
        print('A!')
    
    #if button_A.rose:
    #    print('Just released')

    if button_B.fell:
        print("B!")
    
    if button_C.fell:
        print("C!")