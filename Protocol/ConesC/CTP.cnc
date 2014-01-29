#include "types.h"
context CTP {
  provides interface Receiver;
  uses interface SplitControl as RadioControl;
  uses interface StdControl as RoutingControl;
  uses interface Send;
  uses interface RootControl;
  uses interface Receive;
} implementation {
  message_t packet;
  bool isBusy = FALSE;
  event void activated() {
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
  layered void setParams(uint16_t* params) {
    // apply parameters
  }
  layered void send(uint16_t data) {
    DataMessage* msg = (DataMessage*)call Send.getPayload(&packet, sizeof(DataMessage));
    msg->temperature = data;
    if (call Send.send(&packet, sizeof(DataMessage)) == SUCCESS)
      isBusy = TRUE;
  }
  event void Send.sendDone(message_t* msg, error_t err) {
    isBusy = FALSE;
  }
  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
    signal Receiver.receive(((DataMessage*)payload)->temperature);
    return msg;
  }
}
