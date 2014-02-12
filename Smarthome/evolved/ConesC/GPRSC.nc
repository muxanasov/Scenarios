#include "types.h"
module GPRSC {
  provides interface GPRS;
  uses interface Timer<TMilli> as Timer;
} implementation {
  bool started = FALSE;
  command void GPRS.send(int dest, LogMessage* msg) {
    if (!started) return;
  }
  command void GPRS.start() {
    started = TRUE;
    call Timer.startPeriodic(SAMPLING_TIMER);
  } 
  command void GPRS.stop() {
    started = FALSE;
    call Timer.stop();
  }
  event void Timer.fired() {
    LogMessage msg;
    signal GPRS.receive(&msg);
  }
}
