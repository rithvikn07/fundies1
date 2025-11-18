use context dcic2024
include csv
include data-source


penguins = load-table:
  Penguin-number,species,island,bill_length_mm,bill_depth_mm,flipper_length_mm,body_mass_g,sex,year
  source: csv-table-file("penguins.csv", default-options)
    
  sanitize body_mass_g using num-sanitizer
  sanitize bill_length_mm using num-sanitizer
  sanitize flipper_length_mm using num-sanitizer
  sanitize bill_depth_mm using num-sanitizer
  sanitize year using num-sanitizer

end


#| Scalar Processing

   Example Question 1

   What is the ratio of average male body mass to average female body mass? 

|#

# Filter table to get two different tables for men and women

male_penguins = filter-with(penguins, lam(r :: Row): r["sex"] == "male" end)

female_penguins = filter-with(penguins, lam(r1 :: Row): r1["sex"] == "female" end)

# Extracting body masses as a list

male_masses = male_penguins.column("body_mass_g")

female_masses = female_penguins.column("body_mass_g")

# Function to calculate average of a list
fun avrg(l :: List <Number>) -> Number block:
  var summ = 0
  var countt = 0
  for each(x from l) block:
    summ := summ + x
    countt := countt + 1
  end
  summ / countt
  
where:
  avrg([list: 3, 5, 7, 9]) is 6
  avrg([list: 3, 4]) is 3.5
end

# Ratio:
avrg(male_masses) / avrg(female_masses)


#| Example Question 2

   Which species has the greatest variance?
|#


# Filtering to get seperate tables for each species
adelie_penguins = filter-with(penguins, lam(r2 :: Row): r2["species"] == "Adelie" end )

gentoo_penguins = filter-with(penguins, lam(r3 :: Row): r3["species"] == "Gentoo" end )

chinstrap_penguins = filter-with(penguins, lam(r4 :: Row): r4["species"] == "Chinstrap" end )
  
# Extracting the body masses as lists
adelie_masses = adelie_penguins.column("body_mass_g")

gentoo_masses = gentoo_penguins.column("body_mass_g")

chinstrap_masses = chinstrap_penguins.column("body_mass_g")

# Function to calculate variance of body mass lists
fun variance(ls :: List <Number>) -> Number block:
  avg = avrg(ls)
  
  var total_ = 0
  var count_ = 0
  
  for each(y from ls) block:
    total_:= total_ + ((y - avg) * (y - avg))
    count_:= count_ + 1
  end
  
  total_ / count_
end

# Storing variables as averages
adelie_masses_var = num-round(variance(adelie_masses))

gentoo_masses_var = num-round(variance(gentoo_masses))

chinstrap_masses_var = num-round(variance(chinstrap_masses))

# Function to calculate maximum value from three variables. 
fun max_calculator(a, b, c) -> String:
  
  if (a >= b) and (a >= c):
    "first value is max"
  else if (b >= a) and (b >= c):
    "second value is max"
  else:
    "third value is max"
  end
  
where:
  max_calculator(2, 4, 6) is "third value is max"
end

max_calculator(adelie_masses_var, gentoo_masses_var, chinstrap_masses_var)



#| Transformation
   
   Example Question 1
   
   "How can I view the lengths of penguins' bills in such a way that I know if they fall below or above the average for their species?"
   
|#


# Extracting the bill_lengths for each species as lists

adelie_bill_length = adelie_penguins.column("bill_length_mm")

gentoo_bill_length = gentoo_penguins.column("bill_length_mm")

chinstrap_bill_length = chinstrap_penguins.column("bill_length_mm")



# Transforms table of adelie penguins by comparing each value to the average. Short-bill implies below average, and long-bill implies above average.

adelie_penguins_new1 = transform-column(adelie_penguins, "bill_length_mm", lam(x :: Number) -> String: 
    if x < avrg(adelie_bill_length):
      "short-bill"
    else:
      "long-bill"
    end
  end)

#Do the same with the other two species:


gentoo_penguins_new1 = transform-column(gentoo_penguins, "bill_length_mm", lam(x :: Number) -> String: 
    if x < avrg(gentoo_bill_length):
      "short-bill"
    else:
      "long-bill"
    end
  end)

chinstrap_penguins_new1 = transform-column(chinstrap_penguins, "bill_length_mm", lam(x :: Number) -> String: 
    if x < avrg(chinstrap_bill_length):
      "short-bill"
    else:
      "long-bill"
    end
  end)

