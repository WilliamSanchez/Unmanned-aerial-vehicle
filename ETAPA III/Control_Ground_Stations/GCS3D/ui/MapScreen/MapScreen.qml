
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
        //cameraPitchOffset: _p_deg
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
                    thePlane.attributes.insertAttribute(headingAtt, 0.);
                    thePlane.attributes.insertAttribute(rollAtt, 0.);
                    thePlane.attributes.insertAttribute(pitchAtt, 0.);
                }

            }
        }

          Component.onCompleted:{
              //forceActiveFocus();
              sceneView.cameraController = orbitPlaneCtrlr;
          }

    }


    Text {
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 5
        text: qsTr("Lon: "+_lat+"\nLat: "+_lon+"\nAlt: "+_alt)
        color: "black"
        font.pixelSize: 15
        opacity: 0.8
        z: parent.z + 10
    }
}

