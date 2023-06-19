#!/bin/bash

AOL_ARCHIVE_URL="https://www.cim.mcgill.ca/~dudek/206/Logs/AOL-user-ct-collection/aol-data.tar.gz"
TARGET_FILE="/data/aol-data.txt"

function success {
  echo "Success!"
}

function check_aol_archive_alive {
  echo "Checking if remote file at AOL Archive URL exists..."
  if ! wget -q --method=HEAD $AOL_ARCHIVE_URL;
    then
      success
    else
      >&2 echo "Error! Cannot find remote file at AOL Archive URL."
      exit 1
  fi
}

function create_data_directory {  
  echo "Initialize 'data/' directory..."
  if test -d "data";
    then
      mkdir data
    else
      >&2 echo "Error! 'data/' directory already exists. Advice: rename or delete it..."
      exit 1
  fi
  success
}

function download_archive {
  echo "Downloading AOL User Session Collection archive..."
  wget --output-document=aol-data.tar.gz -c $AOL_ARCHIVE_URL
  success
}

function extract_archives {
  echo "Extracting archives..."
  gzip -d aol-data.tar.gz
  tar xv aol-data.tar && rm aol-data.tar

  mv AOL-user-ct-collection/* data
  rm -rf AOL-user-ct-collection/

  gzip -d /data/*.gz

  success
}

function concatenate_data {
  echo "Concatenating data..."

  touch $TARGET_FILE

  head -n 1 /data/user-ct-test-collection-01.txt >> $TARGET_FILE
  tail --line +2 /data/user*.txt | grep "==> user-" --invert-match >> $TARGET_FILE 

  # clean up blank lines
  sed -i "/^$/d" $TARGET_FILE

  success
}


function handle_validation_success {
  # This line count includes the first line of headers
  echo "36,389,568 lines of data written to '$TARGET_FILE'!"
  echo "See '/data/U500k_README.txt' for more information."
  success
}

function handle_validation_failure {
  >&2 echo "Error! Something went wrong. Deleting '/data' directory..."
  rm -rf data
  exit 1
}

function validate_data {
  echo "Validating data..."

  # expected value comes from U500k_README.txt, "36,389,567 lines of data"
  local EXPECTED_COUNT=36389567

  # actual value is the count of all lines after the first one (it's headers)
  local ACTUAL_COUNT=`tail --line +2 $TARGET_FILE | wc -l | grep -o "^[0-9]\+"`

  test $EXPECTED_COUNT -eq $ACTUAL_COUNT && handle_validation_success || handle_validation_failure
}

function main {
  echo "Initializing script..."
  echo "Creating 'aol-data.txt' and 'U500k_README.txt' in '/data' ..."

  # some function calls will exit early on failure
  check_aol_archive_alive
  create_data_directory
  download_archive
  extract_archives
  concatenate_data
  validate_data

  echo "I hope you are happy with this!"
}

main
