#!/bin/bash


menu() {
    echo ""
    echo "Do you want to: "
    echo "1) Download master"
    echo "2) Upload scripts to github (on new branch)"
    echo "3) Put scripts into configuration"
    echo "9) Exit"
    read -n 1 -p "Please enter the number of the menu item: " swag
    echo ""
    echo ""

    if [[ $swag -eq 1 ]]; then
        dlMaster
        menu
    elif [[ $swag -eq 2 ]]; then
        uploadBranch
        menu
    elif [[ $swag -eq 3 ]]; then
        apply
        menu
    else
        exit
    fi
}

dlMaster() {
    git checkout master
    git pull
}

uploadBranch() {
    rn=$(date +%s)
    git branch $rn
    git checkout $rn
    git add .
    git commit -m "auto generated push request from script.sh: $rn"
    git push origin $rn
}

apply() {
    for f in ./*; do
        if ! [[ "$f" == *.sh ]]; then
            response=${response,,}
            f=$(echo $f | cut -c 3-)
            read -n 1 -r -p "Do you want to include $f [y/N]? " response
            echo
            if [[ "$response" =~ ^(yes|y)$ ]]; then
                echo "Adding $f to GNU Stow..."
                stow --adopt $f
            elif [[ "$response" =~ ^(no|n)$ ]]; then
                echo "Skipping $f for now..."
            else
                echo "Sorry I didn't get that... skipping..."
            fi
        fi
    done
}

menu
