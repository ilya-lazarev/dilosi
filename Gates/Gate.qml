import QtQuick 2.0
import QtQuick.Controls 2.5
import gates.org 1.0
import Gates 1.0
//import 'gatesLib.js' 1.0 as GL

Item {
    id: root

    GateType { id: gt }
    implicitWidth: 50
    implicitHeight: gate.type == GateType.Not ? 50 : 60

    property alias gate: gt
    property alias inv: gt.inv
    property alias inputs: gt.inputs
    property int rad: 6
    property int stroke: 3
    property bool alert: false
    property bool selected: false
    readonly property int _ofs: 4
    readonly property int pinMinSpacing: implicitWidth / 3

    x: gt.x
    y: gt.y

    onXChanged: gt.x = x
    onYChanged: gt.y = y

    // dimmer - alert,selcted
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
        id: baseRect
        color: '#00000000'
        implicitWidth: parent.width - rad*2
        implicitHeight: gate.type == GateType.Not ? parent.width - rad*2 : parent.height
        x: rad
        y: 0
        border {
            color: '#000000'
            width: selected ? stroke * 1.5 : stroke
        }
    }

    // input pins
    Repeater {
        model: gate.inputs
        delegate: Rectangle {
            color: '#00000000'
            border {
                color: '#000000'
                width: stroke
            }

            width: rad
            height: stroke
            y: _ofs + baseRect._pinStep / (gate.inputs+1) * (index+1)
        }
    }

    // output pin
    Rectangle {
        id: outPin
        color: '#00000000'
        border {
            color: '#000000'
            width: stroke
        }
        x: root.width - rad
        width: rad
        height: stroke
        y: _ofs + (baseRect.height - 2*_ofs) / 3
    }

    // inverted output
    Rectangle {
        border {
            color: '#000000'
            width: stroke
        }
        width: rad*2
        height: width
        radius: rad
        x: root.width - 2*rad - rad/2 +1
        y: outPin.y - rad/2 - stroke/2
        visible: gate.inv
    }

    Label {
        id: label
        text: GL.getSymbol(gate.type)
        x: 2*rad + stroke
        y: rad
        font.pixelSize: root.height / 4
    }
}
