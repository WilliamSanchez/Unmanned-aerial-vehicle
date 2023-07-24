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
    property int _alt: 500
    property real _head: 0.0
    property real _airs: 0.0
    property real _xaccel: 0.0
    property real _yaccel: 0.0
    property real _zaccel: 0.0
    property real _p_deg: 0.0
    property real _r_deg: 0.0
    property real _y_deg: 0.0


    Plugin{
        id: mapPlugin
        name:"osm" //"mapboxgl" "esri"
    }

    Connections{
        target: uav
        onLatitudeChanged: {
            _lon    = uav.longitude
            _lat    = uav.latitude
            _alt    = uav.alture
            _head   = uav.heading
            _airs   = uav.airspeed
            _xaccel = uav.x_accel
            _yaccel = uav.y_accel
            _zaccel = uav.z_accel
            _p_deg  = uav.p_rate
            _r_deg  = uav.r_rate
            _y_deg  = uav.y_rate
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
                    width: 100
                    height: 50
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:ui/assets/Top.png"
                    transform: Rotation{origin.x: image.width/2; origin.y: image.height/2; axis { x: 0; y: 0; z: 1 } angle: _head}
                }
            }
        }
    }

    Text {
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 5
        text: qsTr("Lon: "+_lon+"\nLat: "+_lat+"\nAlt: "+_alt+"\nSpeed: "+_airs)
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
