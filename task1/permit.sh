#!/bin/bash

sudo apt install acl
cd users

for i in $(ls -d */)
do
    branch=${i}
    cd ${i}
    for j in $(ls -d */)
    do
        user=${j}
        manager=manager_${branch::-1}
        sudo chmod -R 550 ./$user
        sudo setfacl -m u:$manager:rwx ./$user
        sudo setfacl -m u:$manager:rwx ./$user/Current_Balance.txt
        sudo setfacl -m u:$manager:rwx ./$user/Transaction_History.txt
        sudo setfacl -m u:ceo:rwx ./$user
        sudo setfacl -m u:ceo:rwx ./$user/Current_Balance.txt
        sudo setfacl -m u:ceo:rwx ./$user/Transaction_History.txt
    done
    cd ..
done

for i in $(ls -d */)
do
    branch=${i}
    sudo chmod 770 ./$branch
    sudo setfacl -m u:ceo:rwx ./$branch  
done

echo "All permissions have been changed!"