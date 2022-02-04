from matplotlib import pyplot as plt 
import numpy as np  
from numpy import genfromtxt
import math
import time

PI=math.pi

def getBearing(lat1,lon1,lat2,lon2):

    phi1 = lat1 * PI/180.
    phi2 = lat2 * PI/180.
    lambda1 = lon1 * PI/180.
    lambda2 = lon2 * PI/180.
    y = math.sin(lambda2-lambda1)*math.cos(phi2)
    x = math.cos(phi1)*math.sin(phi2) - math.sin(phi1)*math.cos(phi2)*math.cos(lambda2-lambda1)

    theta = math.atan2(y,x)
    bearing = math.fmod((theta*180/PI + 360),360)

    distance_meters = math.acos(math.sin(lat1*PI/180.)*math.sin(lat2*PI/180.) + math.cos(lat1*PI/180.)*math.cos(lat2*PI/180.)*math.cos(lon2*PI/180.-lon1*PI/180.) ) * 6371000
    distance_feet = 3.281*distance_meters

    return(bearing,distance_feet)

data = genfromtxt('output.txt', delimiter=',')

rlat=data[:,0]
rlon=data[:,1]
blat=data[:,2]
blon=data[:,3]

plt.plot(rlat,rlon,label='remote')
plt.plot(blat,blon,label='base')
#plt.plot(rlat,blat)
plt.title("Indoors; separated by 20 feet")
plt.legend()
plt.show()

