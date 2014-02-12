#include "types.h"
module ShMainC {
  uses interface Read<uint16_t> as TemperatureSensor;
  uses interface Read<uint16_t> as LightSensor;
  uses interface Read<uint16_t> as SmokeSensor;
  uses interface Read<uint16_t> as Camera;
  uses interface Read<uint16_t> as Accelerometer;
  uses interface Read<uint16_t> as Time;
  uses interface GPRS;
  uses interface Actuator as Lights;
  uses interface Actuator as Heater;
  uses interface Actuator as Conditioner;
  uses interface Timer<TMilli> as SamplingTimer;
  uses interface Boot;
  uses interface SplitControl as RadioControl;
  uses interface StdControl as RoutingControl;
  uses interface Send;
  uses interface RootControl;
  uses interface Receive;
} implementation {
  bool isDay = FALSE;
  bool isNight = TRUE;
  bool isWeekend = FALSE;
  bool isNormal = TRUE;
  bool isFire = FALSE;
  bool isHousebreaking = FALSE;
  bool isStatusNormal = TRUE;
  LogMessage msg;
  message_t packet;
  bool isBusy = FALSE;
  uint16_t acc = 0;
  event void Boot.booted() {
    call SamplingTimer.startPeriodic(SAMPLING_TIMER);
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
  event void GPRS.receive(LogMessage* rmsg){}
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
  nx_uint16_t buildStatus() {
    if (isStatusNormal) return STATUS_OK;
    else return STATUS_FAILURE;
  }
  void sendLog() {
    if (isNormal) {
      msg.status = buildStatus();
      // send msg to BS
    } else if (isFire) {
      call GPRS.send(FIRE,&msg);
      send(&msg);
    } else if (isHousebreaking) {
      call GPRS.send(POLICE,&msg);
    }
  }
  event void SamplingTimer.fired() {
    call TemperatureSensor.read();
    call LightSensor.read();
    call SmokeSensor.read();
    call Camera.read();
    call Accelerometer.read();
    call Time.read();
    sendLog();
  }
  event void Time.readDone(error_t res, uint16_t val) {
    if (res != SUCCESS) {
      isStatusNormal = FALSE;
      return;
    }
    isStatusNormal = TRUE;
    if (val % DAY_BORDER == 0 && !isWeekend) { // activate LightIntencityG.Day;
      isDay = TRUE;
      isNight = FALSE;
      isWeekend = FALSE;
    } else if (val % NIGHT_BORDER == 0 && !isWeekend) { // activate LightIntencityG.Night;
      isDay = FALSE;
      isNight = TRUE;
      isWeekend = FALSE;
    } else if (val % WEEKEND_START == 0) { // activated LightIntencityG.Weekend;
      isDay = FALSE;
      isNight = FALSE;
      isWeekend = TRUE;
    } else if (val % WEEKEND_END == 0 && val % NIGHT_BORDER == 0) { // activate LightIntencutyG.Night;
      isDay = FALSE;
      isNight = TRUE;
      isWeekend = FALSE;
    }
  }
  void handle() {
    if (msg.temperature >= CRITICAL_TEMP &&
        msg.smoke >= CRITICAL_SMOKE) { // activate EmergencyG.Fire;
      call GPRS.start();
      call RadioControl.start();
      isFire = TRUE;
      isNormal = FALSE;
      isHousebreaking = FALSE;
    } else if ( acc >= CRITICAL_ACC) { // activate EmergencyG.Housebreaking;
      call GPRS.start();
      call RoutingControl.stop();
      call RadioControl.stop();
      isFire = FALSE;
      isNormal = FALSE;
      isHousebreaking = TRUE;
    } else { // activate EmergencyG.Normal;
      call GPRS.stop();
      call RoutingControl.stop();
      call RadioControl.stop();
      isFire = FALSE;
      isNormal = TRUE;
      isHousebreaking = FALSE;
    }
  }
  Prefs* prefs() {
    Prefs prfs;
    if (isDay) {
      prfs.temperature = 25;
      prfs.light = 100500;
    } else if (isNight) {
      prfs.temperature = 30;
      prfs.light = 0;
    } else if (isWeekend) {
      prfs.temperature = 30;
      prfs.light = 100500;
    }
    return &prfs;
  }
  event void TemperatureSensor.readDone(error_t res, uint16_t val) {
    uint16_t prfs;
    if (res != SUCCESS) {
      isStatusNormal = FALSE;
      return;
    }
    isStatusNormal = TRUE;
    msg.temperature = val;
    prfs = prefs()->temperature;
    if (val == prfs) { // activate ClimateG.NormalClm;
      call Heater.turnOn(FALSE);
      call Conditioner.turnOn(FALSE);
    } else if (val < prfs) { // activate ClimateG.Low;
      call Heater.turnOn(TRUE);
      call Conditioner.turnOn(FALSE);
    } else if (val > prfs) { //activate ClimateG.High;
      call Heater.turnOn(FALSE);
      call Conditioner.turnOn(TRUE);
    }
    handle();
  }
  event void LightSensor.readDone(error_t res, uint16_t val) {
    uint16_t prfs;
    if (res != SUCCESS) {
      isStatusNormal = FALSE;
      return;
    }
    isStatusNormal = TRUE;
    msg.light = val;
    prfs = prefs()->light;
    if (val >= prfs) call Lights.turnOn(FALSE); // activate LightIntencityG.Bright;
    else call Lights.turnOn(TRUE); // activate LightIntencityG.Dark;
  }
  event void SmokeSensor.readDone(error_t res, uint16_t val) {
    if (res != SUCCESS) {
      isStatusNormal = FALSE;
      return;
    }
    isStatusNormal = TRUE;
    msg.smoke = val;
    handle();
  }
  event void Camera.readDone(error_t res, uint16_t val) {
    if (res != SUCCESS) {
      isStatusNormal = FALSE;
      return;
    }
    isStatusNormal = TRUE;
    msg.camera = val;
  }
  event void Accelerometer.readDone(error_t res, uint16_t val) {
    if (res != SUCCESS) {
      isStatusNormal = FALSE;
      return;
    }
    isStatusNormal = TRUE;
    acc = val;
    handle();
  }
}
