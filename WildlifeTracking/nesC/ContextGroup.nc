#include "Contexts.h"
interface ContextGroup {
  event void contextChanged(context_t con);
  command void activate(context_t con);
  command context_t getContext();
}