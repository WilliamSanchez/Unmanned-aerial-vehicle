// Copyright 2023 ESRI
//
// All rights reserved under the copyright laws of the United States
// and applicable international laws, treaties, and conventions.
//
// You may freely redistribute and use this sample code, with or
// without modification, provided you include the original copyright
// notice and use restrictions.
//
// See the Sample code usage restrictions document for further information.
//

import QtQuick 2.15
import QtQuick.Window 2.15
import "../ui/MapScreen"
import "../ui/OrientationBar"
import "../ui/ControlScreen"

import DQdata 1.0

Window {

    width: 1280
    height: 720
    visible: true
    title: qsTr("Tesla")

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
