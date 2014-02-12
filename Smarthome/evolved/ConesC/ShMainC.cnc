#include "types.h"
module ShMainC {
  uses context group EmergencyG;
  uses context group LightIntencityG;
  uses context group ClimateG;
  uses context group PreferencesG;
  uses interface Read<uint16_t> as TemperatureSensor;
  uses interface Read<uint16_t> as LightSensor;
  uses interface Read<uint16_t> as SmokeSensor;
  uses interface Read<uint16_t> as Camera;
  uses interface Read<uint16_t> as Accelerometer;
  uses interface Read<uint16_t> as Time;
  uses interface Timer<TMilli> as SamplingTimer;
  uses interface Boot;
} implementation {
  event void Boot.booted() {
    call SamplingTimer.startPeriodic(SAMPLING_TIMER);
  }
  event void SamplingTimer.fired() {
    call TemperatureSensor.read();
    call LightSensor.read();
    call SmokeSensor.read();
    call Camera.read();
    call Accelerometer.read();
    call EmergencyG.sendLog();
  }
  event void Time.readDone(error_t res, uint16_t val) {
    if (res != SUCCESS) return;
    if (val % DAY_BORDER == 0 && call PreferencesG.getContext() != PreferencesG.Weekend) 
      activate PreferencesG.Day;
    else if (val % NIGHT_BORDER == 0 && call PreferencesG.getContext() != PreferencesG.Weekend) 
      activate PreferencesG.Night;
    else if (val % WEEKEND_START == 0) activate PreferencesG.Weekend;
    else if (val % WEEKEND_END == 0 && val % NIGHT_BORDER == 0) activate PreferencesG.Night;
  }
  event void TemperatureSensor.readDone(error_t res, uint16_t val) {
    uint16_t prefs;
    if (res != SUCCESS) return;
    prefs = (call PreferencesG.prefs())->temperature;
    if (val == prefs) activate ClimateG.NormalClm;
    else if (val < prefs) activate ClimateG.Low;
    else if (val > prefs) activate ClimateG.High;
  }
  event void LightSensor.readDone(error_t res, uint16_t val) {
    uint16_t prefs;
    if (res != SUCCESS) return;
    prefs = (call PreferencesG.prefs())->light;
    if (val >= prefs) activate LightIntencityG.Bright;
    else activate LightIntencityG.Dark;
  }
  event void SmokeSensor.readDone(error_t res, uint16_t val) {}
  event void Camera.readDone(error_t res, uint16_t val) {}
  event void Accelerometer.readDone(error_t res, uint16_t val) {}
}
