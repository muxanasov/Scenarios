#include "BeaconMsg.h"
module WtMainC {
  uses context group LocatorC;
  uses context group BaseStationC;
  uses context group CommunicationC;
  uses context group BatteryC;

  uses interface GPSReader;
  uses interface Boot;
  uses interface Receive;
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend;
  uses interface SplitControl as AMControl;
  uses interface Read<uint16_t> as Voltage;
  uses interface Read<uint16_t> as Temperature;
  uses interface Timer<TMilli> as Timer;
  uses interface Timer<TMilli> as TimerCom;
  uses interface Timer<TMilli> as BSReset;
}
implementation {
  int16_t flag = 0;
  uint16_t beacons = 0;
  bool busy = FALSE;
  message_t pkt;
  
  event void Boot.booted()
  {
	// timer for voltage readings
    call Timer.startPeriodic(300000000);
    
    // timer to send communication beacons periodically
    call TimerCom.startPeriodic(1000000);
    
    // consider a node is not moving when is switched on
    activate LocatorC.NotMoving;
    
    activate BatteryC.Normal;
    activate BaseStationC.OutRange;
    
    // starting radio
    call AMControl.start();
  }
  
  event void AMControl.startDone(error_t err) {
    if (err != SUCCESS)
      call AMControl.start();
    else {
	  // if radio is started succesfully, starting to send beacons
      //activate CommunicationC.NotLeader;
    }
  }
  
  event void AMControl.stopDone(error_t err) {
    if (err != SUCCESS)
      call AMControl.stop();
  }
  
  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
	// we can receive several types of messages
	dbg("Debug", "Received message.\n");
    if (len == sizeof(BeaconMsg)) {
      BeaconMsg* bmpkt = (BeaconMsg*)payload;
      uint16_t type = bmpkt->msgtype;
      dbg("Debug", "Type %d.\n", type);
      switch(type) {
        case BEACONMSG_TYPE: // a communcation beacon
          // check if the beacon is unique
          beacons = beacons + 1;
          //if (beacons >= MAX_BEACONS)
          //  activate CommunicationC.Leader;
          call BaseStationC.sendLog(42,42);
          break;
        case BSBEACON_TYPE: // a beacon from BS
          // reset watch dog timer
          call BSReset.startOneShot(BSBEACON_TIMEOUT);
          activate BaseStationC.InRange;
          break;
        default:
      }
    }
    return msg;
  }
  
  event void BSReset.fired() {
	// if no beacons were received during the BSReset timeout
    activate BaseStationC.OutRange;
  }
  
  void sendBeacon() {
    if (busy) return;
    busy = call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(BeaconMsg)) == SUCCESS;
    dbg("Debug", "C.NL Send success, waiting... %d.\n", busy);
  }
  
  event void TimerCom.fired() {
    call Temperature.read();
  }
  
  event void AMSend.sendDone(message_t* msg, error_t err) {
	dbg("Debug", "C.NL Send done %d.\n", busy);
    if (&pkt == msg) {
		BeaconMsg* msgpayload = (BeaconMsg*)(call Packet.getPayload(msg, sizeof(BeaconMsg)));
		BeaconMsg* pktpayload = (BeaconMsg*)(call Packet.getPayload(&pkt, sizeof(BeaconMsg)));
		busy = !(msgpayload->msgtype == pktpayload->msgtype); 
	}
  }
  
  event void Temperature.readDone(error_t err, uint16_t data) {
    float sample;
    if (err != SUCCESS) return;
    sample = -39 + 0.01*data;
    if (sample >= CRITICAL_TEMP)
      activate CommunicationC.Diseased;
    else
      activate CommunicationC.Healthy;
    call CommunicationC.createBeacon((BeaconMsg*)(call Packet.getPayload(&pkt, sizeof(BeaconMsg))));
    sendBeacon();
  }
  
  event void Timer.fired() {
	// read voltage lvl
	call Voltage.read();
  }
  
  event void Voltage.readDone(error_t err, uint16_t val) {
	uint16_t lvl = val;
	if (err != SUCCESS) return;
	// analyzing
	// TODO: calculate %
	if (lvl >= NORMAL_LVL)
	  activate BatteryC.Normal;
	else
	  activate BatteryC.Low;
  }
  
  event void BatteryC.contextChanged(context_t con) {
  
  }
  
  event void CommunicationC.contextChanged(context_t con){
    //dbg("Debug", "Communication context changed %d.\n", con);
  }
  
  event void BaseStationC.contextChanged(context_t con){
    //dbg("Debug", "BaseStation context changed %d.\n", con);
  }
  
  event void LocatorC.contextChanged(context_t con){
    //dbg("Debug", "Locator context changed %d.\n", con);
  }
  
  uint16_t prevLat = 0;
  uint16_t prevLng = 0;
  
  event void GPSReader.readDone(uint16_t lat, uint16_t lng) {
	uint16_t difference = 0;
    dbg("Debug", "Main: GPS read Done. Logging. %d %d\n", lat, lng);
    call BaseStationC.sendLog(lat, lng);
    // analyzing readings to detect a state
    if (prevLat != 0 && prevLng != 0) {
      difference = (lat-prevLat)*(lat-prevLat)+(lng-prevLng)*(lng-prevLng);
      if (difference <= NEGLIGIBLE_DIFFERENCE )
        activate LocatorC.NotMoving;
      else if (SMALL_DIFFERENCE >= difference && difference > NEGLIGIBLE_DIFFERENCE)
        activate LocatorC.Resting;
      else if (difference > SMALL_DIFFERENCE)
        activate LocatorC.Running;
	}
	prevLat = lat;
    prevLng = lng;
  }
}
