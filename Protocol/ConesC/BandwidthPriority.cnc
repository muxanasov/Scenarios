context BandwidthPriority {
} implementation {
  uint16_t params[3] = {100500,25, 42};
  layered uint16_t* params() {
    return params;
  }
}
