class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.run(query, *args) #programers are lazy, and variable arguments is cool
    DB[:conn].execute(query, args).map{|row| self.new_from_db(row)}
  end

  def self.all 
    sql = "SELECT * FROM students"
    run(sql)
  end

  def self.find_by_name(name) #Don't know why we used LIMIT 1 in the lab even thu the query returns one student
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
    SQL
    run(sql, name)[0]
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    run(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    run(sql)
  end

  def self.all_students_in_grade_9
    all_students_in_grade_X(9)
  end

  def self.students_below_12th_grade
    all.select{|st| st.grade.to_i < 12}
    # sql = <<-SQL
    #   SELECT * FROM students
    #   WHERE grade < ?
    # SQL
    # run(sql, 12)
  end

  def self.first_X_students_in_grade_10(x)
    all_students_in_grade_X(10).take(x)
    # sql = <<-SQL
    #   SELECT * FROM students
    #   WHERE grade = 10
    #   LIMIT ?
    # SQL
    # run(sql, x)
  end

  def self.first_student_in_grade_10
    first_X_students_in_grade_10(1)[0]
  end
  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = ?
    SQL
    run(sql, x)
  end

end
