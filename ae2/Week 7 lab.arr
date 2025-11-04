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
