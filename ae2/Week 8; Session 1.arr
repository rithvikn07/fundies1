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
end

#2

