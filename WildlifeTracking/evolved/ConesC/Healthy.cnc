#include "BeaconMsg.h"

context Healthy {
  transitions Diseased iff LocatorC.NotMoving || LocatorC.Resting;
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
