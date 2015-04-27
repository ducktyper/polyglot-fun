#include <assert.h>
#include "001_fibonacci_sequence.h"

int main(void)
{
  // zero to one
  assert(fibonacci(0) == 0);
  assert(fibonacci(1) == 1);
  // two to four
  assert(fibonacci(2) == 1);
  assert(fibonacci(3) == 2);
  assert(fibonacci(4) == 3);
  // large
  assert(fibonacci(5) == 5);
  assert(fibonacci(12) == 144);
  // negative one to negative four
  assert(fibonacci(-1) == 1);
  assert(fibonacci(-2) == -1);
  assert(fibonacci(-3) == 2);
  assert(fibonacci(-4) == -3);
  // large negative
  assert(fibonacci(-5) == 5);
  assert(fibonacci(-8) == -21);

  return 0;
}
