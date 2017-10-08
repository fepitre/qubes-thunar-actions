#!/bin/bash

# Check if at least two arguments are provided: actions + file(s)
if [ "$#" -le 1 ]; then
    echo "Not enough arguments provided. Aborting..."
fi

# File(s)
files=$(echo $* | sed s/"$1 "//g)

# copy and move handle a list of files where other actions don't
case $1 in
    copy)
        /usr/lib/qubes/qvm-copy-to-vm.gnome "$files"
        ;;
    move)
        /usr/lib/qubes/qvm-move-to-vm.gnome "$files"
        ;;
    img)
        for file in $files
        do
            /usr/lib/qubes/qvm-convert-img.gnome  "$file"
        done
        ;;
    pdf)
        for file in $files
        do
            /usr/lib/qubes/qvm-convert-pdf.gnome  "$file"
        done
        ;;
    openvm)
        vm=$(zenity --entry --text "Enter the destination VM name:")
        for file in $files
        do
            qvm-open-in-vm $vm "$file" | zenity --notification --text "Opening $file in VM $vm..." --timeout 3 &
        done
        ;;
    opendvm)
        for file in $files
        do
            qvm-open-in-dvm "$files" | zenity --notification --text "Opening $file in DisposableVM..." --timeout 3 &
        done
        ;;
    *)
        echo "Unknown action. Aborting..."
        exit 1
      ;;
esac
