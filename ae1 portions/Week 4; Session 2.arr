use context dcic2024
include data-source
include csv

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

#2

shop = table: object :: String, price :: Number
  row: "Football", 10
  row: "Basketball", 20
  row: "Bat", 30
end

fun add-vat(p :: Table) -> Table:
  transform-column(p, "price", lam(v :: Number): v * 1.2 end)
where:
  test =
    table: price
      row: 10
      row: 20
    end
  add-vat(test) is
  table: price
    row: 12
    row: 24
  end
end

#3

ons = load-table: Code,Indicies,Aug-24,Sep-24,Oct-24,Nov-24,Dec-24,Jan-25,Feb-25,Mar-25,Apr-25,May-25,Jun-25,Jul-25,Aug-25
  source:csv-table-file("ons-cpih-aug25.csv", default-options)
  sanitize Aug-24 using num-sanitizer
  sanitize Sep-24 using num-sanitizer
  sanitize Oct-24 using num-sanitizer
  sanitize Nov-24 using num-sanitizer
  sanitize Dec-24 using num-sanitizer
  sanitize Jan-25 using num-sanitizer
  sanitize Feb-25 using num-sanitizer
  sanitize Mar-25 using num-sanitizer
  sanitize Apr-25 using num-sanitizer
  sanitize May-25 using num-sanitizer
  sanitize Jun-25 using num-sanitizer
  sanitize Jul-25 using num-sanitizer
  sanitize Aug-25 using num-sanitizer
end



new_ons = build-column(ons, "difference", lam(r): r["Aug-24"] - r["Aug-25"] end)

new_ons

newest_ons = build-column(new_ons, "pct-difference", lam(p): ((num-abs(p["difference"] - p["Aug-24"])) / ((p["difference"] + p["Aug-24"]) / 2)) * 100 end)

newest_ons