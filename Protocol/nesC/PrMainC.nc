#include "types.h"
module PrMainC {
  uses interface Boot;
  uses interface Timer<TMilli> as Timer;
  uses interface Read<uint16_t> as Accelerometer;
  uses interface Read<uint16_t> as Temperature;
  
  uses interface SplitControl as RadioControl;
  uses interface StdControl as RoutingControl;
  uses interface Send;
  uses interface RootControl;
  uses interface Receive;
  
  uses interface DisseminationValue<uint16_t> as Value;
  uses interface DisseminationUpdate<uint16_t> as Update;
} implementation {
  uint16_t bwParams[3] = {100500,25, 42};
  uint16_t ltParams[3] = {25,42, 36};
  uint16_t lqaParams[3] = {42,100500, 25};
  message_t packet;
  bool isBusy = FALSE;
  bool CTP = TRUE;
  bool isLifetimePriority = TRUE;
  bool isBandwidthPriority = FALSE;
  bool isLQAdaptation = FALSE;
  event void Boot.booted() {
    call Timer.startPeriodic(INTERVAL);
    call RadioControl.start();
  }
  event void RadioControl.startDone(error_t err) {
    if (err != SUCCESS){
      call RadioControl.start();
      return;
    }
    call RoutingControl.start();
    if (TOS_NODE_ID == 1)
      call RootControl.setRoot();
  }
  event void RadioControl.stopDone(error_t err){}
  uint16_t* params() {
    if (isLifetimePriority)
      return ltParams;
    if (isBandwidthPriority)
      return bwParams;
    if (isLQAdaptation)
      return lqaParams;
  }
  void setParams(uint16_t* prms) {
    // apply parameters
  }
  event void Timer.fired() {
    uint16_t* prms = params();
    call Accelerometer.read();
    call Temperature.read();
    setParams(prms);
  }
  event void Accelerometer.readDone(error_t err, uint16_t val) {
    if (err != SUCCESS) return;
    if (val > 0) CTP = FALSE;//activate ProtocolTypeG.Gossip;
    else CTP = TRUE;//activate ProtocolTypeG.CTP;
  }
  void receive(uint16_t val) {
    // estimate lq and traffic
    if (val > 15) {//activate ProtocolParametersG.LQAdaptation;
      isLifetimePriority = FALSE;
      isBandwidthPriority = FALSE;
      isLQAdaptation = TRUE;
    } else if (val < 15) {// activate ProtocolParametersG.LifetimePriority;
      isLifetimePriority = TRUE;
      isBandwidthPriority = FALSE;
      isLQAdaptation = FALSE;
    } else {//activate ProtocolParametersG.BandwidthPriority;
      isLifetimePriority = FALSE;
      isBandwidthPriority = TRUE;
      isLQAdaptation = FALSE;
    }
  }
  void send(uint16_t data) {
    if (CTP) {
      DataMessage* msg = (DataMessage*)call Send.getPayload(&packet, sizeof(DataMessage));
      msg->temperature = data;
      if (call Send.send(&packet, sizeof(DataMessage)) == SUCCESS)
        isBusy = TRUE;
    } else {
      call Update.change(&data);
    }
  }
  event void Send.sendDone(message_t* msg, error_t err) {
    isBusy = FALSE;
  }
  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
    receive(((DataMessage*)payload)->temperature);
    return msg;
  }
  event void Temperature.readDone(error_t err, uint16_t val) {
    if (err != SUCCESS) return;
    send(val);
  }
  event void Value.changed() {
    receive(*(call Value.get()));
  }
}
