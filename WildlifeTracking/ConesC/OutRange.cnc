#include "BeaconMsg.h"
context OutRange {
  uses interface LogDumper;
  uses interface GPSSensor;
}
implementation {
  LocationMsg messages[STORAGE_SIZE];
  uint16_t pointer = 0;
  
  event void activated() {
    dbg("Debug", "BS.OR activated.\n");
    call GPSSensor.start();
  }
  
  event void deactivated() {
    call GPSSensor.stop();
    dbg("Debug", "Dump log.\n");
    post dump();
  }
  
  event void GPSSensor.startDone(error_t err) {
    if (err != SUCCESS)
      call GPSSensor.start();
  }
  
  event void GPSSensor.stopDone(error_t err) {
    if (err != SUCCESS)
      call GPSSensor.stop();
  }
  
  task void dump() {
    call LogDumper.dumpLog(messages);
  }
  
  layered void sendLog(uint16_t lat, uint16_t lng) {
    LocationMsg message;
    message.nodeid = 42;
    message.msgtype = LOCATION_TYPE;
    message.lat = lat;
    message.lng = lng;
    messages[pointer] = message;
    pointer = pointer + 1;
    if (pointer >= STORAGE_SIZE) pointer = 0;
    dbg("Debug", "Log locally.\n");
  }
}
