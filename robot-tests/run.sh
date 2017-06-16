#!/bin/bash
# Entry script to start Xvfb and set display
set -e

# Set the defaults
DEFAULT_LOG_LEVEL="INFO" # Available levels: TRACE, DEBUG, INFO (default), WARN, NONE (no logging)
DEFAULT_RES="1280x1024x24"
DEFAULT_DISPLAY=":99"
DEFAULT_ROBOT_TESTS="false"
DEFAULT_ROBOT_OUTPUT_DIRECTORY="/robot/results"
DEFAULT_PARAMETERS=""

# Use default if none specified as env var
LOG_LEVEL=${LOG_LEVEL:-$DEFAULT_LOG_LEVEL}
RES=${RES:-$DEFAULT_RES}
DISPLAY=${DISPLAY:-$DEFAULT_DISPLAY}
ROBOT_TESTS=${ROBOT_TESTS:-$ROBOT_TESTS}
ROBOT_OUTPUT_DIRECTORY=${ROBOT_OUTPUT_DIRECTORY:-$DEFAULT_ROBOT_OUTPUT_DIRECTORY}
PARAMETERS=${PARAMETERS:-$DEFAULT_PARAMETERS}

if [[ "${ROBOT_TESTS}" == "false" ]]; then
  echo "Error: Please specify the robot test or directory as env var ROBOT_TESTS"
  exit 1
fi

# Start Xvfb
echo -e "Starting Xvfb on display ${DISPLAY} with res ${RES}"
Xvfb ${DISPLAY} -ac -screen 0 ${RES} +extension RANDR &
export DISPLAY=${DISPLAY}

# Creating output directory
if [ ! -d "${ROBOT_OUTPUT_DIRECTORY}" ]; then
   mkdir -p ${ROBOT_OUTPUT_DIRECTORY}
else
	rm -rf ${ROBOT_OUTPUT_DIRECTORY}/*
fi 

# Execute tests
echo -e "Executing robot test command: pybot --loglevel ${LOG_LEVEL} ${PARAMETERS} -d ${ROBOT_OUTPUT_DIRECTORY} ${ROBOT_TESTS}"

ls -la /robot
pybot --loglevel ${LOG_LEVEL} ${PARAMETERS} -d ${ROBOT_OUTPUT_DIRECTORY} ${ROBOT_TESTS}

# Stop Xvfb
kill -9 $(pgrep Xvfb)
