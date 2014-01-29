context NotMoving {
  
  uses interface MocAccelerometer as Accelerometer;
  uses interface Timer<TMilli> as Timer;
  uses interface GPSSensor;
}
implementation{
  event void activated() {
    dbg("Debug", "L.NM is activated.\n");
    // initialize accelerometer
    call Accelerometer.start();
    call Timer.startPeriodic(1000000);
  }
  
  event void Accelerometer.startDone(error_t err) {
	if (err != SUCCESS)
	  call Accelerometer.start();
  }
  
  event void Accelerometer.stopDone(error_t err) {
	if (err != SUCCESS)
	  call Accelerometer.stop();
  }
  
  event void Timer.fired() {
    dbg("Debug", "Checking the movement...\n");
    if (call Accelerometer.isMoving()) {
      dbg("Debug", "We are moving!\n");
      // read GPS once
      call GPSSensor.read();
    }
  }
  
  event void deactivated() {
    call Accelerometer.stop();
    call Timer.stop();
    dbg("Debug", "L.NM is deactivated.\n");
  }
  
  event void GPSSensor.startDone(error_t err) {
    // pass
  }
  
  event void GPSSensor.stopDone(error_t err) {
    // pass
  }
}
