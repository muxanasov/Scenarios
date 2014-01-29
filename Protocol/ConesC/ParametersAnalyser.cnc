module ParametersAnalyser {
  uses interface Receiver;
  uses context group ProtocolParametersG;
} implementation {
  event void Receiver.receive(uint16_t val) {
    // estimate lq and traffic
    if (val > 15) activate ProtocolParametersG.LQAdaptation;
    else if (val < 15) activate ProtocolParametersG.LifetimePriority;
    else activate ProtocolParametersG.BandwidthPriority;
  }
}
