# SPDX-FileCopyrightText: 2021 ladyada for Adafruit Industries
# SPDX-License-Identifier: MIT

# Simple seesaw test reading analog value
# on SAMD09, analog in can be pins 2, 3, or 4
# on Attiny8x7, analog in can be pins 0, 1, 2, 3, 6, 7, 18, 19, 20

import time
import board
from adafruit_seesaw.seesaw import Seesaw
from adafruit_seesaw.analoginput import AnalogInput

ss = Seesaw(board.I2C())

analogin_pin = 2
analog_in = AnalogInput(ss, analogin_pin)

while True:
    print(analog_in.value)
    time.sleep(0.1)
