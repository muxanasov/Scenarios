#ifndef BEACONMSG_H
#define BEACONMSG_H

typedef nx_struct BeaconMsg {
	nx_uint16_t msgtype;
	nx_uint16_t nodeid;
} BeaconMsg;

typedef nx_struct LocationMsg {
	nx_uint16_t msgtype;
	nx_uint16_t nodeid;
	nx_uint16_t lat;
	nx_uint16_t lng;
} LocationMsg;

enum {
	BEACONMSG_TYPE = 1,
	BSBEACON_TYPE = 2,
	LOCATION_TYPE = 3,
	ALERTBEACON_TYPE = 4,
	AM_BEACON = 6,
	STORAGE_SIZE = 10,
	SMALL_DIFFERENCE = 25, // we store 5^2
	NEGLIGIBLE_DIFFERENCE = 4, // we store 2^2
	NORMAL_LVL = 25, // low border of a normal lvl in %
	MAX_BEACONS = 10,
	BSBEACON_TIMEOUT = 500000000,
	CRITICAL_TEMP = 40 // critical temperature in C
};

#endif // BEACONMSG_H
