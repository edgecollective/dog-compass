EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "Dog Compass"
Date ""
Rev "4"
Comp ""
Comment1 "edgecollective.io/dog-compass"
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Device:R R1
U 1 1 5F989DB1
P 5725 6150
F 0 "R1" H 5795 6196 50  0000 L CNN
F 1 "4.7K" H 5795 6105 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0309_L9.0mm_D3.2mm_P12.70mm_Horizontal" V 5655 6150 50  0001 C CNN
F 3 "~" H 5725 6150 50  0001 C CNN
	1    5725 6150
	1    0    0    -1  
$EndComp
Text GLabel 6100 6325 0    50   Input ~ 0
SCL
$Comp
L power:+3V3 #PWR01
U 1 1 5F98B87C
P 5725 6000
F 0 "#PWR01" H 5725 5850 50  0001 C CNN
F 1 "+3V3" H 5740 6173 50  0000 C CNN
F 2 "" H 5725 6000 50  0001 C CNN
F 3 "" H 5725 6000 50  0001 C CNN
	1    5725 6000
	1    0    0    -1  
$EndComp
$Comp
L Device:R R2
U 1 1 5F98BC9A
P 6100 6175
F 0 "R2" H 6170 6221 50  0000 L CNN
F 1 "4.7K" H 6170 6130 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0309_L9.0mm_D3.2mm_P12.70mm_Horizontal" V 6030 6175 50  0001 C CNN
F 3 "~" H 6100 6175 50  0001 C CNN
	1    6100 6175
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR03
U 1 1 5F98C06B
P 6100 6025
F 0 "#PWR03" H 6100 5875 50  0001 C CNN
F 1 "+3V3" H 6115 6198 50  0000 C CNN
F 2 "" H 6100 6025 50  0001 C CNN
F 3 "" H 6100 6025 50  0001 C CNN
	1    6100 6025
	1    0    0    -1  
$EndComp
Text GLabel 5725 6300 0    50   Input ~ 0
SDA
Text Notes 5600 5625 0    79   ~ 0
i2c pullups
$Comp
L Device:R R3
U 1 1 6028DEF2
P 6650 2575
F 0 "R3" H 6720 2621 50  0000 L CNN
F 1 "4.7K" H 6720 2530 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0309_L9.0mm_D3.2mm_P12.70mm_Horizontal" V 6580 2575 50  0001 C CNN
F 3 "~" H 6650 2575 50  0001 C CNN
	1    6650 2575
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR011
U 1 1 6028E7B5
P 6575 1150
F 0 "#PWR011" H 6575 1000 50  0001 C CNN
F 1 "+3V3" H 6590 1323 50  0000 C CNN
F 2 "" H 6575 1150 50  0001 C CNN
F 3 "" H 6575 1150 50  0001 C CNN
	1    6575 1150
	1    0    0    -1  
$EndComp
Text Notes 6675 900  0    79   ~ 0
BUTTON A
$Comp
L Device:R R4
U 1 1 60FBA6C0
P 6575 1300
F 0 "R4" H 6645 1346 50  0000 L CNN
F 1 "4.7K" H 6645 1255 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0309_L9.0mm_D3.2mm_P12.70mm_Horizontal" V 6505 1300 50  0001 C CNN
F 3 "~" H 6575 1300 50  0001 C CNN
	1    6575 1300
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR013
U 1 1 60FBA6C6
P 6650 2425
F 0 "#PWR013" H 6650 2275 50  0001 C CNN
F 1 "+3V3" H 6665 2598 50  0000 C CNN
F 2 "" H 6650 2425 50  0001 C CNN
F 3 "" H 6650 2425 50  0001 C CNN
	1    6650 2425
	1    0    0    -1  
$EndComp
Text Notes 6750 2175 0    79   ~ 0
BUTTON B
$Comp
L Switch:SW_Push SW1
U 1 1 612C3561
P 7050 1450
F 0 "SW1" H 7050 1735 50  0000 C CNN
F 1 "SW_Push" H 7050 1644 50  0000 C CNN
F 2 "Button_Switch_THT:SW_Tactile_SPST_Angled_PTS645Vx58-2LFS" H 7050 1650 50  0001 C CNN
F 3 "~" H 7050 1650 50  0001 C CNN
	1    7050 1450
	1    0    0    -1  
$EndComp
Wire Wire Line
	6575 1450 6850 1450
$Comp
L power:GND #PWR015
U 1 1 612C4DF2
P 7250 1450
F 0 "#PWR015" H 7250 1200 50  0001 C CNN
F 1 "GND" H 7255 1277 50  0000 C CNN
F 2 "" H 7250 1450 50  0001 C CNN
F 3 "" H 7250 1450 50  0001 C CNN
	1    7250 1450
	1    0    0    -1  
