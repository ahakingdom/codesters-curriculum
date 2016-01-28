require 'json'
require 'csv'

# Data is from 2015
# http://www.basketball-reference.com/leagues/NBA_2015.html


csv_data = File.read('leagues_NBA_2015_team.csv')
csv = CSV.parse(csv_data, :headers=> true)

team_data = {}

csv.each do |row|
  row["Team"][-1] == "*" ? team_name = row["Team"][0...-1] : team_name = row["Team"]
  team_data[team_name] = {
    "field_goals" => row["Field Goals"].to_i,
    "fg_attempts" => row["Field Goal Attempts"].to_i, 
    "free_throws" => row["Free Throws"].to_i,
    "ft_attempts" => row["Free Throw Attempts"].to_i
  }
end

output = File.open('NBA_teams_2015.py', 'w')
output << JSON.generate(team_data)
output.close


output = File.open('NBA_teams_2015.html', 'w')
output << "<!DOCTYPE html><html><head><body><h2>NBA Team Stats 2015</h2><table><tr><th>Team</th><th>Field Goals</th><th>Field Goal Attempts</th><th>Free Throws</th><th>Free Throw Attempts</th></tr>"

team_data.each do |team, data|
  output << "<tr><td>#{team}</td><td>#{data["field_goals"]}</td><td>#{data["fg_attempts"]}</td><td>#{data["free_throws"]}</td><td>#{data["ft_attempts"]}</td></tr>"
end

output << "</table></body></html>"
output.close