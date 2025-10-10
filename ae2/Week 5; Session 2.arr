use context starter2024

#List

#1
discount-codes = [list: "NEWYEAR", "student", "NONE", "student", "VIP", "none"]

unique-codes = distinct(discount-codes)

fun is-real-code(code :: String) -> Boolean:
  not(string-to-lower(code) == "none")
end

real-codes = filter(is-real-code, unique-codes)

upper-codes = map(string-to-upper, real-codes)

upper-codes

#2

survey = [list: "yes", "NO", "maybe", "Yes", "no", "Maybe"]

lower_survey = map(string-to-lower, survey)

unique_survey = distinct(lower_survey)

unique_survey

filter(lam(r): not(r == "maybe") end, unique_survey)


#Loop
#1

fun prod(num-list :: List) -> Number block:
  var total1 = 1
  for each(n from num-list):
    total1 := total1 * n
  end
  total1
where:
  prod([list:1,2,3]) is 6
end

#2

fun sum-even-numbers(n-list :: List) -> Number block:
  var total2 = 0
  for each(u from n-list):
    if (num-modulo(u,2) == 0):
        total2:= total2 + u
    else:
      0
    end
  end
  total2
where:
  sum-even-numbers([list:1,2,3,4,6]) is 12
end
  
#3

fun my-length(nu-list :: List) -> Number block:
  nu-list.length()
where:
  my-length([list:2]) is 1
  my-length([list:2,3,4]) is 3
end

#4

fun my-doubles(numb-list :: List) -> List: 
  map(lam(x): x * 2 end, numb-list)
where:
  my-doubles([list:1,2,3]) is ([list:2,4,6])
end

#5
