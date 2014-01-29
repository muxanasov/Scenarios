module TimeC {
  provides interface Read<uint16_t>;
} implementation {
  command error_t Read.read() {
    signal Read.readDone(SUCCESS, 42);
  }
}
