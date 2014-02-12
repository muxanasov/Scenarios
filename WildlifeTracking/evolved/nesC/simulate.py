#!/usr/bin/python

import sys
import time

from BeaconMsg import *
from TOSSIM import *

t = Tossim([])
t.addChannel("Debug", sys.stdout)

# building a topology & a noise model

r = t.radio()
r.add(0, 1, -54.0)
#r.add(1, 0, -55.0)

for i in range(0,1000000):
	t.getNode(0).addNoiseTraceReading(-98)
	#t.getNode(1).addNoiseTraceReading(-98)

t.getNode(0).createNoiseModel()
#t.getNode(1).createNoiseModel()

# building a BS beacon pkt

bsmsg = BeaconMsg();
bsmsg.set_nodeid(0);
bsmsg.set_msgtype(2); # BS_TYPE

bspkt = t.newPacket();
bspkt.setData(bsmsg.data);
bspkt.setType(6)
bspkt.setDestination(0)

# building a node beacon pkt

nmsg = BeaconMsg();
nmsg.set_nodeid(0);
nmsg.set_msgtype(1); # COMMUNICATION_TYPE

npkt = t.newPacket();
npkt.setData(nmsg.data);
npkt.setType(6)
npkt.setDestination(0)

# each 100secs we will send a new BS beacon message
MSG_TIMEOUT = 100 # in sec

# communication beacon mesage will be sent a bit more frequent
COM_TIMEOUT = 10 # sec

last_time = time.time()
comm_time = time.time()

m = t.getNode(0)
m.bootAtTime(0)

#t.getNode(1).bootAtTime(0)

t.runNextEvent()

print "Simulation: sending a BS message.\n"
last_time = time.time()
bspkt.deliver(0, t.time())

while(m.isOn()):
	if (time.time() - last_time >= MSG_TIMEOUT):
		print "Simulation: seinding BS message.\n"
		last_time = time.time()
		bspkt.deliver(0, t.time())
	if (time.time() - comm_time >= COM_TIMEOUT):
		print "Simulation: seinding communication message.\n"
		comm_time = time.time()
		npkt.deliver(0, t.time())
	b = t.runNextEvent()
