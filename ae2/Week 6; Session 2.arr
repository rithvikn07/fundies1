use context starter2024

link(1, link(2, link(3, empty)))

#1
fun string-concat(l :: List):
  cases (List) l:
    | empty => ""
    | link(f, r) => f + string-concat(r)
  end
where:
  string-concat([list: "a", "b", "c"]) is "abc"
end

#2

fun strings-upper(l2 :: List):
  cases (List) l2:
    | empty => empty
    | link(f, r) => link(string-to-upper(f), strings-upper(r))
  end
where:
  strings-upper([list: "a", "b", "c"]) is ([list: "A", "B", "C"])
end

#3

fun round-numbers(l3 :: List<Number>):
  cases (List) l3:
    | empty => empty
    | link(f, r) => link(num-round(f), round-numbers(r))
  end
where:
  round-numbers([list: 1.8, 2.2, 3.1]) is ([list: 2, 2, 3])
end