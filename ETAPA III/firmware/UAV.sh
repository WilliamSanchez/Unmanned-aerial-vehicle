#!/bin/sh

echo "Starting program $1"
addr=localhost
protocol=FGProtocol
 
if [ "$1" = "fgfs_uav" ] || [ -z "$1" ]; then 
 program=fgfs_uav 
 protocol=UAVProtocol
elif [ "$1" = "target" ]; then
 cp matrices.c *.h ~/Documents/Embedded_Systems/Embedded_Linux/EmbeddedLinuxSystems/Buildroot/files/uav_project
 cp target.c ~/Documents/Embedded_Systems/Embedded_Linux/EmbeddedLinuxSystems/Buildroot/files/uav_project/uav_project.c
 sudo rm -rf ~/Documents/Embedded_Systems/Embedded_Linux/QEMU/buildroot/output/build/uav_project*
 echo "Exit of program"
 exit
 sudo make
 addr=192.168.1.100
else
 program="$1" 
fi

FGFS=fgfs  
flightPlan="../KJFK-CYYZ.xml"    

echo "Execuitn of file $program"

make clean

#--httpd=8088 --generic=socket,out,100,127.0.0.1,5500,udp,FGProtocol
#--httpd=8088 --generic=socket,out,100,127.0.0.1,5500,udp,UAVProtocol
#--parking-id=T7-06

if [ $1 != "target" ]; then make $program; fi

gnome-terminal --tab -- ${FGFS} --aircraft=777-300\
			--airport=KJFK\
			--parking-id=T7-06\
			--httpd=8088\
			--flight-plan="$flightPlan"\
			--generic=socket,out,50,192.168.1.100,5500,udp,"$protocol"\
			--generic=socket,in,100,"$addr",192.168.1.1,udp,"$protocol"&

echo "Press [ENTER] to continue"
read var

if [ "$1" = "main" ]; then
   sudo $(exec) "./$program"&
   echo "FINISH PROGRAM"
elif [ "$1" != "target" ]; then
   exec $program -d&
fi
wait

#sudo kill -9 $(pgrep -f "/bin/bash ./simulation")
#sudo kill -9 $(pidof ./build/examples/ric/nearRT-RIC)
#lsof -i:<port>
#kill -9 <pid>
