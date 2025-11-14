use context dcic2024
include csv
include data-source

#| Scalar Processing

   Example Question 1

   What is the ratio of average male body mass to average female body mass? 

|#

penguins = load-table:
  Penguin-number,species,island,bill_length_mm,bill_depth_mm,flipper_length_mm,body_mass_g,sex,year
  source: csv-table-file("penguins.csv", default-options)
    
  sanitize body_mass_g using num-sanitizer

end


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

   Are the penguins 

|#