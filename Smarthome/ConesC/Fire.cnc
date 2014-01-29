#include "types.h"
context Fire {
  transitions Normal;
  uses interface Read<uint16_t> as Camera;
  uses interface Read<uint16_t> as TemperatureSensor;
  uses interface Read<uint16_t> as SmokeSensor;
  uses interface GPRS;
  uses interface SplitControl as RadioControl;
  uses interface StdControl as RoutingControl;
  uses interface Send;
  uses interface RootControl;
  uses interface Receive;
} implementation {
  LogMessage msg;
  message_t packet;
  bool isBusy = FALSE;
  event void activated() {
    call GPRS.start();
    call RadioControl.start();
  }
  event void deactivated() {
    call RoutingControl.stop();
    call RadioControl.stop();
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
  event void GPRS.receive(LogMessage* rmsg){
    // do some stuff
  }
  event void Camera.readDone(error_t res, uint16_t val) {
    if (res != SUCCESS) return;
    msg.camera = val;
  }
  event void TemperatureSensor.readDone(error_t res, uint16_t val) {
    if (res != SUCCESS) return;
    msg.temperature = val;
  }
  event void SmokeSensor.readDone(error_t res, uint16_t val) {
    if (res != SUCCESS) return;
    msg.smoke = val;
  }
  send(LogMessage* data) {
    LogMessage* m = (LogMessage*)call Send.getPayload(&packet, sizeof(LogMessage));
    memcpy(m,data,sizeof(LogMessage));
    if (call Send.send(&packet, sizeof(LogMessage)) == SUCCESS)
      isBusy = TRUE;
  }
  event void Send.sendDone(message_t* m, error_t err) {
    isBusy = FALSE;
  }
  event message_t* Receive.receive(message_t* m, void* payload, uint8_t len) {
    // do some stuff
    return m;
  }
  layered void sendLog() {
    send(&msg);
    call GPRS.send(FIRE, &msg);
  }
}
