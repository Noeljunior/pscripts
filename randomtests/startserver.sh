# Path to the server binary
cd $1
DIRPATH=minecraft_server.1.6.4.jar

# Start server
nohup java -Xmx1024M -Xms1024M -jar $DIRPATH >/dev/null 1>/dev/null 2>/dev/null < /dev/null &
#java -Xmx2048M -Xms2048M -jar $DIRPATH
