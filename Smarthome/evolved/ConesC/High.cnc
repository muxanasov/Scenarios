context High {
  transitions NormalClm;
  uses interface Actuator as Conditioner;
} implementation {
  event void activated() {
    call Conditioner.turnOn(TRUE);
  }
  event void deactivated() {
    call Conditioner.turnOn(FALSE);
  }
}
