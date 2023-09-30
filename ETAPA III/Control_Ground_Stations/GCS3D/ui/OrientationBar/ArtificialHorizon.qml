import QtQuick 2.15
import QtQuick.Shapes 1.12

Rectangle {

    Shape {

        id: circle
        anchors.fill: parent
        property real r: 50

        ShapePath {
            id : sky
            strokeColor: "transparent"
            fillColor: "blue"
            startX: circle.width / 2 - 0 //circle.r
            startY:  circle.height / 2 - 50 // circle.r
            PathArc {
                x: circle.width / 2 + 50 //circle.r-10
                y: circle.height / 2 + 0 //circle.r-10
                radiusX: circle.r; radiusY: circle.r
                useLargeArc: true
            }
        }

        ShapePath {
            id: earth
            strokeColor: "transparent"
            fillColor: "brown"
            startX: circle.width / 2 + 50//circle.r-10
            startY: circle.height / 2 + 0 //+ circle.r-10
            PathArc {
                x: circle.width / 2 - 0 //circle.r
                y: circle.height / 2 - 50  //circle.r
                radiusX: circle.r; radiusY: circle.r
                //useLargeArc: true
            }
        }
    }

}
