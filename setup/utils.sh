#!/bin/bash

RESET='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'

print_banner() {
  clear
  echo -e "${BLUE}"
  cat <<"EOF"
   .----------------.  .----------------.  .----------------.  .----------------. 
  | .--------------. || .--------------. || .--------------. || .--------------. |
  | |   ______     | || |  _________   | || | ____    ____ | || |   ______     | |
  | |  |_   _ \    | || | |_   ___  |  | || ||_   \  /   _|| || |  |_   __ \   | |
  | |    | |_) |   | || |   | |_  \_|  | || |  |   \/   |  | || |    | |__) |  | |
  | |    |  __'.   | || |   |  _|      | || |  | |\  /| |  | || |    |  ___/   | |
  | |   _| |__) |  | || |  _| |_       | || | _| |_\/_| |_ | || |   _| |_      | |
  | |  |_______/   | || | |_____|      | || ||_____||_____|| || |  |_____|     | |
  | |              | || |              | || |              | || |              | |
  | '--------------' || '--------------' || '--------------' || '--------------' |
   '----------------'  '----------------'  '----------------'  '----------------' 
EOF
  echo -e "${RESET}"
  echo -e "${YELLOW}Setting up your machine...${RESET}\n"
}

ask_sudo() {
  echo -e "${BLUE}[*]${RESET} Requesting sudo permissions..."
  sudo -v

  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit

  done 2>/dev/null &
}

execute() {
  local task_name="$1"
  local command="$2"

  printf "${BLUE}[*]${RESET} %-50s" "$task_name..."

  local log_file=$(mktemp)
  eval "$command" >"$log_file" 2>&1 &
  local pid=$!

  local delay=0.1
  local spinstr='|/-\'
  while kill -0 $pid 2>/dev/null; do
    local temp=${spinstr#?}
    printf " [%c]  " "$spinstr"
    local spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    printf "\b\b\b\b\b\b"
  done
  printf "    \b\b\b\b"

  wait $pid
  local exit_code=$?

  if [ $exit_code -eq 0 ]; then
    printf "${GREEN}DONE${RESET}\n"
    rm "$log_file"
  else
    printf "${RED}FAIL${RESET}\n"
    echo -e "\n${RED}Error log:${RESET}"
    cat "$log_file"
    rm "$log_file"
    exit 1
  fi
}
