#!/bin/bash
STARTPORT=1
ENDPORT=65535
TIMEOUT=1
MAXCON=0


checkPort() {
    RES=$(nc portquiz.net $1 -w $TIMEOUT 2> /dev/null; echo $?)
    
    if [ "$RES" == "0" ]; then
	    echo $1
    fi
}

checkIfWaits() {
    # $1    max
    # $2    actual
    
    if [ "$1" == "0" ]; then
        echo "0"
	    return 0;
    fi
    
    a=$1
    b=$2
    
    WRES=$(echo $((b%a)))
    
    if [ "$WRES" == "0" ]; then
        echo "1" 
    else
        echo "0"
    fi
    
}


echo "Starting scanning at port no" $STARTPORT
echo ""
for i in $(seq $STARTPORT $ENDPORT); do

    checkPort $i &
    
    IWAIT=$(checkIfWaits $MAXCON $i)
    if [ "$IWAIT" == "1" ]; then
        wait
    fi

done

wait
echo "Finished on port no" $ENDPORT