#adelie_penguins
#adelie_penguins_new1

# Tables show that "bill_length_mm" column has been transformed. Same result will be shown in other two species as well. 



#| Selection
   
   Example Question 1
   
   "Which penguins have flipper lengths greater than the median flipper length of the island they were found on?"
   
|#


# Filtering to get seperate tables for penguins from each island

torgerson_penguins = filter-with(penguins, lam(r :: Row): r["island"] == "Torgersen" end)

biscoe_penguins = filter-with(penguins, lam(r :: Row): r["island"] == "Biscoe" end)

dream_penguins = filter-with(penguins, lam(r :: Row): r["island"] == "Dream" end)


# Ordering in ascending order to find median

torgerson_penguins_ordered = order-by(torgerson_penguins, "flipper_length_mm", true)

biscoe_penguins_ordered = order-by(biscoe_penguins, "flipper_length_mm", true)

dream_penguins_ordered = order-by(dream_penguins, "flipper_length_mm", true)

# Function to calculate median of list
fun mediann(lst :: List <Number>):
  num = length(lst)
  mid = num-round(num / 2)
  
  # use num-round because: if the length of a list is odd, for example 3, 3/2 is not an integer. num-round rounds it up to 2. which is why we do "mid - 1" when the list length is odd.
  
  if num-modulo(num, 2) == 1:
    lst.get(mid - 1)
    
    # if the length of the list is odd, there will be a middle value which acts as the median. 
    # however if the length of the list is even, we need to calculate the average of the middle two values to calculate the median
    
  else:
    (lst.get(mid - 1) + lst.get(mid)) / 2
  end

where:
  mediann([list: 1,2,3,4]) is 2.5
  mediann([list: 2,3,4]) is 3
end

#Extracting flipper lengths for the penguins from each island as lists

torgerson_flipper_lengths = torgerson_penguins.column("flipper_length_mm")

biscoe_flipper_lengths = biscoe_penguins.column("flipper_length_mm")

dream_flipper_lengths = dream_penguins.column("flipper_length_mm")

# Selection process of filtering tables by selecting the values that are greater than the median

mediann(torgerson_flipper_lengths)

torgerson_penguins_new1 = filter-with(torgerson_penguins, lam(r :: Row): 
  r["flipper_length_mm"] > mediann(torgerson_flipper_lengths) end)

biscoe_penguins_new1 = filter-with(biscoe_penguins, lam(r :: Row): 
  r["flipper_length_mm"] > mediann(biscoe_flipper_lengths) end)

dream_penguins_new1 = filter-with(dream_penguins, lam(r :: Row): 
  r["flipper_length_mm"] > mediann(dream_flipper_lengths) end)

mediann(biscoe_flipper_lengths)
mediann(dream_flipper_lengths)

#Writing a checker
fun above_mediann(r :: Row) -> Boolean:
  doc: "Checking if the selection process works correctly."
  
  if (r["island"] == "Biscoe") and (r["flipper_length_mm"] > mediann(biscoe_flipper_lengths)):
    true
  else if (r["island"] == "Torgerson") and (r["flipper_length_mm"] > mediann(torgerson_flipper_lengths)):
    true
  else if (r["island"] == "Dream") and (r["flipper_length_mm"] > mediann(dream_flipper_lengths)):
    true
  else:
    false
  end
    
where:
  above_mediann(biscoe_penguins_new1.row-n(3)) is true
  above_mediann(biscoe_penguins_new1.row-n(0)) is true
  above_mediann(dream_penguins_new1.row-n(1)) is true
  
  above_mediann(dream_penguins.row-n(1)) is false
end

#| This shows that every value in these "new1" tables return true because they are transformed to only include the values that satisfy the condition of being greater than the median.

   The test case of the original table "dream_penguins" tests a value that is less than the median, so it returns false and is also not included in the "new1" table.
   
|#

torgerson_penguins_new1
biscoe_penguins_new1
dream_penguins

#

#| Accumulation

   Example Question 1
   
   "How many penguins have a bill-length-to-depth ratio greater than 3.0?"
   
|#
      
bill_lengths = penguins.column("bill_length_mm")

bill_depths = penguins.column("bill_depth_mm")

fun count-ratios(lengths :: List, depths :: list, threshold :: Number) -> Number:
  var acc = 0
  
  for i from 0 to (length(lengths) - 1):
    ratio = length(i) / depth(i)
    if ratio > threshold:
      acc := acc + 1
    end
  end

  
  acc
end
