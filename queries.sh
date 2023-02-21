#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.
call () {
  echo "$($PSQL "$1")"
}

WIN="winner"
WGL="winner_goals"
OPP="opponent"
OGL="opponent_goals"

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
call "select sum($WGL + $OGL) from games"

echo -e "\nAverage number of goals in all games from the winning teams:"
call "select avg($WGL) from games"

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
call "select round(avg($WGL), 2) from games"

echo -e "\nAverage number of goals in all games from both teams:"
call "select avg($WGL + $OGL) from games"

echo -e "\nMost goals scored in a single game by one team:"
call "select MAX($WGL) from games"

echo -e "\nNumber of games where the winning team scored more than two goals:"
call "select count(*) from games where $WGL > 2"

echo -e "\nWinner of the 2018 tournament team name:"
call "select name from teams full join games on teams.team_id = games.winner_id where round='Final' and year=2018"

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
call "select distinct name from games as g1 full join teams on g1.winner_id = teams.team_id full join games as g2 on teams.team_id = g2.opponent_id where (g1.year=2014 or g2.year=2014) and (g1.round='Eighth-Final' or g2.round='Eighth-Final')"

echo -e "\nList of unique winning team names in the whole data set:"
call "select distinct name from teams right join games on teams.team_id = games.winner_id order by name"

echo -e "\nYear and team name of all the champions:"
call "select year, name from teams full join games on teams.team_id = games.winner_id where round='Final' order by year"

echo -e "\nList of teams that start with 'Co':"
call "select name from teams where name LIKE 'Co%'"