$EndComp
$Comp
L Switch:SW_Push SW2
U 1 1 612CCB02
P 7100 2725
F 0 "SW2" H 7100 3010 50  0000 C CNN
F 1 "SW_Push" H 7100 2919 50  0000 C CNN
F 2 "Button_Switch_THT:SW_Tactile_SPST_Angled_PTS645Vx58-2LFS" H 7100 2925 50  0001 C CNN
F 3 "~" H 7100 2925 50  0001 C CNN
	1    7100 2725
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR016
U 1 1 612CCB08
P 7300 2725
F 0 "#PWR016" H 7300 2475 50  0001 C CNN
F 1 "GND" H 7305 2552 50  0000 C CNN
F 2 "" H 7300 2725 50  0001 C CNN
F 3 "" H 7300 2725 50  0001 C CNN
	1    7300 2725
	1    0    0    -1  
$EndComp
Wire Wire Line
	6900 2725 6650 2725
Text GLabel 6400 2725 0    50   Input ~ 0
A3
Text GLabel 6425 1450 0    50   Input ~ 0
A2
$Comp
L Connector:Conn_01x03_Female J5
U 1 1 614DA351
P 5900 7200
F 0 "J5" H 5928 7226 50  0000 L CNN
F 1 "Conn_01x03_Female" H 5928 7135 50  0000 L CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x03_P2.54mm_Vertical" H 5900 7200 50  0001 C CNN
F 3 "~" H 5900 7200 50  0001 C CNN
	1    5900 7200
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR09
U 1 1 614DCC4C
P 5700 7300
F 0 "#PWR09" H 5700 7050 50  0001 C CNN
F 1 "GND" H 5705 7127 50  0000 C CNN
F 2 "" H 5700 7300 50  0001 C CNN
F 3 "" H 5700 7300 50  0001 C CNN
	1    5700 7300
	0    1    1    0   
$EndComp
Text Notes 5550 6950 0    79   ~ 0
BATT ON/OFF
$Comp
L power:GND #PWR021
U 1 1 614FA1BB
P 10000 3700
F 0 "#PWR021" H 10000 3450 50  0001 C CNN
F 1 "GND" H 10005 3527 50  0000 C CNN
F 2 "" H 10000 3700 50  0001 C CNN
F 3 "" H 10000 3700 50  0001 C CNN
	1    10000 3700
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR022
U 1 1 614FA1C1
P 10225 3800
F 0 "#PWR022" H 10225 3650 50  0001 C CNN
F 1 "+3V3" H 10240 3973 50  0000 C CNN
F 2 "" H 10225 3800 50  0001 C CNN
F 3 "" H 10225 3800 50  0001 C CNN
	1    10225 3800
	1    0    0    -1  
$EndComp
Text GLabel 10400 4000 0    50   Input ~ 0
SDA
Text GLabel 10400 3900 0    50   Input ~ 0
SCL
Wire Wire Line
	10400 3700 10000 3700
Wire Wire Line
	10400 3800 10225 3800
$Comp
L Connector:Conn_01x04_Female J16
U 1 1 614FA1CB
P 10600 3800
F 0 "J16" H 10628 3776 50  0000 L CNN
F 1 "Conn_01x04_Female" V 10775 3350 50  0000 L CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x04_P2.54mm_Vertical" H 10600 3800 50  0001 C CNN
F 3 "~" H 10600 3800 50  0001 C CNN
	1    10600 3800
	1    0    0    -1  
$EndComp
Text Notes 9775 3450 0    79   ~ 0
i2c breakout
$Comp
L Mechanical:MountingHole_Pad H1
U 1 1 614A1FDA
P 7775 5775
F 0 "H1" H 7875 5824 50  0000 L CNN
F 1 "MountingHole_Pad" H 7875 5733 50  0000 L CNN
F 2 "MountingHole:MountingHole_2.7mm_M2.5_Pad" H 7775 5775 50  0001 C CNN
F 3 "~" H 7775 5775 50  0001 C CNN
	1    7775 5775
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole_Pad H2
U 1 1 614A5606
P 8025 6100
F 0 "H2" H 8125 6149 50  0000 L CNN
F 1 "MountingHole_Pad" H 8125 6058 50  0000 L CNN
F 2 "MountingHole:MountingHole_2.7mm_M2.5_Pad" H 8025 6100 50  0001 C CNN
F 3 "~" H 8025 6100 50  0001 C CNN
	1    8025 6100
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole_Pad H5
U 1 1 614E3462
P 10425 5750
F 0 "H5" H 10525 5799 50  0000 L CNN
F 1 "MountingHole_Pad" H 10525 5708 50  0000 L CNN
F 2 "MountingHole:MountingHole_2.7mm_M2.5_Pad" H 10425 5750 50  0001 C CNN
F 3 "~" H 10425 5750 50  0001 C CNN
	1    10425 5750
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole_Pad H6
U 1 1 614E3468
P 10425 6100
F 0 "H6" H 10525 6149 50  0000 L CNN
F 1 "MountingHole_Pad" H 10525 6058 50  0000 L CNN
F 2 "MountingHole:MountingHole_2.7mm_M2.5_Pad" H 10425 6100 50  0001 C CNN
F 3 "~" H 10425 6100 50  0001 C CNN
	1    10425 6100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0105
