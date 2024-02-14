#!/bin/sh

echo "Starting program $1"

program
protocol

if [ "$1" = "fgfs_uav" ] || [ -z "$1" ]; then 
 program=fgfs_uav 
 protocol=UAVProtocol
else 
 program="$1" 
 protocol=FGProtocol
fi

FGFS=fgfs  
flightPlan="../KJFK-CYYZ.xml"    

echo "Execuitn of file $program"

make clean

#--httpd=8088 --generic=socket,out,100,127.0.0.1,5500,udp,FGProtocol
#--httpd=8088 --generic=socket,out,100,127.0.0.1,5500,udp,UAVProtocol
#--parking-id=T7-06

make $program 

gnome-terminal --tab -- ${FGFS} --aircraft=777-300\
			--airport=KJFK\
			--parking-id=T7-06\
			--httpd=8088\
			--flight-plan="$flightPlan"\
			--generic=socket,out,100,127.0.0.1,5500,udp,"$protocol"&

echo "Press [ENTER] to continue" 
read var
 
if [ "$1" = "main" ]; then  
   sudo $(exec) "./$program"&
   echo "FINISH PROGRAM"
else
   exec $program -d&
fi
wait	



#lsof -i:<port>
#kill <pid>
