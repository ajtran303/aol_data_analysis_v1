#!/bin/bash

AOL_ARCHIVE_URL="https://www.cim.mcgill.ca/~dudek/206/Logs/AOL-user-ct-collection/aol-data.tar.gz"

function success {
  echo "Success!"
}

function check_aol_archive_alive {
  echo "Checking if remote file at AOL Archive URL exists..."
  if wget -q --method=HEAD $AOL_ARCHIVE_URL;
    then
      success
    else
      >&2 echo "Error! Cannot find remote file at AOL Archive URL."
      exit 1
  fi
}

function download_archive {
  echo "Downloading AOL User Session Collection archive..."
  wget --output-document=aol-data.tar.gz -c $AOL_ARCHIVE_URL
  success
}

function extract_archives {
  echo "Extracting archives..."
  gzip -d aol-data.tar.gz
  tar xf aol-data.tar && rm aol-data.tar
  gzip -d /AOL-user-ct-collection/*.gz

  if test ! -d data;
    then
      mv AOL-user-ct-collection data
    else
      mv AOL-user-ct-collection/* data
      rm -rf AOL-user-ct-collection
  fi

  success
}

function main {
  echo "Initializing script..."
  echo "Downloading to 'data/' ..."

  # some function calls will exit early on failure
  check_aol_archive_alive
  download_archive
  extract_archives

  echo "Done!"
  echo "I hope you are happy with this!"
}

main
