module.exports = {
  calculate: function(index) {
    if (index === 0 || index === 1) { return index; }

    if (index < 0) {
      return this.calculate(index + 2) - this.calculate(index + 1);
    } else {
      return this.calculate(index - 2) + this.calculate(index - 1);
    }
  }
};
