interface GPSSensor {
  command void start();
  command void stop();
  command void read();
  event void startDone(error_t err);
  event void stopDone(error_t err);
}