U 1 1 615C33CE
P 7775 5875
F 0 "#PWR0105" H 7775 5625 50  0001 C CNN
F 1 "GND" H 7780 5702 50  0000 C CNN
F 2 "" H 7775 5875 50  0001 C CNN
F 3 "" H 7775 5875 50  0001 C CNN
	1    7775 5875
	0    1    1    0   
$EndComp
$Comp
L power:+3V3 #PWR0106
U 1 1 615C451F
P 8025 6200
F 0 "#PWR0106" H 8025 6050 50  0001 C CNN
F 1 "+3V3" H 8040 6373 50  0000 C CNN
F 2 "" H 8025 6200 50  0001 C CNN
F 3 "" H 8025 6200 50  0001 C CNN
	1    8025 6200
	0    -1   -1   0   
$EndComp
Text GLabel 10425 6200 0    50   Input ~ 0
SCL
Text GLabel 10425 5850 0    50   Input ~ 0
SDA
$Comp
L power:GND #PWR0107
U 1 1 6193871C
P 3925 7425
F 0 "#PWR0107" H 3925 7175 50  0001 C CNN
F 1 "GND" H 3930 7252 50  0000 C CNN
F 2 "" H 3925 7425 50  0001 C CNN
F 3 "" H 3925 7425 50  0001 C CNN
	1    3925 7425
	1    0    0    -1  
$EndComp
$Comp
L Device:R R5
U 1 1 6193A6F6
P 3925 7275
F 0 "R5" H 3995 7321 50  0000 L CNN
F 1 "R" H 3995 7230 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0309_L9.0mm_D3.2mm_P12.70mm_Horizontal" V 3855 7275 50  0001 C CNN
F 3 "~" H 3925 7275 50  0001 C CNN
	1    3925 7275
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x03_Female J19
U 1 1 61938716
P 4450 7125
F 0 "J19" H 4478 7151 50  0000 L CNN
F 1 "Conn_01x03_Female" H 4478 7060 50  0000 L CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x03_P2.54mm_Vertical" H 4450 7125 50  0001 C CNN
F 3 "~" H 4450 7125 50  0001 C CNN
	1    4450 7125
	1    0    0    -1  
$EndComp
Text Notes 4100 6875 0    79   ~ 0
Write Permit\n
Text GLabel 4250 7225 0    50   Input ~ 0
A5
Text Notes 1100 2350 0    79   ~ 0
Adafruit Sharp Display \n1.3"
$Comp
L Switch:SW_Push_Dual SW4
U 1 1 61BD3A38
P 8625 2975
F 0 "SW4" H 8625 3260 50  0000 C CNN
F 1 "SW_Push_Dual" H 8625 3169 50  0000 C CNN
F 2 "Button_Switch_THT:SW_TH_Tactile_Omron_B3F-10xx" H 8625 3175 50  0001 C CNN
F 3 "~" H 8625 3175 50  0001 C CNN
	1    8625 2975
	1    0    0    -1  
$EndComp
Wire Wire Line
	8425 2975 8150 2975
Wire Wire Line
	8150 2975 8150 2675
Text GLabel 8150 2675 0    50   Input ~ 0
~RESET
Wire Wire Line
	8425 2975 8425 2850
Wire Wire Line
	8425 2850 8825 2850
Wire Wire Line
	8825 2850 8825 2975
Connection ~ 8425 2975
Wire Wire Line
	8825 3175 8825 3050
Wire Wire Line
	8825 3050 8425 3050
Wire Wire Line
	8425 3050 8425 3175
Wire Wire Line
	8825 3175 8825 3300
Connection ~ 8825 3175
$Comp
L Adafruit_AirLift_FeatherWing-eagle-import:GND #GND0101
U 1 1 61BE19AA
P 8825 3400
F 0 "#GND0101" H 8825 3400 50  0001 C CNN
F 1 "GND" H 8825 3279 59  0000 C CNN
F 2 "" H 8825 3400 50  0001 C CNN
F 3 "" H 8825 3400 50  0001 C CNN
	1    8825 3400
	1    0    0    -1  
