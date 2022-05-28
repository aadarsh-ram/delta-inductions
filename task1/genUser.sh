#!/bin/bash

userfile=$1

if [ -f "${userfile}" ]
then
    echo "Using given accounts file"
else
    userfile=./files/User_Accounts.txt
    echo "Defaulting to files/User_Accounts.txt"
fi

while read line; do
    row=( $line );
    user=${row[0]};
    branch=${row[1]}
    echo $user

    mkdir -p ./users/$branch
    cd ./users
    manager=manager_$branch
    if ! id -u $manager &>/dev/null;
    then
        sudo useradd $manager -d /
        echo -e "$manager\n$manager\n" | sudo passwd $manager
        sudo chown $manager ./$branch
    fi
    
    cd ./$branch
    homedir=./$user
    mkdir $homedir
    if ! id -u $user &>/dev/null;
    then
        sudo useradd $user -d /$user
        echo -e "$user\n$user\n" | sudo passwd $user
    fi

    cp ../../files/Current_Balance.txt $homedir/Current_Balance.txt
    cp ../../files/Transaction_History.txt $homedir/Transaction_History.txt
    sudo chown -R $user $homedir

    cd ../..
done <<<$(cat $userfile)

if ! id -u ceo &>/dev/null;
then
    sudo useradd ceo -d /
    echo -e "ceo\nceo\n" | sudo passwd ceo
fi  

echo "Users, managers and the CEO accounts have been created!"