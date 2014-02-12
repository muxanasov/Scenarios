context Low {
  transitions NormalClm;
  uses interface Actuator as Heater;
} implementation {
  event void activated() {
    call Heater.turnOn(TRUE);
  }
  event void deactivated() {
    call Heater.turnOn(FALSE);
  }
}
