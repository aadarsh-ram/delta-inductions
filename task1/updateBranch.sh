#!/bin/bash

cd users
for i in $(ls -d */)
do
    branch=${i}
    cd ${i}
    touch Branch_Current_Balance.txt
    touch Branch_Transaction_History.txt
    cp ../../files/Daily_Interest_Rates.txt Daily_Interest_Rates.txt
    currbal=0
    for j in $(ls -d */)
    do
        user=${j}
        cd $user
        num=( $(cat Current_Balance.txt) )
        currbal=$(($currbal + ${num[0]}))
        cat ./Transaction_History.txt >> ../Branch_Transaction_History.txt
        cd ..
    done
    echo $currbal >> ./Branch_Current_Balance.txt
    cd ..
done