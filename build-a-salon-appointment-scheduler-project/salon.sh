#!/bin/bash
PSQL="psql -X --username=bassem --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ My salon ~~~~~"
echo -e "\nWelcome to My Salon, how can I help you?"

SALON() {
if [[ $1 ]]
then
echo -e "$1"
fi

SERVICES=$($PSQL "select service_id, name from services order by service_id;")

echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
do
echo "$SERVICE_ID) $SERVICE_NAME"
done

read SERVICE_ID_SELECTED
if [[ ! $USER_SELECTION =~ ^[0-9]*$ ]]
then
SALON "Invalid selection.\n What would you like today?"
fi
QUERY_SERVICE_RESULT=$($PSQL "select service_id from services where service_id = $SERVICE_ID_SELECTED;")
if [[ -z $QUERY_SERVICE_RESULT ]]
then
SALON "I could not find that service.\n What would you like today?"
else
echo "What's your phone number?"
read CUSTOMER_PHONE
CUSTOMER_NAME=$($PSQL "select name from customers where phone = '$CUSTOMER_PHONE';")
if [[ -z $CUSTOMER_NAME ]]
then
echo "I don't have a record for that phone number, what's your name?"
read CUSTOMER_NAME
CUSTOMER_INSERT_RESULT=$($PSQL "insert into customers(name, phone) values('$CUSTOMER_NAME', '$CUSTOMER_PHONE');")
SERVICE_NAME_SELECTED=$($PSQL "select name from services where service_id = $SERVICE_ID_SELECTED;")
echo "What time would you like your $SERVICE_NAME_SELECTED $CUSTOMER_NAME?"
read SERVICE_TIME
CUSTOMER_ID_SELECTED=$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE';")
INSERT_APPOINTMENT=$($PSQL "insert into appointments(customer_id, service_id, time) values($CUSTOMER_ID_SELECTED, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")
echo "I have put you down for a $SERVICE_NAME_SELECTED at $SERVICE_TIME, $CUSTOMER_NAME."
else
SERVICE_NAME_SELECTED=$($PSQL "select name from services where service_id = $SERVICE_ID_SELECTED;")
echo "What time would you like your $SERVICE_NAME_SELECTED $CUSTOMER_NAME?"
read SERVICE_TIME
CUSTOMER_ID_SELECTED=$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE';")
INSERT_APPOINTMENT=$($PSQL "insert into appointments(customer_id, service_id, time) values($CUSTOMER_ID_SELECTED, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")
echo "I have put you down for a $SERVICE_NAME_SELECTED at $SERVICE_TIME, $CUSTOMER_NAME."
fi
fi
}

SALON
