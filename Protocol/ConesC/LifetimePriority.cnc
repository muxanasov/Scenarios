context LifetimePriority {
} implementation {
  uint16_t params[3] = {25,42, 36};
  layered uint16_t* params() {
    return params;
  }
}
