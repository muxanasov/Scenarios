#include "types.h"
context Weekend {
} implementation {
  Prefs prefs;
  event void activated() {
    prefs.temperature = 30;
    prefs.light = 100500;
  }
  layered Prefs* prefs() {
    return &prefs;
  }
}
