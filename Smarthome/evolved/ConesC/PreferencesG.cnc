#include "types.h"
context group PreferencesG {
  layered Prefs* prefs();
} implementation {
  contexts Day, Night is default, Weekend;
}
