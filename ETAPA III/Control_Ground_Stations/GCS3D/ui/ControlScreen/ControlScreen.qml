import QtQuick 2.15
import QtQuick.Controls 2.12

Rectangle{
    anchors{
      top: parent.top
      bottom: parent.bottom
      right: parent.right
    }
    color: "green"
    width: parent.width/4

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
