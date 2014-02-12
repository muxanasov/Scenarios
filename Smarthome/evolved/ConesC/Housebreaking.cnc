#include "types.h"
context Housebreaking {
  uses interface Read<uint16_t> as Camera;
  uses interface GPRS;
} implementation {
  LogMessage msg;
  event void activated() {
    call GPRS.start();
  }
  event void GPRS.receive(LogMessage* rmsg){}
  event void Camera.readDone(error_t res, uint16_t val) {
    if (res != SUCCESS) return;
    msg.camera = val;
  }
  layered void sendLog() {
    call GPRS.send(POLICE, &msg);
  }
}
