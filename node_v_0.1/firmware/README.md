# co2monitor-firmware

For a specific firmware release version go here: https://gitlab.com/cversek/co2monitor-firmware/-/releases

## Gateway Setup ##

- Hardware: REV_L board!  

- Firmware & config: is all inside the `REV_L_gateway_nomesh_neopixel` folder


Loading `config.json` onto the board

1. Modify `config.json` to match your wifi, bayou pubkey + privkey, measurement interval, etc.

2. Install circuitpy: a) double tap RESET on the ItsyBitsy, which opens up ITSYBOOT;  b) drag 'adafruit-circuitpython-itsybitsy_m4_express-en_US-6.3.0.uf2' onto the ITSYBOOT drive.  c) you'll see that the drive disappears, and that CIRCUITPY drive appears instead (if it doesn't, single tap RESET)

3. Drag `config.json` onto CIRCUITPY drive


Installing firmware

1. Double tap RESET on ItsyBitsy to bring up ITSYBOOT

2. Drag-drop firmware file `REV_L_gateway_nomesh_neopixel.ino.itsybitsy_m4.uf2` onto ITSYBOOT to install firmware

3. Board should automatically reset and start running firmware; if it doesn't, tap RESET on ItsyBitsy


## Remote Node Setup ##

- Hardware: use the REV_E  Heltec boards!

- Firmware:  inside the `heltec_REV_E_remote_nomesh` folder


Loading configuration and firmware onto the board

Use Arduino IDE.  Modify `config.h` file appropriately -- you'll need to 'manually' set the 'node_id' variable for each remote node in `config.h` before compiling and loading firmware


