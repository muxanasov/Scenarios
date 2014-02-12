module LightsC {
  provides interface Actuator;
} implementation {
  command void Actuator.turnOn(bool turnOn) {
    if (turnOn) return; // turning on
    // turning off
  }
}
