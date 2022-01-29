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
$EndSCHEMATC
