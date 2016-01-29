require 'json'
require 'csv'

# Data is just from 6, 7, 8 graders

# Education

# travel time to school
# hours of homework
# sleep hours school night
# sleep hours non-school night

csv_data = File.read('50-student-sample.csv')
csv = CSV.parse(csv_data, :headers=> true)

student_data = {}

csv.each_with_index do |row, i|
  student_data["student_#{i + 1}"] = {
     "travel_time" => row["Travel_time_to_School"].to_f, 
     "school_night_sleep" => row["Sleep_Hours_Schoolnight"].to_f,
     "weekend_sleep" => row["Sleep_Hours_Non_Schoolnight"].to_f,
     "homework_hours" => row["Doing_Homework_Hours"].to_f
  }
end

output = File.open('student_education_data.py', 'w')
output << JSON.generate(student_data)
output.close

output = File.open('student_education_data.html', 'w')
output << "<!DOCTYPE html><html><head><body><h2>Data from 38 random 6th, 7th, and 8th graders:</h2><table><tr><th>Student</th><th>Travel Time to School (Minutes)</th><th>School Night Sleep (Hours)</th><th>Weekend Sleep (Hours)</th><th>Time Spent on Homework (Hours)</th></tr>"

student_data.each do |student, data|
  travel_time = data["travel_time"]
  school_night_sleep = data["school_night_sleep"]
  weekend_sleep = data["weekend_sleep"]
  homework_hours = data["homework_hours"]
  output << "<tr><td>#{student}</td><td>#{travel_time}</td><td>#{school_night_sleep}</td><td>#{weekend_sleep}</td><td>#{homework_hours}</td></tr>"
end

output << "</table></body></html>"
output.close