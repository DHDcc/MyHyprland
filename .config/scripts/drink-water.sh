#!/bin/bash

# Display a reminder message
echo "It's time to drink water! Stay hydrated."

# Use notify-send to display a desktop notification
notify-send -i ~/icons/water-bottle.icon.png "Drink Water Reminder" "It's time to drink water! Stay hydrated." -u normal

