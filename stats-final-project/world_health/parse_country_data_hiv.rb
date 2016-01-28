require 'json'
require 'csv'

# data is from 2014

# http://kff.org/global-indicator/people-living-with-hivaids/#

csv_data = File.read('hiv_aids_data_by_country.csv')
csv = CSV.parse(csv_data, :headers=> true)

country_hiv_aids_data = {}

csv.each_with_index do |row, i|
  unless row["People Living with HIV/AIDS"]== "N/A"
    num_people = row["People Living with HIV/AIDS"].split(",").join().to_i
    country_hiv_aids_data[row["Location"]] = {
        "people_living_with_hiv_aids" => num_people, 
    }
  end
end

puts country_hiv_aids_data.length

output = File.open('country_hiv_aids_data.py', 'w')
output << JSON.generate(country_hiv_aids_data)
output.close


output = File.open('country_hiv_aids_data.html', 'w')
output << "<!DOCTYPE html><html><head><body><h2>People living with HIV/AIDS around the world</h2><table><tr><th>Country</th><th>People Living with HIV/AIDS (2014)</th></tr>"

country_hiv_aids_data.each do |country, data|
  output << "<tr><td>#{country}</td><td>#{data["people_living_with_hiv_aids"]}</td></tr>"
end

output << "</table></body></html>"
output.close
