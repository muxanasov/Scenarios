configuration PrMainAppC {
} implementation {
  components
    ProtocolParametersG,
    ParametersAnalyser,
    ProtocolTypeG,
    AccelerometerC,
    MainC,
    PrMainC,
    new TimerMilliC() as Timer,
    new SensirionSht11C() as THSensor;
    
  PrMainC.Boot -> MainC;
  PrMainC.Timer -> Timer;
  PrMainC.ProtocolParametersG -> ProtocolParametersG;
  ParametersAnalyser.ProtocolParametersG -> ProtocolParametersG;
  PrMainC.ProtocolTypeG -> ProtocolTypeG;
  PrMainC.Receiver -> ProtocolTypeG;
  ParametersAnalyser.Receiver -> ProtocolTypeG;
  PrMainC.Accelerometer -> AccelerometerC;
  PrMainC.Temperature -> THSensor.Temperature;
}
