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
L Device:R R2
U 1 1 5F989DB1
P 5725 6150
F 0 "R2" H 5795 6196 50  0000 L CNN
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
L Device:R R1
U 1 1 5F98BC9A
P 6100 6175
F 0 "R1" H 6170 6221 50  0000 L CNN
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
L power:GND #PWR0107
U 1 1 6193871C
P 3950 7100
F 0 "#PWR0107" H 3950 6850 50  0001 C CNN
F 1 "GND" H 3955 6927 50  0000 C CNN
F 2 "" H 3950 7100 50  0001 C CNN
F 3 "" H 3950 7100 50  0001 C CNN
	1    3950 7100
	1    0    0    -1  
$EndComp
Text Notes 4100 6875 0    79   ~ 0
Write Permit\n
Text GLabel 4350 7200 0    50   Input ~ 0
A5
Text Notes 7075 3375 0    79   ~ 0
QWIIC
$Comp
L Connector:Conn_01x04_Female J20
U 1 1 61C7347D
P 7900 3725
F 0 "J20" H 7928 3701 50  0000 L CNN
F 1 "Conn_01x04_Female" V 8075 3275 50  0000 L CNN
F 2 "Connector_JST:JST_SH_SM04B-SRSS-TB_1x04-1MP_P1.00mm_Horizontal" H 7900 3725 50  0001 C CNN
F 3 "~" H 7900 3725 50  0001 C CNN
	1    7900 3725
	1    0    0    -1  
$EndComp
Wire Wire Line
	7700 3725 7525 3725
Wire Wire Line
	7700 3625 7300 3625
Text GLabel 7700 3925 0    50   Input ~ 0
SCL
Text GLabel 7700 3825 0    50   Input ~ 0
SDA
$Comp
L power:+3V3 #PWR0112
U 1 1 61C7348B
P 7525 3725
F 0 "#PWR0112" H 7525 3575 50  0001 C CNN
F 1 "+3V3" H 7540 3898 50  0000 C CNN
F 2 "" H 7525 3725 50  0001 C CNN
F 3 "" H 7525 3725 50  0001 C CNN
	1    7525 3725
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0113
U 1 1 61C73495
P 7300 3625
F 0 "#PWR0113" H 7300 3375 50  0001 C CNN
F 1 "GND" H 7305 3452 50  0000 C CNN
F 2 "" H 7300 3625 50  0001 C CNN
F 3 "" H 7300 3625 50  0001 C CNN
	1    7300 3625
	1    0    0    -1  
$EndComp
Text GLabel 5700 7200 0    50   Input ~ 0
EN
$Comp
L mysensors_radios:RFM95HW U1
U 1 1 61D2BB57
P 3350 1850
F 0 "U1" H 3350 2464 40  0000 C CNN
F 1 "RFM95HW" H 3900 2500 40  0000 C CNN
F 2 "footprints:RFM95" H 3350 1850 30  0001 C CIN
F 3 "https://cdn-learn.adafruit.com/assets/assets/000/031/659/original/RFM95_96_97_98W.pdf?1460518717" H 3350 2297 60  0000 C CNN
	1    3350 1850
	1    0    0    -1  
$EndComp
$Comp
L remote-rescue:feather-dog U2
U 1 1 61D308E3
P 1550 6050
F 0 "U2" H 1500 7200 50  0000 C CNN
F 1 "feather" H 1500 7100 50  0000 C CNN
F 2 "footprints:feather" H 1550 6050 50  0001 C CNN
F 3 "" H 1550 6050 50  0001 C CNN
	1    1550 6050
	1    0    0    -1  
$EndComp
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
L remote-rescue:neo-6m-black-dog U5
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
Text GLabel 2800 1900 0    50   Input ~ 0
D5
$Comp
L Connector:Conn_01x03_Female J19
U 1 1 61938716
P 4550 7100
F 0 "J19" H 4578 7126 50  0000 L CNN
F 1 "Conn_01x03_Female" H 4578 7035 50  0000 L CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x03_P2.54mm_Vertical" H 4550 7100 50  0001 C CNN
F 3 "~" H 4550 7100 50  0001 C CNN
	1    4550 7100
	1    0    0    -1  
