import QtQuick 2.0
import QtQuick.Window 2.14
import QtLocation 5.6
import QtPositioning 5.6

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

}
