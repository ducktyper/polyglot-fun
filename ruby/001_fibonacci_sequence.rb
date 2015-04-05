class Fibonacci
  def calculate index
    return index if index == 0 || index == 1
    if index < 0
      calculate(index + 2) - calculate(index + 1)
    else
      calculate(index - 2) + calculate(index - 1)
    end
  end
end
