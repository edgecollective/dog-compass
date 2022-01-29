# SPDX-FileCopyrightText: 2020 Bryan Siepert, written for Adafruit Industries
# SPDX-License-Identifier: MIT
from time import sleep
import board
from adafruit_ms8607 import MS8607

i2c = board.I2C()
sensor = MS8607(i2c)

while True:

    print("Pressure: %.2f hPa" % sensor.pressure)
    print("Temperature: %.2f C" % sensor.temperature)
    print("Humidity: %.2f %% rH" % sensor.relative_humidity)
    print("\n------------------------------------------------\n")
    sleep(1)
