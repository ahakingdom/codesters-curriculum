require 'csv'
require 'pry'

# Education

# travel time to school
# hours of homework
# sleep hours school night
# sleep hours non-school night

# Social Media

# text messages sent
# hours of social media

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
output << "<!DOCTYPE html><html><head><body><table><tr><th>State</th><th>Population (2014)</th><th>% of People with Home Computers (2014)</th><th>Number of Amusement Parks (2013)</th><th>% of People Who Ride Public Transit (2013)</th></tr>"

state_data.each do |state, data|
  state_unslug = state.split("_").map(&:capitalize).join(" ")
  output << "<tr><td>#{state_unslug}</td><td>#{data["population"]}</td><td>#{data["home_computer"]}</td><td>#{data["amusement_parks"]}</td><td>#{data["public_transit_riders"]}</td></tr>"
end

output << "</table></body></html>"

output.close