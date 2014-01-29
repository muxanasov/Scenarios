#include "BeaconMsg.h"

context Healthy {
}
implementation {
  event void activated() {
    dbg("Debug", "C.L activated.\n");
  }
  layered BeaconMsg* createBeacon(BeaconMsg* payload) {
    if (payload == NULL) {
	  return;
    }
    payload->nodeid = 42;
    payload->msgtype = BEACONMSG_TYPE;
    return payload;
  }
}
