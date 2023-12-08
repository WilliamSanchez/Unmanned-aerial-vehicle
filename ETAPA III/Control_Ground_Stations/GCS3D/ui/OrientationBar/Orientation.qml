import QtQuick 2.15
import QtQuick.Controls 2.12

Rectangle{
   id: orientationBar
   anchors{
      left: parent.left
      right: controlScreen.left
      top: parent.top
   }

    property int dec_pitch: -mapScreen._p_deg
   property int dec_roll: -mapScreen._r_deg
   property int dec_head: mapScreen._head-180

   Row{
       x: 5
       y: 5
      spacing: 10

      Rectangle{
          id: main
          color: "red"
          width: orientationBar.width/4-10
          height: orientationBar.height-10
          ArtificialHorizon {
              anchors.centerIn: parent
              width: parent.width
              height: parent.height
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
              id: top
              anchors.centerIn: parent
              width: 0.85*parent.width
              height: 0.85*parent.height
              fillMode: Image.PreserveAspectFit
              source: "qrc:ui/assets/Back.png"
              transform: Rotation{origin.x: top.width/2; origin.y: top.height/2; axis { x: 0; y: 0; z: 1 } angle: mapScreen._r_deg}

          }

          Text {
              anchors.bottom: parent.bottom
              anchors.bottomMargin: 5
              anchors.left: parent.left
              anchors.leftMargin: 5
              text: qsTr(""+dec_roll)
              color: "black"
              font.pixelSize: 15
              opacity: 0.5
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
              transform: Rotation{origin.x: back.width/2; origin.y: back.height/2; axis { x: 0; y: 0; z: 1 } angle: mapScreen._head+180}

          }

          Text {
              anchors.bottom: parent.bottom
              anchors.bottomMargin: 5
              anchors.left: parent.left
              anchors.leftMargin: 5
              text: qsTr(""+dec_head)
              color: "black"
              font.pixelSize: 15
              opacity: 0.5
          }
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
              id: side
              anchors.centerIn: parent
              width: 0.85*parent.width
              height: 0.85*parent.height
              fillMode: Image.PreserveAspectFit
              source: "qrc:ui/assets/Side.png"
              transform: Rotation{origin.x: side.width/2; origin.y: side.height/2; axis { x: 0; y: 0; z: 1 } angle: mapScreen._p_deg}

          }

          Text {
              anchors.bottom: parent.bottom
              anchors.bottomMargin: 5
              anchors.left: parent.left
              anchors.leftMargin: 5
              text: qsTr(""+dec_pitch)
              color: "black"
              font.pixelSize: 15
              opacity: 0.5
          }

      }


   }



   color: "blue"

   height: parent.height/5
}
