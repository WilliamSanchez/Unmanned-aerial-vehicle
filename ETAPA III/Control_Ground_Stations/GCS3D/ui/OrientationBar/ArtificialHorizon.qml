import QtQuick 2.15
import QtQuick.Shapes 1.12

Rectangle {
    id: artificialHorizon
    //width: parent.width
    //height: parent.height

    property real roll_deg:  mapScreen._r_deg
    property real pitch_deg:  mapScreen._p_deg
    property real roll:  -roll_deg*Math.PI/180
    property real pitch: pitch_deg*Math.PI/180


    Shape {

        anchors.centerIn: parent
        width: parent.height
        height: parent.height

        property real r: parent.height/2
        property real h: parent.height/2


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

    }


    Shape {
        id: circle
        anchors.centerIn: parent

        width: parent.height
        height: parent.height

        property real r: circle.height/2
        property real h: 3*circle.height/8


        ShapePath {
            strokeColor: "transparent"
            fillGradient: RadialGradient{
                centerX: circle.width/2
                centerY : circle.height/2
                centerRadius:  circle.r
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
                useLargeArc: pitch < 0 ? true : false
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
                useLargeArc: pitch > 0 ? true : false
            }
        }


        ShapePath {
            strokeColor: "green"
            fillColor: "transparent"
            strokeWidth: 5
            startX: circle.width/2 - circle.h*(Math.cos(roll+pitch))
            startY:  circle.height/2 - circle.h*(Math.sin(roll+pitch))
            PathLine {
                x: circle.width/2 + circle.h*(Math.cos(roll-pitch))
                y: circle.width/2 + circle.h*(Math.sin(roll-pitch))
            }
        }

        ShapePath {
            strokeColor: "transparent"
            fillColor: "black"
            strokeWidth: 3
            startX: circle.width/2
            startY: circle.height/2
            PathLine {
                x: circle.width/2 + circle.width/12*Math.cos(Math.PI/10)
                y: circle.height/2 + circle.height/12*Math.sin(Math.PI/10)
            }
            PathLine {
                x: circle.width/2 - circle.width/12*Math.cos(Math.PI/10)
                y: circle.height/2 + circle.height/12*Math.sin(Math.PI/10)
            }
            PathLine {
                x: circle.width/2
                y: circle.height/2
            }
        }

/*
        ShapePath {
            strokeColor: "transparent"
            fillColor: "black"
            strokeWidth: 3
            startX: (circle.width/2)*Math.cos(roll)+circle.h*Math.sin(pitch)*Math.cos(Math.PI/2-roll)
            startY: (circle.width/2)*Math.sin(roll)-circle.h*Math.sin(pitch)*Math.sin(Math.PI/2-roll)

            PathLine {
                x: (circle.width/2)*Math.cos(roll)+circle.h*Math.sin(pitch)*Math.cos(Math.PI/2-roll) + 25*(Math.cos(Math.PI/10))
                y: (circle.width/2)*Math.sin(roll)-circle.h*Math.sin(pitch)*Math.sin(Math.PI/2-roll) + 25*(Math.sin(Math.PI/10))
            }
            PathLine {
                x: (circle.width/2)*Math.cos(roll)+circle.h*Math.sin(pitch)*Math.cos(Math.PI/2-roll) - 25*(Math.cos(Math.PI/10))
                y: (circle.width/2)*Math.sin(roll)-circle.h*Math.sin(pitch)*Math.sin(Math.PI/2-roll) + 25*(Math.sin(Math.PI/10))
            }
            PathLine {
                x: (circle.width/2)*Math.cos(roll)+circle.h*Math.sin(pitch)*Math.cos(Math.PI/2-roll)
                y:( circle.width/2)*Math.sin(roll)-circle.h*Math.sin(pitch)*Math.sin(Math.PI/2-roll)
            }
        }
*/
        ShapePath {
            fillColor: "transparent"
            strokeColor: "red"
            strokeWidth: 2
            startX: circle.width/2
            startY: circle.height/12

            PathLine {
                x: circle.width/2+circle.width/20*Math.cos(Math.PI/4)
                y: circle.height/6*Math.sin(Math.PI/4)
            }
            PathLine {
                x: circle.width/2-circle.width/20*Math.cos(Math.PI/4)
                y: circle.height/6*Math.sin(Math.PI/4)
            }
            PathLine {
                x: circle.width/2
                y: circle.height/12
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
        x: circle.h*Math.sin(pitch)*Math.cos(Math.PI/2-roll)
        y: -circle.h*Math.sin(pitch)*Math.sin(Math.PI/2-roll)
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectFit
        source: "qrc:ui/assets/rotate_pitch.png"
        transform: Rotation{origin.x: top.width/2; origin.y: top.height/2; axis { x: 0; y: 0; z: 1 } angle: roll_deg}

    }

}
