#!/bin/bash

userfile=$1

if [ -f "${userfile}" ]
then
    echo "Using given accounts file"
else
    userfile=./files/User_Accounts.txt
    echo "Defaulting to files/User_Accounts.txt"
fi

history=./files/Transacion_List.txt
while read line; do
    row=( $line )
    accName=${row[0]}
    amt=${row[1]}
    while read line2; do
        row=( $line2 )
        acc=${row[0]}
        branch=${row[1]}
        if [[ $accName == $acc ]]
        then
            userbalfile=./users/$branch/$acc/Current_Balance.txt
            num=( $(cat $userbalfile) )
            check1=$(echo $amt | awk '{print $amt < 0}')
            if [[ 1 -eq $check1 ]]
            then
                check2=$(echo $num $amt | awk '{print $num < $amt}')
                if [[ 1 -eq $check2 ]]
                then
                    echo "Insufficient funds in $acc"
                else
                    newAmt=`echo $num $amt | awk '{printf "%f", $1 + $2}'`
                    > $userbalfile
                    echo $newAmt >> $userbalfile
                fi
            else
                newAmt=`echo $num $amt | awk '{printf "%f", $1 + $2}'`
                > $userbalfile
                echo $newAmt >> $userbalfile
            fi
            trHisfile=./users/$branch/$acc/Transaction_History.txt
            echo $line >> $trHisfile
        fi
    done <<<$(cat $userfile)  
done <<<$(sed '1d' $history)

echo "All transactions done successfully!"