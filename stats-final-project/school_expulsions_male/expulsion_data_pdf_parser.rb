require 'pdf-reader'
require 'json'
require 'pry'

reader = PDF::Reader.new('School-Discipline-Snapshot.pdf')

table_pt_1 = reader.page(12).text.split(/\n/)[10..-5]
table_pt_2 = reader.page(13).text.split(/\n/)[6..-12]
table_pt_2.delete_if {|row| row.split.length < 3}

misaligned_states = ["Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"]

i = -5
state = 0
while i < 0
  no_state = table_pt_2[i].split()
  add_state = no_state.unshift(misaligned_states[state]).join(" ")
  table_pt_2[i] = add_state
  i += 1
  state += 1
end

expulsion_data_table_from_pdf = table_pt_1 + table_pt_2

expulsion_data_males = {}

expulsion_data_table_from_pdf.each do |row|
  unless row == "" || row.include?("Hawaii")
    row_values = row.split(" ")
    state_name = row_values[0..-8].join(" ")
    expulsion_data_males[state_name] = {
      "amer_indian" => row_values[-7].to_i, 
      "asian" => row_values[-6].to_i,
      "native_hawaiian" => row_values[-5].to_i, 
      "black" => row_values[-4].to_i, 
      "latino" => row_values[-3].to_i, 
      "multiracial" => row_values[-2].to_i, 
      "white" => row_values[-1].to_i
    }
  end
end

output = File.open('us_schools_male_expulsions.py', 'w')
output << JSON.generate(expulsion_data_males)
output.close


output = File.open('us_schools_male_expulsions.html', 'w')
output << "<!DOCTYPE html><html><head><body><h2>Out-of-school suspensions of male students by race/ethnicity, disability, and state: 2011-2012</h2><p>Note: Hawaii did not provide data</p><table><tr><th>State</th><th>American Indian/Alaska Native</th><th>Asian</th><th>Native Hawaiian/Other Pacific Islander</th><th>Black/African American</th><th>Hispanic/Latino of any race</th><th>Two or more races</th><th>White</th></tr>"

expulsion_data_males.each do |state, data|
  output << "<tr><td>#{state}</td><td>#{data["amer_indian"]}</td><td>#{data["asian"]}</td><td>#{data["native_hawaiian"]}</td><td>#{data["black"]}</td><td>#{data["latino"]}</td><td>#{data["multiracial"]}</td><td>#{data["white"]}</td></tr>"
end

output << "</table></body></html>"
output.close