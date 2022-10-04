#!/bin/bash
if [ "$#" -ne 1 ]
then
  echo Please provide an element as an argument.
else
  PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

  # if argument is number
  if [[ $1 == ?(-)+([0-9]) ]]
  then
    ELEMENT=$($PSQL "SELECT * FROM elements WHERE atomic_number = $1")
  else
    # if argument is not a nubmer
    ELEMENT=$($PSQL "SELECT * FROM elements WHERE symbol = '$1' OR name = '$1'")
  fi

  if [[ -z $ELEMENT ]]
  then
    # if element entered not exist
    echo 'I could not find that element in the database.'
  else
    # read into variables
    echo "$ELEMENT" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME
    do
      PROPERTY=$($PSQL "SELECT type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties LEFT JOIN types ON types.type_id = properties.type_id WHERE atomic_number = $ATOMIC_NUMBER");

      echo "$PROPERTY" | while read TYPE BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
      done
    done
  fi
fi
