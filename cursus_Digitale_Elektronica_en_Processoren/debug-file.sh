#!/bin/bash

lgf="old-logger.dat"
fle="$1"
tmo=120

while [ "$#" -gt 0 ]
    fle="$1"
    shift
    do
    for lb in `grep -h -n -P "^.{0,3}/$fle:[0-9]*:" "$lgf" | cut -d':' -f 1 | tac`
        do
        tail -n "+$lb" "$lgf" | grep -m 1 '^l\.' -B 999
        read -t $tmo -p 'press "e" to edit; "q" to quit debugging this file; wait or press any key to continue? ' -n 1 -r a
        echo
        if [[ "$a" =~ [eE] ]]
            then
            la=$(tail -n "+$lb" "$lgf" | grep -m 1 '^l\.' | grep -m 1 '[0-9]*' -o)
            vim +"$la" "$fle"
        elif [[ "$a" =~ [qQ] ]]
            then
            break
        fi
    done
    git commit -am "debug \"$fle\""
done
