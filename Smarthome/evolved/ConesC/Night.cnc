#include "types.h"
context Night {
} implementation {
  Prefs prefs;
  event void activated() {
    prefs.temperature = 30;
    prefs.light = 0;
  }
  layered Prefs* prefs() {
    return &prefs;
  }
}
