import board
import busio
from digitalio import DigitalInOut
import adafruit_requests as requests
import adafruit_esp32spi.adafruit_esp32spi_socket as socket
from adafruit_esp32spi import adafruit_esp32spi
import json
import adafruit_scd30
import time

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


# If you are using a board with pre-defined ESP32 Pins:
esp32_cs = DigitalInOut(board.D13)
esp32_ready = DigitalInOut(board.D11)
esp32_reset = DigitalInOut(board.D12)

spi = busio.SPI(board.SCK, board.MOSI, board.MISO)
esp = adafruit_esp32spi.ESP_SPIcontrol(spi, esp32_cs, esp32_ready, esp32_reset)

requests.set_socket(socket, esp)

while True:

    if scd.data_available:
            print("Data Available!")
            print("CO2: %d PPM" % scd.CO2)

            print("Connecting to AP...")
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
            print("Fetching text from", TEXT_URL)
            r = requests.get(TEXT_URL)
            print("-" * 40)
            print(r.text)
            print("-" * 40)
            r.close()

            print()
            print("Fetching json from", JSON_URL)
            r = requests.get(JSON_URL)
            print("-" * 40)
            print(r.json())
            print("-" * 40)
            r.close()

            print("Done!")

    time.sleep(2)
