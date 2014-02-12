#include "BeaconMsg.h"
context group CommunicationC {
  layered BeaconMsg* createBeacon(BeaconMsg* payload);
}
implementation {
  components
    Healthy is default,
    Diseased;
}
