context Resting {
  uses interface Timer<TMilli> as Timer;
  uses interface GPSSensor;
}
implementation{
  event void activated() {
    dbg("Debug", "L.Re is activated.\n");
    call Timer.startPeriodic( 1000000 );
  }
  event void deactivated() {
    dbg("Debug", "L.Re is deactivated.\n");
    call Timer.stop();
  }
  
  event void Timer.fired() {
    dbg("Debug", "L.Re ReadGPS.\n");
    call GPSSensor.read();
  }
  
  event void GPSSensor.startDone(error_t err) {
    // pass
  }
  
  event void GPSSensor.stopDone(error_t err) {
    // pass
  }
}
