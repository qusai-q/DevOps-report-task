#!/bin/bash

echo "System Information"
echo -n "Executed By: "
whoami

echo -n "Hostname: "
hostname

echo -n "Server IP: "
hostname -I

echo -n "OS Type and Version: "
cat /etc/os-release | grep PRETTY_NAME

echo -n "Kernel Version: "
uname -r

echo -n "Architecture: "
uname -m

echo -n "Server Time: "
date

echo -n "Uptime: "
uptime -p

echo ""
echo "Resource Usage "
echo "Memory Usage "
free -h

echo "CPU Cores "
nproc
