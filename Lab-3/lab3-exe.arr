use context starter2024
#1
fun leapyear(year :: Number) -> Boolean:
  doc: "returns if the inputted year is a leap year or not"
  
  if num-modulo(year,4) == 0:
    true
  else:
    false
  end
  
where:
  leapyear(2024) is true
  leapyear(2019) is false
  
end

#2

fun tick(second :: Number) -> Number:
  doc: "returns the next second inputted"
  
  if (second <= 59) and (second >= 0) and (num-is-integer(second) == true):
    second + 1
  else:
    000
  end
  
where:
  tick(2) is 3
  tick(500) is 000
  tick(5.2) is 000
end
    
#3

fun rock-paper-scissors(player_1, player_2 :: String) -> String:
  doc: "returns winner of game, or if game is tied"
  
  
  if (player_1 == "rock") and (player_2 == "rock"):
    "tie"
  else if (player_1 == "rock") and (player_2 == "scissors"):
    "player_1"
  else if (player_1 == "rock") and (player_2 == "paper"):
    "player_2"
  else if (player_1 == "paper") and (player_2 == "rock"):
    "player_1"
  else if (player_1 == "paper") and (player_2 == "paper"):
    "tie"
  else if (player_1 == "paper") and (player_2 == "scissors"):
    "player_2"
  else if (player_1 == "scissors") and (player_2 == "scissors"):
    "tie"
  else if (player_1 == "scissors") and (player_2 == "paper"):
    "player_1"
  else if (player_1 == "scissors") and (player_2 == "rock"):
    "player_2"
  else:
    "invalid choice"
  end
  
where:
  rock-paper-scissors("rock","scissors") is "player_1"
  rock-paper-scissors("scissors","scissors") is "tie"
  rock-paper-scissors("paper","scissors") is "player_2"
  rock-paper-scissors("hello","rock") is "invalid choice"
  rock-paper-scissors("hello","world") is "invalid choice"
  
end

#4

planet = table: Planet, Distance
  row: "Mercury", 0.39
  row: "Venus", 0.72
  row: "Earth", 1
  row: "Mars", 1.52
  row: "Jupiter", 5.2
  row: "Staurn", 9.54
  row: "Uranus", 19.2
  row: "Neptune", 30.06
end


mars = planet.row-n(3)
mars["Distance"]

#5
