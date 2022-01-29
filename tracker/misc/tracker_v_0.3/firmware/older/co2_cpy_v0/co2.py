import board
import busio
from digitalio import DigitalInOut
import adafruit_requests as requests
import adafruit_esp32spi.adafruit_esp32spi_socket as socket
from adafruit_esp32spi import adafruit_esp32spi
import json
import adafruit_scd30
import time
from adafruit_bitmap_font import bitmap_font
from adafruit_display_text import label

# If you are using a board with pre-defined ESP32 Pins:
esp32_cs = DigitalInOut(board.D13)
esp32_ready = DigitalInOut(board.D11)
esp32_reset = DigitalInOut(board.D12)

scd = adafruit_scd30.SCD30(board.I2C())
# Get wifi details and more from a secrets.py file
try:
    f=open('config.json')
    config=json.load(f)
except:
    print("error!")

print("ESP32 SPI webclient test")

TEXT_URL = "http://wifitest.adafruit.com/testwifi/index.html"
JSON_URL = "http://api.coindesk.com/v1/bpi/currentprice/USD.json"




spi = busio.SPI(board.SCK, board.MOSI, board.MISO)
esp = adafruit_esp32spi.ESP_SPIcontrol(spi, esp32_cs, esp32_ready, esp32_reset)

requests.set_socket(socket, esp)

import board
import displayio
import terminalio
from adafruit_display_text import label
import adafruit_displayio_ssd1306

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
text = "PVOS.ORG\nCO2 Monitor\nREV_T"
text_area = label.Label(terminalio.FONT, text=text, color=0xFFFF00, x=20, y=15)
display.show(text_area)

time.sleep(1)

#w.timeout=20 # Set a timeout of 2.5 seconds
#w.mode = WatchDogMode.RAISE



while True:
    #w.feed()

    if scd.data_available:

            if (scd.CO2>1):
                print("Data Available!")
                print("CO2: %d PPM" % scd.CO2)

                print("Connecting to AP...")

                text = str(round(scd.CO2))
                #font = bitmap_font.load_font("/Helvetica-Bold-16.bdf")

                display.refresh()

                font = bitmap_font.load_font("/Junction-regular-24.bdf")
                #font = bitmap_font.load_font("/Helvetica-Bold-16.bdf")
                color = 0xFFFF00
                text_area = label.Label(font=font, text=text, color=color, x=25, y=25)
                display.show(text_area)


                #splash.append(text_area)

                while not esp.is_connected:
                    try:
                        esp.connect_AP(config["wifi_ssid"], config["wifi_password"])
                    except RuntimeError as e:
                        print("could not connect to AP, retrying: ", e)
                        continue
                print("Connected to", str(esp.ssid, "utf-8"), "\tRSSI:", esp.rssi)
                print("My IP address is", esp.pretty_ip(esp.ip_address))
                print(
                    "IP lookup adafruit.com: %s" % esp.pretty_ip(esp.get_host_by_name("adafruit.com"))
                )
                print("Ping google.com: %d ms" % esp.ping("google.com"))

                # esp._debug = True
                
                JSON_POST_URL = "http://bayou.pvos.org/data/kurqr92abvua"
                data = {}
                data.update({'private_key':'heqwfgxztjsf'})
                data.update({'co2_ppm':scd.CO2})
                data.update({'node_id':0})
                print("POSTing data to {0}: {1}".format(JSON_POST_URL, data))
                response = requests.post(JSON_POST_URL, data=data)
                #print("JSON Response: ", response.json())
                print("-" * 40)
                response.close()
                print("Done!")
                time.sleep(5)

    time.sleep(2)
