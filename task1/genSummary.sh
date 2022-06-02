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
# Expenditures stats need to be calculated per month
transdir=`ls ./files/trans/*.txt`

declare -A currBal
initflag=0

for file in $transdir
do
    declare -A accounts
    declare -A months
    months=( ["02"]="Feburary" ["03"]="March" ["04"]="April" ) # Months can be added
    month=${file:30:2}
    printf "\nMonth: ${months[$month]}\n"
    # First file
    if [[ initflag -eq 0 ]];
    then
        while read line; do
            row=( $line )
            accName=${row[0]}
            amt=${row[1]}
            flag=0
            ind=-1; cnt=0
            # Check if already tracked in array
            for i in ${!accounts[@]}; 
            do
                if [[ $i == $accName ]]; then
                    ind=cnt; flag=1;
                    break;
                fi
                ((cnt++))
            done

            # If not, give initial balance of 500
            if [[ flag -eq 0 ]];
            then
                accounts+=([$accName]=500)
            fi 

            # Check if transaction is possible
            check1=$(echo ${accounts[$accName]} $amt | awk '{print ($1+$2) < 0 }')
            if [[ check -eq 0 ]];
            then
                newAmt=$(echo ${accounts[$accName]} $amt | awk '{printf "%f", $1 + $2}')
                accounts[$accName]=$newAmt;
            else
                echo "Transaction invalid"
            fi

        done <<<$(cat $file)
    
        # "accounts" has current balance, but not changes
        # Copy the current balance to "currBal"
        for k in "${!accounts[@]}";
        do 
            currBal+=([$k]={accounts[$k]})
        done

        # "accounts" will now have changes
        for k in "${!accounts[@]}";
        do
            accChange=$(echo ${accounts[$k]} | awk '{printf "%f", $1 - 500}')
            accounts[$k]=$accChange
        done

        # Print changes
        printf "Account changes summary (highest to lowest)\n"
        # printf "For month of $month\n"
        echo "Account" '   ' "Change"
        for k in "${!accounts[@]}"
        do
            echo $k ' : ' ${accounts["$k"]}
        done | sort -rn -k3
        initflag=1 # Inital file over
    else
        while read line; do
            row=( $line )
            accName=${row[0]}
            amt=${row[1]}
            flag=0
            ind=-1; cnt=0
            # Check if already tracked in array
            for i in ${!accounts[@]}; 
            do
                if [[ $i == $accName ]]; then
                    ind=cnt; flag=1;
                    break;
                fi
                ((cnt++))
            done
            # If not, give currBal amt to the account
            if [[ flag -eq 0 ]];
            then
                accounts+=([$accName]={$currBal[$accName]})
            fi 

            # Check if transaction is possible
            check1=$(echo ${accounts[$accName]} $amt | awk '{print ($1+$2) < 0 }')
            if [[ check -eq 0 ]];
            then
                newAmt=$(echo ${accounts[$accName]} $amt | awk '{printf "%f", $1 + $2}')
                accounts[$accName]=$newAmt;
            else
                echo "Transaction invalid"
            fi

        done <<<$(cat $file)

        # Since "accounts" has current balance, and "currBal" has previous account balance
        # Copy "accounts" to "tempArr"
        declare -A tempArr
        for k in "${!accounts[@]}";
        do 
            tempArr+=([$k]={accounts[$k]})
        done

        # "accounts" will now have changes
        for k in "${!accounts[@]}";
        do
            accChange=$(echo ${accounts[$k]} ${currBal[$k]} | awk '{printf "%f", $1 - $2}')
            accounts[$k]=$accChange
        done

        # Print changes
        printf "Account changes summary (highest to lowest)\n"
        echo "Account" '   ' "Change"
        for k in "${!accounts[@]}"
        do
            echo $k ' : ' ${accounts["$k"]}
        done | sort -rn -k3
        
        # Update "currBal" to have current account balances
        declare -gA currBal
        for k in "${!tempArr[@]}";
        do 
            currBal+=([$k]={tempArr[$k]})
        done
    fi
done

rm -rf -d ./files/trans

while read line; do
    row=( $line )
    date=${row[2]}
    month=${date:5:2}
    mkdir -p ./files/exp
    expfile=./files/exp/Expenditures_$month.txt
    touch $expfile

    amt=${row[1]}
    check1=$(echo $amt | awk '{print $amt < 0}')
    if [[ $check1 -eq 1 ]];
    then
        echo "${amt:1}" >> $expfile
    fi
done <<<$(sed '1d' $history)

expdir=`ls ./files/exp/*.txt`
for file in $expdir
do
    declare -A months
    months=( ["02"]="Feburary" ["03"]="March" ["04"]="April" ) # Months can be added
    month=${file:25:2}
    printf "\nMonth: ${months[$month]}\n"
    printf "Stats on expenditures\n"
    echo "Mean: $(datamash mean 1 < $file)"
    echo "Median: $(datamash median 1 < $file)"
    echo "Mode: $(datamash mode 1 < $file)"
done
rm -rf -d ./files/exp
