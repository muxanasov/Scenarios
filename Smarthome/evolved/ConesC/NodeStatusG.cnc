context group NodeStatusG {
  layered nx_uint16_t buildStatus();
} implementation {
 components NormalStatus is default, Failure;
}
