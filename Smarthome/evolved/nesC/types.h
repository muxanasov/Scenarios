#ifndef TYPES_H
#define TYPES_H

typedef nx_struct LogMessage {
	nx_uint16_t msgtype;
	nx_uint16_t nodeid;
	nx_uint16_t temperature;
	nx_uint16_t smoke;
	nx_uint16_t camera;
	nx_uint16_t light;
} LogMessage;

typedef nx_struct Prefs {
	nx_uint16_t temperature;
	nx_uint16_t light;
} Prefs;

enum {
	SAMPLING_TIMER = 1000, // 1 sec
	CRITICAL_TEMP = 100500,
	CRITICAL_SMOKE = 100500,
	CRITICAL_ACC = 100500,
	LIGHT_PREF = 100500,
	TEMPERATURE_PREF = 100500,
	NIGHT_BORDER = 22, // 10pm
	DAY_BORDER = 8, // 8am
	WEEKEND_START = 128, // 24*5+8
	WEEKEND_END = 166, // 24*6+22
	BROADCAST = 0,
	FIRE = 1,
	POLICE = 2
};

#endif // BEACONMSG_H
