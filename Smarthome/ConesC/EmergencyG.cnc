context group EmergencyG {
  layered void sendLog();
  uses interface Read<uint16_t> as TemperatureSensor;
  uses interface Read<uint16_t> as LightSensor;
  uses interface Read<uint16_t> as SmokeSensor;
  uses interface Read<uint16_t> as Camera;
} implementation {
  contexts Normal is default,
    Housebreaking, Fire;
  components GPRSC, new TimerMilliC() as Timer,
    ActiveMessageC, CollectionC, new CollectionSenderC(0xee);
  
  GPRSC.Timer -> Timer;
  
  Normal.TemperatureSensor = TemperatureSensor;
  Normal.LightSensor = LightSensor;
  Normal.GPRS -> GPRSC;
  
  Fire.TemperatureSensor = TemperatureSensor;
  Fire.SmokeSensor = SmokeSensor;
  Fire.Camera = Camera;
  Fire.GPRS -> GPRSC;
  Fire.RadioControl -> ActiveMessageC;
  Fire.RoutingControl -> CollectionC;
  Fire.Send -> CollectionSenderC;
  Fire.RootControl -> CollectionC;
  Fire.Receive -> CollectionC.Receive[0xee];
  
  Housebreaking.Camera = Camera;
  Housebreaking.GPRS -> GPRSC;
}
