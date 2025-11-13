use context starter2024

data TaxonomyTree:
  node(rank :: String, name :: String, children :: List<TaxonomyTree>)
end

# Example: Part of the cat family
lion = node("Species", "Panthera leo", [list: ])
tiger = node("Species", "Panthera tigris", [list: ])
leopard = node("Species", "Panthera pardus", [list: ])
panthera = node("Genus", "Panthera", [list: lion, tiger, leopard])

house-cat = node("Species", "Felis catus", [list: ])
wildcat = node("Species", "Felis silvestris", [list: ])
felis = node("Genus", "Felis", [list: house-cat, wildcat])

felidae = node("Family", "Felidae", [list: panthera, felis])

#1

fun count-species(t :: TaxonomyTree) -> Number:
  if t.rank == "Species":
    1 + count-species-list(t.children)
  else:
    count-species-list(t.children)
  end
end

fun count-species-list(lst :: List<TaxonomyTree>) -> Number:
  cases (List<TaxonomyTree>) lst:
    | empty => 0
    | link(first, rest) => count-species(first) + count-species-list(rest)
  end
  
where:
  count-species(felidae) is 5
end

#2

fun count-rank(t :: TaxonomyTree, r :: String) -> Number:
  if t.rank == r:
    1 + count-rank-list(t.children)
  else:
    count-rank-list(t.children)
  end
end

fun count-rank-list(lst1 :: List<TaxonomyTree>, r :: String) -> Number:
  cases (List<TaxonomyTree>) lst1:
    | empty => 0
    | link(first, rest) => count-rank(first) + count-rank-list(rest)
  end
  
where:
  count-rank(felidae, "Genus") is 2
end

#3

fun taxon-height(t :: TaxonomyTree) -> Number:
  if t.children == [list:]:
    1
  else:
    1 + taxon-height-list(t.children)
  end
end

fun taxon-height-list(lst2 :: List<TaxonomyTree>) -> Number:
  cases (List<TaxonomyTree>) lst2:
    | empty => 0
    | link(first, rest) => num-max(taxon-height(first), taxon-height-list(rest))
  end

where:
   taxon-height(felidae) is 3
end

#4

fun all-names(t :: TaxonomyTree) -> List<String>:
  append([list: t.name], all-names-list(t.children))
end

fun all-names-list(lst3 :: List<TaxonomyTree>) -> Number:
  cases (List<TaxonomyTree>) lst3:
    | empty => [list:]
    | link(first,rest) => append(all-names(first), all-names-list(rest))
  end

where:
  all-names(felidae)
  is [list: "Felidae", "Panthera", "Panthera leo", "Panthera tigris",
               "Panthera pardus", "Felis", "Felis catus", "Felis silvestris"]
end
  

