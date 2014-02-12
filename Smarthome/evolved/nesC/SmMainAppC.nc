configuration SmMainAppC {}
implementation {
  components
    ActiveMessageC, CollectionC, new CollectionSenderC(0xee),
    SmokeC,
    CameraC,
    AccelerometerC,
    TimeC,
    HeaterC,
    ConditionerC,
    LightsC,
    GPRSC,
    MainC,
    ShMainC,
    new SensirionSht11C() as THSensor,
    new HamamatsuS1087ParC() as LSensor,
    new TimerMilliC() as SamplingTimer,
    new TimerMilliC() as GPRSTimer;

  ShMainC.Heater -> HeaterC;
  ShMainC.Lights -> LightsC;
  ShMainC.Conditioner -> ConditionerC;
  ShMainC.GPRS -> GPRSC;
  
  GPRSC.Timer -> GPRSTimer;
  
  ShMainC.Boot -> MainC;
  ShMainC.SamplingTimer -> SamplingTimer;
  ShMainC.TemperatureSensor -> THSensor.Temperature;
  ShMainC.LightSensor -> LSensor;
  ShMainC.Camera -> CameraC;
  ShMainC.SmokeSensor -> SmokeC;
  ShMainC.Accelerometer -> AccelerometerC;
  ShMainC.Time -> TimeC;
  
  ShMainC.RadioControl -> ActiveMessageC;
  ShMainC.RoutingControl -> CollectionC;
  ShMainC.Send -> CollectionSenderC;
  ShMainC.RootControl -> CollectionC;
  ShMainC.Receive -> CollectionC.Receive[0xee];
}
