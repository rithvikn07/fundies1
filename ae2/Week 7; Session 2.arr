use context starter2024

data River:
  | merge(width :: Number, left :: River, right :: River)
  | stream(flow-rate :: Number)
end

main-river = merge(11, stream(5), stream(4))
main-river2 = merge(2, main-river, stream(2))


#1

fun count-streams(r :: River) -> Number:
  cases (River) r:
    | merge(width, left, right) => count-streams(left) + count-streams(right)
    | stream(flow) => 1
  end
where:
  count-streams(main-river) is 2
end

#2

fun max-width(r :: River) -> Number:
  cases (River) r:
    | stream(flow) => 0
    | merge(width, left, right) => num-max(width, num-max(max-width(left), max-width(right)))
  end
where:
  max-width(main-river2) is 11
end
  
#3

fun widen-river(r :: River, amount :: Number) -> River:
  cases (River) r:
    | merge(width, left, right) => merge(width + amount, widen-river(left, amount), widen-river(right, amount))
    | stream(flow) => stream(flow)
  end
where:
  widen-river(main-river, 1) is merge(12, stream(5), stream(4))
  widen-river(main-river, 2).width is 13
end

#4

fun cap-flow(r :: River, cap :: Number) -> River:
  cases(River) r:
    | stream(flow) => 
      if flow > cap:
        stream(cap)
      else:
        stream(flow)
      end
    | merge(width, left, right) => merge(width, cap-flow(left, cap), cap-flow(right, cap))
  end
where:
  cap-flow(main-river, 3) is merge(11, stream(3), stream(3))
end


main-river3 = merge(3, stream(10), stream(1))
main-river4 = merge(4, stream(5), stream(6))
main-river5 = merge(7, stream(4), stream(3))

#5

fun has-large-stream(r :: River) -> Boolean:
  cases(River) r:
    | stream(f) =>
      if f > 5:
        true
      else:
        false
      end
    | merge(width, left, right) => has-large-stream(left) or has-large-stream(right)
  end
where:
  has-large-stream(main-river3) is true
  has-large-stream(main-river4) is true
  has-large-stream(main-river5) is false
end