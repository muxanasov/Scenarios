#include "types.h"
context NormalStatus {
} implementation {
  layered nx_uint16_t buildStatus() {
    return STATUS_OK;
  }
}
