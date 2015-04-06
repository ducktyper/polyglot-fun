namespace Kata
{
  public class Fibonacci
  {
    public int Calculate(int index)
    {
      if (index == 0 || index == 1)
      {
        return index;
      }

      if (index < 0)
      {
        return Calculate(index + 2) - Calculate(index + 1);
      }
      else
      {
        return Calculate(index - 2) + Calculate(index - 1);
      }
    }
  }
}
