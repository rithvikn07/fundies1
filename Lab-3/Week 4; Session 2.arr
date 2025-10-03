use context dcic2024
include data-source

#1

items = table: item :: String, x-coordinate :: Number, y-coordinate :: Number
  row: "Sword of Dawn",           23,  -87
  row: "Healing Potion",         -45,   12
  row: "Dragon Shield",           78,  -56
  row: "Magic Staff",             -9,   64
  row: "Elixir of Strength",      51,  -33
  row: "Cloak of Invisibility",  -66,    5
  row: "Ring of Fire",            38,  -92
  row: "Boots of Swiftness",     -17,   49
  row: "Amulet of Protection",    82,  -74
  row: "Orb of Wisdom",          -29,  -21
end

items

fun make_closer(coords) -> Number:
  coords * 0.9
where:
  make_closer(23) is 23 * 0.9
end

new_x_items = transform-column(items, "x-coordinate", make_closer)

new_items = transform-column(new_x_items, "y-coordinate", make_closer)

new_items

fun calc-distance(r :: Row) -> Number:
  num-sqrt(
    num-sqr(r["x-coordinate"]) + num-sqr(r["y-coordinate"]))
  
where:
  calc-distance(items.row-n(0)) is-roughly
    num-sqrt(num-sqr(23) + num-sqr(-87))
      
  calc-distance(items.row-n(3)) is-roughly
    num-sqrt(num-sqr(-9) + num-sqr(64))
end

items_dist_rough = build-column(items, "distance", calc-distance)

items_dist_rough

items_dist = transform-column(items_dist_rough, "distance", num-to-rational)

items_dist

new_items_dist = order-by(items_dist, "distance", true)

new_items_dist.row-n(0)["distance"]


fun obfuscate(str :: String) -> String:
  string-repeat("X", string-length(str))
  
where:
  obfuscate("hello") is "XXXXX"
end

x_items = transform-column(new_items_dist, "item", obfuscate)

x_items

fun ob(t :: Table) -> Table:
  transform-column(t, "item", lam(str :: String): string-repeat("X", string-length(str)) end)
where:
  test-table =
    table: item
      row: "Sword of Dawn"
      row: "Healing Potion"
    end
  ob(test-table) is 
  table: item
    row: "XXXXXXXXXXXXX"
    row: "XXXXXXXXXXXXXX"
  end
end

