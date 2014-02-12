COMPONENT = WtMainAppC
BUILD_EXTRA_DEPS = BeaconMsg.py
CLEAN_EXTRA = BeaconMsg.py

BeaconMsg.py: BeaconMsg.h
	mig python -target=$(PLATFORM) $(CFLAGS) -python-classname=BeaconMsg BeaconMsg.h BeaconMsg -o $@

include $(MAKERULES)
