require 'json'
require 'csv'
require 'pry'

# data is from 2014

# http://kff.org/global-indicator/people-living-with-hivaids/#

csv_data = File.read('hiv_aids_data_by_country.csv')
csv = CSV.parse(csv_data, :headers=> true)

country_hiv_aids_data = {}

csv.each_with_index do |row, i|
  if row["People Living with HIV/AIDS"] != "N/A" && row["Adults receiving ART"] != "N/A" && row["AIDS Deaths"] != "N/A"
    num_people = row["People Living with HIV/AIDS"].split(",").join().to_i
    receiving_treatment = row["Adults receiving ART"].split(",").join().to_i
    row["AIDS Deaths"][0] == "<" ? deaths = row["AIDS Deaths"][1..-1] : deaths = row["AIDS Deaths"]
    deaths = deaths.split(",").join().to_i
    country_hiv_aids_data[row["Location"]] = {
        "people_living_with_hiv_aids" => num_people,
        "people_receiving_ART" => receiving_treatment,
        "aids_deaths" => deaths
    }
  end
end

country_hiv_aids_data = country_hiv_aids_data.sort_by {|country, data| data["people_living_with_hiv_aids"]}.reverse
country_hiv_aids_data = country_hiv_aids_data[0..49].to_h

output = File.open('country_hiv_aids_data.py', 'w')
output << JSON.generate(country_hiv_aids_data)
output.close


output = File.open('country_hiv_aids_data.html', 'w')
output << "<!DOCTYPE html><html><head><body><h2>People living with HIV/AIDS around the world</h2><table><tr><th>Country</th><th>People Living with HIV/AIDS (2014)</th><th>People Receiving Antiretroviral Therapy (2014)</th><th>AIDS Deaths (2014)</th></tr>"

country_hiv_aids_data.each do |country, data|
  output << "<tr><td>#{country}</td><td>#{data["people_living_with_hiv_aids"]}</td><td>#{data["people_receiving_ART"]}</td><td>#{data["aids_deaths"]}</td></tr>"
end

output << "</table></body></html>"
output.close
