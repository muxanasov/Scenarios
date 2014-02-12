#include "BeaconMsg.h"

context Diseased {
}
implementation {
  event void activated() {
    dbg("Debug", "C.NL activated.\n");
  }
  
  layered BeaconMsg* createBeacon(BeaconMsg* payload) {
    if (payload == NULL) {
	  return;
    }
    payload->nodeid = 42;
    payload->msgtype = ALERTBEACON_TYPE;
    return payload;
  }
}
