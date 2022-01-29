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

num_balls = 20
balls = displayio.Group() # group of balls
#vees = []  # array of velocities for each ball
for i in range(num_balls):
    fill = BLACK 
    b = Circle(display.width//2,display.height//2, 10, fill=fill, outline=0,stroke=1)
    #v = [random.randint(-3,3), random.randint(-3,3)] # random initial velocity
    #vees.append(v)
    balls.append(b)
screen.append(balls)  # add ball group to screen
while True:
    for i in range(len(balls)):
        b = balls[i] # get a ball
        v = vees[i]  # get its velocity
        b.x = int(b.x + v[0]) # update ball position
        b.y = int(b.y + v[1]) # update ball position
        # if ball hits edge, bounce it off by reflecting velocity
        if b.x <= 0 or b.x > display.width: v[0] = -v[0] + random.random()-0.5
        if b.y <= 0 or b.y > display.height: v[1] = -v[1] + random.random()-0.5
    time.sleep(0.01)


splash.append(rect)
splash.append(circle)
splash.append(line)
splash.append(text_group)
splash.append(polygon)

while True:
    i=3