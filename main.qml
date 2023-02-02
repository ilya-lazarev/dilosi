import QtQml 2.15
import QtQuick 2.15
//import Qt.labs.platform 1.1 as Pl
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.3
import Gates 1.0
import gates.org 1.0

ApplicationWindow {
    id: mainWin
    width: 1024
    height: 800
    visible: true

    title: qsTr("Hello World")
    property int menuHeight: 16
    property int iconSize: 24

    function newGate(type) {
        var g;

        g = GL.createGate(type, ii, {x: ii.width/2, y: ii.height/2})
        if(g !== null)
            ii.gates.push(g)
        return g;
    }

    Action {
        id: acFileOpen
        text: qsTr("&Open")
        shortcut: 'Ctrl+O'
        onTriggered: console.log("OpenFile")
        icon {
            source: 'qrc:/img/24x24/fileopen.png'
        }
    }

    Action {
        id: acFileSave
        text: qsTr("&Save")
        shortcut: 'Ctrl+S'
        onTriggered: {
            console.log("SaveFile")
            iolib.writeConfig(ii.gates)
        }
        icon {
            source: 'qrc:/img/24x24/filesave.png'
        }
    }

    Action {
        id: acAppExit
        text: qsTr("&Quit")
        shortcut: 'Ctrl+Q'
        onTriggered: Qt.quit()
        icon {
            source: 'qrc:/img/24x24/finish.png'
        }
    }

    Action {
        id: acAddAndGate
        text: qsTr("Add (N)AND gate")
        onTriggered: newGate(GateLib.And)
        shortcut: 'Ctrl+1'
        icon {
            source: 'qrc:/img/24x24/andGate.png'
            color: 'transparent'
        }
    }
    Action {
        id: acAddOrGate
        text: qsTr("Add (N)OR gate")
        onTriggered: newGate(GateLib.Or)
        shortcut: 'Ctrl+2'
        icon {
            source: 'qrc:/img/24x24/orGate.png'
            color: 'transparent'
        }
    }
    Action {
        id: acAddXorGate
        text: qsTr("Add (N)XOR gate")
        onTriggered: newGate(GateLib.Xor)
        shortcut: 'Ctrl+3'
        icon {
            source: 'qrc:/img/24x24/xorGate.png'
            color: 'transparent'
        }
    }

    Action {
        id: acAddNotGate
        text: qsTr("Add NOT/REPEATER gate")
        onTriggered: newGate(GateLib.Not)
        shortcut: 'Ctrl+4'
        icon {
            source: 'qrc:/img/24x24/notGate.png'
            color: 'transparent'
        }
    }

    menuBar: MenuBar {
        id: menuBar
        Layout.margins: 0
        Menu {
            title: qsTr("&File")
            MenuItem {
                action: acFileOpen
                font.pointSize: 10
                icon.color: "transparent"
            }
            MenuItem {
                action: acFileSave
                font.pointSize: 10
                icon.color: "transparent"
            }
            MenuSeparator {}
            MenuItem {
                action: acAppExit
                icon.color: "transparent"
            }
        }
    }

    header: ToolBar {
        id: toolBar
        Layout.margins: 0
        Layout.fillWidth: true
        hoverEnabled: true
        RowLayout {
            TButton {
                action: acFileOpen
                tooltip:  qsTr("Open")
            }
            TButton {
                action: acFileSave
                tooltip:  qsTr("Save")
            }
            TButton {
                action: acAppExit
                tooltip:  qsTr("Quit the app")
            }

            // -------------------
            ToolSeparator { }

            TButton {
                action: acAddNotGate
                tooltip:  qsTr("Create 'not' ot repeater gate")
            }
            TButton {
                action: acAddAndGate
                tooltip:  qsTr("Create (N)AND gate")
            }
            TButton {
                action: acAddOrGate
                tooltip:  qsTr("Create (N)OR gate")
            }
            TButton {
                action: acAddXorGate
                tooltip:  qsTr("Create (N)XOR gate")
            }

            ToolSeparator { }

            CheckBox {
                id: notCheck
                text: qsTr("Inverted")
                enabled: mArea.current !== null && !mArea.dragging
                checked: mArea.current !== null ? mArea.current.not : false
                onToggled: if(mArea.current !== null) mArea.current.not = checked
                ToolTip {
                    enabled: true
                    text: qsTr("Toggle output iversion")
                    delay: 500
                    visible: parent.hovered
                }
            }
            SpinBox {
                id: inPins

                enabled: mArea.current !== null && !mArea.dragging && mArea.current.type != GateLib.Not
                value: mArea.current !== null ? mArea.current.inputs : 0
                from: 1
                to: 8
                onValueModified: if(mArea.current !== null) mArea.current.inputs = value
                ToolTip {
                    enabled: true
                    text: qsTr("Number of inputs")
                    delay: 500
                    timeout: 1000
                    visible: parent.hovered
                }
            }

            ToolSeparator { }

            SpinBox {
                id: zoomView

                from: 100
                to: 300
                stepSize: 10
                value: ii.scaleF * 100
                textFromValue: (value,locale) => '' + value + '%'
                ToolTip {
                    enabled: true
                    text: qsTr("Zoom")
                    delay: 500
                    visible: parent.hovered
                }
                onValueModified: ii.scaleF = value/100.0
            }
        }
    }

    footer: Pane {
        RowLayout {
            Layout.fillWidth: true
            Label {
                id: status
                text: qsTr("Status:")
                font.pointSize: 12
            }
            Label {
                id: xpos
                text: '[' + ii.scX
                font.pointSize: 12
            }

            Label {
                id: sep
                text: ';'
                font.pointSize: 12
            }

            Label {
                id: ypos
                text: ii.scY + ']'
                font.pointSize: 12
            }
            Pane {
                Layout.fillWidth: true
            }
        }
    }


    Item {
        id: ii
        z: -1
        property var gates: []
        property real scaleF: 1.0
        property int scX: 0 // scale center x
        property int scY: 0 // scale center y

        anchors.fill: parent

//        width: scView.width * 4
//        height: scView.height * 4
//            x: -scView.width*2;
//            y: -scView.height*2
//            clip: true

        transform: Scale {
            xScale: ii.scaleF
            yScale: ii.scaleF
            origin {
                x: ii.scX
                y: ii.scY
            }
        }

        Rectangle {
            x: 0; y: 0
            anchors.fill: parent
            color: '#77007700'
            z: -1
            border.color: '#88000000'
            enabled: false
        }

        function findFromPoint(gp) {
            for(var i in ii.gates) {
                var c = ii.gates[i]
                var lp = c.mapFromGlobal(gp.x, gp.y)
                if( c.contains(lp) && c.objectName && c.objectName.startsWith("gate_")) {
                    return c
                }
            }

            return null
        }

        function contains(item, x, y) {
            var p = {x: x, y: y}
            return item.contains(p);
        }

        function checkOverlap(o) {
            var c;

            for( var i in gates ) {
                if(o === ii.gates[i])
                    continue;
                c = ii.gates[i];

                if(c.contains(Qt.point(o.x - c.x, o.y - c.y)))
                    return true;
                if(c.contains(Qt.point(o.x + o.width - c.x, o.y - c.y)))
                    return true;
                if(c.contains(Qt.point(o.x + o.width - c.x, o.y + o.height - c.y)))
                    return true;
                if(c.contains(Qt.point(o.x - c.x, o.y + o.height- c.y)))
                    return true;

                // not overlapped
            }
            return false;
        }

        MouseArea {
            id: mArea
            x: 0; y: 0
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
            hoverEnabled: true
            property bool dragging: false
            property var current: null
            property var dragObj: null
            property var op: null
            property bool moved: false
            property bool panning: false
            property var startP: Qt.point
            property var centerP: Qt.point

            onPressed: {
                if( mouse.button == Qt.LeftButton) {
                    moved = false
                    var g = ii.mapToGlobal(mouse.x, mouse.y)
                    var obj = ii.findFromPoint(g)
                    if(obj !== null) {
                        dragging = false
                        dragObj = obj
                        startP.x = obj.x
                        startP.y  = obj.y
                        op = obj.mapFromGlobal(g.x, g.y)
                    } else {
                        if(current) {
                            current.selected = false
                            current = null
                        }
                    }
                } else if(mouse.button == Qt.MiddleButton) {
                    startP = ii.mapToGlobal(mouse.x, mouse.y)
                    centerP.x = ii.scX
                    centerP.y = ii.scY
                    panning = true
                    console.log("Start pan @ " + startP + ', ' + centerP)
                }
            }

            onClicked: {
                if( mouse.button == Qt.LeftButton) {
                    if( dragObj && !moved ) {
                        if( !dragObj.selected) {
                            ii.gates.map(o => o.selected =false)
                            dragObj.selected = true
                            current = dragObj
                        } else {
                            dragObj.selected = false
                            current = null
                        }
                    }
                    moved = false
                    dragObj = null
                }
            }


            onReleased: {
                if( mouse.button == Qt.LeftButton) {
                    if(dragObj && ii.checkOverlap(dragObj)) {
                        dragObj.x = startP.x
                        dragObj.y = startP.y
                        dragObj.alert = false
                    }

                    dragging = false
                    op = null
                } else if(mouse.button == Qt.MiddleButton) {
                    panning = false
                }

            }

            onPositionChanged: {
                if(dragObj) {
                    dragging = true
                    moved = true
                    dragObj.x = mouse.x - op.x
                    dragObj.y = mouse.y - op.y
                    dragObj.alert = ii.checkOverlap(dragObj)
                } else if((mouse.buttons & Qt.MiddleButton) && panning) {
                    var p = ii.mapToGlobal(mouse.x, mouse.y)
                    p.x -= startP.x
                    p.y -= startP.y
                    ii.scX = centerP.x - p.x * ii.scaleF
                    ii.scY = centerP.y - p.y * ii.scaleF
                    console.log("Delta = " + p)
                }

            }

            onWheel: {
                if(wheel.angleDelta.y > 0 && ii.scaleF <= zoomView.to / 100.0) {
                    ii.scX = wheel.x
                    ii.scY = wheel.y
                    ii.scaleF += .05
                } else if(ii.scaleF>1){
                    ii.scX = wheel.x
                    ii.scY = wheel.y
                    ii.scaleF -= .05
                }
                console.log(ii.scale)
            }
        }
    }

    Component.onCompleted: {
        GL.preload();
    }
}
