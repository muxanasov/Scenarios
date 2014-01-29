module GPSSensorC {
  provides interface GPSSensor;
  provides interface GPSReader;
}
implementation {
  uint16_t coords[20][2];
  uint16_t pointer = 0;
  bool isStarted = FALSE;
  command void GPSSensor.start() {
    // it's not moving for the fist 3 readings;
    coords[0][0] = 42;
    coords[0][1] = 42;
    coords[1][0] = 42;
    coords[1][1] = 42;
    coords[2][0] = 42;
    coords[2][1] = 42;
    
    // it starts moving slowly
    coords[3][0] = 44;
    coords[3][1] = 44;
    coords[4][0] = 48;
    coords[4][1] = 44;
    coords[5][0] = 48;
    coords[5][1] = 49;
    
    // it's not moving for the next 3 readings;
    coords[6][0] = 48;
    coords[6][1] = 49;
    coords[7][0] = 48;
    coords[7][1] = 49;
    coords[8][0] = 48;
    coords[8][1] = 49;
    
    // it starts moving fastly;
    coords[9][0] = 53;
    coords[9][1] = 49;
    coords[10][0] = 55;
    coords[10][1] = 55;
    coords[11][0] = 65;
    coords[11][1] = 65;
    
    // and then stops
    coords[12][0] = 70;
    coords[12][1] = 65;
    coords[13][0] = 70;
    coords[13][1] = 68;
    coords[14][0] = 70;
    coords[14][1] = 70;
    
    // it's not moving for the next 3 readings;
    coords[15][0] = 70;
    coords[15][1] = 71;
    coords[16][0] = 70;
    coords[16][1] = 70;
    coords[17][0] = 70;
    coords[17][1] = 71;
    
    // move slowly
    coords[18][0] = 73;
    coords[18][1] = 71;
    coords[19][0] = 73;
    coords[19][1] = 74;
    
    pointer = 0;
    
    isStarted = TRUE;
    signal GPSSensor.startDone(SUCCESS);
  }
  command void GPSSensor.stop() {
    isStarted = FALSE;
    signal GPSSensor.stopDone(SUCCESS);
  }
  
  command void GPSSensor.read() {
    if (!isStarted) return;
    signal GPSReader.readDone(coords[pointer][0], coords[pointer][1]);
    pointer += 1;
    if (pointer >= 20) pointer = 0;
  }
}
