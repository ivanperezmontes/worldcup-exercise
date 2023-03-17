#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database

echo "$($PSQL "TRUNCATE teams, games RESTART IDENTITY")"
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != "year" ]]
then
  WINNER_EXISTS="$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")"
  if [[ -z $WINNER_EXISTS ]]
  then
    INSERT_WINNER="$($PSQL "INSERT INTO teams (name) VALUES('$WINNER')")"
    if [[ $INSERT_WINNER == "INSERT 0 1" ]]
      then
        echo -e "\n$WINNER inserted"
    else
        echo -e "\nError inserting $WINNER"
    fi
  else
    echo -e  "\nTeam $WINNER already exists"
  fi

  OPPONENT_EXISTS="$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")"
  if [[ -z $OPPONENT_EXISTS ]]
    then
      INSERT_OPPONENT="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
    if [[ $INSERT_OPPONENT == "INSERT 0 1" ]]
      then
        echo -e "\$OPPONENT inserted"
      else
        echo  -e "\nError inserting $OPPONENT"
    fi
  else
    echo -e "\nTeam $OPPONENT already exists"
  fi
  WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
  OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
  INSERT_GAMES="$($PSQL "INSERT INTO games(year, round, winner_id, winner_goals, opponent_goals, opponent_id) VALUES($YEAR,'$ROUND', $WINNER_ID, $WINNER_GOALS, $OPPONENT_GOALS, $OPPONENT_ID)")"
  if [[ $INSERT_GAMES == "INSERT 0 1" ]]
    then
      echo -e "\nGame insertion correct"
    else
      echo -e "\nGame insertion incorrect"
  fi
fi
done
