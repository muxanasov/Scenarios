configuration WtMainAppC {}
implementation {
  components
    MainC,
    WtMainC,
    ActiveMessageC,
    GPSSensorC,
    MocAccelerometerC,
    new AMReceiverC(AM_BEACON),
    new AMSenderC(AM_BEACON),
    new AMSenderC(AM_BEACON) as BSSender,
    new SensirionSht11C() as Sensor,
    new DemoSensorC() as Voltage,
    new TimerMilliC() as Timer,
    new TimerMilliC() as TimerCom,
    new TimerMilliC() as GPSTimer,
    new TimerMilliC() as AccTimer,
    new TimerMilliC() as BSReset;

  WtMainC.Boot -> MainC;
  WtMainC.Timer -> Timer;
  WtMainC.TimerCom -> TimerCom;
  WtMainC.BSReset -> BSReset;
  WtMainC.GPSTimer -> GPSTimer;
  WtMainC.AccTimer -> AccTimer;
  WtMainC.AMControl -> ActiveMessageC;
  WtMainC.Receive -> AMReceiverC;
  WtMainC.GPSReader -> GPSSensorC;
  WtMainC.GPSSensor -> GPSSensorC;
  WtMainC.Voltage -> Voltage;
  WtMainC.Temperature -> Sensor.Temperature;
  
  WtMainC.Packet -> AMSenderC;
  WtMainC.AMPacket -> AMSenderC;
  WtMainC.AMSend -> AMSenderC;
  
  WtMainC.LogPacket -> BSSender;
  WtMainC.BSPacket -> BSSender;
  WtMainC.BSSend -> BSSender;
  
  WtMainC.Accelerometer -> MocAccelerometerC;
}
