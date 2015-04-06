namespace Kata
{
  using NUnit.Framework;

  [TestFixture]
  public class FibonacciTest
  {
    Fibonacci subject;

    [SetUp]
    public void LoadSubject()
    {
      subject = new Fibonacci();
    }

    [Test]
    public void ZeroToOne()
    {
      Assert.AreEqual(0,  subject.Calculate(0));
      Assert.AreEqual(1,  subject.Calculate(1));
    }

    [Test]
    public void TwoToFour()
    {
      Assert.AreEqual(1,  subject.Calculate(2));
      Assert.AreEqual(2,  subject.Calculate(3));
      Assert.AreEqual(3,  subject.Calculate(4));
    }

    [Test]
    public void Large()
    {
      Assert.AreEqual(5,  subject.Calculate(5));
      Assert.AreEqual(144,  subject.Calculate(12));
    }

    [Test]
    public void NegativeOneToNegativeFour()
    {
      Assert.AreEqual(1,  subject.Calculate(-1));
      Assert.AreEqual(-1,  subject.Calculate(-2));
      Assert.AreEqual(2,  subject.Calculate(-3));
      Assert.AreEqual(-3,  subject.Calculate(-4));
    }

    [Test]
    public void LargeNegative()
    {
      Assert.AreEqual(5,  subject.Calculate(-5));
      Assert.AreEqual(-21,  subject.Calculate(-8));
    }
  }
}
