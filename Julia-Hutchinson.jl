# Assignment: Program Two
# Course: CS 424
# Instructor: Dr. Harry S. Delugach
# Name: LoriElle P. Hutchinson
# Date: 11-24-2026

#=
Program Overview:

This program reads in a register.txt file that details student, course, and registration info. It then uses structs to store student and course info, specifically IDs, names, and details on which students are enrolled in which classes. The program will match students with their registered courses and save them to their respective arrays/vectors. The program will also check for invalid registrations. Finally, it outputs a list of courses with their enrolled students and student info, including the courses they are enrolled in.

=#

# TYPES/ STRUCTS

# (Type Number 1) - Student Information
mutable struct Student

  # Defining variables
  id::String
  name::String
  courses::Vector{String}
  courseCount::Int

end
  
#Used in a loop to add a course to a student's course list
function addCourse(student::Student, course::String)
  student.courseCount = student.courseCount + 1
  push!(student.courses, course)
end

#Returns the student ID saved for that student instance. Used in the loop to see if the ID stored inside this student type matches the student ID from the registration file.
function getID(student::Student)
  return student.id
end

#Returns the student's name saved for that student instance. Used in the loop to add the student's name to the corresponding array.
function getName(student::Student)
  return student.name
end

# Outputs a list of each student with the full course name(s) for which they are enrolled.
function output(student::Student, courses)
  println("Student Name: ", student.name)
  println("Student ID: ", student.id
)
  println("Courses: ")
  
  if isempty(student.courses)
        print("This student is not enrolled in any courses.\n")
  else
    for crn in student.courses
      for c in courses
        if c.crn == crn
          println("- ", c.name)
        end
      end
    end
  end
end

# Outputs the count for the number of courses each student is taking.
function count(student::Student)
  if student.courseCount > 0
  	println("Number of courses: ", student.courseCount)
  end
end

# (Type Number 2) - Course Information
mutable struct Course

  # Defining variables
  crn::String
  name::String
  students::Vector{String}
  studentCount::Int

end
  
#Used in a loop to add a student to course list
function addStudent(course::Course, student::String)
  course.studentCount = course.studentCount + 1
  push!(course.students, student)
end

#Returns the course CRN saved for that course instance. Used in the loop to see if the ID stored inside this course type matches the course CRN from the registration file.
function getID(course::Course)
  return course.crn
end

#Returns the course name saved for that course instance. Used in the loop to add the course name to the corresponding array.
function getName(course::Course, students)
  return course.name
end

# Outputs a list of each course with the full name(s) of enrolled students.
function output(course::Course, students)
  println("Course Name: ", course.name, "(", course.crn,")")
  println("Students: ")
  
  if isempty(course.students)
        print("No students are enrolled in the course.\n")
  else
    for studentID in course.students
      for s in students
        if s.id == studentID
          println("- ", s.name)
        end
      end
    end
  end
end

# Outputs the count for the number of students in a course instance.
function count(course::Course)
  if course.studentCount > 0
  	println("Number of Students: ", course.studentCount)
  end
end

# VARIABLES
global part = 0  #Aids in going through section 0, 1, and 2 of file
students = Student[] #List of student types. Added to as the file is read.
courses = Course[]   #List of course types. Added to as the file is read.
registrations = Vector{Vector{String}}() # A vector within a vector to save student ID and course CRN match-up.

# READING IN THE TEXT FILE
open("register.txt", "r") do file
    for line in eachline(file)
	# If a line is empty, move to the next section of text file.
        if isempty(strip(line))
		global part = part + 1

	# Reads in student IDs and name. Then creates a student class and passes on the read-in info.
	elseif part == 0
    		studentID, studentName = split(strip(line), r"\s+"; limit = 2)
		student = Student(studentID, studentName, String[], 0)
      		push!(students, student)

	# # Reads in course CRNs and names. Then creates a Course struct and stores the information.
	elseif part == 1
    		courseCRN, courseName = split(strip(line), r"\s+"; limit = 2)
		course = Course(courseCRN, courseName, String[], 0)
      		push!(courses, course)

	# Reads in the student IDs and course CRNs to match up enrollment info.
	elseif part == 2
 		#Error checking to make sure only 2 pieces of info are passed. If invalid line, will output error. Else, will push info to registration array.
		data = split(strip(line))

		if length(data) != 2
    			println("Error: Invalid registration line: ", line)

		else
    			studentID = data[1]
    			courseCRN = data[2]
    			push!(registrations, [studentID, courseCRN])
		end
	end
    end
end

#=

REGIS LOOP - This nested loop iterates through each registration and checks whether the student ID and course ID exist. If both exist, it connects the information using the student and course structures. If not, they print an error.

=#
for r in registrations
	studentID = r[1]
	courseCRN = r[2]

	tempStudent = nothing #temporary student type to hold each info while matching up student ID and course crn.
	tempCourse = nothing #temporary student type to hold each info while matching up student ID and course crn.


	for student in students
		if getID(student) == studentID
                	tempStudent = student
			break
		end
	end
	
	for course in courses
		if getID(course) == courseCRN
			tempCourse = course
			break
		end
	end
	
	if tempStudent != nothing && tempCourse != nothing
		addCourse(tempStudent, tempCourse.crn)
		addStudent(tempCourse, tempStudent.id)
	end
	
	if tempStudent == nothing 
		println("Error! Student not found.")
	end

	if tempCourse == nothing
		println("Error! Course not found.")
	end
                
end
 
#=
OUTPUT

Output will be to standard output (e.g., using print or println). Output must include at least these two sections. First, a list of each student with the full course name(s) for which they are enrolled. Optional: the count for the number of courses each student is taking. Also, a list of each course (course number and name) with the full list of student name(s) enrolled in that course.Optional: the count for the number of students in each course

=#
for student in students
    output(student, courses)
    count(student)
    println()
end
println()
for course in courses
    output(course, students)
    count(course)
    println()

end

#=
Reflection:

In this assignment, I learned more about creating structs and functions, working with data types like arrays and vectors, and how similar file reading is in Julia and Ruby.

Overall, I enjoyed the opportunity to learn another programming language. However, between Ruby and Julia, I would prefer Ruby. I appreciated some of the syntax similarities, such as the end keyword, which I had already gotten used to in the first programming assignment. It was also interesting getting to learn about some of the differences between the languages, such as using nothing in Julia instead of nil in Ruby.

I can also see what you meant when you said this language was built by mathematicians for mathematicians. At times, I found myself thinking, "Wow, this would probably be better in a language like Python," especially when it came to having to be more mindful of data types. Another interesting difference was how classes, or in this case structs, work in Julia, with methods being defined outside of the struct declaration. I have mixed feelings about this approach. I think it can make the code look cleaner, but at other times, I find it makes the code less readable and easier to make mistakes, especially if you forget which struct a method is associated with.

All in all, I enjoyed having a pretty similar assignment for programs 1 and 2. I was able to use Programming Assignment 1 as a solid foundation for this program. This made it easier to focus on learning Julia's syntax and recognizing the similarities and differences between the two languages.

=#
