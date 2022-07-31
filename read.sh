for (( i = 1;  i < 5; ++i))
do
    read -n1 op
    if [[ $op == '' ]] 
        then
            echo "new line $op"
        else
            echo "normal $op"
    fi

done