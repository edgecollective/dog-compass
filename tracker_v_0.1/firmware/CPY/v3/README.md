# Bluetooth plotter

use plotter.py w/ bluefruit app (using nordic)

use livelog_flash.py to log to CPY flash (note: still currently requires the microsd featherwing w/ RTC)

use livelog_sd.py to log to microsd (requires featherwing with microsd + RTC)

boot.py is set up so that on hard reboot, if A0 is held to ground (connect wire), CPY can write to flash (but external computer can't write to CPY flash).  so typical sequence is to boot up with A0 high, copy new code that is intended to log to flash (e.g. livelog_flash.py above), and then hard reboot with A0 connected to ground to allow logger code to write to flash. See notes [here](https://learn.adafruit.com/circuitpython-essentials/circuitpython-storage) 




