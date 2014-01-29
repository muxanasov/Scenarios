context group BaseStationC {
  layered void sendLog(uint16_t lat, uint16_t lng);
}
implementation {
  components
    InRange,
    OutRange is default,
    GPSSensorC,
    new AMSenderC(AM_BEACON);
    
  InRange.Packet -> AMSenderC;
  InRange.AMPacket -> AMSenderC;
  InRange.AMSend -> AMSenderC;
  OutRange.GPSSensor -> GPSSensorC;
  OutRange.LogDumper -> InRange;
}
