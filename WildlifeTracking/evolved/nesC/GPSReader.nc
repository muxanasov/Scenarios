interface GPSReader {
  event void readDone(uint16_t lat, uint16_t lng);
}
