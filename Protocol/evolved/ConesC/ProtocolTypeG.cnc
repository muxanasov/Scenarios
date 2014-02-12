context group ProtocolTypeG {
  provides interface Receiver;
  layered void send(uint16_t data);
  layered void setParams(uint16_t* params);
} implementation {
  contexts Gossip, CTP is default;
  components ActiveMessageC, CollectionC, new CollectionSenderC(0xee),
    new DisseminatorC(uint16_t, 0x1234) as Diss16C;
  CTP.RadioControl -> ActiveMessageC;
  CTP.RoutingControl -> CollectionC;
  CTP.Send -> CollectionSenderC;
  CTP.RootControl -> CollectionC;
  CTP.Receive -> CollectionC.Receive[0xee];  
  Gossip.Value -> Diss16C;
  Gossip.Update -> Diss16C;
  
  Receiver = Gossip;
  Receiver = CTP;
}
