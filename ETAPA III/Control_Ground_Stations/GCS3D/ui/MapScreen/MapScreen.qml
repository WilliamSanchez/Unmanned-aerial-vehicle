
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Esri.ArcGISRuntime
import Esri.ArcGISExtras
import "qrc:/ui/assets/functions.js" as DQData

Rectangle {
    width: 3*parent.width/4
    height: 4*parent.height/5
    visible: true
    id: mapScreen

    readonly property url dataPath: {
        Qt.platform.os === "ios" ?
                    System.writableLocationUrl(System.StandardPathsDocumentsLocation) + "/ArcGIS/Runtime/Data/3D" :
                    System.writableLocationUrl(System.StandardPathsHomeLocation) + "/ArcGIS/Runtime/Data/3D"
    }

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

    readonly property string headingAtt: "heading";
    readonly property string pitchAtt: "pitch";
    readonly property string rollAtt: "roll";
    readonly property string attrFormat: "[%1]"


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

            thePlane.geometry= ArcGISRuntimeEnvironment.createObject("Point",{
                x: _lon,
                y: _lat,
                z: _alt,
                spatialReference: Factory.SpatialReference.createWgs84()
            });
            thePlane.attributes.replaceAttribute(headingAtt, _head);
            thePlane.attributes.replaceAttribute(pitchAtt, _p_deg);
            thePlane.attributes.replaceAttribute(rollAtt, _r_deg);

        }
    }


    OrbitGeoElementCameraController{
        id: orbitPlaneCtrlr
        targetGeoElement: thePlane
        cameraDistance: 5000
        cameraPitchOffset: _p_deg
    }

    // add a sceneView component
    SceneView {
        id: sceneView
        anchors.fill: parent

        // add a Scene to the SceneView
        Scene {
            id: scene
            // add the ArcGISImagery basemap to the scene
            initBasemapStyle: Enums.BasemapStyleArcGISImagery

            // add a surface...surface is a default property of scene
            Surface {
                // add an arcgis tiled elevation source...elevation source is a default property of surface
                ArcGISTiledElevationSource {
                    url: "https://elevation3d.arcgis.com/arcgis/rest/services/WorldElevation3D/Terrain3D/ImageServer"
                }
            }
        }

        GraphicsOverlay {
            id: graphicsOverlay

            LayerSceneProperties {
                surfacePlacement: Enums.SurfacePlacementRelative
            }

            SimpleRenderer {
                id: sceneRenderer
                RendererSceneProperties {
                    id: renderProps
                    headingExpression: attrFormat.arg(headingAtt)
                    pitchExpression:  attrFormat.arg(pitchAtt)
                    rollExpression: attrFormat.arg(rollAtt)
                }
            }

            ModelSceneSymbol {
                id: mms
                url: System.resolvedPath(dataPath) + "/Bristol/Bristol.dae"
                scale: 10.0
                heading: 0.0
            }

            Graphic {
                id: thePlane
                symbol: mms

                geometry: Point {
                    x: _lon
                    y: _lat
                    z: 5000
                    spatialReference: sceneView.spatialReference
                }

                Component.onCompleted: {
                    //thePlane.attributes.insertAttribute(headingAtt, 0.);
                    //thePlane.attributes.insertAttribute(rollAtt, 0.);
                    //thePlane.attributes.insertAttribute(pitchAtt, 0.);
                }

            }
        }

          Component.onCompleted:{
              //forceActiveFocus();
              //sceneView.setViewpointCamera(camera)
              //sceneView.cameraController = orbitLocationCtrlr
              sceneView.cameraController = orbitPlaneCtrlr;
              //sceneView.cameraController = globeController
          }

    }

/*

    Camera{
        id: camera
        heading: _head
        pitch: _p_deg
        roll: _r_deg
        location: theCr
    }

    Button{
        anchors.right: parent.right
        anchors.top:parent.top
        height: parent.height/5
        width: parent.width/6
        text: 'SendData MAIN'
        visible: true
        onClicked: {
            _lon = _lon + 0.001
            _lat = _lat -0.001
            thePlane.geometry= ArcGISRuntimeEnvironment.createObject("Point",{
                x: _lon,
                y: _lat,
                z: distance / 2,
                spatialReference: Factory.SpatialReference.createWgs84()
            });
            thePlane.attributes.replaceAttribute(headingAtt, _lat+mapScreen.cont);
            thePlane.attributes.replaceAttribute(pitchAtt, _lon-mapScreen.cont);
            thePlane.attributes.replaceAttribute(rollAtt, _lat-_lon);


        }
    }
*/
    Text {
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 5
        text: qsTr("Lon: "+_lat+"\nLat: "+_lon+"\nAlt: "+1000)
        color: "black"
        font.pixelSize: 15
        opacity: 0.8
        z: parent.z + 10
    }
}

/*
// [WriteFile Name=ChangeViewpoint, Category=Maps]
// [Legal]
// Copyright 2016 Esri.

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// [Legal]

import QtQuick
import QtQuick.Controls
import Esri.ArcGISRuntime

Rectangle {
    width: 800
    height: 600
    id: mapScreen
    anchors{
        top:  orientationBar.bottom
        bottom: parent.bottom
        right: controlScreen.left
    }GCS2D

    property real _lat: 49.2827
    property real _lon: -123.1207
    property var cont: 0

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

    Button{
        anchors.right: parent.right
        anchors.top:parent.top
        height: parent.height/5
        width: parent.width/6
        text: 'SendData'
        visible: true
        onClicked: {
            _lon = _lon + 0.001
            _lat = _lat -0.001
            ptBuilder.setXY(_lon, _lat); // Hawai'i
            mv.setViewpointCenterAndScale(ptBuilder.geometry, 5000);
        }
    }


}
*/
/*

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
    property var cont: 0

    Plugin{
        id: mapPlugin
        name: "osm" //"mapboxgl"//"esri"
    }

    Map{
        id: map
        visible: true
        anchors.fill: parent
        plugin: mapPlugin
        //center: QtPositioning.coordinate(49.2827,-123.1207)
        center: QtPositioning.coordinate(_lat,_lon)
        zoomLevel: 14
        activeMapType: {

            MapType.SatelliteMapDay
            //MapType.SatelliteMapNight
            //MapType.TerrainMap
            //MapType.night=true
        }



        MapItemView {


            MapQuickItem {
                id: marker
                anchorPoint.x: image.width/2
                anchorPoint.y: image.height/2
                //coordinate: QtPositioning.coordinate(49.2827,-123.1207)
                coordinate: QtPositioning.coordinate(_lat,_lon)
                sourceItem:     Image {
                    id: image
                    width: 50
                    height: 25
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:ui/assets/Top.png"
                    transform: Rotation{origin.x: image.width/2; origin.y: image.height/2; axis { x: 0; y: 0; z: 1 } angle: _lon+cont}
                }


            }
        }
    }

    Text {
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 5
        text: qsTr("Lon: "+DQData.latitude(_lat)+"\nLat: "+DQData.longitude(_lon)+"\nAlt: "+1000)
        color: "black"
        font.pixelSize: 15
        opacity: 0.8
        z: parent.z + 10
    }


    width: 3*parent.width/4
}


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
