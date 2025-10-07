use context dcic2024
include csv
include data-source

flights = load-table:
  rownames, dep_time, sched_dep_time, dep_delay, arr_time, sched_arr_time, arr_delay, carrier, flight, tailnum, origin, dest, air_time, distance, hour, minute, time_hour

  source: csv-table-file("flights.csv", default-options)
    
  sanitize rownames using num-sanitizer
  sanitize dep_time using num-sanitizer
  sanitize sched_dep_time using num-sanitizer
  sanitize dep_delay using num-sanitizer
  sanitize arr_time using num-sanitizer
  sanitize sched_arr_time using num-sanitizer
  sanitize arr_delay using num-sanitizer
  sanitize flight using num-sanitizer
  sanitize air_time using num-sanitizer
  sanitize distance using num-sanitizer
  sanitize hour using num-sanitizer
  sanitize minute using num-sanitizer
  
end

fun is_long_flight(r :: Row) -> Boolean:
  if r["distance"] >= 1500:
    true
  else:
    false
  end
end

newflights = filter-with(flights, is_long_flight)

newflights1 = order-by(newflights, "distance", false)

newflights1

newflights1.row-n(0)["carrier"]
newflights1.row-n(0)["origin"]
newflights1.row-n(0)["dest"]

#2
  
fun is_delayed_departure(r1 :: Row) -> Boolean:
  r1["dep_delay"] >= 30
end

fun is_morning_sched_dep(r2 :: Row) -> Boolean:
  r2["sched_dep_time"] < 1200
end

flights2 = filter-with(flights, lam(r3 :: Row): r3["dep_delay"] >= 30 end)

newflights2 = filter-with(flights2, lam(r4 :: Row): r4["sched_dep_time"] < 1200 end)

new2flights2 = filter-with(newflights2, lam(r5 :: Row): r5["distance"] > 500 end)

newest_flights2 = order-by(new2flights2, "dep_delay", false)

newest_flights2

newest_flights2.row-n(0)["flight"]
newest_flights2.row-n(0)["origin"]
newest_flights2.row-n(0)["dep_delay"]

#3

flights3 = transform-column(flights, "dep_delay", lam(x :: Number):  if x < 0: 0 else: x end end)

newflights3 = transform-column(flights3, "arr_delay", lam(y :: Number):  if y < 0: 0 else: y end end)

newest_flights3 = build-column(newflights3, "effective_speed", lam(z :: Row): if z["air_time"] > 0: z["distance"] / (z["air_time"] / 60) else: 0 end end)

newest_flights3


final_flights3 = order-by(newest_flights3, "effective_speed", false)

final_flights3

final_flights3.row-n(0)["carrier"]
final_flights3.row-n(0)["origin"]
final_flights3.row-n(0)["dest"]

#4

#4.1

fun apply-arrival-discount(t :: Table) -> Table:
  transform-column(t, "arr_delay", lam(n :: Number): if (n >= 0) and (n <= 45):
    n * 0.8 else: n end end)
where:
  test-table =
    table: arr_delay
      row: -10
      row: 0
      row: 30
      row: 60
    end
  apply-arrival-discount(test-table) is
  table: arr_delay
    row: -10
    row: 0
    row: 24
    row: 60
  end
end
