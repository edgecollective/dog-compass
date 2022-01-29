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

# Make the display context
splash = displayio.Group()
display.show(splash)

color_bitmap = displayio.Bitmap(WIDTH, HEIGHT, 1)
color_palette = displayio.Palette(1)
color_palette[0] = 0xFFFFFF  # White

bg_sprite = displayio.TileGrid(color_bitmap, pixel_shader=color_palette, x=0, y=0)
#splash.append(bg_sprite)

# Draw a smaller inner rectangle
inner_bitmap = displayio.Bitmap(WIDTH - BORDER * 2, HEIGHT - BORDER * 2, 1)
inner_palette = displayio.Palette(1)
inner_palette[0] = 0x000000  # Black
inner_sprite = displayio.TileGrid(
    inner_bitmap, pixel_shader=inner_palette, x=BORDER, y=BORDER
)
#splash.append(inner_sprite)

# Draw a label
text = "1000"
upper_limit = label.Label(
    terminalio.FONT, text=text, color=0xFFFFFF, x=0, y=6
)
splash.append(upper_limit)

text = " 500"
middle_limit = label.Label(
    terminalio.FONT, text=text, color=0xFFFFFF, x=0, y= HEIGHT // 2
)
splash.append(middle_limit)

text = "   0"
lower_limit = label.Label(
    terminalio.FONT, text=text, color=0xFFFFFF, x=0, y= HEIGHT - 8 
)
splash.append(lower_limit)


text = "---"
co2_reading = label.Label(
    terminalio.FONT, text=text, color=0xFFFFFF, x=WIDTH - 20, y= 6 
)
splash.append(co2_reading)

xpos = 27 
splash.append(Line(xpos, 0, xpos, 128, 0xFFFFFF))

splash.append(Line(xpos, HEIGHT-1, WIDTH, HEIGHT-1 , 0xFFFFFF))

screenx = xpos
screeny = 0

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
                
                co2_reading.text = str(round(scd.CO2))
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
