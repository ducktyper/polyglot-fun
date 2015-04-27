# polyglot-fun
## Goal
I'm a ruby programmer trying to learn other languages. Recently, I have done some Code Kata
practice and think this will be a fun way to learn other langauges.
Here is the learning process I will try.

1. (Prepare) Solve a Code Kata, from web or create one, in Ruby.
2. (Learn) Solve the same problem in other languages.
3. (Master) Resolve the same problem again and again until feel happy.

## Setup
Setup is based on Mac
### Ruby
#### Install
No need
#### Run test
  ruby -Ilib:test ruby/001_fibonacci_sequence_test.rb

### Javascript
#### Install
brew install node
#### Run test
  node javascript/001_fibonacci_sequence_test.js

### C&#35;
#### Install
Visit http://www.mono-project.com/download/
Click 'Download Mono MDK' and install
#### Run test
  mcs -t:library csharp/001FibonacciSequence.cs
  mcs -t:library -r:nunit.framework,csharp/001FibonacciSequence csharp/001FibonacciSequenceTest.cs
  nunit-console csharp/001FibonacciSequenceTest.dll
  rm csharp/001FibonacciSequence.dll csharp/001FibonacciSequenceTest.dll TestResult.xml

### Objective-C
#### Install
Create a new OSX library from Xcode
#### Run test
xcodebuild test -scheme FibonacciSequence

### C
#### Install
No need
#### Run test
gcc -Wall fibonacci_sequence_test.c fibonacci_sequence.c -o fibonacci_sequence.out
rm fibonacci_sequence.out']
