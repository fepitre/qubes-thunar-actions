#!/bin/bash

# Allow us to handle filenames with spaces using newline separator from Thunar
IFS='
'

# Check if at least two arguments are provided: actions + file(s)
if [ "$#" -le 1 ]; then
    echo "Not enough arguments provided. Aborting..."
fi

# File(s)
files=${*:2}

# copy and move handle a list of files where other actions don't
case $1 in
    copy)
        qvm-copy-to-vm '$default' $files | zenity --notification --text="Copying files..." --timeout 3
        ;;
    move)
        qvm-move-to-vm '$default' $files | zenity --notification --text="Moving files..." --timeout 3
        ;;
    img)
        for file in $files
        do
            qvm-convert-img $file | zenity --notification --text="Converting file $file..." --timeout 3
        done
        ;;
    pdf)
        for file in $files
        do
            qvm-convert-pdf $file | zenity --notification --text="Converting file $file..." --timeout 3
        done
        ;;
    openvm)
        for file in $files
        do
            qvm-open-in-vm '$default' $file | zenity --notification --text "Opening $file in VM..." --timeout 3 &
        done
        ;;
    opendvm)
        for file in $files
        do
            qvm-open-in-dvm $files | zenity --notification --text "Opening $file in DisposableVM..." --timeout 3 &
        done
        ;;
    *)
        echo "Unknown action. Aborting..."
        exit 1
      ;;
esac