$EndComp
Text Notes 8200 2525 0    79   ~ 0
EXT RESET
$Comp
L Device:Q_NMOS_GDS Q1
U 1 1 61C12A63
P 5300 4850
F 0 "Q1" H 5504 4896 50  0000 L CNN
F 1 "Q_NMOS_GDS" H 5504 4805 50  0000 L CNN
F 2 "Package_TO_SOT_THT:TO-220-3_Horizontal_TabDown" H 5500 4950 50  0001 C CNN
F 3 "~" H 5300 4850 50  0001 C CNN
	1    5300 4850
	1    0    0    -1  
$EndComp
Text GLabel 1350 3200 0    50   Input ~ 0
SCK
$Comp
L Device:R R6
U 1 1 61C43F0B
P 5100 5000
F 0 "R6" H 5170 5046 50  0000 L CNN
F 1 "10K" H 5170 4955 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0309_L9.0mm_D3.2mm_P12.70mm_Horizontal" V 5030 5000 50  0001 C CNN
F 3 "~" H 5100 5000 50  0001 C CNN
	1    5100 5000
	1    0    0    -1  
$EndComp
Text GLabel 4875 4850 0    50   Input ~ 0
D9
Text Notes 9725 4775 0    79   ~ 0
QWIIC
$Comp
L Connector:Conn_01x04_Female J20
U 1 1 61C7347D
P 10550 5125
F 0 "J20" H 10578 5101 50  0000 L CNN
F 1 "Conn_01x04_Female" V 10725 4675 50  0000 L CNN
F 2 "Connector_JST:JST_SH_SM04B-SRSS-TB_1x04-1MP_P1.00mm_Horizontal" H 10550 5125 50  0001 C CNN
F 3 "~" H 10550 5125 50  0001 C CNN
	1    10550 5125
	1    0    0    -1  
$EndComp
Wire Wire Line
	10350 5125 10175 5125
Wire Wire Line
	10350 5025 9950 5025
Text GLabel 10350 5325 0    50   Input ~ 0
SCL
Text GLabel 10350 5225 0    50   Input ~ 0
SDA
$Comp
L power:+3V3 #PWR0112
U 1 1 61C7348B
P 10175 5125
F 0 "#PWR0112" H 10175 4975 50  0001 C CNN
F 1 "+3V3" H 10190 5298 50  0000 C CNN
F 2 "" H 10175 5125 50  0001 C CNN
F 3 "" H 10175 5125 50  0001 C CNN
	1    10175 5125
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0113
U 1 1 61C73495
P 9950 5025
F 0 "#PWR0113" H 9950 4775 50  0001 C CNN
F 1 "GND" H 9955 4852 50  0000 C CNN
F 2 "" H 9950 5025 50  0001 C CNN
F 3 "" H 9950 5025 50  0001 C CNN
	1    9950 5025
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0103
U 1 1 61CB8180
P 5100 5150
F 0 "#PWR0103" H 5100 4900 50  0001 C CNN
F 1 "GND" H 5105 4977 50  0000 C CNN
F 2 "" H 5100 5150 50  0001 C CNN
F 3 "" H 5100 5150 50  0001 C CNN
	1    5100 5150
	1    0    0    -1  
$EndComp
Wire Wire Line
	5100 5150 5400 5150
Wire Wire Line
	5400 5150 5400 5050
Connection ~ 5100 5150
Text GLabel 5400 4650 0    50   Input ~ 0
POWER_1
Wire Wire Line
	5100 4850 4875 4850
Connection ~ 5100 4850
Text GLabel 1350 3500 0    50   Input ~ 0
A0
Text GLabel 1350 3350 0    50   Input ~ 0
MOSI
Text Notes 4650 3975 0    79   ~ 0
Sensor Power Switch
Wire Wire Line
	6575 1450 6425 1450
Connection ~ 6575 1450
Wire Wire Line
	6650 2725 6400 2725
Connection ~ 6650 2725
Wire Wire Line
	4800 4250 4800 4325
Wire Wire Line
	5025 4250 4800 4250
Wire Wire Line
	5375 4250 5225 4250
Wire Wire Line
	5375 4375 5375 4250
$Comp
L power:GND #PWR0102
U 1 1 61EFFD10
P 4800 4325
F 0 "#PWR0102" H 4800 4075 50  0001 C CNN
F 1 "GND" H 4805 4152 50  0000 C CNN
F 2 "" H 4800 4325 50  0001 C CNN
F 3 "" H 4800 4325 50  0001 C CNN
	1    4800 4325
	1    0    0    -1  
