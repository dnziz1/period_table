#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# If no arg provided
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

# Check if argument is a number 
if [[ $1 =~ ^[0-9]+$ ]]
then
  ATOMIC_NUMBER=$1
  QUERY_RESULT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p ON e.atomic_number = p.atomic_number JOIN types t ON p.type_id = t.type_id WHERE e.atomic_number = $ATOMIC_NUMBER")
else
  # Check if argument is symbol 
  if [[ $1 =~ ^[A-Za-z]{1,2}$ ]]
  then
    SYMBOL=$1
    QUERY_RESULT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p ON e.atomic_number = p.atomic_number JOIN types t ON p.type_id = t.type_id WHERE e.symbol = '$SYMBOL' OR e.symbol = INITCAP('$SYMBOL')")
  else
    # Argument is a name
    NAME=$1
    QUERY_RESULT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p ON e.atomic_number = p.atomic_number JOIN types t ON p.type_id = t.type_id WHERE e.name = '$NAME' OR e.name = INITCAP('$NAME')")
  fi
fi

