require 'pdf-reader'
require 'json'
require 'pry'

reader = PDF::Reader.new('School-Discipline-Snapshot.pdf')

table_pt_1 = reader.page(14).text.split(/\n/)[9..-5]

table_pt_2 = reader.page(15).text.split(/\n/)[6..-13]
table_pt_2.delete_if {|row| row.split.length < 3}

expulsion_data_table_from_pdf = table_pt_1 + table_pt_2

expulsion_data_females = {}

expulsion_data_table_from_pdf.each do |row|
  unless row == "" || row.include?("Hawaii")
    row_values = row.split(" ")
    state_name = row_values[0..-8].join(" ")
    expulsion_data_females[state_name] = {
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

output = File.open('us_schools_female_expulsions.py', 'w')
output << JSON.generate(expulsion_data_females)
output.close


output = File.open('us_schools_female_expulsions.html', 'w')
output << "<!DOCTYPE html><html><head><body><h2>Out-of-school suspensions of female students by race/ethnicity and state: 2011-2012</h2><p>Note: Hawaii did not provide data</p><table><tr><th>State</th><th>American Indian/Alaska Native (%)</th><th>Asian (%)</th><th>Native Hawaiian/Other Pacific Islander (%)</th><th>Black/African American (%)</th><th>Hispanic/Latino of any race (%)</th><th>Two or more races (%)</th><th>White (%)</th></tr>"

expulsion_data_females.each do |state, data|
  output << "<tr><td>#{state}</td><td>#{data["amer_indian"]}</td><td>#{data["asian"]}</td><td>#{data["native_hawaiian"]}</td><td>#{data["black"]}</td><td>#{data["latino"]}</td><td>#{data["multiracial"]}</td><td>#{data["white"]}</td></tr>"
end

output << "</table></body></html>"
output.close