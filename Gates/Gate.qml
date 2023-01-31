import QtQuick 2.0
import QtQuick.Controls 2.5
import gates 1.0

Item {
    id: root
    implicitWidth: 50
    implicitHeight: 60

    property int inputs: 2
    property bool not : true
    property int rad: 6
    property int stroke: 3
    property string symbol: '*'
    property bool alert: false
    property bool selected: false
    property int type: GateType.Gate

    Rectangle {
        id: tinter
        color: alert  && selected ? '#aaff3388' : alert ? '#99ff0000' : selected ? '#330077ff' : '#00000000';
        x: 0
        y: 0
        anchors.fill: parent
        radius: rad
        visible: alert || selected
    }

    Rectangle {
        color: '#00000000'
        implicitWidth: parent.width - rad*2
        implicitHeight: parent.height
        x: rad
        y: 0
        border {
            color: '#000000'
            width: selected ? stroke * 1.5 : stroke
        }
    }
    Repeater {
        model: inputs
        delegate: Rectangle {
            color: '#00000000'
            border {
                color: '#000000'
                width: stroke
            }

            width: rad
            height: stroke
            y: root.height / (inputs+1) * (index+1)
        }
    }
    Rectangle {
        border {
            color: '#000000'
            width: stroke
        }
        width: rad*2
        height: width
        radius: rad
        x: root.width - 2*rad
        y: root.height / 4
        visible: root.not
    }
    Label {
        text: symbol
        x: 2*rad + stroke
        y: rad
        font.pixelSize: root.height / 4
    }
    function pinAtPoint(x,y) {
        return {0: 'in'}
    }
//    Component.onCompleted: {
//        root.grabToImage(function(result) {
//                root.Drag.imageSource = result.url
//                console.log(result)
//            }
//        )
//    }
}
