import QtQuick 2.15
import QtQuick.Shapes 1.12

Rectangle {

    property real roll_deg: -25.0
    property real roll: roll_deg*Math.PI/180
    property real pitch: -30.0*Math.PI/180
    color: "red"

    Shape {
        id: circle
        anchors.centerIn: parent
        property real r: 100
        property real h: 80


        ShapePath {
            strokeColor: "transparent"
            fillColor: "darkblue"
            startX: circle.width/2 - circle.r*Math.cos(roll)
            startY:  circle.height/2 - circle.r*Math.sin(roll)
            PathArc {
                x: circle.width/2 + circle.r*Math.cos(roll)
                y: circle.width/2 + circle.r*Math.sin(roll)
                radiusX: circle.r; radiusY: circle.r
                useLargeArc: true
            }
        }

        ShapePath {
            strokeColor: "transparent"
            fillColor: "sienna"
            startX: circle.width/2 + circle.r*Math.cos(roll)
            startY:  circle.height/2 + circle.r*Math.sin(roll)
            PathArc {
                x: circle.width/2 - circle.r*Math.cos(roll)
                y: circle.width/2 - circle.r*Math.sin(roll)
                radiusX: circle.r; radiusY: circle.r
                useLargeArc: true
            }
        }

        ShapePath {
            strokeColor: "transparent"
            fillGradient: RadialGradient{
                centerX: circle.width/2
                centerY : circle.height/2
                centerRadius: 100
                focalX: centerX; focalY: centerY
                GradientStop { position: 0; color: "white" }
                GradientStop { position: 0.7; color: "darkblue" }
            }
            startX: circle.width/2 - circle.h*(Math.cos(roll+pitch))
            startY:  circle.height/2 - circle.h*(Math.sin(roll+pitch))
            PathArc {
                x: circle.width/2 + circle.h*(Math.cos(roll-pitch))
                y: circle.width/2 + circle.h*(Math.sin(roll-pitch))
                radiusX: circle.h; radiusY: circle.h
                useLargeArc: true
            }
        }

        ShapePath {
            strokeColor: "transparent"
            fillColor: "sienna"
            startX: circle.width/2 + circle.h*Math.cos(roll-pitch)
            startY: circle.width/2 + circle.h*Math.sin(roll-pitch)
            PathArc {
                x: circle.width/2 - circle.h*Math.cos(roll+pitch)
                y: circle.width/2 - circle.h*Math.sin(roll+pitch)
                radiusX: circle.h; radiusY: circle.h
                //useLargeArc: true
            }
        }

    }

    Image {
        id: top
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectFit
        source: "qrc:ui/assets/rotate_roll.png"
        transform: Rotation{origin.x: top.width/2; origin.y: top.height/2; axis { x: 0; y: 0; z: 1 } angle: roll_deg}

    }

    Image {
        //id: pitch
        //anchors.centerIn: parent
        x: (circle.width/2)*Math.cos(roll)+circle.h*Math.sin(pitch)*Math.cos(Math.PI/2-roll)
        y: (circle.width/2)*Math.sin(roll)-circle.h*Math.sin(pitch)*Math.sin(Math.PI/2-roll)
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectFit
        source: "qrc:ui/assets/rotate_pitch.png"
        transform: Rotation{origin.x: top.width/2; origin.y: top.height/2; axis { x: 0; y: 0; z: 1 } angle: roll_deg}

    }


}
