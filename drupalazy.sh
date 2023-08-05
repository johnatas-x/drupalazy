#!/usr/bin/env bash
: '
Use this script to massively update your custom .info files.

Johnatas©
'
# Console colors.
GREEN='\033[32m'
LAVENDER_BG='\033[1;30;0;44m'
NC='\033[0m'
RED='\033[0;31m'
YELLOW='\033[1;33m'

# Colors functions.
echo-green() {
  echo -e "${GREEN}$1${NC}"
}
echo-lavender-bg() {
  echo -e "${LAVENDER_BG}$1${NC}"
}
echo-red() {
  echo -e "${RED}$1${NC}"
}
echo-yellow() {
  echo -e "${YELLOW}$1${NC}"
}

### Global variables ###
COUNT_KO=0
COUNT_OK=0
COUNT_SKIPPED=0
ERRORS=()
FILE_EXTENSION='.info.yml'
REDIRECT_OUTPUT='/dev/null'

### Functions ###
read_drupal_path() {
  # shellcheck disable=SC2116
  read -erp "Enter the Drupal installation path: $(echo $'\n↪ ')" -i "$PWD" DRUPAL_PATH
  check_path
}

check_path() {
  if [ ! -d "$DRUPAL_PATH/modules" ] || [ ! -d "$DRUPAL_PATH/themes" ]; then
    echo-red "Incorrect installation path. This must contain the 'modules' and 'themes' folders."
    read_drupal_path
  fi
}

files_counter() {
  CUSTOM_MODULES=$(find "$DRUPAL_PATH/modules/custom" 2>"$REDIRECT_OUTPUT" | grep -Fc "$FILE_EXTENSION")
  CUSTOM_THEMES=$(find "$DRUPAL_PATH/themes/custom" 2>"$REDIRECT_OUTPUT" | grep -Fc "$FILE_EXTENSION")
}

update_files() {
  echo-green "\n----- Update custom $1 files -----"
  local UPDATE_PATH="$DRUPAL_PATH/$1/custom"

  for FILE_PATH in $(find "$UPDATE_PATH" | grep -F "$FILE_EXTENSION" | sort -k11); do
    echo -n "${FILE_PATH##*/}"
    if grep -Eiq '\^10' "$FILE_PATH"; then
      echo-yellow " ✔"
      (( COUNT_SKIPPED++ ))
    elif grep -Eiq '\^9' "$FILE_PATH"; then
      sed -i 's/\^9/\^9 || \^10/' "$FILE_PATH"
      (( COUNT_OK++ ))
      echo-green " ✔"
    else
      echo-red " ✘"
      (( COUNT_KO++ ))
      ERRORS[${#ERRORS[@]}]="$FILE_PATH"
    fi
  done
}

echo_recap() {
  echo
  echo-lavender-bg " Update recap "
  echo -n " - " && echo-green "$COUNT_OK file(s) successfully updated"
  echo -n " - " && echo-yellow "$COUNT_SKIPPED file(s) skipped (already Drupal 10 compatible)"
  echo -n " - " && echo-red "$COUNT_KO file(s) not updated"

  if (( "$COUNT_KO" > 0 )); then
    echo
    echo-lavender-bg " List of not updated files "
    (IFS=$'\n'; echo-red "${ERRORS[*]}")
  fi

  echo
}

### Script ###
echo-lavender-bg " Start of .info update \n"

read_drupal_path
files_counter

if (( "$CUSTOM_MODULES" > 0 )); then
  update_files "modules"
else
  echo-yellow "No custom module to process."
fi

if (( "$CUSTOM_THEMES" > 0 )); then
  update_files "themes"
else
  echo-yellow "No custom theme to process."
fi

echo_recap

exit 1
