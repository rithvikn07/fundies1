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

newflights2 = order-by(newflights, "distance", false)

newflights2

newflights2.row-n(0)["carrier"]
newflights2.row-n(0)["origin"]
newflights2.row-n(0)["dest"]

#2
  