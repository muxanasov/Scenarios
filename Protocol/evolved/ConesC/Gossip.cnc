context Gossip {
  provides interface Receiver;
  uses interface DisseminationValue<uint16_t> as Value;
  uses interface DisseminationUpdate<uint16_t> as Update;
} implementation {
  layered void send(uint16_t data) {
    call Update.change(&data);
  }
  layered void setParams(uint16_t* params) {
    // apply parameters
  }
  event void Value.changed() {
    signal Receiver.receive(*(call Value.get()));
  }
}
