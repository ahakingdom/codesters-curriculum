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
     "travel_time" => row["Travel_time_to_School"], 
     "school_night_sleep" => row["Sleep_Hours_Schoolnight"],
     "weekend_sleep" => row["Sleep_Hours_Non_Schoolnight"],
     "homework_hours" => row["Doing_Homework_Hours"]
  }
end

output = File.open('student_education_data.py', 'w')
output << JSON.generate(student_data)
output.close

output = File.open('student_education_data.html', 'w')
output << "<!DOCTYPE html><html><head><body><h2>Data from 38 random 6th, 7th, and 8th graders:</h2><table><tr><th>Student</th><th>Travel Time to School</th><th>School Night Sleep (Hours)</th><th>Weekend Sleep (Hours)</th><th>Homework Hours</th></tr>"

student_data.each do |student, data|
  output << "<tr><td>#{student}</td><td>#{data["travel_time"]}</td><td>#{data["school_night_sleep"]}</td><td>#{data["weekend_sleep"]}</td><td>#{data["homework_hours"]}</td></tr>"
end

output << "</table></body></html>"
output.close