EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "PVOS CO2 Monitor"
Date ""
Rev "V"
Comp ""
Comment1 "http://pvos.org/co2/rev_v"
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Device:R R1
U 1 1 5F989DB1
P 975 6200
F 0 "R1" H 1045 6246 50  0000 L CNN
F 1 "4.7K" H 1045 6155 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0309_L9.0mm_D3.2mm_P12.70mm_Horizontal" V 905 6200 50  0001 C CNN
F 3 "~" H 975 6200 50  0001 C CNN
	1    975  6200
	1    0    0    -1  
$EndComp
Text GLabel 1350 6375 0    50   Input ~ 0
SCL
$Comp
L power:+3V3 #PWR01
U 1 1 5F98B87C
P 975 6050
F 0 "#PWR01" H 975 5900 50  0001 C CNN
F 1 "+3V3" H 990 6223 50  0000 C CNN
F 2 "" H 975 6050 50  0001 C CNN
F 3 "" H 975 6050 50  0001 C CNN
	1    975  6050
	1    0    0    -1  
$EndComp
$Comp
L Device:R R2
U 1 1 5F98BC9A
P 1350 6225
F 0 "R2" H 1420 6271 50  0000 L CNN
F 1 "4.7K" H 1420 6180 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0309_L9.0mm_D3.2mm_P12.70mm_Horizontal" V 1280 6225 50  0001 C CNN
F 3 "~" H 1350 6225 50  0001 C CNN
	1    1350 6225
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR03
U 1 1 5F98C06B
P 1350 6075
F 0 "#PWR03" H 1350 5925 50  0001 C CNN
F 1 "+3V3" H 1365 6248 50  0000 C CNN
F 2 "" H 1350 6075 50  0001 C CNN
F 3 "" H 1350 6075 50  0001 C CNN
	1    1350 6075
	1    0    0    -1  
$EndComp
Text GLabel 975  6350 0    50   Input ~ 0
SDA
Text Notes 850  5675 0    79   ~ 0
i2c pullups
$Comp
L Device:R R3
U 1 1 6028DEF2
P 5450 6925
F 0 "R3" H 5520 6971 50  0000 L CNN
F 1 "4.7K" H 5520 6880 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0309_L9.0mm_D3.2mm_P12.70mm_Horizontal" V 5380 6925 50  0001 C CNN
F 3 "~" H 5450 6925 50  0001 C CNN
	1    5450 6925
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR011
U 1 1 6028E7B5
P 5425 5700
F 0 "#PWR011" H 5425 5550 50  0001 C CNN
F 1 "+3V3" H 5440 5873 50  0000 C CNN
F 2 "" H 5425 5700 50  0001 C CNN
F 3 "" H 5425 5700 50  0001 C CNN
	1    5425 5700
	1    0    0    -1  
$EndComp
Text Notes 5525 5450 0    79   ~ 0
BUTTON A
$Comp
L power:GND #PWR010
U 1 1 601B48F9
P 3600 6625
F 0 "#PWR010" H 3600 6375 50  0001 C CNN
F 1 "GND" H 3605 6452 50  0000 C CNN
F 2 "" H 3600 6625 50  0001 C CNN
F 3 "" H 3600 6625 50  0001 C CNN
	1    3600 6625
	0    1    1    0   
$EndComp
Text Notes 3050 5675 0    79   ~ 0
POWER
$Comp
L Connector:Barrel_Jack_MountingPin J7
U 1 1 607F42DF
P 3900 6725
F 0 "J7" H 3670 6597 50  0000 R CNN
F 1 "Barrel_Jack_MountingPin" V 3475 6850 50  0000 R CNN
F 2 "Connector_BarrelJack:BarrelJack_Horizontal" H 3950 6685 50  0001 C CNN
F 3 "~" H 3950 6685 50  0001 C CNN
	1    3900 6725
	-1   0    0    1   
$EndComp
Wire Wire Line
	3600 6425 3600 6625
Wire Wire Line
	3600 6425 3900 6425
Connection ~ 3600 6625
$Comp
L Adafruit_AirLift_FeatherWing-eagle-import:GND #GND01
U 1 1 60D7FC5C
P 3275 7475
F 0 "#GND01" H 3275 7475 50  0001 C CNN
F 1 "GND" H 3275 7354 59  0000 C CNN
F 2 "" H 3275 7475 50  0001 C CNN
F 3 "" H 3275 7475 50  0001 C CNN
	1    3275 7475
	1    0    0    -1  
$EndComp
$Comp
L Connector:Screw_Terminal_01x02 J8
U 1 1 60D7B882
P 4000 7475
F 0 "J8" H 3918 7150 50  0000 C CNN
F 1 "Screw_Terminal_01x02" H 3918 7241 50  0000 C CNN
F 2 "TerminalBlock_Phoenix:TerminalBlock_Phoenix_PT-1,5-2-5.0-H_1x02_P5.00mm_Horizontal" H 4000 7475 50  0001 C CNN
F 3 "~" H 4000 7475 50  0001 C CNN
	1    4000 7475
	1    0    0    1   
$EndComp
$Comp
L power:GND #PWR017
U 1 1 60F802F8
P 6625 4550
F 0 "#PWR017" H 6625 4300 50  0001 C CNN
F 1 "GND" H 6630 4377 50  0000 C CNN
F 2 "" H 6625 4550 50  0001 C CNN
F 3 "" H 6625 4550 50  0001 C CNN
	1    6625 4550
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR018
U 1 1 60F802FE
P 6850 4650
F 0 "#PWR018" H 6850 4500 50  0001 C CNN
F 1 "+3V3" H 6865 4823 50  0000 C CNN
F 2 "" H 6850 4650 50  0001 C CNN
F 3 "" H 6850 4650 50  0001 C CNN
	1    6850 4650
	1    0    0    -1  