$EndComp
Text GLabel 5375 4375 2    50   Input ~ 0
POWER_1
$Comp
L Device:Jumper_NO_Small JP1
U 1 1 61EFFD06
P 5125 4250
F 0 "JP1" H 5125 4435 50  0000 C CNN
F 1 "Jumper_NO_Small" H 5125 4344 50  0000 C CNN
F 2 "Jumper:SolderJumper-2_P1.3mm_Open_Pad1.0x1.5mm" H 5125 4250 50  0001 C CNN
F 3 "~" H 5125 4250 50  0001 C CNN
	1    5125 4250
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR0118
U 1 1 61D9297E
P 1350 2750
F 0 "#PWR0118" H 1350 2600 50  0001 C CNN
F 1 "+3V3" V 1365 2878 50  0000 L CNN
F 2 "" H 1350 2750 50  0001 C CNN
F 3 "" H 1350 2750 50  0001 C CNN
	1    1350 2750
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0114
U 1 1 61C86AD2
P 950 3050
F 0 "#PWR0114" H 950 2800 50  0001 C CNN
F 1 "GND" H 955 2877 50  0000 C CNN
F 2 "" H 950 3050 50  0001 C CNN
F 3 "" H 950 3050 50  0001 C CNN
	1    950  3050
	1    0    0    -1  
$EndComp
Wire Wire Line
	4275 7125 4250 7125
Connection ~ 4250 7125
Wire Wire Line
	4250 7125 3925 7125
$Comp
L Device:Q_NPN_EBC Q3
U 1 1 61C856D6
P 3400 5925
F 0 "Q3" H 3591 5971 50  0000 L CNN
F 1 "Q_NPN_EBC" H 3591 5880 50  0000 L CNN
F 2 "Package_TO_SOT_THT:TO-92L_Wide" H 3600 6025 50  0001 C CNN
F 3 "~" H 3400 5925 50  0001 C CNN
	1    3400 5925
	1    0    0    -1  
$EndComp
$Comp
L remote-rescue:DIODE-RocketScreamKicadLibrary-remote-rescue D2
U 1 1 61C856DC
P 3850 5525
F 0 "D2" V 3804 5603 50  0000 L CNN
F 1 "DIODE" V 3895 5603 50  0000 L CNN
F 2 "Diode_THT:D_5W_P12.70mm_Horizontal" H 3850 5325 60  0001 C CNN
F 3 "" H 3850 5525 60  0000 C CNN
	1    3850 5525
	0    1    1    0   
$EndComp
$Comp
L Device:R R8
U 1 1 61C856E2
P 3050 5925
F 0 "R8" V 2843 5925 50  0000 C CNN
F 1 "R" V 2934 5925 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0309_L9.0mm_D3.2mm_P12.70mm_Horizontal" V 2980 5925 50  0001 C CNN
F 3 "~" H 3050 5925 50  0001 C CNN
	1    3050 5925
	0    1    1    0   
$EndComp
$Comp
L remote-rescue:SPEAKER_BUZZER5MM-Adafruit_Circuit_Playground-eagle-import-remote-rescue SP1
U 1 1 61C8B808
P 3500 5525
F 0 "SP1" V 3553 5473 59  0000 R CNN
F 1 "SPEAKER_BUZZER5MM" V 3448 5473 59  0000 R CNN
F 2 "Adafruit Circuit Playground:BUZZER_SMT_5MM" H 3500 5525 50  0001 C CNN
F 3 "" H 3500 5525 50  0001 C CNN
	1    3500 5525
	0    -1   -1   0   
$EndComp
$Comp
L power:+3V3 #PWR0115
U 1 1 61CC95CE
P 3850 5325
F 0 "#PWR0115" H 3850 5175 50  0001 C CNN
F 1 "+3V3" H 3865 5498 50  0000 C CNN
F 2 "" H 3850 5325 50  0001 C CNN
F 3 "" H 3850 5325 50  0001 C CNN
	1    3850 5325
	1    0    0    -1  
$EndComp
Wire Wire Line
	3500 5325 3850 5325
Connection ~ 3850 5325
Wire Wire Line
	3850 5725 3500 5725
Connection ~ 3500 5725
$Comp
L power:GND #PWR0116
U 1 1 61CCCAF3
P 3500 6125
F 0 "#PWR0116" H 3500 5875 50  0001 C CNN
F 1 "GND" H 3505 5952 50  0000 C CNN
F 2 "" H 3500 6125 50  0001 C CNN
F 3 "" H 3500 6125 50  0001 C CNN
	1    3500 6125
	1    0    0    -1  
