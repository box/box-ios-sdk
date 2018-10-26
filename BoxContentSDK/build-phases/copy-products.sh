#!/bin/bash

# This script is intended to copy products to the Carthage build directory,
# only in the case that we're building directly from Xcode. Otherwise, we
# just let Carthage do it.
# We insist on input files to be defined, because this ensures correct build
# order in the case of a parallel build.

# Usage: Add copy-products.sh <CARTHAGE_BUILD_DIRECTORY> in an Xcode build phase,
# and add all the files you want copied as Input Files.
# The Carthage build directory will be something like:
#   $SRCROOT/Carthage/Build
# Input files you likely want are:
#   $(BUILT_PRODUCTS_DIR)/$(PRODUCT_NAME).framework
#   $(BUILT_PRODUCTS_DIR)/$(PRODUCT_NAME).framework.dSYM

if [ -z "$SCRIPT_INPUT_FILE_COUNT" ]; then
    echo "This script is supposed to be run in an Xcode build phase!"
    exit 1
fi

if [ "$#" -ne "1" ]; then
    echo "warning: Example usage: copy-products.sh \$SRCROOT/Carthage/Build"
    echo "error: Usage: copy-products.sh <Carthage build directory>"
    exit 1
fi

if [ "$SCRIPT_INPUT_FILE_COUNT" -eq "0" ]; then
    echo "error: specify files to copy in the build phase Input Files"
    exit 1
fi

# Don't rsync if we're building with Carthage (it's not needed)
if [ "$CARTHAGE" = "YES" ]; then
    echo "Skipping rsync during Carthage build."
    exit 0
fi

CARTHAGE_BUILD_DIR="$1"
PLATFORM="iOS"

# Only copy when the Carthage/Build directory is a symlink
if [[ ! -L "$CARTHAGE_BUILD_DIR" || ! -d "$CARTHAGE_BUILD_DIR" ]]; then
    echo "warning: Skipping rsync because Carthage build location isn't a symlink to a directory."
    exit 0
fi

# Loop over Xcode Input Files and copy
for i in $(seq 0 $(( $SCRIPT_INPUT_FILE_COUNT - 1 )) ); do
    VAR="SCRIPT_INPUT_FILE_$i"
    FILE="${!VAR}"
    if [ -e "$FILE" ]; then
        echo "Syncing $FILE"
        rsync --delete -av "$FILE" "$CARTHAGE_BUILD_DIR/$PLATFORM/"
    else
        echo "warning: File does not exist: $FILE"
    fi
done
