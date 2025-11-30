#!/bin/bash

path="./database/db"


# Get current timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Specify the file extension
FILE_EXTENSION=".sql"

if [ $# -eq 0 ]; then
  echo "Please provide file name"
  exit 1
fi
# Create the new file
touch "${path}/${TIMESTAMP}_$1${FILE_EXTENSION}"
