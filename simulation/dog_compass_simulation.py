import time
import math
import numpy as np

PI = math.pi
TIMESTEP = 0.1 #seconds
SAMPLE_SECONDS = 1.0

# MOCK the GPS interface
class GPS:
    def __init__(self, 
                 lat0,
                 lon0,
                 dlat = 0.0, #fake change each update
                 dlon = 0.0,
                 ):
        self._dlat = dlat
        self._dlon = dlon
        self.latitude  = lat0
        self.longitude = lon0
    
    def  update(self):
        self.latitude   += self._dlat
        self.longitude  += self._dlon
        return True
    
# The owner and the dog are somewhere in...
#Licoln, MA
LAT0 = 42.425926 
LON0 = -71.303947

#owner is walking these amounts for each TIMESTEP
OWNER_DLAT = 1e-7
OWNER_DLON = 1e-7

#initially space dog a small distance away (no spacing chokes up the single precions calc for some reason!)
DOG_LAT0_REL = 1e-7
DOG_LON0_REL = 1e-7

#dog is walking these amounts for each TIMESTEP
DOG_DLAT = -1e-7
DOG_DLON = -2e-7



gps_owner = GPS(LAT0, LON0,
                dlat=OWNER_DLAT, dlon=OWNER_DLON)
gps_dog   = GPS(LAT0+DOG_LAT0_REL, LON0+DOG_LON0_REL, 
                dlat=DOG_DLAT, dlon=DOG_DLON)

PI = math.pi

# function to get bearing from remote node to base node, given each node's lat and lon
# 'rlat, rlon' -- 'remote' node lat and lon
# 'blat, blon' -- 'base' node (i.e., this node)'s lat and lon
def getBearing(rlat,rlon,blat,blon):
    lat1=float(blat)
    lon1=float(blon)
    lat2=float(rlat)
    lon2=float(rlon)
    #print(lat1,lon1,lat2,lon2)

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
    #print("ft:",distance_feet)

    return(bearing,distance_feet)
    
def getBearing_singlePrec(rlat,rlon,blat,blon):
    lat1=np.float32(blat)
    lon1=np.float32(blon)
    lat2=np.float32(rlat)
    lon2=np.float32(rlon)
    print(lat1,lon1,lat2,lon2)

    phi1 = lat1 * PI/180.
    phi2 = lat2 * PI/180.
    lambda1 = lon1 * PI/180.
    lambda2 = lon2 * PI/180.
    y = np.sin(lambda2-lambda1)*np.cos(phi2)
    x = np.cos(phi1)*np.sin(phi2) - np.sin(phi1)*np.cos(phi2)*np.cos(lambda2-lambda1)
    theta = np.arctan2(y,x)
    bearing = np.fmod((theta*180/PI + 360),360)
    
    distance_meters = np.arccos(np.sin(lat1*PI/180.)*np.sin(lat2*PI/180.) + np.cos(lat1*PI/180.)*np.cos(lat2*PI/180.)*np.cos(lon2*PI/180.-lon1*PI/180.) ) * 6371000
    distance_feet = 3.281*distance_meters
    #print("ft:",distance_feet)

    return(bearing,distance_feet)


# main loop


ts0 = time.monotonic()
last_print = ts0

B = []
D = []
B_SP = []
D_SP = []

try:
    while True:
        time.sleep(TIMESTEP)
        gps_owner.update()
        gps_dog.update()
        
        current = time.monotonic()  
        if current - last_print >= SAMPLE_SECONDS:
            last_print = current
            
            #update the owner's position
            base_lat = gps_owner.latitude
            base_lon = gps_owner.longitude

            #update the dog's "remote" position
            r_lat = gps_dog.latitude
            r_lon = gps_dog.longitude
               
            #compute the dog's bearing from the owner 
            bearing,distance_feet       = getBearing(r_lat,r_lon,base_lat,base_lon)
            bearing_SP,distance_feet_SP = getBearing_singlePrec(r_lat,r_lon,base_lat,base_lon)
            
            B.append(bearing)
            D.append(distance_feet)
            B_SP.append(bearing_SP)
            D_SP.append(distance_feet_SP)
            
            #report   
            print("---")
            print("current time: {0:.2f}".format(current-ts0))
            print("owner coords: {0:.6f},{0:.6f}".format(base_lat,base_lon))
            print("dog coords: {0:.6f},{0:.6f}".format(r_lat,r_lon))
            print("dog bearing:",bearing)
            print("dog distance_feet:",distance_feet)
            print("dog bearing (single prec.):",bearing_SP)
            print("dog distance_feet (single prec.):",distance_feet_SP)
except KeyboardInterrupt:
    pass


import matplotlib.pyplot as plt
B = np.array(B)
D = np.array(D)
B_SP = np.array(B_SP)
D_SP = np.array(D_SP)

fig = plt.figure()
fig.suptitle("Dog Compass Bearing and Distance Computation Simulation")
ax1, ax2 = fig.subplots(nrows=2)
ax1.plot(B,"b.-", label="double prec.")
ax1.plot(B_SP,"r.-", label="single prec.")
ax1.legend()
ax1.set_ylabel("Bearing (Degrees)")
ax2.plot(D,"b.-", label="double prec.")
ax2.plot(D_SP,"r.-", label="single prec.")
ax2.legend()
ax2.set_ylabel("Distance (Feet)")
ax2.set_xlabel("Time (s)")
plt.show()


