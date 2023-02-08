import QtQuick 2.0
import QtQuick.Controls 2.5
import gates.org 1.0
import Gates 1.0
//import 'gatesLib.js' 1.0 as GL

Item {
    id: root

    GateType { id: gt }
    implicitWidth: 50
    property alias gate: gt

    implicitHeight: gate.type == GateType.Not ? width - rad*2 : 60

    property alias type: gt.type
    property alias inv: gt.inv
    property alias inputs: gt.inputs
    property int rad: 6
    property int stroke: 3
    property bool alert: false
    property bool selected: false
    readonly property int _ofs: 4
    readonly property int pinMinSpacing: implicitWidth / 3
    property alias hilited: inPins.hilited

//    x: gt.x
//    y: gt.y

    onXChanged: gt.x = x
    onYChanged: gt.y = y

    function isInputsArea(point) {
//        dp.text = Math.round(point.x)+'\n'+Math.round(point.y)
        if(point.x>=0 && point.x <=baseRect.x+2 && point.y >= inPins.getInY(0) - 2 && point.y<=inPins.getInY(inputs-1) + 2)
            return true;
        return false
    }

    function isOutputArea(point) {
//        dp.text = Math.round(point.x) + '\n' + Math.round(point.y)
        return point.x>=outPin.x  && point.x <= root.width && point.y >= outPin.y - stroke && point.y <= outPin.y + 2*stroke
    }

    function inPinNumber(y) {
        for( var i = 0; i < inputs; ++i ) {
            if( Math.abs(y - inPins.getInY(i)) < inPins.gapY - 4)
                return i
        }
        return -1
    }

    function getInPinPoint(pin) {
        if( pin <0 || pin >= inputs ) {
            return null
        }
        var x = 0, y = inPins.getInY(pin)
        return Qt.point(x, y)
    }

    function getOutPinPoint() {
        return Qt.point(width-1, outPin.y)
    }

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

    // main rectangle
    Rectangle {
        id: baseRect
        color: '#00000000'
        implicitWidth: parent.width - rad*2
        implicitHeight: gate.type == GateType.Not ? width : parent.height
        x: rad
        y: 0
        border {
            color: '#000000'
            width: selected ? stroke * 1.5 : stroke
        }
    }

    // input pins
    Repeater {
        id: inPins

        property int hilited: -1
        property int gapY: baseRect.height / (gate.inputs+1)
        model: gate.inputs

        function getInY(i) {
            return gapY * (i+1) + stroke/2
        }

        delegate: Rectangle {
            color: '#00000000'
            border {
                color: index == inPins.hilited ? '#FFAA22' : '#000000'
                width: stroke
            }

            width: rad
            height: stroke
            y: inPins.getInY(index) - stroke/2
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
//    Label {
//        id: dp
//        font.pixelSize: 10
//        x: label.x
//        anchors.top: label.bottom
//    }
}
