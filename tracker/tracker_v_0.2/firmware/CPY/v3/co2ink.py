import time
import board
import displayio
import adafruit_ssd1681
import terminalio
from adafruit_display_text import label
from adafruit_bitmap_font import bitmap_font
displayio.release_displays()

import adafruit_scd30

# This pinout works on a Feather M4 and may need to be altered for other boards.
spi = board.SPI()  # Uses SCK and MOSI
epd_cs = board.D9
epd_dc = board.D10
epd_reset = board.D7
epd_busy = board.D11

scd = adafruit_scd30.SCD30(board.I2C())


display_bus = displayio.FourWire(
    spi, command=epd_dc, chip_select=epd_cs, reset=epd_reset, baudrate=1000000
)
time.sleep(1)

display = adafruit_ssd1681.SSD1681(
    display_bus, width=200, height=200, busy_pin=epd_busy, rotation=180
)

#g = displayio.Group()

font = bitmap_font.load_font("/Junction-regular-24.bdf")

text = "PVOS.ORG"

#text_area = label.Label(terminalio.FONT, text=text, color=0xFFFF00, x=20, y=15)
text_area = label.Label(font, text=text, color=0xFFFF00, x=20, y=50)
display.show(text_area)
display.refresh()

time_init=time.monotonic()

interval_seconds = 5

exception_count = 0
sample_recorded_count = 0

time.sleep(3)
print("refresh time")
print(display.time_to_refresh)

while True:

    current_time = time.monotonic()-time_init 
    time.sleep(display.time_to_refresh)
    if ((scd.data_available and (current_time > interval_seconds)) or sample_recorded_count < 1):
        try:
            if (scd.CO2>1):
                text = str(round(scd.CO2))
                print(text)
                text_area = label.Label(font=font, text=text, color=0xFFFF00, x=25, y=25)
                display.show(text_area)
                time_init=time.monotonic()
                sample_recorded_count = sample_recorded_count + 1
                display.refresh()
        except Exception as e:
            print("*** Exception: " + str(e))
            exception_count += 1