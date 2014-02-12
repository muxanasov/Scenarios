configuration PrMainAppC {
} implementation {
  components
    ActiveMessageC,
    CollectionC,
    new CollectionSenderC(0xee),
    new DisseminatorC(uint16_t, 0x1234) as Diss16C,
    AccelerometerC,
    MainC,
    PrMainC,
    new TimerMilliC() as Timer,
    new SensirionSht11C() as THSensor;
    
  PrMainC.Boot -> MainC;
  PrMainC.Timer -> Timer;
  PrMainC.Accelerometer -> AccelerometerC;
  PrMainC.Temperature -> THSensor.Temperature;
  
  PrMainC.RadioControl -> ActiveMessageC;
  PrMainC.RoutingControl -> CollectionC;
  PrMainC.Send -> CollectionSenderC;
  PrMainC.RootControl -> CollectionC;
  PrMainC.Receive -> CollectionC.Receive[0xee];  
  PrMainC.Value -> Diss16C;
  PrMainC.Update -> Diss16C;
}
