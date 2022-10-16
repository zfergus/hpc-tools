#!/bin/bash

PROJECT_NAME="example"

# 1. Change this to the directory containing the input files
SCRIPTS_ROOT=$SCRATCH/$PROJECT_NAME/scripts

# 2. Fill in this list with the input scripts you want to run
SCRIPTS=(
    "$SCRIPTS_ROOT/example.json"
)

# 3. Change this to the directory containing the output files
LOGS_DIR=$SCRATCH/$PROJECT_NAME/logs
mkdir -p $LOGS_DIR

FILE_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
JOB=$FILE_DIR/job.sh

for SCRIPT in ${SCRIPTS[@]}; do
    JOB_NAME=$(basename -- "$SCRIPT")
    JOB_NAME="${JOB_NAME%.*}"
    sbatch \
        -J "$JOB_NAME" \
        -o "$LOGS_DIR/$JOB_NAME.out" -e "$LOGS_DIR/$JOB_NAME.err" \
        "$JOB" "$SCRIPT"
done
