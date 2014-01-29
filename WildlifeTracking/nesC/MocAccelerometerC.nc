module MocAccelerometerC {
  provides interface MocAccelerometer;
}
implementation {
  bool fakedata[10];
  uint16_t pointer = -2;

  command void MocAccelerometer.start() {
    fakedata[0] = FALSE;
    fakedata[1] = TRUE;
    fakedata[2] = FALSE;
    fakedata[3] = FALSE;
    fakedata[4] = FALSE;
    fakedata[5] = FALSE;
    fakedata[6] = FALSE;
    fakedata[7] = FALSE;
    fakedata[8] = FALSE;
    fakedata[9] = FALSE;
    pointer = -1;
    signal MocAccelerometer.startDone(SUCCESS);
  }
  
  command void MocAccelerometer.stop() {
    pointer = -2;
    signal MocAccelerometer.stopDone(SUCCESS);
  }
  
  command bool MocAccelerometer.isMoving() {
    if (pointer == -2) return FALSE;
    pointer += 1;
    if (pointer >= 2) pointer = 0;
    return fakedata[pointer];
  }
}
