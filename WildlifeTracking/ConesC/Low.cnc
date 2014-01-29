context Low {
  uses interface GPSSensor;
}
implementation {
  
  event void activated() {
    call GPSSensor.stop();
  }
  
  event void deactivated() {
    call GPSSensor.start();
  }
  
  event void GPSSensor.startDone(error_t err) {
    if (err != SUCCESS)
      call GPSSensor.start();
  }
  
  event void GPSSensor.stopDone(error_t err) {
    if (err != SUCCESS)
      call GPSSensor.stop();
  }
}
