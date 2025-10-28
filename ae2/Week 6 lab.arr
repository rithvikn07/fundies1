use context dcic2024
include lists
include csv
include data-source

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
  | name :: String
  | surname :: String
  | score :: Number
end