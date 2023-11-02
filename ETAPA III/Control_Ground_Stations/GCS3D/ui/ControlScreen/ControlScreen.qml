import QtQuick 2.15
import QtQuick.Controls 2.12

Rectangle{
    id: controlScreen
    anchors{
        top: parent.top
        bottom: parent.bottom
        right: parent.right
    }
    color: "green"
    width: parent.width/4

    Grid{
        id: start_CGS
        rows: 2

         Rectangle{
             height: controlScreen.height/20
             width: controlScreen.width
             TextField{
                 width: 2*controlScreen.width/3
                 height:controlScreen.height/20
                 id: addressIP
                 placeholderText: qsTr("Enter IP")
             }

             Button{
                 anchors.left: addressIP.right
                 width: controlScreen.width/3
                 height: controlScreen.height/20
                 text: 'connect'
                 visible: true
                 onClicked: {
                    uav.connectIP(addressIP.text)
                    addressIP.text = " ";
                 }
             }
         }

        Button{
            height: controlScreen.height/20
            width: controlScreen.width
            text: 'START'
            visible: true
            onClicked: uav.sendData()
        }

    }
}
