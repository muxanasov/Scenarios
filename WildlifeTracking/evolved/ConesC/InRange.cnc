#include "BeaconMsg.h"
context InRange {
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend;
  uses context group BatteryC;
  provides interface LogDumper;
}
implementation {
  bool busy = FALSE;
  message_t pkt;
  uint16_t pointer = STORAGE_SIZE;
  LocationMsg* buffer = NULL;
  
  command bool check() {
    return call BatteryC.getContext() == BatteryC.Normal;
  }
  
  event void activated() {
    dbg("Debug", "BS.IR activated.\n");
  }
  
  bool send(uint16_t lat, uint16_t lng) {
	LocationMsg* lmpkt = NULL;
    if (busy)
      return FALSE;
    lmpkt = (LocationMsg*)(call Packet.getPayload(&pkt, sizeof(LocationMsg)));
    if (lmpkt == NULL) {
	  return FALSE;
    }
    lmpkt->nodeid = 42;
    lmpkt->msgtype = LOCATION_TYPE;
    lmpkt->lat = lat;
    lmpkt->lng = lng;
    dbg("Debug","Send log to the BS.\n");
    busy = call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(LocationMsg)) == SUCCESS;
    return busy;
  }
  
  layered void sendLog(uint16_t lat, uint16_t lng) {
    while(!send(lat,lng)){}
  }
  
  event void AMSend.sendDone(message_t* msg, error_t err) {
	if (err == SUCCESS)
	  dbg("Debug","BS.IR send done.\n");
    busy = !((&pkt == msg)&&(((LocationMsg*)(call Packet.getPayload(&pkt, sizeof(LocationMsg))))->msgtype == LOCATION_TYPE));
    /*
    if (busy) return;
    if (buffer < STORAGE_SIZE && buffer != null) {
      while(!send(buffer[pointer].lat, bufer[pointer].lng){}
      pointer += 1;
    }
    if (pointer >= STORAGE_SIZE) buffer = NULL;
    */
  }
  
  command void LogDumper.dumpLog(LocationMsg* messages) {
	pointer = 0;
	buffer = messages;
  }
}
