import QtQuick
import QtQuick.Controls
import QtLocation
import QtPositioning
import QtQuick.Shapes
import Esri.ArcGISRuntime
import Esri.ArcGISExtras

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
    property real _alt: 700
    property real _head: 0.0
    property real _airs: 0.0
    property real _xaccel: 0.0
    property real _yaccel: 0.0
    property real _zaccel: 0.0
    property real _p_deg: 0.0
    property real _r_deg: 0.0
    property real _y_deg: 0.0

    Connections{
        target: uav
        onLatitudeChanged: {
            _lon    = uav.longitude
            _lat    = uav.latitude
            _alt    = uav.alture*0.3048
            _head   = uav.heading
            _airs   = uav.airspeed
            _xaccel = uav.x_accel
            _yaccel = uav.y_accel
            _zaccel = uav.z_accel
            _p_deg  = uav.p_rate
            _r_deg  = uav.r_rate
            _y_deg  = uav.y_rate

            ptBuilder.setXY(_lon, _lat);
             mv.setViewpointCenterAndScale(ptBuilder.geometry, _alt+700);
        }
    }

    PointBuilder {
        id: ptBuilder
        spatialReference: SpatialReference { wkid: 4326 }
    }


    MapView {
        id: mv
        anchors.fill: parent

        Component.onCompleted: {
            // Set the focus on MapView to initially enable keyboard navigation
            forceActiveFocus();
        }

        Map {
            Basemap {
                initStyle: Enums.BasemapStyleArcGISImagery
            }
        }

    }


    Image {
        id: image
        y: mv.height/2
        x: mv.width/2
        width: 100
        height: 50
        fillMode: Image.PreserveAspectFit
        source: "qrc:ui/assets/Top.png"
        transform: Rotation{origin.x: image.width/2; origin.y: image.height/2; axis { x: 0; y: 0; z: 1 } angle: _head}
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