$EndComp
Text GLabel 7025 4750 0    50   Input ~ 0
SDA
Text GLabel 7025 4850 0    50   Input ~ 0
SCL
Wire Wire Line
	7025 4550 6625 4550
Wire Wire Line
	7025 4650 6850 4650
$Comp
L Connector:Conn_01x04_Female J12
U 1 1 60F80308
P 7225 4650
F 0 "J12" H 7253 4626 50  0000 L CNN
F 1 "Conn_01x04_Female" V 7400 4200 50  0000 L CNN
F 2 "Connector_JST:JST_SH_SM04B-SRSS-TB_1x04-1MP_P1.00mm_Horizontal" H 7225 4650 50  0001 C CNN
F 3 "~" H 7225 4650 50  0001 C CNN
	1    7225 4650
	1    0    0    -1  
$EndComp
Text Notes 6400 4300 0    79   ~ 0
QWIIC
$Comp
L Device:R R4
U 1 1 60FBA6C0
P 5425 5850
F 0 "R4" H 5495 5896 50  0000 L CNN
F 1 "4.7K" H 5495 5805 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0309_L9.0mm_D3.2mm_P12.70mm_Horizontal" V 5355 5850 50  0001 C CNN
F 3 "~" H 5425 5850 50  0001 C CNN
	1    5425 5850
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR013
U 1 1 60FBA6C6
P 5450 6775
F 0 "#PWR013" H 5450 6625 50  0001 C CNN
F 1 "+3V3" H 5465 6948 50  0000 C CNN
F 2 "" H 5450 6775 50  0001 C CNN
F 3 "" H 5450 6775 50  0001 C CNN
	1    5450 6775
	1    0    0    -1  
$EndComp
Text Notes 5550 6525 0    79   ~ 0
BUTTON B
$Comp
L Connector:Conn_01x03_Female J4
U 1 1 61020F33
P 2400 6675
F 0 "J4" H 2428 6701 50  0000 L CNN
F 1 "Conn_01x03_Female" H 2428 6610 50  0000 L CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x03_P2.54mm_Vertical" H 2400 6675 50  0001 C CNN
F 3 "~" H 2400 6675 50  0001 C CNN
	1    2400 6675
	1    0    0    -1  
$EndComp
Text Notes 2100 6375 0    79   ~ 0
5V DC-DC
$Comp
L device:C C2
U 1 1 61051461
P 2500 7225
F 0 "C2" H 2385 7179 50  0000 R CNN
F 1 "22uF" H 2385 7270 50  0000 R CNN
F 2 "Capacitor_THT:CP_Radial_D5.0mm_P2.50mm" H 2538 7075 50  0001 C CNN
F 3 "" H 2500 7225 50  0001 C CNN
	1    2500 7225
	1    0    0    -1  
$EndComp
Text GLabel 2200 6775 0    50   UnSpc ~ 0
VOUT_DCDC
$Comp
L power:GND #PWR04
U 1 1 6106310F
P 1650 6675
F 0 "#PWR04" H 1650 6425 50  0001 C CNN
F 1 "GND" H 1655 6502 50  0000 C CNN
F 2 "" H 1650 6675 50  0001 C CNN
F 3 "" H 1650 6675 50  0001 C CNN
	1    1650 6675
	1    0    0    -1  
$EndComp
Wire Wire Line
	2200 6675 1650 6675
$Comp
L power:GND #PWR05
U 1 1 61125937
P 2000 7375
F 0 "#PWR05" H 2000 7125 50  0001 C CNN
F 1 "GND" H 2005 7202 50  0000 C CNN
F 2 "" H 2000 7375 50  0001 C CNN
F 3 "" H 2000 7375 50  0001 C CNN
	1    2000 7375
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR06
U 1 1 611261CE
P 2500 7375
F 0 "#PWR06" H 2500 7125 50  0001 C CNN
F 1 "GND" H 2505 7202 50  0000 C CNN
F 2 "" H 2500 7375 50  0001 C CNN
F 3 "" H 2500 7375 50  0001 C CNN
	1    2500 7375
	1    0    0    -1  
$EndComp
Text GLabel 2000 7075 0    50   Input ~ 0
VIN_DCDC
Text GLabel 2500 7075 2    50   UnSpc ~ 0
VOUT_DCDC
$Comp
L Device:D D1
U 1 1 60F73E0C
P 3250 5975
F 0 "D1" H 3250 5758 50  0000 C CNN
F 1 "D" H 3250 5849 50  0000 C CNN
F 2 "Diode_THT:D_5W_P12.70mm_Horizontal" H 3250 5975 50  0001 C CNN
F 3 "~" H 3250 5975 50  0001 C CNN
	1    3250 5975
	-1   0    0    1   
$EndComp
Text GLabel 2200 6575 0    50   Input ~ 0
VIN_DCDC
Text GLabel 3600 6825 0    50   Input ~ 0
VIN_DCDC
Text GLabel 3100 5975 0    50   UnSpc ~ 0
VOUT_DCDC
$Comp
L Connector:Conn_01x12_Female J9
U 1 1 612D6942
P 4125 2375
F 0 "J9" H 4153 2351 50  0000 L CNN
F 1 "Conn_01x12_Female" V 4225 1475 50  0000 L CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x12_P2.54mm_Vertical" H 4125 2375 50  0001 C CNN
F 3 "~" H 4125 2375 50  0001 C CNN
	1    4125 2375
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x16_Female J10
U 1 1 612D6948
P 4575 2700
F 0 "J10" H 4603 2676 50  0000 L CNN
F 1 "Conn_01x16_Female" V 4675 1775 50  0000 L CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x16_P2.54mm_Vertical" H 4575 2700 50  0001 C CNN
F 3 "~" H 4575 2700 50  0001 C CNN
	1    4575 2700
	-1   0    0    1   
