#ifndef TYPES_H
#define TYPES_H

typedef nx_struct DataMessage {
	nx_uint16_t temperature;
} DataMessage;

enum {
	INTERVAL = 1000 // 1 sec
};

#endif // BEACONMSG_H
