#!/bin/bash

# For **Linux** (Experimental) you can run the following command:

# ```bash
# bash -c "$(curl -fsSL https://raw.githubusercontent.com/edelvarden/material-fox-updated/main/install.sh)"
# ```

install() {

  # ----------------------------------------------------------------
  # Get the browser profiles path

  profile_directories=(
  "${HOME}/.mozilla/firefox"
  #"${HOME}/Library/Application Support/Firefox"
  )

  existing_paths=()

  for path in "${profile_directories[@]}"; do
    if [ -d "$path" ]; then
      existing_paths+=("$path")
    fi
  done

  if [ ${#existing_paths[@]} -eq 0 ]; then
    echo "No existing paths found."
  else
    echo "Existing paths:"
    for ((i=0; i<${#existing_paths[@]}; i++)); do
      echo "$(($i + 1)). ${existing_path[$i]}"
    done
  fi

  if [ ${#existing_paths[@]} -gt 1 ]; then
    while [ -z "$profile_path" ]; do
      read -p "Enter the browser number: " profile_number

      if [ "$profile_number" -ne 0 ] && [[ $profile_number =~ ^[0-9]+$ ]] && [ "$profile_number" -le ${#existing_paths[@]} ]; then
        selected_profile="${existing_paths[$profile_number - 1]}"
        echo "You selected $profile_number. $selected_profile."
        profile_path="$selected_profile"
        echo "Browser path: $profile_path"
      else
        echo "Invalid browser number. Enter a number from the list."
      fi
    done
  else
    profile_path="${existing_paths[0]}"
    echo "Browser path: $profile_path"
  fi


  # ----------------------------------------------------------------
  # Get profiles

  cd "$profile_path}"

  # Define the path to the profiles.ini file
  profiles_ini="$profile_path/profiles.ini"

  # Check if the file exists
  if [ ! -f "$profiles_ini" ]; then
    echo "Error: profiles.ini file not found."
    exit 1
  fi

  # Initialize an array to store paths
  profile_paths=()

  # Read the file and extract paths
  while IFS= read -r line; do
    if [[ "$line" =~ ^Path= ]]; then
      # Extract the path value and add it to the array
      path=$(echo "$line" | cut -d'=' -f2)
      profile_paths+=("$path")
    fi
  done < "$profiles_ini"

  # Check if any paths were found
  if [ ${#profile_paths[@]} -eq 0 ]; then
    echo "No profile paths found in profiles.ini."
  else
    # Output the array of paths
    echo "Profile Paths:"
    for ((i=0; i<${#profile_paths[@]}; i++)); do
      echo "$(($i + 1)). ${profile_paths[$i]}"
    done
  fi


  # ----------------------------------------------------------------
  # Get a profile name

  if [ ${#profile_paths[@]} -gt 1 ]; then
    while [ -z "$profile_name" ]; do
      read -p "Enter the profile number: " profile_number

      if [ "$profile_number" -ne 0 ] && [[ $profile_number =~ ^[0-9]+$ ]] && [ "$profile_number" -le ${#profile_paths[@]} ]; then
        selected_profile="${profile_paths[$profile_number - 1]}"
        echo "You selected $profile_number. $selected_profile."
        profile_name="$selected_profile"
        echo "Profile name: $profile_name"
      else
        echo "Invalid profile number. Enter a number from the list."
      fi
    done
  else
    profile_name="${profile_paths[0]}"
    echo "Profile name: $profile_name"
  fi


  # ----------------------------------------------------------------
  # Clone git repo to the selected profile

  # Define the chrome directory
  chrome_dir="$profile_path/$profile_name/chrome"

  isUpdate=false

  if [ ! -d "$chrome_dir" ]; then
    isUpdate=true
  else
    echo "The chrome folder already exists!"
    read -p "Do you want to replace it? (Y/N): " confirm

    if [ "$confirm" == "Y" ] || [ "$confirm" == "y" ]; then
      rm -rf "$chrome_dir"
      isUpdate=true
    fi
  fi

  if [ "$isUpdate" = true ]; then
    git clone "https://github.com/edelvarden/material-fox-updated.git" chrome
  else
    echo "Exit installation."
    exit 1
  fi

  userjs_file="$profile_path/$profile_name/user.js"
  includeUserJS=false

  if [ ! "$userjs_file" ]; then
    includeUserJS=true
  else
    echo "The user.js already exists!"
    read -p "Do you want to replace it? (Y/N): " confirm

    if [ "$confirm" == "Y" ] || [ "$confirm" == "y" ]; then
      rm -f "$userjs_file"
      includeUserJS=true
    fi
  fi

  if [ "$includeUserJS" = true ]; then
    cp -f "$chrome_dir/user.js" "$userjs_file"
  else
    echo "Exit installation."
    exit 1
  fi
}

# Install only if git is available
if command -v git &> /dev/null; then
    install
else
    echo "Git is not installed. Please install Git to proceed."
fi
