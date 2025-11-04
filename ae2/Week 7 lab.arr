use context starter2024

data SensorNet:
  | hub(bandwidth :: Number, left :: SensorNet, right :: SensorNet)
  | sensor(rate :: Number)
end

# Example network
sA = sensor(60)
sB = sensor(120)
sC = sensor(45)

# You can construct larger networks like:
hub1 = hub(150, sA, sB)
hub2 = hub(120, sA, sC)
core = hub(200, hub1, sC)

#1
fun total-load(n :: SensorNet) -> Number:
  cases (SensorNet) n:
    | sensor(Rate) => Rate
    | hub(bandwith, left, right) => total-load(left) + total-load(right)
  end

where:
  total-load(core) is 225
end

#2    

fun fits-capacities(n :: SensorNet) -> Boolean:
  cases (SensorNet) n:
    | sensor(Rate) => true
    | hub(bandwith, left, right) => 
      (bandwith >= (total-load(left) + total-load(right))) 
      and fits-capacities(left) 
      and fits-capacities(right)
  end
  
where:
  fits-capacities(hub1) is false
  fits-capacities(hub2) is true
end

#3

fun deepest-depth(n :: SensorNet) -> Number:
  cases (SensorNet) n:
    | sensor(depth) => 0
    | hub(bandwith, left, right) => 1 + num-max(deepest-depth(left), deepest-depth(right))
  end
  
where:
  deepest-depth(sA) is 0
  deepest-depth(hub1) is 1
  deepest-depth(core) is 2
end

#4

fun apply-scale(n :: SensorNet, s :: Number) -> SensorNet:
  cases (SensorNet) n:
    | sensor(rate) => sensor(rate / s)
    | hub(bandwith, left, right) => hub(bandwith, apply-scale(left, s), apply-scale(right, s))
  end
  
where:
  apply-scale(hub1, 2) is hub(150, sensor(30), sensor(60))
  
  total-load(core) is 225
  total-load(apply-scale(core, 2)) is 112.5
end