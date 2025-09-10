#!/bin/bash

# This script MUST be run from the directory that contains it.

if ! command -v xcodegen &> /dev/null
then
    echo -e "!!! xcodegen is not installed !!!
" >&2
    echo -e "The XcodeGen tool (https://github.com/yonaskolb/XcodeGen) is required to generate Xcode project based on project yml specification.
 " >&2
    echo "Please install xcodegen (e.g. by using this command "brew install xcodegen") and then run this script again." >&2
    exit 1
else
    xcodegen
fi
