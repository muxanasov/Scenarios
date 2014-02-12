context group ProtocolParametersG {
  layered uint16_t* params();
} implementation {
  contexts LifetimePriority is default, BandwidthPriority;
}
