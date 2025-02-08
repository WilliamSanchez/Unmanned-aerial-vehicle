#!/bin/sh

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/william/Qt/6.8.1/gcc_64/lib

ControlGroundStation=../Control_Ground_Stations/GCS3D/build/Desktop_Qt_6_8_1-Release

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

echo "Choose an dparture pleace"
echo "1-> New York"
echo "2-> Dublin"
echo "3-> London"
echo "4-> Zurich"
echo "5-> Madrid"
echo "6-> Frankfurt"
echo "7-> Medellin"
echo "8-> Tokio"
echo "9-> Montreal"
echo "10-> Kuala Lumpur"


flightPlan="../KJFK-CYYZ.xml" 
airport="KJFK"
parking="T7-06"

read departure

if [ $departure -eq 1 ]; then
	flightPlan="../KJFK-CYYZ.xml" 
	airport="KJFK"
	parking="T7-06"
elif [ $departure -eq 2 ]; then
	flightPlan="../EIDW-EGLL.xml" 
	airport="EIDW"
	parking="120R"
elif [ $departure -eq 3 ]; then
	flightPlan="../EGLL-LFPG.xml" 
	airport="EGLL"
	parking="592"
elif [ $departure -eq 4 ]; then
	flightPlan="../LSZH-LIMC.xml" 
	airport="LSZH"
	parking="E27"
elif [ $departure -eq 5 ]; then
	flightPlan="../LEMD-LPPT.xml" 
	airport="LEMD"
	parking="R21-565"
elif [ $departure -eq 6 ]; then
	flightPlan="../EDDF-EKCH.xml" 
	airport="EDDF"
	parking="C16"
elif [ $departure -eq 7 ]; then
	flightPlan="../SKRG-SKBO.xml" 
	airport="SKRG"
	parking="11"
elif [ $departure -eq 8 ]; then
	flightPlan="../RJAA-RKSI.xml" 
	airport="RJAA"
	parking="T158B"
elif [ $departure -eq 9 ]; then
	flightPlan="../CYUL-CYYZ.xml" 
	airport="CYUL"
	parking="64"
elif [ $departure -eq 10 ]; then
	flightPlan="../WMKK-WSSS.xml" 
	airport="WMKK"
	parking="A51L"
fi

FGFS=fgfs  
#flightPlan="../KJFK-CYYZ.xml"  
#flightPlan="../EIDW-EGLL.xml"    

echo "Execuitn of file $program"

make clean

#--httpd=8088 --generic=socket,out,100,127.0.0.1,5500,udp,FGProtocol
#--httpd=8088 --generic=socket,out,100,127.0.0.1,5500,udp,UAVProtocol
#--parking-id=T7-06

if [ $1 != "target" ]; then make $program; fi

gnome-terminal --tab -- ${FGFS} --aircraft=777-300\
			--airport="$airport"\
			--parking-id="$parking"\
			--httpd=8088\
			--flight-plan="$flightPlan"\
			--generic=socket,out,20,127.0.0.1.100,5500,udp,"$protocol"\
			--generic=socket,in,50,127.0.0.1,5501,udp,"$protocol"&




echo "Press [ENTER] to continue"
read var

cd $ControlGroundStation
gnome-terminal --tab -- $(exec) "./GCS3D"&

cd ../../../../
cd firmware

pwd

read


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
