#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE teams, games")"
echo -e "Cleared all table data"
cat games.csv | while IFS="," read YEAR RND WIN OPP WGL OGL
do
# check that row is not the column headers
if [[ $YEAR != "year" ]]
then
  # try to get the team IDs
  WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WIN'")
  # check that win_id exists
  if [[ -z $WIN_ID ]]
  then
    # if not then insert and try again
    INSERT_NEW_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WIN')")
    WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WIN'")
  fi

  OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP'")
  #check that opp_id exists
  if [[ -z $OPP_ID ]]
  then
    # if not then insert and try again
    INSERT_NEW_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPP')")
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP'")
  fi

  # insert game
  INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$RND', $WIN_ID, $OPP_ID, $WGL, $OGL)")
  # if inserted successfully return a message
  if [[ $INSERT_GAME = "INSERT 0 1" ]]
  then
    echo -e "\nInserted match successfully"
  fi
fi
done