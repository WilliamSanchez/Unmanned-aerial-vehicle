import QtQuick
import QtLocation
import QtPositioning
import QtQuick.Shapes
import "qrc:/ui/assets/functions.js" as DQData

Rectangle{
    id: mapScreen
    anchors{
        top:  orientationBar.bottom
        bottom: parent.bottom
        right: controlScreen.left
    }

    property real _lat: 49.2827
    property real _lon: -123.1207

    Plugin{
        id: mapPlugin
        name:"osm" //"mapboxgl" "esri"
    }

    Connections{
        target: uav
        onLatitudeChanged: {
            _lon=uav.longitude
            _lat = uav.latitude
        }
    }

    Map{
        id: map
        visible: true
        anchors.fill: parent
        plugin: mapPlugin
        //center: QtPositioning.coordinate(49.2827,-123.1207)
        center: QtPositioning.coordinate(_lat,_lon)
        zoomLevel: 14

        MapItemView {
            MapQuickItem {
                id: marker
                anchorPoint.x: image.width/2
                anchorPoint.y: image.height/2
                //coordinate: QtPositioning.coordinate(49.2827,-123.1207)
                coordinate: QtPositioning.coordinate(_lat,_lon)
                sourceItem:     Image {
                    id: image
                    width: 100/3
                    height: 50/3
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:ui/assets/aircraft.png"
                }
            }
        }
    }

    Text {
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 5
        text: qsTr("Lon: "+uav.latitude+"\nLat: "+uav.longitude+"\nAlt: "+1000)
        color: "black"
        font.pixelSize: 15
        opacity: 0.8
        z: parent.z + 10
    }


    width: 3*parent.width/4
}

/*

    Connections{
        target: uav
        var lat= uav.getSomeVar()
        onSomeVarChanged: myLabel.text = qsTr("Lat:"+lat)
    }

    Button{
        id: sendData
        text: 'SendData'
        visible: true
        onClicked: uav.sendData()
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

*/

/*

MouseArea
{
    anchors.fill: map
    hoverEnabled: true
    property var coordinate: map.toCoordinate(Qt.point(mouseX, mouseY))
    Label
    {
        x: parent.mouseX - width
        y: parent.mouseY - height - 5
        text: "lat: %1; lon:%2".arg(parent.coordinate.latitude).arg(parent.coordinate.longitude)
    }
}
*/
