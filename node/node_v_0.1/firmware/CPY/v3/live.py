import board
import busio
import digitalio
from digitalio import DigitalInOut
import adafruit_scd30
import time
from adafruit_bitmap_font import bitmap_font
from adafruit_display_text import label

scd = adafruit_scd30.SCD30(board.I2C())

import board
import displayio
import terminalio
#import neopixel
from adafruit_display_text import label
import adafruit_displayio_ssd1306


#led = neopixel.NeoPixel(board.NEOPIXEL, 1)
#led.brightness = 0.5

displayio.release_displays()

i2c = board.I2C()
display_bus = displayio.I2CDisplay(i2c, device_address=0x3C)
display = adafruit_displayio_ssd1306.SSD1306(display_bus, width=128, height=64)

#splash = displayio.Group()
#display.show(splash)

#color_bitmap = displayio.Bitmap(128, 32, 1)
#color_palette = displayio.Palette(1)
#color_palette[0] = 0xFFFFFF  # White

#bg_sprite = displayio.TileGrid(color_bitmap, pixel_shader=color_palette, x=0, y=0)
#splash.append(bg_sprite)

# Draw a smaller inner rectangle
#inner_bitmap = displayio.Bitmap(118, 24, 1)
#inner_palette = displayio.Palette(1)
#inner_palette[0] = 0x000000  # Black
#inner_sprite = displayio.TileGrid(inner_bitmap, pixel_shader=inner_palette, x=5, y=4)
#splash.append(inner_sprite)

# Draw a label

text = "PVOS.ORG\nCO2 Monitor\nREV_L"
text_area = label.Label(terminalio.FONT, text=text, color=0xFFFF00, x=20, y=15)
display.show(text_area)

time.sleep(3)

exception_count = 0
sample_recorded_count = 0

time_init=time.monotonic()

interval_seconds = 2

while True:

    #w.feed()
    current_time = time.monotonic()-time_init 

    if ((scd.data_available and (current_time > interval_seconds)) or sample_recorded_count < 1):
        try:
            if (scd.CO2>1):
                # print("Data Available!")
                print("CO2: %d PPM" % scd.CO2)
                print("Temperature:", scd.temperature, "degrees C")
                print("Humidity:", scd.relative_humidity, "%%rH")

                # print("Connecting to AP...")

                text = str(round(scd.CO2))
                #font = bitmap_font.load_font("/Helvetica-Bold-16.bdf")

                display.refresh()

                font = bitmap_font.load_font("/Junction-regular-24.bdf")
                #font = bitmap_font.load_font("/Helvetica-Bold-16.bdf")
                #font = terminalio.FONT
                color = 0xFFFF00
                text_area = label.Label(font=font, text=text, color=color, x=25, y=25)
                display.show(text_area)

                
                #splash.append(text_area)

                #reset timer interval
                time_init=time.monotonic()

        except Exception as e:
            print("*** Exception: " + str(e))
            exception_count += 1
            # break
