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
L Mechanical:MountingHole H3
U 1 1 61DE17E7
P 5500 4800
F 0 "H3" H 5600 4846 50  0000 L CNN
F 1 "MountingHole" H 5600 4755 50  0000 L CNN
F 2 "MountingHole:MountingHole_2.7mm_M2.5" H 5500 4800 50  0001 C CNN
F 3 "~" H 5500 4800 50  0001 C CNN
	1    5500 4800
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole H4
U 1 1 61DE2422
P 5250 4650
F 0 "H4" H 5350 4696 50  0000 L CNN
F 1 "MountingHole" H 5350 4605 50  0000 L CNN
F 2 "MountingHole:MountingHole_2.7mm_M2.5" H 5250 4650 50  0001 C CNN
F 3 "~" H 5250 4650 50  0001 C CNN
	1    5250 4650
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole H7
U 1 1 61DE25E7
P 5500 4400
F 0 "H7" H 5600 4446 50  0000 L CNN
F 1 "MountingHole" H 5600 4355 50  0000 L CNN
F 2 "MountingHole:MountingHole_2.7mm_M2.5" H 5500 4400 50  0001 C CNN
F 3 "~" H 5500 4400 50  0001 C CNN
	1    5500 4400
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole H8
U 1 1 61DE2768
P 5800 4300
F 0 "H8" H 5900 4346 50  0000 L CNN
F 1 "MountingHole" H 5900 4255 50  0000 L CNN
F 2 "MountingHole:MountingHole_2.7mm_M2.5" H 5800 4300 50  0001 C CNN
F 3 "~" H 5800 4300 50  0001 C CNN
	1    5800 4300
	1    0    0    -1  
$EndComp
$EndSCHEMATC
