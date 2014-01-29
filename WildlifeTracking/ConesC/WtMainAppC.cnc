configuration WtMainAppC {}
implementation {
  components
    LocatorC,
    BaseStationC,
    CommunicationC,
    BatteryC,
    MainC,
    WtMainC,
    ActiveMessageC,
    GPSSensorC,
    new AMSenderC(AM_BEACON),
    new AMReceiverC(AM_BEACON),
    new DemoSensorC() as Voltage,
    new TimerMilliC() as Timer,
    new TimerMilliC() as TimerCom,
    new TimerMilliC() as BSReset,
    new SensirionSht11C() as Sensor;

  WtMainC.LocatorC -> LocatorC;
  WtMainC.BaseStationC -> BaseStationC;
  WtMainC.CommunicationC -> CommunicationC;
  WtMainC.BatteryC -> BatteryC;
  WtMainC.Boot -> MainC;
  WtMainC.Timer -> Timer;
  WtMainC.TimerCom -> TimerCom;
  WtMainC.BSReset -> BSReset;
  WtMainC.AMControl -> ActiveMessageC;
  WtMainC.Receive -> AMReceiverC;
  WtMainC.Packet -> AMSenderC;
  WtMainC.AMPacket -> AMSenderC;
  WtMainC.AMSend -> AMSenderC;
  WtMainC.GPSReader -> GPSSensorC;
  WtMainC.Voltage -> Voltage;
  WtMainC.Temperature -> Sensor.Temperature;
}
