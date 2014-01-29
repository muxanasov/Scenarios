#include "types.h"
interface GPRS {
  command void start();
  command void stop();
  command void send(int16_t dest, LogMessage* msg);
  event void receive(LogMessage *msg);
}
