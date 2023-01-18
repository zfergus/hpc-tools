#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --time=96:00:00
#SBATCH --mem=64GB

PROJECT_NAME="example"

# Load modules
module purge
module load cmake/3.22.2 python/intel/3.8.6 gcc/10.2.0 hdf5/intel/1.12.0

# 1. Change this to the directory containing the input files
SCRIPTS_ROOT=$SCRATCH/$PROJECT_NAME/scripts
SCRIPT=$(realpath $1)
SCRIPT_REL=$(realpath --relative-to=$SCRIPTS_ROOT $SCRIPT)

OUTPUT_ROOT=$SCRATCH/$PROJECT_NAME/results

# Drop the extension from script
OUTPUT_DIR="$OUTPUT_ROOT/${SCRIPT_REL%.*}"

# 2. Change this to the directory containing the executable
BIN_DIR=$SCRATCH/$PROJECT_NAME/build/release
BIN="${PROJECT_NAME}_bin"

# Run job
cd $BIN_DIR
./$BIN -j $SCRIPT -o $OUTPUT_DIR --log_level debug