$EndComp
Text Notes 3850 1725 0    79   ~ 0
Airlift Featherwing
$Comp
L Connector:Conn_01x02_Female J1
U 1 1 612A5BF6
P 1475 5050
F 0 "J1" H 1503 5026 50  0000 L CNN
F 1 "Conn_01x02_Female" H 1503 4935 50  0000 L CNN
F 2 "Connector_JST:JST_PH_S2B-PH-K_1x02_P2.00mm_Horizontal" H 1475 5050 50  0001 C CNN
F 3 "~" H 1475 5050 50  0001 C CNN
	1    1475 5050
	1    0    0    -1  
$EndComp
Text Notes 1125 4900 0    79   ~ 0
JST VBat Lithium Ion
$Comp
L Switch:SW_Push SW1
U 1 1 612C3561
P 5900 6000
F 0 "SW1" H 5900 6285 50  0000 C CNN
F 1 "SW_Push" H 5900 6194 50  0000 C CNN
F 2 "Button_Switch_THT:SW_Tactile_SPST_Angled_PTS645Vx58-2LFS" H 5900 6200 50  0001 C CNN
F 3 "~" H 5900 6200 50  0001 C CNN
	1    5900 6000
	1    0    0    -1  
$EndComp
Wire Wire Line
	5425 6000 5700 6000
$Comp
L power:GND #PWR015
U 1 1 612C4DF2
P 6100 6000
F 0 "#PWR015" H 6100 5750 50  0001 C CNN
F 1 "GND" H 6105 5827 50  0000 C CNN
F 2 "" H 6100 6000 50  0001 C CNN
F 3 "" H 6100 6000 50  0001 C CNN
	1    6100 6000
	1    0    0    -1  
$EndComp
$Comp
L Switch:SW_Push SW2
U 1 1 612CCB02
P 5900 7075
F 0 "SW2" H 5900 7360 50  0000 C CNN
F 1 "SW_Push" H 5900 7269 50  0000 C CNN
F 2 "Button_Switch_THT:SW_Tactile_SPST_Angled_PTS645Vx58-2LFS" H 5900 7275 50  0001 C CNN
F 3 "~" H 5900 7275 50  0001 C CNN
	1    5900 7075
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR016
U 1 1 612CCB08
P 6100 7075
F 0 "#PWR016" H 6100 6825 50  0001 C CNN
F 1 "GND" H 6105 6902 50  0000 C CNN
F 2 "" H 6100 7075 50  0001 C CNN
F 3 "" H 6100 7075 50  0001 C CNN
	1    6100 7075
	1    0    0    -1  
$EndComp
Wire Wire Line
	5700 7075 5450 7075
Text GLabel 3925 1875 0    50   Input ~ 0
VBAT
Text GLabel 3925 1975 0    50   Input ~ 0
EN
Text GLabel 3925 2075 0    50   Input ~ 0
VBUS
Text GLabel 3925 2175 0    50   Input ~ 0
D13
Text GLabel 3925 2275 0    50   Input ~ 0
D12
Text GLabel 3925 2375 0    50   Input ~ 0
D11
Text GLabel 3925 2475 0    50   Input ~ 0
D10
Text GLabel 3925 2575 0    50   Input ~ 0
D9
Text GLabel 3925 2875 0    50   Input ~ 0
SCL
Text GLabel 3925 2975 0    50   Input ~ 0
SDA
Text GLabel 4775 3300 2    50   Input ~ 0
TX_D1
Text GLabel 4775 3200 2    50   Input ~ 0
RX_D0
Text GLabel 4775 3100 2    50   Input ~ 0
MISO
Text GLabel 4775 3000 2    50   Input ~ 0
MOSI
Text GLabel 4775 2900 2    50   Input ~ 0
SCK
Text GLabel 4775 2800 2    50   Input ~ 0
A5
Text GLabel 4775 2700 2    50   Input ~ 0
A4
Text GLabel 4775 2600 2    50   Input ~ 0
A3
Text GLabel 4775 2500 2    50   Input ~ 0
A2
Text GLabel 4775 2400 2    50   Input ~ 0
A1
Text GLabel 4775 2300 2    50   Input ~ 0
A0
Text GLabel 4775 1900 2    50   Input ~ 0
~RESET
Text GLabel 4775 2100 2    50   Input ~ 0
AREF
$Comp
L power:GND #PWR012
U 1 1 61347A41
P 5075 2200
F 0 "#PWR012" H 5075 1950 50  0001 C CNN
F 1 "GND" H 5080 2027 50  0000 C CNN
F 2 "" H 5075 2200 50  0001 C CNN
F 3 "" H 5075 2200 50  0001 C CNN
	1    5075 2200
	1    0    0    -1  
$EndComp
Wire Wire Line
	4775 2200 5075 2200
$Comp
L power:+3V3 #PWR014
U 1 1 61347A48
P 5150 2000
F 0 "#PWR014" H 5150 1850 50  0001 C CNN
F 1 "+3V3" V 5165 2128 50  0000 L CNN
F 2 "" H 5150 2000 50  0001 C CNN
F 3 "" H 5150 2000 50  0001 C CNN
	1    5150 2000
	1    0    0    -1  
$EndComp
Wire Wire Line
	4775 2000 5150 2000
