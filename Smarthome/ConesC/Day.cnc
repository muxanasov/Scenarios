#include "types.h"
context Day {
} implementation {
  Prefs prefs;
  event void activated() {
    prefs.temperature = 25;
    prefs.light = 100500;
  }
  layered Prefs* prefs() {
    return &prefs;
  }
}
