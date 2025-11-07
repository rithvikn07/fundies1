use context starter2024

fun factorial(n :: Number) -> Number:
  if n == 0:
    1
  else:
    n * factorial(n - 1)
  end
where:
  factorial(0) is 1
  factorial(1) is 1
  factorial(3) is 6
  factorial(5) is 120
end