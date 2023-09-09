#!/bin/bash

# This script sets up three different cron jobs

# Define the commands and their schedules
command1="/home/crawl-dev/dgamelaunch-config/bin/dgl update-trunk"
schedule1="*5 4 * * *"  # Runs daily at 04:05 AM

command2="/home/crawl-dev/dgamelaunch-config/bin/dgl update-gcc stoatsoup stoatsoup/master"
schedule2="5 3 * * *"     # Runs daily at 03:05 AM

command3="/home/crawl-dev/dgamelaunch-config/bin/dgl update-gcc bcadrencrawl bcadrencrawl/bcrawl"
schedule3="35 3 * * *"      # Runs daily at 03:35 AM

# Add the commands and schedules to the crontab
(crontab -l 2>/dev/null; echo "$schedule1 $command1") | crontab -
(crontab -l 2>/dev/null; echo "$schedule2 $command2") | crontab -
(crontab -l 2>/dev/null; echo "$schedule3 $command3") | crontab -

echo "Cron jobs have been set up:"
crontab -l