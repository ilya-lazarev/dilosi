import QtQuick 2.0
import QtQuick.Controls 2.5
import gates.org 1.0

Item {
    id: root

    property int inputs: 2
    property bool not : false
    property int rad: 6
    property int stroke: 3
    property string symbol: '*'
    property bool alert: false
    property bool selected: false
    required property int type
    readonly property int _ofs: 4

    implicitWidth: 50
    implicitHeight: type == GateType.Not ? 50 : 60

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
        readonly property int _pinStep: (baseRect.height - _ofs)
        color: '#00000000'
        implicitWidth: parent.width - rad*2
        implicitHeight: type == GateType.Not ? parent.width - rad*2 : parent.height
        x: rad
        y: 0
        border {
            color: '#000000'
            width: selected ? stroke * 1.5 : stroke
        }
    }

    // input pins
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
            y: _ofs + baseRect._pinStep / (inputs+1) * (index+1)
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
        x: root.width - 2*rad - rad/2
        y: outPin.y - rad/2 - stroke/2
        visible: root.not
    }

    Label {
        text: symbol
        x: 2*rad + stroke
        y: rad
        font.pixelSize: root.height / 4
    }

}
