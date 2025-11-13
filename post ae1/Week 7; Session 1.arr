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

fun my-sum(l):
  cases (List) l:
    | empty => 0
    | link(f, r) => f + my-sum(r)
  end

where:
  my-sum([list:1,2,3]) is 6
  my-sum([list: ]) is 0
end


fun my-len(l):
  cases (List) l:
    | empty => 0
    | link(f, r) => 1 + my-len(r)
  end
  
where:
  my-len([list:1,5,6]) is 3
  my-len([list: ]) is 0
end


fun my-average(l):
  cases (List) l:
    | empty => raise("cannot take average of empty list")
    | else => my-sum(l) / my-len(l)
  end

where:
  my-average([list: 2, 4, 6, 8]) is 5
  my-average([list: 10, 20]) is 15
end

#3.1

fun my-mx(acc, l):
  cases (List) l:
    | empty => acc
    | link(f, r) =>
      if f > acc:
        my-mx(f, r)
      else:
        my-mx(acc, r)
      end
  end
end


fun my-max(l):
  cases (List) l:
    | empty => raise("not defined for empty lists")
    | link(f, r) => my-mx(f, r)
  end

where:
  my-max([list: 2, 1, 4, 3, 2]) is 4
  my-max([list: 9]) is 9
end

#3.2

