import QtQuick 2.0
import QtQuick.Window 2.14
import QtQuick.Controls 2.12
import QtLocation 5.6
import QtPositioning 5.6
import DQdata 1.0

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Ground Control Statations")


    Plugin{
      id: mapPlugin
      name:"osm" //"mapboxgl" "esri"
    }

    Map{

       anchors.fill: parent
       plugin: mapPlugin
       center: QtPositioning.coordinate(49.2827,-123.1207)
       zoomLevel: 14
    }

    DataUAV{
        id: uav
    }

    Connections{
        target: uav
        onSomeVarChanged: myLabel.text = uav.getSomeVar()
    }

    Button{
        id: sendData
        text: 'SendData'
        visible: true
        onClicked: uav.sendData()
    }

    Button{
        id: getData
        anchors.centerIn: parent
        text: 'GetData'
        visible: true
        onClicked: uav.setSomeVar("ABC")
    }

    Text {
        id: myLabel
        text: uav.getSomeVar()
        anchors{
            top:parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: 20
        }
    }
}
