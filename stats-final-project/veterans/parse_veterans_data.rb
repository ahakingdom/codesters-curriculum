# original dataset: http://www.census.gov/library/infographics/veterans-statistics.html (Table 1)
# data from 2009 - 2013
require 'json'
require 'csv'

def separate_comma(number)
  number.to_s.chars.to_a.reverse.each_slice(3).map(&:join).join(",").reverse
end

csv_data = File.read('veterans_data.csv')
csv = CSV.parse(csv_data, :headers=> true)

veterans_data = {}

csv.each do |row|
  veterans_data[row["State"]] = {
    "vet_pop" => row["Veteran Population"].split(',').join.to_i, 
    "percent_female" => row["Percent Female"].to_f, 
    "median_income" => row["Median Household Income"][1..-1].split(',').join.to_i,
    "college_grads" => row["Bachelor's Degree or Higher"].to_f

  }
end

output = File.open('veterans_data.py', 'w')
output << JSON.generate(veterans_data)
output.close

output = File.open('veterans_data.html', 'w')
output << "<!DOCTYPE html><html><head><body><h2>Characteristics of Veterans by State</h2><table><tr><th>State</th><th>Veteran Population</th><th>% Female</th><th>Median Household Income ($)</th><th>Bachelor's Degree or Higher (%)</th></tr>"

veterans_data.each do |state, data|
  vet_pop = separate_comma(data["vet_pop"])
  median_income = separate_comma(data["median_income"])
  output << "<tr><td>#{state}</td><td>#{vet_pop}</td><td>#{data["percent_female"]}</td><td>#{median_income}</td><td>#{data["college_grads"]}</td></tr>"
end

output << "</table></body></html>"
output.close