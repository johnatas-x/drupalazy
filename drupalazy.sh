#!/usr/bin/env bash
: '
Use this script to massively update your custom .info.yml files.

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
  if [ ! -d "$DRUPAL_PATH/core" ] || [ ! -d "$DRUPAL_PATH/modules" ] || [ ! -d "$DRUPAL_PATH/themes" ]; then
    echo-red "Incorrect installation path. This must contain the 'core', 'modules' and 'themes' folders."
    read_drupal_path
  fi

  check_version
}

check_version() {
  local drupal_file="$DRUPAL_PATH/core/lib/Drupal.php"
  local version
  local min_drupal_version=8

  if [ ! -f "$drupal_file" ]; then
    echo-red "An error has occurred. It seems that your current version of Drupal is < $min_drupal_version."
    exit 0
  fi

  version=$(sed -nr '/const VERSION = / s/.*const VERSION = ([^;]+).*/\1/p' "$drupal_file" | tr -d "'")
  SOURCE_VERSION=${version%%.*}
  SUSPECTED_TARGET_VERSION=$(( "$SOURCE_VERSION" + 1))
  echo-lavender-bg "Current core version : $version"
  version_choice
  echo
  echo-lavender-bg "\n↪ Make files from Drupal $SOURCE_VERSION to Drupal $TARGET_VERSION compatible."
}

version_choice() {
  # shellcheck disable=SC2116
  read -erp "Which target version do you want the files to be compatible with? $(echo $'\n↪ Drupal ')" -i "$SUSPECTED_TARGET_VERSION" TARGET_VERSION

  if [ "$TARGET_VERSION" -le "$SOURCE_VERSION" ]; then
    echo-red "Incorrect target version. This must be > $SOURCE_VERSION."
    version_choice
  fi
}

files_counter() {
  CUSTOM_MODULES=$(file_counter "modules")
  CUSTOM_THEMES=$(file_counter "themes")
  CUSTOM_PROFILES=$(file_counter "profiles")
}

file_counter() {
  find "$DRUPAL_PATH/$1/custom" 2>"$REDIRECT_OUTPUT" | grep -Fc "$FILE_EXTENSION"
}

update_files() {
  echo-green "\n----- Update custom $1 files -----"
  local UPDATE_PATH="$DRUPAL_PATH/$1/custom"

  for FILE_PATH in $(find "$UPDATE_PATH" -type f -name "*$FILE_EXTENSION" | sort); do
    echo -n "${FILE_PATH##*/}"
    local line
    line=$(grep -E 'core_version_requirement' "$FILE_PATH")

    if [ -z "$line" ]; then
      echo-red " ✖"
      (( COUNT_KO++ ))
      ERRORS+=("$FILE_PATH")
      continue
    fi

    local value
    value=$(echo "$line" | sed -E "s/^[[:space:]]*core_version_requirement:[[:space:]]*['\"]?(.*)['\"]?/\1/")
    value=$(echo "$value" | sed -e 's/^["'\'']//; s/["'\'']$//')
    # shellcheck disable=SC2016
    escaped_target=$(printf '%s' "$TARGET_VERSION" | sed 's/[.[\*^$()+?{|]/\\&/g')

    if echo "$value" | grep -Eiq "(^|\s|\|\|)[\^~]${escaped_target}"; then
      skipped
      continue
    fi

    if [[ "$value" == *">"* ]]; then
      last_gt=${value##*>}
      if [[ "$last_gt" != *"<"* ]]; then
        skipped
        continue
      else
        max_ver=${last_gt##*<}
        if [ "$(echo "$max_ver > $TARGET_VERSION" | bc -l)" -eq 1 ]; then
          skipped
          echo "$last_gt"
          continue
        fi
      fi
    fi

    if echo "$value" | grep -Eiq "(^|\s|\|\|)(<=|<)$((escaped_target + 1))($|\.)"; then
      skipped
      continue
    fi

    local new_value="$value || ^$TARGET_VERSION"
    local quote=""

    if echo "$line" | grep -q '"'; then
      quote='"'
    elif echo "$line" | grep -q "'"; then
      quote="'"
    fi

    local escaped_new_value
    escaped_new_value=$(printf '%s\n' "$new_value" | sed -e 's/[\/&|]/\\&/g')
    sed -i -E "s|^(core_version_requirement:[[:space:]]*)['\"]?.*['\"]?|\1${quote}${escaped_new_value}${quote}|" "$FILE_PATH"
    echo-green " ✔"
    (( COUNT_OK++ ))
  done
}

skipped() {
  echo-yellow " ✔"
  (( COUNT_SKIPPED++ ))
}

echo_recap() {
  echo
  echo-lavender-bg " Update recap "
  echo -n " - " && echo-green "$COUNT_OK file(s) successfully updated"
  echo -n " - " && echo-yellow "$COUNT_SKIPPED file(s) skipped (already Drupal $TARGET_VERSION compatible)"
  echo -n " - " && echo-red "$COUNT_KO file(s) not updated"

  if (( "$COUNT_KO" > 0 )); then
    echo
    echo-lavender-bg " List of not updated files "
    (IFS=$'\n'; echo-red "${ERRORS[*]}")
  fi

  echo
}

### Script ###
echo-lavender-bg " Start of .info update "
echo
read_drupal_path
files_counter

if (( "$CUSTOM_MODULES" > 0 )); then
  update_files "modules"
else
  echo-yellow "\n----- No custom module to process -----"
fi

if (( "$CUSTOM_THEMES" > 0 )); then
  update_files "themes"
else
  echo-yellow "\n----- No custom theme to process -----"
fi

if (( "$CUSTOM_PROFILES" > 0 )); then
  update_files "profiles"
else
  echo-yellow "\n----- No custom profile to process -----"
fi

echo_recap
exit 1
