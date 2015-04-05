var assert = require('assert');
var fibonacci = require('./001_fibonacci_sequence.js');

// zero to one
assert.equal(0, fibonacci.calculate(0));
assert.equal(1, fibonacci.calculate(1));

// two to four
assert.equal(1, fibonacci.calculate(2));
assert.equal(2, fibonacci.calculate(3));
assert.equal(3, fibonacci.calculate(4));

// large
assert.equal(5, fibonacci.calculate(5));
assert.equal(144, fibonacci.calculate(12));

// negative one to negative four
assert.equal(1, fibonacci.calculate(-1));
assert.equal(-1, fibonacci.calculate(-2));
assert.equal(2, fibonacci.calculate(-3));
assert.equal(-3, fibonacci.calculate(-4));
