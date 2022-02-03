from matplotlib import pyplot as plt 
import numpy as np  
from numpy import genfromtxt
import math

my_data = genfromtxt('gps.txt', delimiter=' ')

lats=my_data[:,0]
lons=my_data[:,1]

PI = math.pi

def getBearing(lat1,lon1,lat2,lon2):

    phi1 = lat1 * PI/180.
    phi2 = lat2 * PI/180.
    lambda1 = lon1 * PI/180.
    lambda2 = lon2 * PI/180.
    y = math.sin(lambda2-lambda1)*math.cos(phi2)
    x = math.cos(phi1)*math.sin(phi2) - math.sin(phi1)*math.cos(phi2)*math.cos(lambda2-lambda1)
    
    print(y,x) 
    theta = math.atan2(y,x)
    bearing = math.fmod((theta*180/PI + 360),360)
    
    distance_meters = math.acos(math.sin(lat1*PI/180.)*math.sin(lat2*PI/180.) + math.cos(lat1*PI/180.)*math.cos(lat2*PI/180.)*math.cos(lon2*PI/180.-lon1*PI/180.) ) * 6371000
    distance_feet = 3.281*distance_meters
    print("ft:",distance_feet)

    return(bearing,distance_feet)

#a = np.array([22,87,5,43,56,73,55,54,11,20,51,5,79,31,27]) 
bins=np.arange(min(lats),max(lats),5)
#print(a)
print("std:",np.std(lats))
print("std_err:",np.std(lats)/math.sqrt(len(lats)))
lon_fixed=-71.29804155012758

lat_min=42.247000
lat_max=42.247600

bearing,feet=getBearing(lat_min,lon_fixed,lat_max,lon_fixed)
#plt.plot(lats)
print("delta Feet:",feet)
plt.hist(lats, bins = bins) 
plt.title("hist(latitude)") 
plt.show()