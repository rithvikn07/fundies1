use context dcic2024
include csv
include data-source

basket = table: item :: String, price :: Number, quantity :: Number
  row: "apple", 0.50, 10
  row: "orange", 0.75, 5
  row: "watermelon", 2.99, 2

end

basket

fun add-table(t :: Table) -> Table:
  build-column(t, "total", lam(x :: Row): x["price"] * x["quantity"] end)
  
end

newt = add-table(basket)

newt


fun tick(t1 :: Table) -> Table:
  transform-column(t1, "price", lam(y): y + 2 end)

where:
  test-table = table: price
    row: 2
    row: 4
  end 
  tick(test-table) is
  table: price
  row: 4
  row: 6

end
end