Text GLabel 5200 7075 0    50   Input ~ 0
A5
Text GLabel 5275 6000 0    50   Input ~ 0
A4
$Comp
L Connector:Conn_01x03_Female J5
U 1 1 614DA351
P 4700 4125
F 0 "J5" H 4728 4151 50  0000 L CNN
F 1 "Conn_01x03_Female" H 4728 4060 50  0000 L CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x03_P2.54mm_Vertical" H 4700 4125 50  0001 C CNN
F 3 "~" H 4700 4125 50  0001 C CNN
	1    4700 4125
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR09
U 1 1 614DCC4C
P 4500 4025
F 0 "#PWR09" H 4500 3775 50  0001 C CNN
F 1 "GND" H 4505 3852 50  0000 C CNN
F 2 "" H 4500 4025 50  0001 C CNN
F 3 "" H 4500 4025 50  0001 C CNN
	1    4500 4025
	0    1    1    0   
$EndComp
Text GLabel 4500 4225 0    50   Input ~ 0
VBAT_EXT
Text GLabel 4500 4125 0    50   Input ~ 0
VBAT
Text Notes 4350 3875 0    79   ~ 0
BATT ON/OFF
$Comp
L power:GND #PWR021
U 1 1 614FA1BB
P 8200 3700
F 0 "#PWR021" H 8200 3450 50  0001 C CNN
F 1 "GND" H 8205 3527 50  0000 C CNN
F 2 "" H 8200 3700 50  0001 C CNN
F 3 "" H 8200 3700 50  0001 C CNN
	1    8200 3700
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR022
U 1 1 614FA1C1
P 8425 3800
F 0 "#PWR022" H 8425 3650 50  0001 C CNN
F 1 "+3V3" H 8440 3973 50  0000 C CNN
F 2 "" H 8425 3800 50  0001 C CNN
F 3 "" H 8425 3800 50  0001 C CNN
	1    8425 3800
	1    0    0    -1  
$EndComp
Text GLabel 8600 4000 0    50   Input ~ 0
SDA
Text GLabel 8600 3900 0    50   Input ~ 0
SCL
Wire Wire Line
	8600 3700 8200 3700
Wire Wire Line
	8600 3800 8425 3800
$Comp
L Connector:Conn_01x04_Female J16
U 1 1 614FA1CB
P 8800 3800
F 0 "J16" H 8828 3776 50  0000 L CNN
F 1 "Conn_01x04_Female" V 8975 3350 50  0000 L CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x04_P2.54mm_Vertical" H 8800 3800 50  0001 C CNN
F 3 "~" H 8800 3800 50  0001 C CNN
	1    8800 3800
	1    0    0    -1  
$EndComp
Text Notes 7975 3450 0    79   ~ 0
QWIIC
$Comp
L Mechanical:MountingHole_Pad H1
U 1 1 614A1FDA
P 7075 5825
F 0 "H1" H 7175 5874 50  0000 L CNN
F 1 "MountingHole_Pad" H 7175 5783 50  0000 L CNN
F 2 "MountingHole:MountingHole_2.7mm_M2.5_Pad" H 7075 5825 50  0001 C CNN
F 3 "~" H 7075 5825 50  0001 C CNN
	1    7075 5825
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole_Pad H2
U 1 1 614A5606
P 7325 6150
F 0 "H2" H 7425 6199 50  0000 L CNN
F 1 "MountingHole_Pad" H 7425 6108 50  0000 L CNN
F 2 "MountingHole:MountingHole_2.7mm_M2.5_Pad" H 7325 6150 50  0001 C CNN
F 3 "~" H 7325 6150 50  0001 C CNN
	1    7325 6150
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole_Pad H5
U 1 1 614E3462
P 9725 5800
F 0 "H5" H 9825 5849 50  0000 L CNN
F 1 "MountingHole_Pad" H 9825 5758 50  0000 L CNN
F 2 "MountingHole:MountingHole_2.7mm_M2.5_Pad" H 9725 5800 50  0001 C CNN
F 3 "~" H 9725 5800 50  0001 C CNN
	1    9725 5800
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole_Pad H6
U 1 1 614E3468
P 9725 6150
F 0 "H6" H 9825 6199 50  0000 L CNN
F 1 "MountingHole_Pad" H 9825 6108 50  0000 L CNN
F 2 "MountingHole:MountingHole_2.7mm_M2.5_Pad" H 9725 6150 50  0001 C CNN
F 3 "~" H 9725 6150 50  0001 C CNN
	1    9725 6150
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0105
U 1 1 615C33CE
P 7075 5925
F 0 "#PWR0105" H 7075 5675 50  0001 C CNN
F 1 "GND" H 7080 5752 50  0000 C CNN
F 2 "" H 7075 5925 50  0001 C CNN
F 3 "" H 7075 5925 50  0001 C CNN
	1    7075 5925
	0    1    1    0   
$EndComp
$Comp
L power:+3V3 #PWR0106
U 1 1 615C451F
P 7325 6250
F 0 "#PWR0106" H 7325 6100 50  0001 C CNN
F 1 "+3V3" H 7340 6423 50  0000 C CNN
F 2 "" H 7325 6250 50  0001 C CNN
F 3 "" H 7325 6250 50  0001 C CNN
	1    7325 6250
	0    -1   -1   0   
$EndComp
Text GLabel 9725 6250 0    50   Input ~ 0
SCL
Text GLabel 9725 5900 0    50   Input ~ 0
SDA
$Comp
L device:C C1
U 1 1 610277F2
P 2000 7225
F 0 "C1" H 1885 7179 50  0000 R CNN
F 1 "10uF" H 1885 7270 50  0000 R CNN
F 2 "Capacitor_THT:CP_Radial_D5.0mm_P2.50mm" H 2038 7075 50  0001 C CNN
F 3 "" H 2000 7225 50  0001 C CNN
	1    2000 7225
	1    0    0    -1  
$EndComp
Text Notes 8175 1375 0    79   ~ 0
'Air baffle' headers for SCD30
$Comp
L power:GND #PWR0107
U 1 1 6193871C
P 2375 4375
F 0 "#PWR0107" H 2375 4125 50  0001 C CNN
F 1 "GND" H 2380 4202 50  0000 C CNN
F 2 "" H 2375 4375 50  0001 C CNN
F 3 "" H 2375 4375 50  0001 C CNN
	1    2375 4375
	1    0    0    -1  
