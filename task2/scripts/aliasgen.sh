#!/bin/bash

echo "alias genUser='. ./genUser.sh'" >> ~/.bashrc
echo "alias allotInterest='. ./allotInterest.sh'" >> ~/.bashrc
echo "alias makeTransaction='. ./makeTransaction.sh'" >> ~/.bashrc
echo "alias permit='. ./permit.sh'" >> ~/.bashrc
echo "alias updateBranch='. ./updateBranch.sh'" >> ~/.bashrc
echo "alias genSummary='. ./genSummary.sh'" >> ~/.bashrc
source ~/.bashrc

echo "All aliases created successfully!"