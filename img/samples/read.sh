IFS=
for (( i = 1;  i < 5; ++i))
do
    read -n1 op
    if [[ $op == '' ]] 
        then
            echo "new line $op"
        else
            printf "%d" \'$op
            # echo ascii($op)
            if [[ $(printf "%d" \'$op) == 127 ]]
                then
                    echo "delete"
            fi
    fi

done