$EndComp
$Comp
L Device:R R5
U 1 1 6193A6F6
P 2375 4225
F 0 "R5" H 2445 4271 50  0000 L CNN
F 1 "R" H 2445 4180 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0309_L9.0mm_D3.2mm_P12.70mm_Horizontal" V 2305 4225 50  0001 C CNN
F 3 "~" H 2375 4225 50  0001 C CNN
	1    2375 4225
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x03_Female J19
U 1 1 61938716
P 2900 4075
F 0 "J19" H 2928 4101 50  0000 L CNN
F 1 "Conn_01x03_Female" H 2928 4010 50  0000 L CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x03_P2.54mm_Vertical" H 2900 4075 50  0001 C CNN
F 3 "~" H 2900 4075 50  0001 C CNN
	1    2900 4075
	1    0    0    -1  
$EndComp
Text Notes 2550 3825 0    79   ~ 0
Write Permit\n
Text GLabel 3925 2675 0    50   Input ~ 0
D6
Text GLabel 3925 2775 0    50   Input ~ 0
D5
Text GLabel 2700 4175 0    50   Input ~ 0
A3
Text Notes -3050 100  0    79   ~ 0
Adafruit Sharp
$Comp
L Switch:SW_Push_Dual SW4
U 1 1 61BD3A38
P 6475 3325
F 0 "SW4" H 6475 3610 50  0000 C CNN
F 1 "SW_Push_Dual" H 6475 3519 50  0000 C CNN
F 2 "Button_Switch_THT:SW_TH_Tactile_Omron_B3F-10xx" H 6475 3525 50  0001 C CNN
F 3 "~" H 6475 3525 50  0001 C CNN
	1    6475 3325
	1    0    0    -1  
$EndComp
Wire Wire Line
	6275 3325 6000 3325
Wire Wire Line
	6000 3325 6000 3025
Text GLabel 6000 3025 0    50   Input ~ 0
~RESET
Wire Wire Line
	6275 3325 6275 3200
Wire Wire Line
	6275 3200 6675 3200
Wire Wire Line
	6675 3200 6675 3325
Connection ~ 6275 3325
Wire Wire Line
	6675 3525 6675 3400
Wire Wire Line
	6675 3400 6275 3400
Wire Wire Line
	6275 3400 6275 3525
Wire Wire Line
	6675 3525 6675 3650
Connection ~ 6675 3525
$Comp
L Adafruit_AirLift_FeatherWing-eagle-import:GND #GND0101
U 1 1 61BE19AA
P 6675 3750
F 0 "#GND0101" H 6675 3750 50  0001 C CNN
F 1 "GND" H 6675 3629 59  0000 C CNN
F 2 "" H 6675 3750 50  0001 C CNN
F 3 "" H 6675 3750 50  0001 C CNN
	1    6675 3750
	1    0    0    -1  
$EndComp
Text Notes 6050 2875 0    79   ~ 0
EXT RESET
$Comp
L power:GND #PWR02
U 1 1 6140B58B
P 1275 5150
F 0 "#PWR02" H 1275 4900 50  0001 C CNN
F 1 "GND" H 1280 4977 50  0000 C CNN
F 2 "" H 1275 5150 50  0001 C CNN
F 3 "" H 1275 5150 50  0001 C CNN
	1    1275 5150
	1    0    0    -1  
$EndComp
Text GLabel 3400 5975 2    50   Input ~ 0
VBUS
Text GLabel 1275 5050 0    50   Input ~ 0
VBAT
$Comp
L Connector:Conn_01x12_Female J2
U 1 1 61C48A19
P -1275 2525
F 0 "J2" H -1247 2501 50  0000 L CNN
F 1 "Conn_01x12_Female" V -1175 1625 50  0000 L CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x12_P2.54mm_Vertical" H -1275 2525 50  0001 C CNN
F 3 "~" H -1275 2525 50  0001 C CNN
	1    -1275 2525
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x16_Female J3
U 1 1 61C48A23
P -825 2850
F 0 "J3" H -797 2826 50  0000 L CNN
F 1 "Conn_01x16_Female" V -725 1925 50  0000 L CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x16_P2.54mm_Vertical" H -825 2850 50  0001 C CNN
F 3 "~" H -825 2850 50  0001 C CNN
	1    -825 2850
	-1   0    0    1   
$EndComp
Text Notes -1575 1625 0    79   ~ 0
Feather
Text GLabel -1475 2025 0    50   Input ~ 0
VBAT
Text GLabel -1475 2125 0    50   Input ~ 0
EN
Text GLabel -1475 2225 0    50   Input ~ 0
VBUS
Text GLabel -1475 2325 0    50   Input ~ 0
D13
Text GLabel -1475 2425 0    50   Input ~ 0
D12
Text GLabel -1475 2525 0    50   Input ~ 0
D11
Text GLabel -1475 2625 0    50   Input ~ 0
D10
Text GLabel -1475 2725 0    50   Input ~ 0
D9
Text GLabel -1475 3025 0    50   Input ~ 0
SCL
Text GLabel -1475 3125 0    50   Input ~ 0
SDA
Text GLabel -625 3450 2    50   Input ~ 0
TX_D1
Text GLabel -625 3350 2    50   Input ~ 0
RX_D0
Text GLabel -625 3250 2    50   Input ~ 0
MISO
Text GLabel -625 3150 2    50   Input ~ 0
MOSI
Text GLabel -625 3050 2    50   Input ~ 0
SCK
Text GLabel -625 2950 2    50   Input ~ 0
A5
Text GLabel -625 2850 2    50   Input ~ 0
A4
Text GLabel -625 2750 2    50   Input ~ 0
A3
Text GLabel -625 2650 2    50   Input ~ 0
A2
Text GLabel -625 2550 2    50   Input ~ 0
A1
Text GLabel -625 2450 2    50   Input ~ 0
A0
Text GLabel -625 2050 2    50   Input ~ 0
~RESET
Text GLabel -625 2250 2    50   Input ~ 0
AREF
$Comp
L power:GND #PWR0109
U 1 1 61C48A46
P -325 2350
F 0 "#PWR0109" H -325 2100 50  0001 C CNN
F 1 "GND" H -320 2177 50  0000 C CNN
F 2 "" H -325 2350 50  0001 C CNN
F 3 "" H -325 2350 50  0001 C CNN
	1    -325 2350
	1    0    0    -1  
