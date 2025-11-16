use context dcic2024
include csv
include data-source


penguins = load-table:
  Penguin-number,species,island,bill_length_mm,bill_depth_mm,flipper_length_mm,body_mass_g,sex,year
  source: csv-table-file("penguins.csv", default-options)
    
  sanitize body_mass_g using num-sanitizer
  sanitize bill_length_mm using num-sanitizer

end


#| Scalar Processing

   Example Question 1

   What is the ratio of average male body mass to average female body mass? 

|#

# Filter table to get two different tables for men and women

male_penguins = filter-with(penguins, lam(r :: Row): r["sex"] == "male" end)

female_penguins = filter-with(penguins, lam(r1 :: Row): r1["sex"] == "female" end)

#Extract body masses as a list

male_masses = male_penguins.column("body_mass_g")

female_masses = female_penguins.column("body_mass_g")

#function to calculate average
fun avrg(l :: List <Number>) -> Number block:
  var summ = 0
  var countt = 0
  for each(x from l) block:
    summ := summ + x
    countt := countt + 1
  end
  summ / countt
end

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

adelie_masses_var = num-round(variance(adelie_masses))

gentoo_masses_var = num-round(variance(gentoo_masses))

chinstrap_masses_var = num-round(variance(chinstrap_masses))

fun max_calculator(a, b, c) -> String:
  
  if (a >= b) and (a >= c):
    "first value is max"
  else if (b >= a) and (b >= c):
    "second value is max"
  else:
    "third value is max"
  end
end

max_calculator(adelie_masses_var, gentoo_masses_var, chinstrap_masses_var)

#| Example Question 3

   W

|#

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

#| Example Question 2

   W

|#