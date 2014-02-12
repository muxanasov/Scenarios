context group LightIntencityG {
} implementation {
  contexts Dark, Bright is default;
  components LightsC;
  
  Dark.Lights -> LightsC;
  Bright.Lights -> LightsC;
}