$EndComp
Text GLabel 2900 5925 0    50   Input ~ 0
A1
Text GLabel 5700 7200 0    50   Input ~ 0
EN
$Comp
L mysensors_radios:RFM95HW U1
U 1 1 61D2BB57
P 3350 1850
F 0 "U1" H 3350 2464 40  0000 C CNN
F 1 "RFM95HW" H 3350 2388 40  0000 C CNN
F 2 "footprints:RFM95" H 3350 1850 30  0001 C CIN
F 3 "https://cdn-learn.adafruit.com/assets/assets/000/031/659/original/RFM95_96_97_98W.pdf?1460518717" H 3350 2297 60  0000 C CNN
	1    3350 1850
	1    0    0    -1  
$EndComp
$Comp
L dog:feather U2
U 1 1 61D308E3
P 1550 6050
F 0 "U2" H 1500 7200 50  0000 C CNN
F 1 "feather" H 1500 7100 50  0000 C CNN
F 2 "footprints:feather" H 1550 6050 50  0001 C CNN
F 3 "" H 1550 6050 50  0001 C CNN
	1    1550 6050
	1    0    0    -1  
$EndComp
$Comp
L dog:Adafruit_IMU_BNO005 U3
U 1 1 61D39165
P 9500 1000
F 0 "U3" H 9428 471 50  0000 L CNN
F 1 "Adafruit_IMU_BNO005" H 9428 380 50  0000 L CNN
F 2 "footprints:IMU_Ada_BNO005" H 9500 1000 50  0001 C CNN
F 3 "" H 9500 1000 50  0001 C CNN
	1    9500 1000
	1    0    0    -1  
$EndComp
$Comp
L dog:Adafruit_Sharp_Display_1_3 U4
U 1 1 61D40EC2
P 1700 2500
F 0 "U4" H 1778 1696 50  0000 L CNN
F 1 "Adafruit_Sharp_Display_1_3" H 1778 1605 50  0000 L CNN
F 2 "footprints:Display_adafruit_sharp_13" H 1700 2500 50  0001 C CNN
F 3 "" H 1700 2500 50  0001 C CNN
	1    1700 2500
	1    0    0    -1  
$EndComp
Wire Wire Line
	1350 3050 950  3050
Text GLabel 1100 5800 0    50   Input ~ 0
A0
Text GLabel 1100 7450 0    50   Input ~ 0
DW
Text GLabel 2000 6250 2    50   Input ~ 0
D9
Text GLabel 1100 6250 0    50   Input ~ 0
A3
Text GLabel 1100 6550 0    50   Input ~ 0
A5
Text GLabel 1100 6400 0    50   Input ~ 0
A4
Text GLabel 2000 6700 2    50   Input ~ 0
SCL
Text GLabel 2000 6850 2    50   Input ~ 0
SDA
$Comp
L dog:neo-6m-black U5
U 1 1 61D7113B
P 5350 1850
F 0 "U5" H 5578 1546 50  0000 L CNN
F 1 "neo-6m-black" H 5578 1455 50  0000 L CNN
F 2 "footprints:gps_neo6m_black" H 5350 1850 50  0001 C CNN
F 3 "" H 5350 1850 50  0001 C CNN
	1    5350 1850
	1    0    0    -1  
$EndComp
Text Notes 4900 1750 0    79   ~ 0
GPS NEO6M BLACK
Text Notes 8800 900  0    79   ~ 0
COMPASS
Text Notes 1200 4750 0    79   ~ 0
FEATHER
Text GLabel 1100 7150 0    50   Input ~ 0
RX_D0
Text GLabel 1100 7300 0    50   Input ~ 0
TX_D1
Text GLabel 5150 2100 0    50   Input ~ 0
RX_D0
Text GLabel 5150 2200 0    50   Input ~ 0
TX_D1
$Comp
L power:+3V3 #PWR0101
U 1 1 61D83F21
P 4650 2400
F 0 "#PWR0101" H 4650 2250 50  0001 C CNN
F 1 "+3V3" V 4665 2528 50  0000 L CNN
F 2 "" H 4650 2400 50  0001 C CNN
F 3 "" H 4650 2400 50  0001 C CNN
	1    4650 2400
	1    0    0    -1  
$EndComp
Wire Wire Line
	5150 2400 4650 2400
Wire Wire Line
	5150 2300 5000 2300
Wire Wire Line
	5000 2300 5000 2500
