context group BatteryC {
}
implementation {
  components
    Low is default,
    Normal,
    GPSSensorC;
    
  Low.GPSSensor -> GPSSensorC;
}
