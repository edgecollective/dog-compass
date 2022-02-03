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

data = genfromtxt('dual_gps.txt', delimiter=' ')

rlat=data[:,0]
rlon=data[:,1]

blat=-1*(data[:,2]+data[:,3]/60.)
blon=data[:,4]+data[:,5]/60.

r_bearing,r_feet=getBearing(np.min(rlat),np.min(rlon),np.max(rlat),np.max(rlon))
b_bearing,b_feet=getBearing(np.min(blat),np.min(blon),np.max(blat),np.max(blon))

test_bearing,test_feet=getBearing(42.4123,-71.2978,42.4124,-71.2978)
print("remote_spread:",r_feet)
print("base_spread:",b_feet)
print("test_spread:",test_feet)

plt.plot(rlat,rlon,label='remote')
plt.plot(blat,blon,label='base')
#plt.plot(rlat,blat)
plt.legend()
plt.show()

