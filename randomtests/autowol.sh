#!/bin/sh

# add this to the iptables
# iptables -I FORWARD 1 -p tcp -d 192.168.1.10 -m limit --limit 1/min -j LOG --log-prefix "WOL_LOG:  " --log-level 7

INTERVAL=5
NUMP=2
OLD=""
PORT="80||443"
TARGET=192.168.1.10
INTERFACE=br-lan
MAC=d0:50:99:91:31:7f
WOL=/usr/bin/etherwake
#LOGFILE="indexwol.html"
LOGFILE=/dev/null
LOGPROG="dmesg" # default: dmesg

post_log() {
    SUBJ="$@"
    echo "<span style=\"padding:5px;font-weight:bold\">`date`</span> "$SUBJ" <br>" >> $LOGFILE
}

init_log() {
    echo "<meta http-equiv=\"refresh\" content=\"10\">" > $LOGFILE
    post_log "AUTO WOL started at ports" "$PORT"
}

wake_up () {
	PORT=$1
	TARGET=$2
	BROADCAST=$3
	MAC=$4
	NEW=`$LOGPROG | awk '/WOL_LOG/ && /DST='"$TARGET"'/ && /DPT='"$PORT"'/ {print }' | tail -1`
    SRC=`echo "$NEW" | awk -F'[=| ]' '{print $18}'`
    if [ "$NEW" != "" -a "$NEW" != "$OLD" ]; then
         if ping -qc $NUMP $TARGET >/dev/null; then
            post_log "target was accessed by $SRC and is already alive"
         else
            post_log "$SRC needs target awake"
            WOLRES=$($WOL -i $BROADCAST $MAC)
            post_log "$WOLRES"
            sleep 5
         fi
     OLD=$NEW
   fi
}

init_log

while sleep $INTERVAL; do
	wake_up $PORT $TARGET $INTERFACE $MAC;
done

