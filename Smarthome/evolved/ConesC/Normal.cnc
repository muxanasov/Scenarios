#include "types.h"
context Normal {
  uses interface Read<uint16_t> as TemperatureSensor;
  uses interface Read<uint16_t> as LightSensor;
  uses interface GPRS;
} implementation {
  LogMessage msg;
  event void activated() {
    call GPRS.stop();
  }
  event void GPRS.receive(LogMessage* rmsg){}
  event void TemperatureSensor.readDone(error_t res, uint16_t val) {
    if (res != SUCCESS) return;
    msg.temperature = val;
  }
  event void LightSensor.readDone(error_t res, uint16_t val) {
    if (res != SUCCESS) return;
    msg.light = val;
  }
  layered void sendLog() {
    // send message to the BS
  }
}
