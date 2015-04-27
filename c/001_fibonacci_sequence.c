#include "001_fibonacci_sequence.h"

int fibonacci(int index)
{
  if(index == 0 || index == 1)
    return index;

  if(index < 0)
    return fibonacci(index + 2) - fibonacci(index + 1);
  else
    return fibonacci(index - 2) + fibonacci(index - 1);
}
