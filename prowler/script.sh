#!/bin/bash
echo "Running Prowler Scans"
./prowler -b -n -f us-east-1 -g extras -M csv > prowler_report.csv
echo "Converting Prowler Report from CSV to JSON"
python converter.py
echo "Loading JSON data into DynamoDB"
python loader.py