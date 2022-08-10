#!/bin/bash

# Generate a cronjob for this script
sudo crontab -l > cron_bkp
sudo echo "0 0 * * * sudo ./allotInterest.sh >/dev/null 2>&1" > cron_bkp
sudo crontab cron_bkp
sudo rm cron_bkp

userfile=$1

if [ -f "${userfile}" ]
then
    echo "Using given accounts file"
else
    userfile=./files/User_Accounts.txt
    echo "Defaulting to files/User_Accounts.txt"
fi

while read line; do
    row=( $line )
    acc=${row[0]}
    branch=${row[1]}
    cat1=${row[2]}
    cat2=${row[3]}
    cat3=${row[4]}
    totIntRate=0
    intfile=./users/$branch/Daily_Interest_Rates.txt

    while read line2; do
        col=( $line2 )
        currcat=${col[0]}
        rate=${col[1]}
        if [[ $currcat == $cat1 ]]
        then
            totIntRate=`echo $totIntRate ${rate::-1} | awk '{printf "%f", $1 + $2}'`
        fi
    done <<<$(cat $intfile)

    while read line2; do
        col=( $line2 )
        currcat=${col[0]}
        rate=${col[1]}
        if [[ $currcat == $cat2 ]]
        then
            totIntRate=`echo $totIntRate ${rate::-1} | awk '{printf "%f", $1 + $2}'`
        fi
    done <<<$(cat $intfile)

    while read line2; do
        col=( $line2 )
        currcat=${col[0]}
        rate=${col[1]}
        if [[ $currcat == $cat3 ]]
        then
            totIntRate=`echo $totIntRate ${rate::-1} | awk '{printf "%f", $1 + $2}'`
        fi
    done <<<$(cat $intfile)

    userbalfile=./users/$branch/$acc/Current_Balance.txt
    num=( $(cat $userbalfile) )
    newAmt=`echo $totIntRate $num | awk '{printf "%f", $2 + ($2 * $1)}'`
    > $userbalfile
    echo $newAmt >> $userbalfile
done <<<$(cat $userfile)