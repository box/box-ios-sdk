#!/bin/bash


SECTION_HEADER_ARRAY=("⚠ BREAKING CHANGES") 
SECTION_CONTENT_ARRAY=()
CHANGELOG_FILE_NAME="CHANGELOG.md"
VERSIONRC_FILE_NAME=".versionrc"
RELEASE_VERSION_REGEXP="##.*\[[0-9]+\.[0-9]+\.[0-9]+\].*"
SECTION_NAME_REGEXP="### .*"
VISIBLE_SECTION_REGEXP="\"hidden\": false"
PROCESSED_SECTION_INDEX=""
PROCESSED_RELEASE_VERSION="NONE" # NONE, CURRENT, OLD
RELEASE_SECTION_CONTENT=""
OUTPUT=""


# STEP 1.
# Extract order and names of sections from .versionrc file
while IFS="" read -r line || [ -n "$line" ]; do
    if [[ "$line" == *${VISIBLE_SECTION_REGEXP}* ]]; then
        EXTRACTED_SECTION_NAME=$(echo ${line} | sed -nE 's/.*section\": \"(.*)\", \"hidden\".*/\1/p')
        SECTION_HEADER_ARRAY[${#SECTION_HEADER_ARRAY[@]}]="${EXTRACTED_SECTION_NAME}"
    fi
done < "${VERSIONRC_FILE_NAME}"


# STEP 2.
# Process each line and fix sections order if processed release is current one
while IFS="" read -r line || [ -n "$line" ]; do
    if [[ "$line" =~ $RELEASE_VERSION_REGEXP ]]; then
        if [[ $PROCESSED_RELEASE_VERSION == "NONE" ]]; then
            PROCESSED_RELEASE_VERSION="CURRENT"
            OUTPUT="${OUTPUT}${line}\n\n\n"
            continue;
        else
            if [[ $PROCESSED_RELEASE_VERSION == "CURRENT" ]]; then
                for (( i=0; i<${#SECTION_HEADER_ARRAY[@]}; i++ )); do
                    if [[ ! -z "${SECTION_CONTENT_ARRAY[$i]}" ]]; then
                        RELEASE_SECTION_CONTENT="${RELEASE_SECTION_CONTENT}### ${SECTION_HEADER_ARRAY[$i]}\n\n${SECTION_CONTENT_ARRAY[$i]}\n"
                    fi
                done

                OUTPUT="${OUTPUT}${RELEASE_SECTION_CONTENT}"
                PROCESSED_RELEASE_VERSION="OLD"
            fi
        fi
    fi

    if [[ $PROCESSED_RELEASE_VERSION == "CURRENT" ]]; then
        if [[ -z ${line} ]];  then
            continue
        fi

        if [[ "$line" =~ $SECTION_NAME_REGEXP ]]; then
            PROCESSED_SECTION_INDEX=""
            for (( i=0; i<${#SECTION_HEADER_ARRAY[@]}; i++ )); do
                if [[ "$line" == *"${SECTION_HEADER_ARRAY[$i]}"* ]]; then
                    PROCESSED_SECTION_INDEX=$i
                    SECTION_CONTENT_ARRAY[$PROCESSED_SECTION_INDEX]=""
                fi
            done
        else
            SECTION_CONTENT_ARRAY[$PROCESSED_SECTION_INDEX]="${SECTION_CONTENT_ARRAY[PROCESSED_SECTION_INDEX]}${line}\n"
        fi
    else
        OUTPUT="${OUTPUT}${line}\n"
    fi
done < "${CHANGELOG_FILE_NAME}"


# STEP 3.
# Overwrite CHANGELOG.md file with fixed order of current release
echo -e "${OUTPUT}\c" > "${CHANGELOG_FILE_NAME}"
