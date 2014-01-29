#include "types.h"
module PrMainC {
  uses context group ProtocolTypeG;
  uses context group ProtocolParametersG;
  uses interface Boot;
  uses interface Timer<TMilli> as Timer;
  uses interface Read<uint16_t> as Accelerometer;
  uses interface Read<uint16_t> as Temperature;
  uses interface Receiver;
} implementation {
  event void Boot.booted() {
    call Timer.startPeriodic(INTERVAL);
  }
  event void Timer.fired() {
    uint16_t* params = call ProtocolParametersG.params();
    call Accelerometer.read();
    call Temperature.read();
    call ProtocolTypeG.setParams(params);
  }
  event void Accelerometer.readDone(error_t err, uint16_t val) {
    if (err != SUCCESS) return;
    if (val > 0) activate ProtocolTypeG.Gossip;
    else activate ProtocolTypeG.CTP;
  }
  event void Temperature.readDone(error_t err, uint16_t val) {
    if (err != SUCCESS) return;
    call ProtocolTypeG.send(val);
  }
  event void Receiver.receive(uint16_t val) {
    // do something
  }
}
