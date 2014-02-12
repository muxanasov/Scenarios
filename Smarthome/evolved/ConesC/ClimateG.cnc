context group ClimateG {
} implementation {
  contexts High, Low, NormalClm is default;
  components HeaterC, ConditionerC;
  High.Conditioner -> ConditionerC;
  Low.Heater -> HeaterC;
}