Text GLabel 8950 1650 0    50   Input ~ 0
SCL
Text GLabel 8950 1800 0    50   Input ~ 0
SDA
Text GLabel 5000 2500 0    50   Input ~ 0
POWER_1
$Comp
L Device:R R7
U 1 1 61DE7962
P 6700 3775
F 0 "R7" H 6770 3821 50  0000 L CNN
F 1 "4.7K" H 6770 3730 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0309_L9.0mm_D3.2mm_P12.70mm_Horizontal" V 6630 3775 50  0001 C CNN
F 3 "~" H 6700 3775 50  0001 C CNN
	1    6700 3775
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR0104
U 1 1 61DE7C60
P 6700 3625
F 0 "#PWR0104" H 6700 3475 50  0001 C CNN
F 1 "+3V3" H 6715 3798 50  0000 C CNN
F 2 "" H 6700 3625 50  0001 C CNN
F 3 "" H 6700 3625 50  0001 C CNN
	1    6700 3625
	1    0    0    -1  
$EndComp
Text Notes 6800 3375 0    79   ~ 0
BUTTON C
$Comp
L Switch:SW_Push SW3
U 1 1 61DE7C6B
P 7150 3925
F 0 "SW3" H 7150 4210 50  0000 C CNN
F 1 "SW_Push" H 7150 4119 50  0000 C CNN
F 2 "Button_Switch_THT:SW_Tactile_SPST_Angled_PTS645Vx58-2LFS" H 7150 4125 50  0001 C CNN
F 3 "~" H 7150 4125 50  0001 C CNN
	1    7150 3925
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0108
U 1 1 61DE7C75
P 7350 3925
F 0 "#PWR0108" H 7350 3675 50  0001 C CNN
F 1 "GND" H 7355 3752 50  0000 C CNN
F 2 "" H 7350 3925 50  0001 C CNN
F 3 "" H 7350 3925 50  0001 C CNN
	1    7350 3925
	1    0    0    -1  
$EndComp
Wire Wire Line
	6950 3925 6700 3925
Text GLabel 6450 3925 0    50   Input ~ 0
A4
Wire Wire Line
	6700 3925 6450 3925
Connection ~ 6700 3925
$Comp
L Connector:Conn_Coaxial J1
U 1 1 61DED342
P 2700 750
F 0 "J1" H 2800 725 50  0000 L CNN
F 1 "Conn_Coaxial" H 2800 634 50  0000 L CNN
F 2 "Connector_Coaxial:SMA_Amphenol_132134_Vertical" H 2700 750 50  0001 C CNN
F 3 " ~" H 2700 750 50  0001 C CNN
	1    2700 750 
	1    0    0    -1  
$EndComp
Wire Wire Line
	2800 1700 2500 1700
Wire Wire Line
	2500 1700 2500 750 
$Comp
L power:GND #PWR0109
U 1 1 61D58311
P 2700 950
F 0 "#PWR0109" H 2700 700 50  0001 C CNN
F 1 "GND" H 2705 777 50  0000 C CNN
F 2 "" H 2700 950 50  0001 C CNN
F 3 "" H 2700 950 50  0001 C CNN
	1    2700 950 
	1    0    0    -1  
$EndComp
Text GLabel 2800 2200 0    50   Input ~ 0
SCK
Text GLabel 2800 2000 0    50   Input ~ 0
MOSI
Text GLabel 1100 7000 0    50   Input ~ 0
MISO
Text GLabel 1100 6850 0    50   Input ~ 0
MOSI
Text GLabel 1100 6700 0    50   Input ~ 0
SCK
Text GLabel 2800 2100 0    50   Input ~ 0
MISO
Text GLabel 2000 6550 2    50   Input ~ 0
D5
Text GLabel 2000 6400 2    50   Input ~ 0
D6
Text GLabel 2800 1900 0    50   Input ~ 0
D5
Text GLabel 2800 2400 0    50   Input ~ 0
D6
Text GLabel 3900 1850 2    50   Input ~ 0
D9
Text GLabel 2000 6100 2    50   Input ~ 0
D10
Text GLabel 2000 5950 2    50   Input ~ 0
D11
Text GLabel 2000 5800 2    50   Input ~ 0
D12
Text GLabel 2000 5650 2    50   Input ~ 0
D13
Text GLabel 2000 5350 2    50   Input ~ 0
EN
Text GLabel 2000 5200 2    50   Input ~ 0
VBAT
Text GLabel 2000 5500 2    50   Input ~ 0
VBUS
Text GLabel 1100 5950 0    50   Input ~ 0
A1
Text GLabel 1100 6100 0    50   Input ~ 0
A2
$Comp
L power:GND #PWR0110
U 1 1 61EE6385
P 750 5650
F 0 "#PWR0110" H 750 5400 50  0001 C CNN
F 1 "GND" H 755 5477 50  0000 C CNN
F 2 "" H 750 5650 50  0001 C CNN
F 3 "" H 750 5650 50  0001 C CNN
	1    750  5650
	1    0    0    -1  
