#!/bin/bash

command=$(acpi -b)
command=${command//, / }

#state=$(echo $res | awk '{ print $2 }')
state=$(echo $command | awk '{ print $3 }')
percentage=$(echo $command | awk '{ print $4 }' | sed 's/%//' )
time_to=$(echo $command | awk '{ print $5 }')
time_to=${time_to:0:5}

full_text="$percentage%"
color="#00FF00"

if [[ $state == "Charging" ]] || [[ $state == "Unknown" ]]; then
    full_text=" $full_text"
elif [[ $state == "Discharging" ]]; then
    full_text="$full_text"
fi

if [[ ! -z $time_to ]]; then
    full_text="$full_text($time_to)"
fi

if [[ $state == "Discharging" ]];then

    if [[ $percentage -lt 20 ]]; then
        full_text=" $full_text"
        color="#FF0000"
        #notify-send -u critical "Battery Insanely Low <br> below 20%" "please connect charger now :/"
    elif [[ $percentage -lt 40 ]]; then
        full_text=" $full_text"
        color="#FFAE00"
        #notify-send -t 5000 -u normal "Battery Low <br> below 40%" "please connect charger"
    elif [[ $percentage -lt 60 ]]; then
        full_text=" $full_text"
        color="#FFF600"
    elif [[ $percentage -lt 85 ]]; then
        full_text=" $full_text"
        color="#A8FF00"
    elif [[ $percentage -lt 100 ]]; then
        full_text=" $full_text"
        color="#00FF00"
    fi
fi


echo $full_text
echo
echo $color
