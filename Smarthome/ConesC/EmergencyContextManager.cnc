#include "types.h"
module EmergencyContextManager {
  uses context group EmergencyG;
  uses interface Read<uint16_t> as TemperatureSensor;
  uses interface Read<uint16_t> as SmokeSensor;
  uses interface Read<uint16_t> as Accelerometer;
} implementation {
  uint16_t temp = 0;
  uint16_t smoke = 0;
  uint16_t acc = 0;
  void handle() {
    if (temp >= CRITICAL_TEMP &&
        smoke >= CRITICAL_SMOKE) activate EmergencyG.Fire;
    else if ( acc >= CRITICAL_ACC) activate EmergencyG.Housebreaking;
    else activate EmergencyG.Normal;
  }
  event void TemperatureSensor.readDone(error_t res, uint16_t val) {
    if (res != SUCCESS) return;
    temp = val;
    handle();
  }
  event void SmokeSensor.readDone(error_t res, uint16_t val) {
    if (res != SUCCESS) return;
    smoke = val;
    handle();
  }
  event void Accelerometer.readDone(error_t res, uint16_t val) {
    if (res != SUCCESS) return;
    acc = val;
    handle();
  }
}
