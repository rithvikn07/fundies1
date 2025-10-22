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

newt2 = order-by(newt, "total", false)

newt2

newt2.row-n(0)["total"]
