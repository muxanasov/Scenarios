context Running {
  uses interface Timer<TMilli> as Timer;
  uses interface GPSSensor;
}
implementation{
  event void activated() {
    dbg("Debug", "L.Ru is activated.\n");
    call Timer.startPeriodic( 100000 );
  }
  event void deactivated() {
    dbg("Debug", "L.Ru is deactivated.\n");
    call Timer.stop();
  }
  
  event void Timer.fired() {
    dbg("Debug", "L.Ru readGPS.\n");
    call GPSSensor.read();
  }
  
  event void GPSSensor.startDone(error_t err) {
    // pass
  }
  
  event void GPSSensor.stopDone(error_t err) {
    // pass
  }
}
