#include "BeaconMsg.h"
module WtMainC {
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend;
  
  uses interface Packet as LogPacket;
  uses interface AMPacket as BSPacket;
  uses interface AMSend as BSSend;
	
  uses interface GPSReader;
  uses interface GPSSensor;
  uses interface MocAccelerometer as Accelerometer;
  uses interface Boot;
  uses interface Receive;
  uses interface SplitControl as AMControl;
  uses interface Read<uint16_t> as Voltage;
  uses interface Read<uint16_t> as Temperature;
  uses interface Timer<TMilli> as Timer;
  uses interface Timer<TMilli> as TimerCom;
  uses interface Timer<TMilli> as BSReset;
  uses interface Timer<TMilli> as GPSTimer;
  uses interface Timer<TMilli> as AccTimer;
}
implementation {
  int16_t flag = 0;
  uint16_t beacons = 0;
  bool busy = FALSE;
  message_t pkt;
  bool bsBusy = FALSE;
  message_t bspkt;
  bool isDiseased = FALSE;
  bool inRange = FALSE;
  LocationMsg messages[STORAGE_SIZE];
  uint16_t pointer = 0;
  event void Boot.booted() {
    call Timer.startPeriodic(300000000);
    call TimerCom.startPeriodic(1000000);
    call AccTimer.startPeriodic(1000000);
    call Accelerometer.start();
    call GPSSensor.start();
    call AMControl.start();
  }
  event void Accelerometer.startDone(error_t err) {
	if (err != SUCCESS)
	  call Accelerometer.start();
  }
  event void Accelerometer.stopDone(error_t err) {
	if (err != SUCCESS)
	  call Accelerometer.stop();
  }
  event void AccTimer.fired() {
    dbg("Debug", "Checking the movement...\n");
    if (call Accelerometer.isMoving()) {
      dbg("Debug", "We are moving!\n");
      call GPSSensor.read();
    }
  }
  event void GPSTimer.fired() {
	call GPSSensor.read();
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
  void sendLog(uint16_t lat, uint16_t lng) {
	if (!inRange) {
	  LocationMsg message;
      message.nodeid = 42;
      message.msgtype = LOCATION_TYPE;
      message.lat = lat;
      message.lng = lng;
      messages[pointer] = message;
      pointer = pointer + 1;
      if (pointer >= STORAGE_SIZE) pointer = 0;
      dbg("Debug", "Log locally.\n");
	} else {
	  LocationMsg* lmpkt = NULL;
      if (bsBusy)
        return;
      lmpkt = (LocationMsg*)(call LogPacket.getPayload(&pkt, sizeof(LocationMsg)));
      if (lmpkt == NULL) {
	    return;
      }
      lmpkt->nodeid = 42;
      lmpkt->msgtype = LOCATION_TYPE;
      lmpkt->lat = lat;
      lmpkt->lng = lng;
      dbg("Debug","Send log to the BS.\n");
      bsBusy = call BSSend.send(AM_BROADCAST_ADDR, &bspkt, sizeof(LocationMsg)) == SUCCESS;
	}
  }
  event void BSSend.sendDone(message_t* msg, error_t err) {
	if (err == SUCCESS)
	  dbg("Debug","BS.IR send done.\n");
    bsBusy = !((&bspkt == msg)&&(((LocationMsg*)(call LogPacket.getPayload(&bspkt, sizeof(LocationMsg))))->msgtype == LOCATION_TYPE));
  }
  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
	// we can receive several types of messages
	dbg("Debug", "Received message.\n");
    if (len == sizeof(BeaconMsg)) {
      BeaconMsg* bmpkt = (BeaconMsg*)payload;
      uint16_t type = bmpkt->msgtype;
      dbg("Debug", "Type %d.\n", type);
      switch(type) {
        case ALERTBEACON_TYPE:
        case BEACONMSG_TYPE: // a communcation beacon
          // check if the beacon is unique
          beacons = beacons + 1;
          sendLog(42, 42);//call BaseStationC.sendLog(42,42);
          break;
        case BSBEACON_TYPE: // a beacon from BS
          // reset watch dog timer
          call BSReset.startOneShot(BSBEACON_TIMEOUT);
          inRange = TRUE;
          dbg("Debug", "Dump log.\n");
          //activate BaseStationC.InRange;
          break;
        default:
      }
    }
    return msg;
  }
  event void BSReset.fired() {
	dbg("Debug", "BSeset fired.\n");
    inRange = FALSE;
  }
  void sendBeacon() {
	BeaconMsg* bmpkt = NULL;
    dbg("Debug", "Sending beacon.\n");
    if (busy)
      return;
    bmpkt = (BeaconMsg*)(call Packet.getPayload(&pkt, sizeof(BeaconMsg)));
    if (bmpkt == NULL) {
	  return;
    }
    bmpkt->nodeid = 42;
    if (!isDiseased)
      bmpkt->msgtype = BEACONMSG_TYPE;
    else bmpkt->msgtype = ALERTBEACON_TYPE;
    busy = call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(BeaconMsg)) == SUCCESS;
    dbg("Debug", "C.NL Send success, waiting... %d.\n", busy);
  }
  event void TimerCom.fired() {
	call Temperature.read();
  }
  event void Temperature.readDone(error_t err, uint16_t data) {
	float sample;
    if (err != SUCCESS) return;
    sample = -39 + 0.01*data;
    if (sample >= CRITICAL_TEMP)
      isDiseased = TRUE;
    else
      isDiseased = FALSE;
    sendBeacon();
  }
  event void AMSend.sendDone(message_t* msg, error_t err) {
	dbg("Debug", "C.NL Send done %d.\n", busy);
    if (&pkt == msg) {
		BeaconMsg* pktpayload = (BeaconMsg*)(call Packet.getPayload(&pkt, sizeof(BeaconMsg)));
		BeaconMsg* msgpayload = (BeaconMsg*)(call Packet.getPayload(msg, sizeof(BeaconMsg)));
		busy = !(pktpayload->msgtype == msgpayload->msgtype); 
	}
  }
  event void Timer.fired() {
	call Voltage.read();
  }
  event void Voltage.readDone(error_t err, uint16_t val) {
	uint16_t lvl = val;
	if (err != SUCCESS) return;
	if (lvl >= NORMAL_LVL)
	  call GPSSensor.start();
	else
	  call GPSSensor.stop();
  }
  event void GPSSensor.startDone(error_t err) {
    if (err != SUCCESS)
      call GPSSensor.start();
  }
  event void GPSSensor.stopDone(error_t err) {
    if (err != SUCCESS)
      call GPSSensor.stop();
  }
  uint16_t prevLat = 0;
  uint16_t prevLng = 0;
  event void GPSReader.readDone(uint16_t lat, uint16_t lng) {
	uint16_t difference = 0;
    dbg("Debug", "Main: GPS read Done. Logging. %d %d\n", lat, lng);
    sendLog(lat, lng);
    if (prevLat != 0 && prevLng != 0) {
      difference = (lat-prevLat)*(lat-prevLat)+(lng-prevLng)*(lng-prevLng);
      if (difference <= NEGLIGIBLE_DIFFERENCE ) {
        call GPSTimer.stop();
        call AccTimer.startPeriodic(1000000);
        call Accelerometer.start();
      } else if (SMALL_DIFFERENCE >= difference && difference > NEGLIGIBLE_DIFFERENCE) {
        call AccTimer.stop();
        call Accelerometer.stop();
        call GPSTimer.startPeriodic(1000000);
      } else if (difference > SMALL_DIFFERENCE) {
        call AccTimer.stop();
        call Accelerometer.stop();
        call GPSTimer.startPeriodic(100000);
	  }
	}
	prevLat = lat;
    prevLng = lng;
  }
}
