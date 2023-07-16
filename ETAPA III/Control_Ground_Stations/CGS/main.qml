import QtQuick 2.0
import QtQuick.Window 2.14
import "ui/OrientationBar"
import "ui/ControlScreen"
import "ui/MapScreen"
import DQdata 1.0

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Ground Control Statations")

    DataUAV{
        id: uav
    }

    ControlScreen{
        id: controlScreen
    }

    Orientation{
        id: orientationBar
    }

    MapScreen{
        id: mapScreen
    }

}

