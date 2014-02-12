configuration WtMainAppC {
}
implementation {
  components
    EmergencyGConfiguration,
    SmokeC,
    CameraC,
    MainC,
    new SensirionSht11C() as THSensor,
    new HamamatsuS1087ParC() as LSensor,
    new TimerMilliC() as SamplingTimer;
  EmergencyG.Camera -> CameraC;
  ShMainC.Camera -> CameraC;
  ShMainC.SamplingTimer -> SamplingTimer;
  ShMainC.LightSensor -> LSensor;
  EmergencyG.SmokeSensor -> SmokeC;
  ShMainC.TemperatureSensor -> THSensor.Temperature;
  ShMainC.Boot -> MainC;
  EmergencyG.TemperatureSensor -> THSensor.Temperature;
  EmergencyG.LightSensor -> LSensor;
  ShMainC.EmergencyGGroup -> EmergencyGConfiguration;
  ShMainC.EmergencyGLayer -> EmergencyGConfiguration;
  ShMainC.SmokeSensor -> SmokeC;
}