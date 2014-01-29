context group ProtocolParametersG {
  layered uint16_t* params();
} implementation {
  contexts LQAdaptation, LifetimePriority is default, BandwidthPriority;
}
