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
import math

from adafruit_display_shapes.sparkline import Sparkline

import random


q1 = digitalio.DigitalInOut(board.D9)
q1.direction = digitalio.Direction.OUTPUT
q1.value = True

time.sleep(2)

scd = adafruit_scd30.SCD30(board.I2C())

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

font = terminalio.FONT

line_color = 0xFFFFFF

WHITE = 0x000000

chart_width = display.width - 40
chart_height = display.height - 25 

sparkline1 = Sparkline(width=chart_width, height=chart_height, max_items=40, y_min=0, y_max=1000, x=35, y=19, color=line_color)

text_xoffset = -10
text_label1a = label.Label(
    font=font, text=str(sparkline1.y_top), color=line_color
)  # yTop label
text_label1a.anchor_point = (1, 0.5)  # set the anchorpoint at right-center
text_label1a.anchored_position = (
    sparkline1.x + text_xoffset,
    sparkline1.y,
)  # set the text anchored position to the upper right of the graph

text_label1b = label.Label(
    font=font, text=str(sparkline1.y_bottom), color=line_color
)  # yTop label
text_label1b.anchor_point = (1, 0.5)  # set the anchorpoint at right-center
text_label1b.anchored_position = (
    sparkline1.x + text_xoffset,
    sparkline1.y + chart_height,
)  # set the text anchored position to the upper right of the graph

text_label1c = label.Label(
    font=font, text=str(sparkline1.y_top // 2), color=line_color
)  # yTop label
text_label1c.anchor_point = (1, 0.5)  # set the anchorpoint at right-center
text_label1c.anchored_position = (
    sparkline1.x + text_xoffset,
    sparkline1.y + chart_height/2,
)  # set the text anchored posi


bounding_rectangle = Rect(
    sparkline1.x, sparkline1.y, chart_width, chart_height, outline=line_color
)

text_label1d = label.Label(
    font=font, text="---", color=line_color
)  # yTop label
text_label1d.anchor_point = (1, 0.5)  # set the anchorpoint at right-center
text_label1d.anchored_position = (
    #sparkline1.x + chart_width + text_xoffset,
    WIDTH * 4.5 // 5, 
    4 
)  # set the text anchored posi


# Create a group to hold the sparkline, text, rectangle and tickmarks
# append them into the group (my_group)
#
# Note: In cases where display elements will overlap, then the order the
# elements are added to the group will set which is on top.  Latter elements
# are displayed on top of former elemtns.
rad = 2 
posx = rad*2 
posy = HEIGHT - rad*2 

circle = Circle(posx, posy, rad)
y_axis = Line(sparkline1.x,sparkline1.y,sparkline1.x,sparkline1.y+chart_height,color=line_color)
x_axis = Line(sparkline1.x,sparkline1.y+chart_height,sparkline1.x+chart_width,sparkline1.y+chart_height,color=line_color)
my_group = displayio.Group()

my_group.append(sparkline1)
my_group.append(text_label1a)
my_group.append(text_label1b)
my_group.append(text_label1c)
my_group.append(text_label1d)
#my_group.append(bounding_rectangle)
my_group.append(y_axis)
#my_group.append(x_axis)
my_group.append(circle)

total_ticks = 2 

for i in range(total_ticks + 1):
    x_start = sparkline1.x - 5
    x_end = sparkline1.x
    y_both = int(round(sparkline1.y + (i * (chart_height) / (total_ticks))))
    if y_both > sparkline1.y + chart_height - 1:
        y_both = sparkline1.y + chart_height - 1
    my_group.append(Line(x_start, y_both, x_end, y_both, color=line_color))


# Set the display to show my_group that contains the sparkline and other graphics
display.show(my_group)

while True:

    #w.feed()
    current_time = time.monotonic()-time_init 


    if (scd.data_available and ((current_time > interval_seconds) or sample_recorded_count < 1)):
        try:
            if (scd.CO2>1):

                #font = bitmap_font.load_font("/Junction-regular-24.bdf")
                #font = bitmap_font.load_font("/Helvetica-Bold-16.bdf")
                #font = terminalio.FONT
                #text = str(round(scd.CO2))
                #color = 0xFFFF00
                #text_area = label.Label(font=font, text=text, color=color, x=25, y=25)
                #circle.x0 = sparkline1.x + chart_width
                #circle.y0 = sparkline1.y + chart_height - round(scd.CO2)
                #circle.y0 = HEIGHT // 2
                circle.fill=line_color
                #text_label1d.text="CO2_PPM:"+str(round(scd.CO2))
                time.sleep(.1)
                circle.fill=WHITE

                display.auto_refresh = False
    
                sparkline1.add_value(round(scd.CO2))
                
                print(sparkline1.values())

                max_co2 = max(sparkline1.values())
                sparkline1.y_max = round(math.ceil(max_co2 / 1000.0) * 1000.0)
                sparkline1.update()
                text_label1a.text=str(sparkline1.y_top)
                text_label1c.text=str(sparkline1.y_top // 2)
                text_label1d.text="CO2_PPM: "+str(round(scd.CO2))

                #sparkline1.add_value(random.uniform(0, 1000))
                sparkline1.add_value(round(scd.CO2))
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
                print(sample_recorded_count)
                time_init=time.monotonic()
                """ 
                if(sample_recorded_count % 10 == 0):
                    fet.value = False
                    display.sleep()
                    for i in range(0,10):
                        print("co2 off, display off")
                        time.sleep(1)
                    print ("co2 on, display on")
                    fet.value = True
                    display.wake()
                    time.sleep(1)
                    scd = adafruit_scd30.SCD30(board.I2C())
                    time.sleep(3)
                """

        except Exception as e:
            print("*** Exception: " + str(e))
            exception_count += 1
            # break
