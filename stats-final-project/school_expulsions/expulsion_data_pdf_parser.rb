require 'pdf-reader'
require 'json'
reader = PDF::Reader.new('School-Discipline-Snapshot.pdf')

# puts reader.pdf_version
# puts reader.info
# puts reader.metadata
# puts reader.page_count

# puts reader.page(12)

pg = reader.page(12)
data_table = pg.text.split(/\n/)
# data_table.delete_if { |line| line =~ /^\s*\n/ }
# puts data_table[3] =~ /^\s*\n/ ? "yes" : "no"
# puts data_table[10]
data_table =  data_table[10..-5]
# puts data_table
expulsion_data_males = {}

data_table.each do |row|
  unless row == ""
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
output << "<!DOCTYPE html><html><head><body><h2>Out-of-school suspensions of male students by race/ethnicity, disability, and state: 2011-2012</h2><table><tr><th>State</th><th>American Indian/Alaska Native</th><th>Asian</th><th>Native Hawaiian/Other Pacific Islander</th><th>Black/African American</th><th>Hispanic/Latino of any race</th><th>Two or more races</th><th>White</th></tr>"

expulsion_data_males.each do |state, data|
  output << "<tr><td>#{state}</td><td>#{data["amer_indian"]}</td><td>#{data["asian"]}</td><td>#{data["native_hawaiian"]}</td><td>#{data["black"]}</td><td>#{data["latino"]}</td><td>#{data["multiracial"]}</td><td>#{data["white"]}</td></tr>"
end

output << "</table></body></html>"
output.close