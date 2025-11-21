use context dcic2024
include csv
include data-source
import statistics as s
import math as m

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




#| Example Question 2

   Which species has the greatest variance?
|#



#| Transformation
   
   Example Question
   
   "How can I view the lengths of penguins' bills in such a way that I know if they fall below or above the average for their species?"
   
|#


# Filtering to get seperate tables for each species
adelie_penguins = filter-with(penguins, lam(r2 :: Row): r2["species"] == "Adelie" end )

gentoo_penguins = filter-with(penguins, lam(r3 :: Row): r3["species"] == "Gentoo" end )

chinstrap_penguins = filter-with(penguins, lam(r4 :: Row): r4["species"] == "Chinstrap" end )

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

#Doing the same with the other two species:

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

# Outputting the tables to show that "bill_length_mm" column has been transformed. Same result will be shown in other two species as well. 

adelie_penguins
adelie_penguins_new1

freq-bar-chart(chinstrap_penguins_new1, "bill_length_mm")





#| Selection
   
   Example Question
   
   "Which penguins have flipper lengths greater than the median flipper length of the island they were found on?"
   
|#


# Filtering to get seperate tables for penguins from each island

torgerson_penguins = filter-with(penguins, lam(r :: Row): r["island"] == "Torgersen" end)

biscoe_penguins = filter-with(penguins, lam(r :: Row): r["island"] == "Biscoe" end)

dream_penguins = filter-with(penguins, lam(r :: Row): r["island"] == "Dream" end)


#Extracting flipper lengths for the penguins from each island as lists

torgerson_flipper_lengths = torgerson_penguins.column("flipper_length_mm")

biscoe_flipper_lengths = biscoe_penguins.column("flipper_length_mm")

dream_flipper_lengths = dream_penguins.column("flipper_length_mm")

# Selection process of filtering tables by selecting the values that are greater than the median



torgerson_penguins_new1 = filter-with(torgerson_penguins, lam(r :: Row): 
  r["flipper_length_mm"] > s.median(torgerson_flipper_lengths) end)

biscoe_penguins_new1 = filter-with(biscoe_penguins, lam(r :: Row): 
  r["flipper_length_mm"] > s.median(biscoe_flipper_lengths) end)

dream_penguins_new1 = filter-with(dream_penguins, lam(r :: Row): 
  r["flipper_length_mm"] > s.median(dream_flipper_lengths) end)


#Writing a checker
fun above_mediann(r :: Row) -> Boolean:
  doc: "Checking if the selection process works correctly."
  
  if (r["island"] == "Biscoe") and (r["flipper_length_mm"] > s.median(biscoe_flipper_lengths)):
    true
  else if (r["island"] == "Torgerson") and (r["flipper_length_mm"] > s.median(torgerson_flipper_lengths)):
    true
  else if (r["island"] == "Dream") and (r["flipper_length_mm"] > s.median(dream_flipper_lengths)):
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


#| Accumulation

   Example Question 1
   
   "How many penguins have a bill-length greater than the median bill-length of all penguins?"
   
|#
   

#Extracting the column "bill_lengths_mm" of all the penguins in the dataset as a list
bill_lengths = penguins.column("bill_length_mm")


# Function to count the number of penguins with bill lengths greater than the median

fun count-above-mean(lengths :: List) -> Number block:
  var acc = 0
  
  for each(num from lengths) block:
    # uses for each loop to transverse "num" through each element of "lengths" list
    # calls to the avrg() function made earlier in the program
    if num > avrg(lengths):
      acc:= acc + 1
    else:
      0
    end
  
  end
  acc
  
where:
  count-above-mean([list: 3, 7, 2, 5, 1, 9, 6]) is 4
end


# Calling function to find output
count-above-mean(bill_lengths)

