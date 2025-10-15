use context starter2024
#1
data Temperature:
  | celcius(degrees :: Number)
  | fahrenheit(degrees :: Number)
  | kelvin(degrees :: Number)
end

fun to-celcius(t :: Temperature) -> Number:
  cases (Temperature) t:
    | celcius(d) => d
    | fahrenheit(d) => (5 / 9) * (d - 32)
    | kelvin(d) => d - 273.5
  end
where:
  to-celcius(fahrenheit(100)) is%(within-abs(0.1)) 37.7
end


#2
data Status:
  | todo
  | in-progress
  | done
end

data Task:
  | task(description :: String, priority :: Priority, status :: Status)
end

data Priority:
  | low
  | medium
  | high
end

fun priority-to-string(p :: Priority) -> String:
  cases (Priority) p:
    | low => "❕TASK:"
    | medium => "❗️TASK:"
    | high => "‼️ TASK:"
  end
end

fun describe(t :: Task) -> String:
  cases (Task) t:
    | task(d, p, s) =>
      priority-to-string(p) + " " + d + " (" +
      cases (Status) s:
        | todo => "To Do"
        | in-progress => "In Progress"
        | done => "Done"
      end + ")"
  end
  
  
end

t1 = task("Finish report", high, todo)

describe(t1)

#3

data WeatherReport:
  | sunny(temperature :: Number)
  | rainy(temperature :: Number, precipitation :: Number)
  | snowy(temperature :: Number, precipitation :: Number, wind-speed :: Number)
end

fun is-severe(w :: WeatherReport):
  cases (WeatherReport) w:
    | sunny(temp) => temp > 35
    | rainy(temp, precip) => precip > 20
    | snowy(temp, precip, wind) => wind > 30
  end
where:
  
  is-severe(sunny(37)) is true
  is-severe(rainy(10, 21)) is true
  is-severe(snowy(22, 19, 31)) is true
end
     