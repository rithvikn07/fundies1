use context dcic2024
include csv
include data-source


flights_53 = load-table: rownames,dep_time,sched_dep_time,dep_delay,arr_time,sched_arr_time,arr_delay,carrier,flight,tailnum,origin,dest,air_time,distance,hour,minute,time_hour
  source: csv-table-file("flights_sample53.csv", default-options)


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


flights_54 = transform-column(flights_53, "tailnum", lam(x :: String): if x == "": "UNKNOWN" else: x end end)

flights_55 = transform-column(flights_54, "dep_delay", lam(x :: Number):  if x < 0: 0 else: x end end)

flights_56 = transform-column(flights_55, "arr_delay", lam(y :: Number):  if y < 0: 0 else: y end end)


flights_57 = build-column(flights_56,"dedup_key",
  lam(f):
    flight-str = num-to-string(f["flight"])

    carrier-norm = string-to-upper(string-replace(f["carrier"], " ", ""))

    hour = num-floor(f["dep_time"] / 100)
    minute = num-modulo(f["dep_time"], 100)

    
    dep-time-norm = to-string(hour) + ":" + to-string(minute)

    
    flight-str + "-" + carrier-norm + "-" + dep-time-norm
  end
)


flights_57

#3
flights_58 = build-column(flights_57, "airline", lam(a :: Row):
  if a["carrier"] == "UA": "United Airlines"
  else if a["carrier"] == "AA": "American Airlines"
  else if a["carrier"] == "B6": "JetBlue"
  else if a["carrier"] == "DL": "Delta Air Lines"
  else if a["carrier"] == "EV": "ExpressJet"
  else if a["carrier"] == "WN": "Southwest Airlines"
  else if a["carrier"] == "OO": "Skywest Airlines"
  else: "Other" end end)

flights_59 = filter-with(flights_58, lam(w :: Row): w["distance"] < 5000 end)

flights_60 = filter-with(flights_59, lam(w1 :: Row): w1["air_time"] > 500 end)

flights_60

#4
freq-bar-chart(flights_58, "airline")
histogram(flights_58, "distance", 5)
scatter-plot(flights_58, "air_time", "distance")

d = flights_58.get-column("distance")

fun x(l :: List) -> Number block:
  var total = 0
  for each(n from l):
    total := total + n
  end
  total
  
where:
  x([list:1,2,3]) is 6
end

fun y(li :: List) -> Number block:
  var total1 = 0
  var c = 0
  for each(nu from li) block:
    total1 := total1 + nu
    c := c + 1
  end
  total1 / c
  
where:
  y([list:1,2,3]) is 2
end

fun max(lis :: List) -> Number block:
  var m = 1
  for each(num from lis):
    if num > m:
      m := num
    else:
      0
    end
  end
end
    
  