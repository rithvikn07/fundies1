use context starter2024

#1

fun more-than-five(l):
  cases (List) l:
    | empty => empty
    | link(f,r) =>
      if string-length(f) > 5:
        link(f, more-than-five(r))
      else:
        more-than-five(r)
      end
  end

where:
  more-than-five([list: "apple", "banana", "pear", "mango", "pineapple"]) is [list: "banana", "pineapple"]

  more-than-five([list: "sky", "sea"]) is [list: ]
end

#2

