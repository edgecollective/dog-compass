import board
import displayio
import digitalio
import framebufferio
import sharpdisplay
from adafruit_display_shapes.rect import Rect
from adafruit_display_shapes.circle import Circle
from adafruit_display_shapes.roundrect import RoundRect
from adafruit_display_shapes.triangle import Triangle
from adafruit_display_shapes.line import Line
from adafruit_display_shapes.polygon import Polygon
import terminalio
import vectorio

q1 = digitalio.DigitalInOut(board.D9)
q1.direction = digitalio.Direction.OUTPUT
q1.value = True

# Release the existing display, if any
displayio.release_displays()

bus = board.SPI()
chip_select_pin = board.D5
# Select JUST ONE of the following lines:
# For the 400x240 display (can only be operated at 2MHz)
#framebuffer = sharpdisplay.SharpMemoryFramebuffer(bus, chip_select_pin, 400, 240)
# For the 144x168 display (can be operated at up to 8MHz)
framebuffer = sharpdisplay.SharpMemoryFramebuffer(bus, chip_select_pin, width=144, height=168, baudrate=8000000)

display = framebufferio.FramebufferDisplay(framebuffer)
#display.rotation = 180 
from adafruit_display_text.label import Label
from terminalio import FONT
#label = Label(font=FONT, text="BLACK\nLIVES\nMATTER", x=120, y=120, scale=4, line_spacing=1.2)
#display.show(label)

splash = displayio.Group()

display.show(splash)

WHITE = 0x00FF00
BLACK = 0x0

rect = Rect(0, 0, 144, 168, fill=WHITE)

FONTSCALE = 1 
# Draw a label
text = "Distance: 2013 ft\nlat: 23.23233"
text_area = Label(terminalio.FONT, text=text, color=BLACK)
text_width = text_area.bounding_box[2] * FONTSCALE
text_group = displayio.Group(
    scale=FONTSCALE,
    x=display.width // 2 - text_width // 2,
    y=display.height // 2,
)
text_group.append(text_area)  # Subgroup for text scaling

cx = display.width // 2
cy = display.width // 4
r = 30
circle = Circle(cx, cy, r, fill=WHITE, outline=BLACK)

line = Line(cx, cy, cx, cy + r, BLACK)

palette = displayio.Palette(1)
palette[0] = 0x125690

points=[(5, 5), (100, 20), (20, 20), (20, 100)]
polygon = vectorio.Polygon(pixel_shader=palette, points=points, x=0, y=0)

splash.append(rect)
splash.append(circle)
splash.append(line)
splash.append(text_group)
splash.append(polygon)

while True:
    i=3