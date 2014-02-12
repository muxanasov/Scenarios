context LQAdaptation {
} implementation {
  uint16_t params[3] = {42,100500, 25};
  layered uint16_t* params() {
    return params;
  }
}
