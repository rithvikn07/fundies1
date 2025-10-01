use context dcic2024
orders = table: time, amount
  row: "08:00", 10.50
  row: "09:30", 5.75
  row: "10:15", 8.00
  row: "11:00", 3.95
  row: "14:00", 4.95
  row: "16:45", 7.95
end

fun is-morning(t :: Row) -> Boolean:
  t["time"] <= "11:59" 
where:
  is-morning(orders.row-n(0)) is true
  is-morning(orders.row-n(4)) is false
end

new1 = filter-with(orders, is-morning)
new2 = filter-with(orders, lam(t): t["time"] <= "11:59" end)

check:
  new1 is new2
end