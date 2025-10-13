#!/bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=bassem --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
if [[ "$YEAR" != "year" && "$ROUND" != "round" && "$WINNER" != "winner" && "$OPPONENT" != "opponent" && "$WINNER_GOALS" != "winner_goals" && "$OPPONENT_GOALS" != "opponent_goals" ]]
then
query_winner_team=$($PSQL "select name from teams where name = '$WINNER';")
if [[ -z $query_winner_team ]]
then
insert_winner_team=$($PSQL "insert into teams(name) values('$WINNER');")
if [[ $insert_winner_team == "INSERT 0 1" ]]
then
echo "Inserted the team: $WINNER in the teams table"
fi
else
echo "The team: $WINNER allready in the teams table"
fi

query_opponent_team=$($PSQL "select name from teams where name = '$OPPONENT';")
if [[ -z $query_opponent_team ]]
then
insert_opponent_team=$($PSQL "insert into teams(name) values('$OPPONENT');")
if [[ $insert_opponent_team == "INSERT 0 1" ]]
then
echo "Inserted the team: $OPPONENT in the teams table"
fi
else
echo "the team $OPPONENT allready in the teams table"
fi

winner_id=$($PSQL "select team_id from teams where name = '$WINNER';")
opponent_id=$($PSQL "select team_id from teams where name = '$OPPONENT';")
insert_game=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $winner_id, $opponent_id, $WINNER_GOALS, $OPPONENT_GOALS);")
fi
done