$EndComp
Wire Wire Line
	-625 2350 -325 2350
$Comp
L power:+3V3 #PWR0110
U 1 1 61C48A51
P -250 2150
F 0 "#PWR0110" H -250 2000 50  0001 C CNN
F 1 "+3V3" V -235 2278 50  0000 L CNN
F 2 "" H -250 2150 50  0001 C CNN
F 3 "" H -250 2150 50  0001 C CNN
	1    -250 2150
	1    0    0    -1  
$EndComp
Wire Wire Line
	-625 2150 -250 2150
Text GLabel -1475 2825 0    50   Input ~ 0
D6
Text GLabel -1475 2925 0    50   Input ~ 0
D5
Text Notes -2475 2925 0    39   ~ 0
pin 9 was D7; is now D6\npin 10 was D5; is now D2
$Comp
L Connector:Conn_01x10_Female J11
U 1 1 61D127B7
P 9325 2150
F 0 "J11" H 9353 2126 50  0000 L CNN
F 1 "Conn_01x10_Female" H 9353 2035 50  0000 L CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x10_P2.54mm_Vertical" H 9325 2150 50  0001 C CNN
F 3 "~" H 9325 2150 50  0001 C CNN
	1    9325 2150
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x08_Female J14
U 1 1 61D1F30A
P -950 600
F 0 "J14" H -922 576 50  0000 L CNN
F 1 "Conn_01x08_Female" H -922 485 50  0000 L CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x08_P2.54mm_Vertical" H -950 600 50  0001 C CNN
F 3 "~" H -950 600 50  0001 C CNN
	1    -950 600 
	1    0    0    -1  
$EndComp
Text Notes -1650 150  0    79   ~ 0
Adafruit 128x128
$Comp
L Device:Q_NMOS_GDS Q1
U 1 1 61C12A63
P 1550 3850
F 0 "Q1" H 1754 3896 50  0000 L CNN
F 1 "Q_NMOS_GDS" H 1754 3805 50  0000 L CNN
F 2 "Package_TO_SOT_THT:TO-220-3_Vertical" H 1750 3950 50  0001 C CNN
F 3 "~" H 1550 3850 50  0001 C CNN
	1    1550 3850
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x09_Female J15
U 1 1 61C52AE8
P -2925 675
F 0 "J15" V -2760 655 50  0000 C CNN
F 1 "Conn_01x09_Female" V -2851 655 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x09_P2.54mm_Vertical" H -2925 675 50  0001 C CNN
F 3 "~" H -2925 675 50  0001 C CNN
	1    -2925 675 
	1    0    0    -1  
$EndComp
Text GLabel -3125 575  0    50   Input ~ 0
SCK
Text GLabel -3125 875  0    50   Input ~ 0
EMD
Text GLabel -3125 975  0    50   Input ~ 0
DISP
Text GLabel -3125 1075 0    50   Input ~ 0
EIN
Text GLabel -1150 300  0    50   Input ~ 0
MOSI
Text GLabel -1150 400  0    50   Input ~ 0
SCK
Text GLabel -1150 600  0    50   Input ~ 0
A2
Text GLabel -1150 700  0    50   Input ~ 0
D5
$Comp
L Device:R R6
U 1 1 61C43F0B
P 1350 4000
F 0 "R6" H 1420 4046 50  0000 L CNN
F 1 "10K" H 1420 3955 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0309_L9.0mm_D3.2mm_P12.70mm_Horizontal" V 1280 4000 50  0001 C CNN
F 3 "~" H 1350 4000 50  0001 C CNN
	1    1350 4000
	1    0    0    -1  
$EndComp
Text Notes 2850 2375 0    39   ~ 0
by default, D13, D12, D11, \nand D10 are all used by \nesp32 featherwing
Text GLabel 1125 3850 0    50   Input ~ 0
D9
Text Notes 9025 4825 0    79   ~ 0
QWIIC
$Comp
L Connector:Conn_01x04_Female J20
U 1 1 61C7347D
P 9850 5175
F 0 "J20" H 9878 5151 50  0000 L CNN
F 1 "Conn_01x04_Female" V 10025 4725 50  0000 L CNN
F 2 "Connector_JST:JST_SH_SM04B-SRSS-TB_1x04-1MP_P1.00mm_Horizontal" H 9850 5175 50  0001 C CNN
F 3 "~" H 9850 5175 50  0001 C CNN
	1    9850 5175
	1    0    0    -1  
$EndComp
Wire Wire Line
	9650 5175 9475 5175
Wire Wire Line
	9650 5075 9250 5075
