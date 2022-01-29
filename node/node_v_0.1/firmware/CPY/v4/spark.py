import board
import busio
import digitalio
from digitalio import DigitalInOut
import adafruit_scd30
import time
from adafruit_bitmap_font import bitmap_font
from adafruit_display_text import label
#import adafruit_sdcard
import microcontroller
import storage
from adafruit_display_shapes.rect import Rect
from adafruit_display_shapes.circle import Circle
from adafruit_display_shapes.roundrect import RoundRect
from adafruit_display_shapes.triangle import Triangle
from adafruit_display_shapes.line import Line
from adafruit_display_shapes.polygon import Polygon

from adafruit_display_shapes.sparkline import Sparkline

import random

scd = adafruit_scd30.SCD30(board.I2C())

import board
import displayio
import terminalio
#import neopixel
from adafruit_display_text import label
import adafruit_displayio_ssd1306

displayio.release_displays()

i2c = board.I2C()
display_bus = displayio.I2CDisplay(i2c, device_address=0x3C)
display = adafruit_displayio_ssd1306.SSD1306(display_bus, width=128, height=64)


time.sleep(1)

exception_count = 0
sample_recorded_count = 0

time_init=time.monotonic()

interval_seconds = 2

WIDTH = 128
HEIGHT = 64  # Change to 64 if needed
BORDER = 1


chart_width = display.width
chart_height = display.height 

sparkline1 = Sparkline(width=chart_width, height=chart_height, max_items=40, y_min=0, y_max=10, x=0, y=0)

my_group = displayio.Group()
# add the sparkline into my_group
my_group.append(sparkline1)

# Add my_group (containing the sparkline) to the display
display.show(my_group)

while True:

    #w.feed()
    current_time = time.monotonic()-time_init 

    if ((scd.data_available and (current_time > interval_seconds)) or sample_recorded_count < 1):
        try:
            if (scd.CO2>1):

                #font = bitmap_font.load_font("/Junction-regular-24.bdf")
                #font = bitmap_font.load_font("/Helvetica-Bold-16.bdf")
                #font = terminalio.FONT
                #text = str(round(scd.CO2))
                #color = 0xFFFF00
                #text_area = label.Label(font=font, text=text, color=color, x=25, y=25)

                display.auto_refresh = False

                sparkline1.add_value(random.uniform(0, 10))
                #co2_reading.text = str(round(scd.CO2))
                
                display.auto_refresh = True

                time.sleep(0.01)

                #text_area = label.Label(
                #    terminalio.FONT, text=text, color=0xFFFFFF, x=28, y=HEIGHT // 2 - 1
                #)
                #display.refresh() 
                #display.show(splash)
                #display.show(text_area)

                sample_recorded_count = sample_recorded_count + 1
                time_init=time.monotonic()

        except Exception as e:
            print("*** Exception: " + str(e))
            exception_count += 1
            # break
