import QtQuick 2.15
import QtQuick.Controls 2.12

Rectangle{
   id: orientationBar
   anchors{
      left: parent.left
      right: controlScreen.left
      top: parent.top
   }

   Button{
       id: sendData
       text: 'SendData'
       visible: true
       onClicked: uav.sendData()
   }

   Button{
       anchors.right: parent.right
       anchors.top:parent.top
       height: parent.height/5
       width: parent.width/6
       text: 'SendData'
       visible: true
       onClicked: {
         mapScreen._lat = mapScreen._lat + 0.0051;
         mapScreen._lon = mapScreen._lon + 0.0015;
       }
   }

   color: "blue"
   Image {
       id: aircraft
       anchors.centerIn: parent
       width: 0.85*parent.height
       fillMode: Image.PreserveAspectFit
       source: "qrc:ui/assets/aircraft.png"
   }
   height: parent.height/5
}