Text GLabel 9650 5375 0    50   Input ~ 0
SCL
Text GLabel 9650 5275 0    50   Input ~ 0
SDA
$Comp
L power:+3V3 #PWR0112
U 1 1 61C7348B
P 9475 5175
F 0 "#PWR0112" H 9475 5025 50  0001 C CNN
F 1 "+3V3" H 9490 5348 50  0000 C CNN
F 2 "" H 9475 5175 50  0001 C CNN
F 3 "" H 9475 5175 50  0001 C CNN
	1    9475 5175
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0113
U 1 1 61C73495
P 9250 5075
F 0 "#PWR0113" H 9250 4825 50  0001 C CNN
F 1 "GND" H 9255 4902 50  0000 C CNN
F 2 "" H 9250 5075 50  0001 C CNN
F 3 "" H 9250 5075 50  0001 C CNN
	1    9250 5075
	1    0    0    -1  
$EndComp
Text GLabel 4775 3400 2    50   Input ~ 0
DW
Text GLabel -625 3550 2    50   Input ~ 0
DW
$Comp
L power:GND #PWR0111
U 1 1 61D01D59
P 9125 2450
F 0 "#PWR0111" H 9125 2200 50  0001 C CNN
F 1 "GND" H 9130 2277 50  0000 C CNN
F 2 "" H 9125 2450 50  0001 C CNN
F 3 "" H 9125 2450 50  0001 C CNN
	1    9125 2450
	0    1    1    0   
$EndComp
Text GLabel 9125 2550 0    50   Input ~ 0
RX_D0
Text GLabel 9125 2650 0    50   Input ~ 0
TX_D1
$Comp
L power:GND #PWR0103
U 1 1 61CB8180
P 1350 4150
F 0 "#PWR0103" H 1350 3900 50  0001 C CNN
F 1 "GND" H 1355 3977 50  0000 C CNN
F 2 "" H 1350 4150 50  0001 C CNN
F 3 "" H 1350 4150 50  0001 C CNN
	1    1350 4150
	1    0    0    -1  
$EndComp
Wire Wire Line
	1350 4150 1650 4150
Wire Wire Line
	1650 4150 1650 4050
Connection ~ 1350 4150
Text GLabel 1650 3650 0    50   Input ~ 0
POWER_1
Wire Wire Line
	1350 3850 1125 3850
Connection ~ 1350 3850
Text GLabel 8825 2350 0    50   Input ~ 0
POWER_1
Text GLabel -1600 1000 0    50   Input ~ 0
POWER_2
Text GLabel -1150 500  0    50   Input ~ 0
A1
Text GLabel -3125 775  0    50   Input ~ 0
D5
Text GLabel -3125 675  0    50   Input ~ 0
MOSI
Text GLabel 3800 7475 0    50   Input ~ 0
VIN_DCDC
Wire Wire Line
	3800 7375 3275 7375
Text GLabel 9125 2250 0    50   Input ~ 0
SCL
Text GLabel 9125 2150 0    50   Input ~ 0
SDA
$Comp
L power:+3V3 #PWR0108
U 1 1 61E3312F
P 8925 2050
F 0 "#PWR0108" H 8925 1900 50  0001 C CNN
F 1 "+3V3" H 8940 2223 50  0000 C CNN
F 2 "" H 8925 2050 50  0001 C CNN
F 3 "" H 8925 2050 50  0001 C CNN
	1    8925 2050
	1    0    0    -1  
$EndComp
Wire Wire Line
	9125 2050 8925 2050
$Comp
L Device:Jumper_NO_Small JP3
U 1 1 61E5B905
P -925 4275
F 0 "JP3" H -925 4460 50  0000 C CNN
F 1 "Jumper_NO_Small" H -925 4369 50  0000 C CNN
F 2 "Jumper:SolderJumper-2_P1.3mm_Open_Pad1.0x1.5mm" H -925 4275 50  0001 C CNN
F 3 "~" H -925 4275 50  0001 C CNN
	1    -925 4275
	1    0    0    -1  
$EndComp
Text GLabel -825 4275 2    50   Input ~ 0
DW
Text Notes -1075 4050 0    79   ~ 0
LORA
Text Notes 900  2975 0    79   ~ 0
Sensor Power Switch
Wire Wire Line
	5425 6000 5275 6000
Connection ~ 5425 6000
Wire Wire Line
	5450 7075 5200 7075
Connection ~ 5450 7075
Wire Wire Line
	-1600 1000 -1150 1000
Wire Wire Line
	1050 3250 1050 3325
Wire Wire Line
	1275 3250 1050 3250
Wire Wire Line
	1625 3250 1475 3250
Wire Wire Line
	1625 3375 1625 3250
$Comp
L power:GND #PWR0102
U 1 1 61EFFD10
P 1050 3325
F 0 "#PWR0102" H 1050 3075 50  0001 C CNN
F 1 "GND" H 1055 3152 50  0000 C CNN
F 2 "" H 1050 3325 50  0001 C CNN
F 3 "" H 1050 3325 50  0001 C CNN
	1    1050 3325
	1    0    0    -1  
$EndComp
Text GLabel 1625 3375 2    50   Input ~ 0
POWER_1
Wire Wire Line
	8825 2350 9125 2350
Wire Wire Line
	-1150 900  -1475 900 
$Comp
L power:+3V3 #PWR0119
U 1 1 61DA88C9
P -1475 675
F 0 "#PWR0119" H -1475 525 50  0001 C CNN
F 1 "+3V3" V -1460 803 50  0000 L CNN
F 2 "" H -1475 675 50  0001 C CNN
F 3 "" H -1475 675 50  0001 C CNN
	1    -1475 675 
	1    0    0    -1  
$EndComp
Wire Wire Line
	-1475 900  -1475 675 
$Comp
L Device:Jumper_NO_Small JP1
U 1 1 61EFFD06
P 1375 3250
F 0 "JP1" H 1375 3435 50  0000 C CNN
F 1 "Jumper_NO_Small" H 1375 3344 50  0000 C CNN
F 2 "Jumper:SolderJumper-2_P1.3mm_Open_Pad1.0x1.5mm" H 1375 3250 50  0001 C CNN
F 3 "~" H 1375 3250 50  0001 C CNN
	1    1375 3250
	1    0    0    -1  
