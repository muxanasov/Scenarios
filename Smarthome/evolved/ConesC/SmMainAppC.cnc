configuration SmMainAppC {}
implementation {
  components
    EmergencyG,
    EmergencyContextManager,
    LightIntencityG,
    ClimateG,
    PreferencesG,
    SmokeC,
    CameraC,
    AccelerometerC,
    TimeC,
    MainC,
    ShMainC,
    new SensirionSht11C() as THSensor,
    new HamamatsuS1087ParC() as LSensor,
    new TimerMilliC() as SamplingTimer;

  ShMainC.EmergencyG -> EmergencyG;
  ShMainC.LightIntencityG -> LightIntencityG;
  ShMainC.ClimateG -> ClimateG;
  ShMainC.PreferencesG -> PreferencesG;
  
  ShMainC.Boot -> MainC;
  ShMainC.SamplingTimer -> SamplingTimer;
  ShMainC.TemperatureSensor -> THSensor.Temperature;
  ShMainC.LightSensor -> LSensor;
  ShMainC.Camera -> CameraC;
  ShMainC.SmokeSensor -> SmokeC;
  ShMainC.Accelerometer -> AccelerometerC;
  ShMainC.Time -> TimeC;
  
  EmergencyG.TemperatureSensor -> THSensor.Temperature;
  EmergencyG.LightSensor -> LSensor;
  EmergencyG.Camera -> CameraC;
  EmergencyG.SmokeSensor -> SmokeC;
  
  EmergencyContextManager.EmergencyG -> EmergencyG;
  EmergencyContextManager.TemperatureSensor -> THSensor.Temperature;
  EmergencyContextManager.SmokeSensor -> SmokeC;
  EmergencyContextManager.Accelerometer -> AccelerometerC;
}
