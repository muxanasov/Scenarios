context Dark {
  uses interface Actuator as Lights;
} implementation {
  event void activated() {
    call Lights.turnOn(TRUE);
  }
}
