import QtQuick 2.15
import QtQuick.Controls 2.12

Rectangle{
   id: orientationBar
   anchors{
      left: parent.left
      right: controlScreen.left
      top: parent.top
   }

   Row{
       x: 5
       y: 5
      spacing: 10

      Rectangle{
          id: main
          color: "red"
          width: orientationBar.width/4-10
          height: orientationBar.height-10
      }

      Rectangle{
          id: pitch
          color: "red"
          width: orientationBar.width/4-10
          height: orientationBar.height-10
          Image {
              anchors.centerIn: parent
              width: parent.width
              height: parent.height
              fillMode: Image.PreserveAspectFit
              source: "qrc:ui/assets/orientation.png"
          }
          Image {
              id: top
              anchors.centerIn: parent
              width: 0.85*parent.width
              height: 0.85*parent.height
              fillMode: Image.PreserveAspectFit
              source: "qrc:ui/assets/Back.png"
              transform: Rotation{origin.x: top.width/2; origin.y: top.height/2; axis { x: 0; y: 0; z: 1 } angle: mapScreen._r_deg}

          }

      }

      Rectangle{

          id: yaw
          color: "red"
          width: orientationBar.width/4-10
          height: orientationBar.height-10
          Image {
              anchors.centerIn: parent
              width: parent.width
              height: parent.height
              fillMode: Image.PreserveAspectFit
              source: "qrc:ui/assets/orientation.png"
          }
          Image {
              id: back
              anchors.centerIn: parent
              width: 0.85*parent.width
              height: 0.85*parent.height
              fillMode: Image.PreserveAspectFit
              source: "qrc:ui/assets/Top.png"
              transform: Rotation{origin.x: back.width/2; origin.y: back.height/2; axis { x: 0; y: 0; z: 1 } angle: mapScreen._head}

          }
      }

      Rectangle{
          id: roll
          color: "red"
          width: orientationBar.width/4-10
          height: orientationBar.height-10

          Image {
              anchors.centerIn: parent
              width: parent.width
              height: parent.height
              fillMode: Image.PreserveAspectFit
              source: "qrc:ui/assets/orientation.png"
          }
          Image {
              id: side
              anchors.centerIn: parent
              width: 0.85*parent.width
              height: 0.85*parent.height
              fillMode: Image.PreserveAspectFit
              source: "qrc:ui/assets/Side.png"
              transform: Rotation{origin.x: side.width/2; origin.y: side.height/2; axis { x: 0; y: 0; z: 1 } angle: -mapScreen._p_deg}

          }

          Button{
              anchors.right: parent.right
              anchors.top:parent.top
              height: parent.height/5
              width: parent.width/6
              text: 'SendData'
              visible: true
              onClicked: uav.sendData()
          }

      }


   }



   color: "blue"

   height: parent.height/5
}
