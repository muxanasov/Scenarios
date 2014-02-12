interface MocAccelerometer {
  command bool isMoving();
  command void start();
  command void stop();
  event void startDone(error_t err);
  event void stopDone(error_t err);
}
