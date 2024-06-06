#!/bin/bash

# AERC_ACCOUNT
# AERC_FROM_NAME
# AERC_FROM_ADDRESS
# AERC_SUBJECT
# AERC_TO
# AERC_CC

USER_MAIL=$(echo $AERC_TO | sed 's/[<>]//g')
USER_EXISTS=$(khard email "$USER_MAIL")

echo "$USER_EXISTS" >> ~/.contacts/gmail/temp.txt
echo "$USER_MAIL" >> ~/.contacts/gmail/temp.txt

if [ "$USER_EXISTS" = "Found no email addresses" ]; then
  echo "
Formatted name : $USER_MAIL
First name : $USER_MAIL
Email :
  work : $USER_MAIL
" | khard new
  echo "Added new user" >> ~/.contacts/gmail/temp.txt
fi

osascript -e "display notification \"[$AERC_ACCOUNT] SENT EMAIL WITH SUBJECT: $AERC_SUBJECT\" with title \"[$AERC_ACCOUNT] SENT EMAIL TO $AERC_TO\""
