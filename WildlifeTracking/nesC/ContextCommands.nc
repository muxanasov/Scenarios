#include "Contexts.h"
interface ContextCommands {
  command bool check();
  command void activate();
  command void deactivate();
  command bool transitionIsPossible(context_t con);
  command bool conditionsAreSatisfied(context_t to, context_t cond);
}