$EndComp
Wire Wire Line
	-3125 275  -3250 275 
$Comp
L power:+3V3 #PWR0118
U 1 1 61D9297E
P -3250 275
F 0 "#PWR0118" H -3250 125 50  0001 C CNN
F 1 "+3V3" V -3235 403 50  0000 L CNN
F 2 "" H -3250 275 50  0001 C CNN
F 3 "" H -3250 275 50  0001 C CNN
	1    -3250 275 
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0114
U 1 1 61C86AD2
P -3550 500
F 0 "#PWR0114" H -3550 250 50  0001 C CNN
F 1 "GND" H -3545 327 50  0000 C CNN
F 2 "" H -3550 500 50  0001 C CNN
F 3 "" H -3550 500 50  0001 C CNN
	1    -3550 500 
	1    0    0    -1  
$EndComp
Wire Wire Line
	-3125 475  -3550 475 
Wire Wire Line
	-3550 475  -3550 500 
Wire Wire Line
	2725 4075 2700 4075
Connection ~ 2700 4075
Wire Wire Line
	2700 4075 2375 4075
$Comp
L Device:Q_NPN_EBC Q3
U 1 1 61C856D6
P -1750 6675
F 0 "Q3" H -1559 6721 50  0000 L CNN
F 1 "Q_NPN_EBC" H -1559 6630 50  0000 L CNN
F 2 "Package_TO_SOT_THT:TO-92L_Wide" H -1550 6775 50  0001 C CNN
F 3 "~" H -1750 6675 50  0001 C CNN
	1    -1750 6675
	1    0    0    -1  
$EndComp
$Comp
L RocketScreamKicadLibrary:DIODE D2
U 1 1 61C856DC
P -1300 6275
F 0 "D2" V -1346 6353 50  0000 L CNN
F 1 "DIODE" V -1255 6353 50  0000 L CNN
F 2 "Diode_THT:D_5W_P12.70mm_Horizontal" H -1300 6075 60  0001 C CNN
F 3 "" H -1300 6275 60  0000 C CNN
	1    -1300 6275
	0    1    1    0   
$EndComp
$Comp
L Device:R R8
U 1 1 61C856E2
P -2100 6675
F 0 "R8" V -2307 6675 50  0000 C CNN
F 1 "R" V -2216 6675 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0309_L9.0mm_D3.2mm_P12.70mm_Horizontal" V -2170 6675 50  0001 C CNN
F 3 "~" H -2100 6675 50  0001 C CNN
	1    -2100 6675
	0    1    1    0   
$EndComp
$Comp
L remote-rescue:SPEAKER_BUZZER5MM-Adafruit_Circuit_Playground-eagle-import SP1
U 1 1 61C8B808
P -1650 6275
F 0 "SP1" V -1597 6223 59  0000 R CNN
F 1 "SPEAKER_BUZZER5MM" V -1702 6223 59  0000 R CNN
F 2 "Adafruit Circuit Playground:BUZZER_SMT_5MM" H -1650 6275 50  0001 C CNN
F 3 "" H -1650 6275 50  0001 C CNN
	1    -1650 6275
	0    -1   -1   0   
$EndComp
$Comp
L power:+3V3 #PWR0115
U 1 1 61CC95CE
P -1300 6075
F 0 "#PWR0115" H -1300 5925 50  0001 C CNN
F 1 "+3V3" H -1285 6248 50  0000 C CNN
F 2 "" H -1300 6075 50  0001 C CNN
F 3 "" H -1300 6075 50  0001 C CNN
	1    -1300 6075
	1    0    0    -1  
$EndComp
Wire Wire Line
	-1650 6075 -1300 6075
Connection ~ -1300 6075
Wire Wire Line
	-1300 6475 -1650 6475
Connection ~ -1650 6475
$Comp
L power:GND #PWR0116
U 1 1 61CCCAF3
P -1650 6875
F 0 "#PWR0116" H -1650 6625 50  0001 C CNN
F 1 "GND" H -1645 6702 50  0000 C CNN
F 2 "" H -1650 6875 50  0001 C CNN
F 3 "" H -1650 6875 50  0001 C CNN
	1    -1650 6875
	1    0    0    -1  
$EndComp
Text GLabel -2250 6675 0    50   Input ~ 0
A0
Text GLabel -1025 4275 0    50   Input ~ 0
A0
Wire Wire Line
	6475 1825 6775 1825
Text Notes 5750 2150 0    39   ~ 0
SCD30 is switched by Q1;\nalternatively, solder jumper\n
Text GLabel 6475 1825 0    50   Input ~ 0
POWER_1
Text GLabel 6775 2025 0    50   Input ~ 0
SDA
Text GLabel 6775 1925 0    50   Input ~ 0
SCL
$Comp
L power:+3V3 #PWR0101
U 1 1 61538CDB
P 6775 1725
F 0 "#PWR0101" H 6775 1575 50  0001 C CNN
F 1 "+3V3" H 6790 1898 50  0000 C CNN
F 2 "" H 6775 1725 50  0001 C CNN
F 3 "" H 6775 1725 50  0001 C CNN
	1    6775 1725
	1    0    0    -1  
$EndComp
Text Notes 6725 1475 0    79   ~ 0
SCD30
$Comp
L Connector:Conn_01x07_Female J17
U 1 1 615108B0
P 6975 2025
F 0 "J17" H 7003 2051 50  0000 L CNN
F 1 "Conn_01x07_Female" H 7003 1960 50  0000 L CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x07_P2.54mm_Vertical" H 6975 2025 50  0001 C CNN
F 3 "~" H 6975 2025 50  0001 C CNN
	1    6975 2025
	1    0    0    -1  
$EndComp
$EndSCHEMATC
