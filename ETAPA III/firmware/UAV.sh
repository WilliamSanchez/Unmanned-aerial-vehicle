#!/bin/sh

echo "Starting program $1"

#program=$1
program=fgfs_uav
FGFS=fgfs      

make clean

#--httpd=8088 --generic=socket,out,100,127.0.0.1,5500,udp,FGProtocol
#--httpd=8088 --generic=socket,out,100,127.0.0.1,5500,udp,UAVProtocol
#--parking-id=T7-06

make $program 

exec $program -d&

gnome-terminal --tab -- ${FGFS} --aircraft=777-300\
			--airport=KJFK\
			--parking-id=T7-06\
			--generic=socket,out,100,127.0.0.1,5500,udp,UAVProtocol&
     
wait	



#lsof -i:<port>
#kill <pid>
