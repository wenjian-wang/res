#!/bin/bash

# ==============================
# Script Name: push_changes.sh
# Description: Push cluster admin webserver change to deployed RES server
# Author: Your Name
# Version: 1.0
# ==============================

# Exit immediately if a command exits with a non-zero status
set -e

# Enable debug mode (uncomment for debugging)
# set -x

# ==============================
# Configuration
# ==============================

LOG_FILE="push_changes.log"

# ==============================
# Functions
# ==============================

# Logging function
log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" | tee -a "$LOG_FILE"
}

# Error handling
error_exit() {
    echo "❌ Error: $1"
    exit 1
}

# Usage function
usage() {
    echo "Usage: $0 [-h] [-n NAME]"
    echo "  -h       Show this help message"
    echo "  -n NAME  Specify a name"
    exit 0
}

build_web () {
    # Get the directory of the current script
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    cd "$SCRIPT_DIR/source/idea/idea-cluster-manager/webapp"
    echo "Current directory: $(pwd)"
    
    # build web server
    yarn build
    
    exit 0
}

pack_tar_file() {
    # Get the directory of the current script
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    # Clear previous files
    rm -fR ~/Downloads/idea-cluster-manager-2024.12.01/webapp/*
    [ -f "~/Downloads/idea-cluster-manager-2024.12.01.tar.gz" ] && rm  ~/Downloads/idea-cluster-manager-2024.12.01.tar.gz

    log "Copy files to dest folder"
    cp -r $SCRIPT_DIR/source/idea/idea-cluster-manager/webapp/build/* ~/Downloads/idea-cluster-manager-2024.12.01/webapp
    
    log "Packing source files..."
    cd ~/Downloads/idea-cluster-manager-2024.12.01/webapp
    tar -cvzf ../idea-cluster-manager-2024.12.01.tar.gz * > /dev/null 2>&1

    log "idea-cluster-manager-2024.12.01.tar.gz generated sucessfully:"
    realpath ../idea-cluster-manager-2024.12.01.tar.gz
    exit 0
}

# ==============================
# Argument Parsing
# ==============================

NAME="Default"

while getopts ":hn:" opt; do
    case "${opt}" in
        h)
            usage
            ;;
        n)
            NAME="$OPTARG"
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            ;;
    esac
done

# ==============================
# Main Execution
# ==============================

log "Script started."
log "Hello, $NAME!"

#build_web

pack_tar_file

# Simulate some processing
sleep 1
log "Processing completed."

log "Script finished successfully."
exit 0
