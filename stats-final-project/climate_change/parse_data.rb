require 'json'
require 'httparty'

# data from NOAA
# data sources are JSON endpoints below
# interactive data feature: http://www.ncdc.noaa.gov/cag/time-series/us/110/0/tavg/1/1/1965-2015?base_prd=true&firstbaseyear=1965&lastbaseyear=2015

months = {"January" => 1, "July" => 7}

months.each do |month_name, month_num|
  url_avg_temp = "http://www.ncdc.noaa.gov/cag/time-series/us/110/00/tavg/1/#{month_num}/1960-2015.json?base_prd=true&firstbaseyear=1960&lastbaseyear=2015"
  url_max_temp = "http://www.ncdc.noaa.gov/cag/time-series/us/110/00/tmax/1/#{month_num}/1965-2015.json?base_prd=true&firstbaseyear=1965&lastbaseyear=2015"
  url_min_temp = "http://www.ncdc.noaa.gov/cag/time-series/us/110/00/tmin/1/#{month_num}/1965-2015.json?base_prd=true&firstbaseyear=1965&lastbaseyear=2015"
  
  response_avg_temp = HTTParty.get(url_avg_temp)
  response_max_temp = HTTParty.get(url_max_temp)
  response_min_temp = HTTParty.get(url_min_temp)

  avg_temp_data = JSON.parse(response_avg_temp)["data"]
  max_temp_data = JSON.parse(response_max_temp)["data"]
  min_temp_data = JSON.parse(response_min_temp)["data"]

  all_data = {
    :avg_temp_data => avg_temp_data, 
    :max_temp_data => max_temp_data, 
    :min_temp_data => min_temp_data
  }

  years = (1965..2015).to_a

  climate_hash = years.each_with_object({}) do |year, climate_hash|
    year_with_month = "#{month_name} #{year}"
    data_year = "#{year}0#{month_num}"
    
    climate_hash[year_with_month] = {
      "avg_temp" => all_data[:avg_temp_data][data_year]["value"].to_f, 
      "max_temp" => all_data[:max_temp_data][data_year]["value"].to_f,
      "min_temp" => all_data[:min_temp_data][data_year]["value"].to_f
    }
  end
  
  file_name = "#{month_name.downcase}_climate_data.py"
  output = File.open(file_name, 'w')
  output << JSON.generate(climate_hash)
  output.close

  file_name = "#{month_name.downcase}_climate_data.html"
  output = File.open(file_name, 'w')
  output << "<!DOCTYPE html><html><head><body><h2>Average, Maximum, and Minimum Temperature for #{month_name} 1965-2015 in the 48 Contiguous US States</h2><table><tr><th>Month, Year</th><th>Average Temp (&degF)</th><th>Maximum Temp (&degF)</th><th>Minimum Temp (&degF)</th></tr>"

  climate_hash.each do |year, data|
    output << "<tr><td>#{year}</td><td>#{data["avg_temp"]}</td><td>#{data["max_temp"]}</td><td>#{data["min_temp"]}</td></tr>"
  end

  output << "</table></body></html>"
  output.close

end

