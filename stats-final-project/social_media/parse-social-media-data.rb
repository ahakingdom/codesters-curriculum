require 'json'
require 'csv'

# Data is just from 6, 7, 8 graders
# Same CSV as the education CSV

csv_data = File.read('50-student-sample.csv')
csv = CSV.parse(csv_data, :headers=> true)

student_data = {}

csv.each_with_index do |row, i|
  student_data["student_#{i + 1}"] = {
     "text_message_sent" => row["Text_Messages_Sent_Yesterday"].to_i, 
     "text_message_received" => row["Text_Messages_Received_Yesterday"].to_i,
     "social_websites" => row["Social_Websites_Hours"].to_i,
  }
end

output = File.open('student_social_media_data.py', 'w')
output << JSON.generate(student_data)
output.close


output = File.open('student_social_media_data.html', 'w')
output << "<!DOCTYPE html><html><head><body><h2>Data from 38 random 6th, 7th, and 8th graders:</h2><table><tr><th>Student</th><th>Text Messages Sent Yesterday</th><th>Text Messages Received Yesterday</th><th>Time Spent on Social Websites (hours)</th></tr>"

student_data.each do |student, data|
  output << "<tr><td>#{student}</td><td>#{data["text_message_sent"]}</td><td>#{data["text_message_received"]}</td><td>#{data["social_websites"]}</td></tr>"
end

output << "</table></body></html>"
output.close