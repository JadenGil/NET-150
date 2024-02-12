#!/bin/bash

#This code was made by Jaden Gilmond

while getopts ":h:p:" opt; do
  case $opt in
    h) hostfile="$OPTARG";;
    p) portfile="$OPTARG";;
    \?) echo "Invalid option: -OPTARG" >&2; exit 1;;
    :) echo "Option -$OPTARG needs an argument." >&2;
  esac
done

shift $((OPTIND-1))

if [ -z "$hostfile" ] || [ -z "$portfile" ]; then
  echo "Use: $0 -h <hostfile> -p <portfile>"
  exit 1
fi

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <hostfile> <portfile>"
    exit 1
fi
#^This checks if the script is checking the 2 arguments^

hostfile=$1
portfile=$2

if [ ! -e "$hostfile" ]; then
    echo "ERROR! The host file '$hostfile' was not found."
    exit 1
fi

if [ ! -e "$portfile" ]; then
    echo "ERROR! the port file '$portfile' was not found"
    exit 1
fi
#^ these check if the host and port files exist and if they don't then it will respond with and error and stop the script^


echo "host,port"

for host in $(cat $hostfile); do
  for port in $(cat $portfile); do
    timeout .1 bash -c "echo >dev/tcp/$host/$port" 2>/dev/null &&
      echo "$host,$port"
  done
done
