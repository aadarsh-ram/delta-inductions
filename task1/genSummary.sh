#!/bin/bash

sudo apt install datamash

history=$1

if [ -f "${history}" ]
then
    echo "Using given transaction list"
else
    history=./files/Transacion_List.txt
    echo "Defaulting to files/Transacion_List.txt"
fi

while read line; do
    row=( $line )
    date=${row[2]}
    month=${date:5:2}
    mkdir -p ./files/trans
    touch ./files/trans/Transacion_List_$month.txt
    echo $line >> ./files/trans/Transacion_List_$month.txt
done <<<$(sed '1d' $history)

# TODO:
# Need to take changes each month using two arrays
# Expenditures stats need to be calculated per month
transdir=`ls ./files/trans/*.txt`
for file in $transdir
do
    declare -A accounts

    while read line; do
        row=( $line )
        accName=${row[0]}
        amt=${row[1]}
        flag=0
        ind=-1; cnt=0
        for i in ${!accounts[@]}; 
        do
            if [[ $i == $accName ]]; then
                ind=cnt; flag=1;
                break;
            fi
            ((cnt++))
        done
        if [[ flag -eq 1 ]];
        then
            newAmt=$(echo ${accounts[$accName]} $amt | awk '{printf "%f", $1 + $2}')
            accounts[$accName]=$newAmt;
        else
            accounts+=([$accName]=500)
        fi
    done <<<$(cat $file)

    printf "Account changes summary (highest to lowest)\n"
    echo "Account" '   ' "Change"
    for k in "${!accounts[@]}"
    do
    echo $k ' : ' ${accounts["$k"]}
    done | sort -rn -k3
done

expfile=./files/allExpenditures.txt
touch $expfile
while read line; do
    row=( $line )
    amt=${row[1]}
    check1=$(echo $amt | awk '{print $amt < 0}')
    if [[ $check1 -eq 1 ]];
    then
        echo "${amt:1}" >> $expfile
    fi
done <<<$(sed '1d' $history)

printf "\nStats on expenditures\n"
echo "Mean: $(datamash mean 1 < $expfile)"
echo "Median: $(datamash median 1 < $expfile)"
echo "Mode: $(datamash mode 1 < $expfile)"

rm $expfile
