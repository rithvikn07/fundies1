use context dcic2024
include csv

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

#descending order
new_table = order-by(orders, "time", false)

new_table.row-n(0)["time"]

photos = load-table: Location, Subject, Date
  source:csv-table-url("https://raw.githubusercontent.com/NU-London/LCSCI4207-datasets/refs/heads/main/photos.csv", default-options)
end

forest_table = filter-with(photos, lam(p): p["Subject"] == "Forest" end)

new_forest_table = order-by(forest_table, "Date", false)

new_forest_table.row-n(0)["Location"]

location_counts = count(photos, "Location")

new_loc_counts = order-by(location_counts, "count", false)

fbc = freq-bar-chart(photos, "Location")
