use context dcic2024
include lists
include csv
include data-source

#1

student_score = load-table: Name,Surname,Email,Score
  source: csv-table-file("students_gate_exam_score.csv", default-options)
    
  sanitize Score using num-sanitizer
    
end

student_score1 = order-by(student_score, "Score", false)

student_score1

student_score1.row-n(0)["Score"]

student_score1.row-n(1)["Score"]

student_score1.row-n(2)["Score"]

data Student:
  | student(name :: String, surname :: String, score :: Number)
end

s1 = student("Ethan", "Gray", 97)
s2 = student("Oscar", "Young", 92)
s3 = student("Adrian", "Bennet", 80)

scores :: List<Number> = [list: s1.score, s2.score, s3.score]

fun good-scores(l :: List<Number>):
  cases (List) l:
    | empty => 0
    | link(f, r) => 
      if f > 90:
        1 + good-scores(r)
      else:
        good-scores(r)
      end
  end
  
where:
  good-scores([list: 97, 92, 80]) is (2)
end

good-scores(scores)

#2

all-emails = student_score1.get-column("Email")

fun get-domain(email :: String) -> String:
  parts = string-split(email, "@")
  domain = parts.get(1)
  domain-parts = string-split(domain, ".")
  domain-parts.get(0)
  
where:
  get-domain("e.gray@nulondon.ac.uk") is "nulondon"
end

uni-domain = map(get-domain, all-emails)

distinct_uni-domain = distinct(uni-domain)
  

fun replace-domain(em :: String) -> String:
  part = string-split(em, "@")
  username = part.get(0)
  domain1 = part.get(1)
  
  if domain1 == "nulondon.ac.uk":
    username + "@northeastern.edu"
  else:
    username + "@" + domain1
  end

where:
  replace-domain("alex@nulondon.ac.uk") is "alex@northeastern.edu"
  replace-domain("mia@ucla.edu") is "mia@ucla.edu"
end

all-emails-transformed = map(replace-domain, all-emails)
  