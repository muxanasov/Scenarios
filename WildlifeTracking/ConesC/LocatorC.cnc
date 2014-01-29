context group LocatorC {
}
implementation {
  components
    Running,
    Resting is default,
    NotMoving,
    MocAccelerometerC,
    GPSSensorC,
    new TimerMilliC() as TimerRunning,
    new TimerMilliC() as TimerResting,
    new TimerMilliC() as TimerNotMoving;
    
  Running.Timer -> TimerRunning;
  Running.GPSSensor -> GPSSensorC;
  Resting.Timer -> TimerResting;
  Resting.GPSSensor -> GPSSensorC;
  NotMoving.Timer -> TimerNotMoving;
  NotMoving.Accelerometer -> MocAccelerometerC;
  NotMoving.GPSSensor -> GPSSensorC;
}