$EndComp
Wire Wire Line
	4350 7100 3950 7100
$Comp
L power:GND #PWR0124
U 1 1 6207EF12
P 3250 2700
F 0 "#PWR0124" H 3250 2450 50  0001 C CNN
F 1 "GND" H 3255 2527 50  0000 C CNN
F 2 "" H 3250 2700 50  0001 C CNN
F 3 "" H 3250 2700 50  0001 C CNN
	1    3250 2700
	1    0    0    -1  
$EndComp
Wire Wire Line
	3250 2700 3350 2700
Connection ~ 3250 2700
Wire Wire Line
	3350 2700 3450 2700
Connection ~ 3350 2700
$Comp
L power:+3V3 #PWR0104
U 1 1 6216FD88
P 3350 1500
F 0 "#PWR0104" H 3350 1350 50  0001 C CNN
F 1 "+3V3" V 3365 1628 50  0000 L CNN
F 2 "" H 3350 1500 50  0001 C CNN
F 3 "" H 3350 1500 50  0001 C CNN
	1    3350 1500
	1    0    0    -1  
$EndComp
Text GLabel 5000 2500 0    50   Input ~ 0
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
Text GLabel 5375 4375 2    50   Input ~ 0
POWER_1
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
Wire Wire Line
	5375 4375 5375 4250
Wire Wire Line
	5375 4250 5225 4250
Wire Wire Line
	5025 4250 4800 4250
Wire Wire Line
	4800 4250 4800 4325
Text Notes 4650 3975 0    79   ~ 0
Sensor Power Switch
Wire Wire Line
	5100 4850 4875 4850
Text GLabel 5400 4650 0    50   Input ~ 0
POWER_1
Wire Wire Line
	5400 5150 5400 5050
Wire Wire Line
	5100 5150 5400 5150
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
Text GLabel 4875 4850 0    50   Input ~ 0
A4
Connection ~ 5100 5150
$Comp
L Device:R R3
U 1 1 61C43F0B
P 5100 5000
F 0 "R3" H 5170 5046 50  0000 L CNN
F 1 "10K" H 5170 4955 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0309_L9.0mm_D3.2mm_P12.70mm_Horizontal" V 5030 5000 50  0001 C CNN
F 3 "~" H 5100 5000 50  0001 C CNN
	1    5100 5000
	1    0    0    -1  
$EndComp
Connection ~ 5100 4850
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
Text GLabel 3900 1950 2    50   Input ~ 0
A3
$Comp
L Connector:Conn_01x05_Female J2
U 1 1 61EF5D35
P 2700 3950
F 0 "J2" H 2728 3976 50  0000 L CNN
F 1 "Conn_01x05_Female" H 2728 3885 50  0000 L CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x05_P2.54mm_Vertical" H 2700 3950 50  0001 C CNN
F 3 "~" H 2700 3950 50  0001 C CNN
	1    2700 3950
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR0105
U 1 1 61EF638E
P 2500 3750
F 0 "#PWR0105" H 2500 3600 50  0001 C CNN
F 1 "+3V3" V 2515 3878 50  0000 L CNN
F 2 "" H 2500 3750 50  0001 C CNN
F 3 "" H 2500 3750 50  0001 C CNN
	1    2500 3750
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0106
U 1 1 61EF71EC
P 2500 4150
F 0 "#PWR0106" H 2500 3900 50  0001 C CNN
F 1 "GND" H 2505 3977 50  0000 C CNN
F 2 "" H 2500 4150 50  0001 C CNN
F 3 "" H 2500 4150 50  0001 C CNN
	1    2500 4150
	1    0    0    -1  
$EndComp
Text GLabel 2500 3850 0    50   Input ~ 0
A0
Text GLabel 2500 3950 0    50   Input ~ 0
A1
Text GLabel 2500 4050 0    50   Input ~ 0
A2
$EndSCHEMATC