$EndComp
Wire Wire Line
	1100 5650 750  5650
Text GLabel 1100 5500 0    50   Input ~ 0
AREF
$Comp
L power:+3V3 #PWR0111
U 1 1 61EE75E9
P 550 5350
F 0 "#PWR0111" H 550 5200 50  0001 C CNN
F 1 "+3V3" H 565 5523 50  0000 C CNN
F 2 "" H 550 5350 50  0001 C CNN
F 3 "" H 550 5350 50  0001 C CNN
	1    550  5350
	1    0    0    -1  
$EndComp
Text GLabel 1100 5200 0    50   Input ~ 0
~RESET
Wire Wire Line
	550  5350 1100 5350
$Comp
L device:Jumper_NO_Small JP2
U 1 1 61E9417E
P 4000 1950
F 0 "JP2" H 4000 2135 50  0000 C CNN
F 1 "Jumper_NO_Small" V 4200 1600 50  0000 C CNN
F 2 "Jumper:SolderJumper-2_P1.3mm_Open_Pad1.0x1.5mm" H 4000 1950 50  0001 C CNN
F 3 "" H 4000 1950 50  0001 C CNN
	1    4000 1950
	1    0    0    -1  
$EndComp
Text GLabel 4100 1950 2    50   Input ~ 0
D10
Text GLabel 2900 4600 2    50   Input ~ 0
D13
Text GLabel 2900 4700 2    50   Input ~ 0
D12
Text GLabel 2900 4800 2    50   Input ~ 0
D11
Text GLabel 2900 4500 2    50   Input ~ 0
A1
$Comp
L power:+3V3 #PWR0117
U 1 1 61F6A488
P 2900 4400
F 0 "#PWR0117" H 2900 4250 50  0001 C CNN
F 1 "+3V3" H 2915 4573 50  0000 C CNN
F 2 "" H 2900 4400 50  0001 C CNN
F 3 "" H 2900 4400 50  0001 C CNN
	1    2900 4400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0119
U 1 1 61F6BD21
P 2900 4900
F 0 "#PWR0119" H 2900 4650 50  0001 C CNN
F 1 "GND" H 2905 4727 50  0000 C CNN
F 2 "" H 2900 4900 50  0001 C CNN
F 3 "" H 2900 4900 50  0001 C CNN
	1    2900 4900
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x06_Female J2
U 1 1 61F6CB97
P 2700 4700
F 0 "J2" H 2592 4175 50  0000 C CNN
F 1 "Conn_01x06_Female" H 2750 3950 50  0001 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x06_P2.54mm_Vertical" H 2700 4700 50  0001 C CNN
F 3 "~" H 2700 4700 50  0001 C CNN
	1    2700 4700
	-1   0    0    1   
$EndComp
Text Notes 8175 4775 0    79   ~ 0
QWIIC
$Comp
L Connector:Conn_01x04_Female J3
U 1 1 61F816B3
P 9000 5125
F 0 "J3" H 9028 5101 50  0000 L CNN
F 1 "Conn_01x04_Female" V 9175 4675 50  0000 L CNN
F 2 "Connector_JST:JST_SH_SM04B-SRSS-TB_1x04-1MP_P1.00mm_Horizontal" H 9000 5125 50  0001 C CNN
F 3 "~" H 9000 5125 50  0001 C CNN
	1    9000 5125
	1    0    0    -1  
$EndComp
Wire Wire Line
	8800 5125 8625 5125
Wire Wire Line
	8800 5025 8400 5025
Text GLabel 8800 5325 0    50   Input ~ 0
SCL
Text GLabel 8800 5225 0    50   Input ~ 0
SDA
$Comp
L power:+3V3 #PWR0120
U 1 1 61F816C1
P 8625 5125
F 0 "#PWR0120" H 8625 4975 50  0001 C CNN
F 1 "+3V3" H 8640 5298 50  0000 C CNN
F 2 "" H 8625 5125 50  0001 C CNN
F 3 "" H 8625 5125 50  0001 C CNN
	1    8625 5125
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0121
U 1 1 61F816CB
P 8400 5025
F 0 "#PWR0121" H 8400 4775 50  0001 C CNN
F 1 "GND" H 8405 4852 50  0000 C CNN
F 2 "" H 8400 5025 50  0001 C CNN
F 3 "" H 8400 5025 50  0001 C CNN
	1    8400 5025
	1    0    0    -1  
$EndComp
$EndSCHEMATC
