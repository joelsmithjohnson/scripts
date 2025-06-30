#!/bin/bash

# menuselect.sh
# This script provides an interactive terminal menu for selecting options.
# Users can navigate the menu using the Up and Down arrow keys and select an option by pressing Enter.
# The script dynamically highlights the currently selected option and supports an "Exit" option to quit.
#
# Features:
# - Arrow key navigation (Up/Down) to move through menu options.
# - Real-time menu updates with highlighted selection.
# - Option selection with Enter key.
# - Graceful exit with the "Exit" option or by pressing 'q'.
#
# Usage:
# ./menuselect.sh option1 option2 option3 ...
# Example:
# ./menuselect.sh "Option 1" "Option 2" "Option 3"
# Example calling from another script
# options=("Option 1" "Option 2" "Option 3")
# selected_option=$(./menuselect.sh "${options[@]}")
#
# Dependencies:
# - Requires a terminal that supports ANSI escape codes.
# - Uses `stty` for raw input handling and `dd` for reading keypresses.

# Define the options
options=("$@")
options+=("Exit")

# Initialize variables
selected=0
num_options=${#options[@]}
menu_printed=false

clear_menu() {
    printf "\033[${num_options}A" # Clear the screen for subsequent displays
    printf "\033[1A"
    printf "\033[0J" # Clear the screen from the cursor down
}

# Function to display the menu
display_menu() {
    if $menu_printed; then
        clear_menu
    fi
    echo "Use arrow keys to navigate and Enter to select or q to Quit:"
    for i in "${!options[@]}"; do
        if [[ $i -eq $selected ]]; then
            # Highlight the selected option
            printf "\e[1;32m> %s\e[0m\n" "${options[$i]}"
        else
            echo "  ${options[$i]}"
        fi
    done
    menu_printed=true
}

display_selection() {
    printf "\033[${num_options}A" # Clear the screen for subsequent displays
    printf "\033[1A"
    printf "\033[0J" # Clear the screen from the cursor down
    echo "$1"
}

get_selection() {
    stty -icanon -echo
    while true; do
    display_menu $num_options

    # Read user input
    # Read 1 bytes
    key=$(dd bs=1 count=1 2>/dev/null)

    if [[ $key == $'\x1b' ]]; then
        # Read the next two bytes for arrow keys
        key2=$(dd bs=1 count=2 2>/dev/null)
        key="$key$key2"
    fi

    case "$key" in
        $'\e[A') # Up Arrow
            ((selected--))
            if [[ $selected -lt 0 ]]; then
                selected=$((num_options - 1))
            fi
            ;;
        $'\e[B') # Down Arrow
            ((selected++))
            if [[ $selected -ge $num_options ]]; then
                selected=0
            fi
            ;;
        q) # Quit on 'q'
            clear_menu
            break
            ;;
        "") # Enter key pressed
            if [[ ${options[$selected]} == "Exit" ]]; then
                clear_menu
                break
            else
                display_selection ${options[$selected]}
                break
            fi
            ;;
        *) # Any other key, ignore it
            continue
            ;;
    esac
    done

}

selected_option=$(get_selection | tee /dev/tty | sed -r 's/\x1b\[[0-9;]*[a-zA-Z]//g' | tail -n 1)
if [[ " $@ " =~ " $selected_option " ]]; then
    echo $selected_option
else
    echo ""
fi
  # Restore terminal settings
stty sane