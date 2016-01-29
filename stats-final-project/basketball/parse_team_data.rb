require 'json'
require 'csv'

# Data is from 2015
# http://www.basketball-reference.com/leagues/NBA_2015.html

def separate_comma(number)
  number.to_s.chars.to_a.reverse.each_slice(3).map(&:join).join(",").reverse
end

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
  data["field_goals"].to_s.length > 3 ? field_goals = separate_comma(data["field_goals"]) : field_goals = data["field_goals"].to_s
  data["fg_attempts"].to_s.length > 3 ? fg_attempts = separate_comma(data["fg_attempts"]) : fg_attempts = data["fg_attempts"].to_s
  data["free_throws"].to_s.length > 3 ? free_throws = separate_comma(data["free_throws"]) : free_throws = data["free_throws"].to_s
  data["ft_attempts"].to_s.length > 3 ? ft_attempts = separate_comma(data["ft_attempts"]) : ft_attempts = data["ft_attempts"].to_s
  output << "<tr><td>#{team}</td><td>#{field_goals}</td><td>#{fg_attempts}</td><td>#{free_throws}</td><td>#{ft_attempts}</td></tr>"
end

output << "</table></body></html>"
output.close