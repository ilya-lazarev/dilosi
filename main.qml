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

        g = GL.createGate(type, ii, {x: 10, y: 25})
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
        onTriggered: newGate(GateType.And)
        shortcut: 'Ctrl+1'
        icon {
            source: 'qrc:/img/24x24/andGate.png'
            color: 'transparent'
        }
    }
    Action {
        id: acAddOrGate
        text: qsTr("Add (N)OR gate")
        onTriggered: newGate(GateType.Or)
        shortcut: 'Ctrl+2'
        icon {
            source: 'qrc:/img/24x24/orGate.png'
            color: 'transparent'
        }
    }
    Action {
        id: acAddXorGate
        text: qsTr("Add (N)XOR gate")
        onTriggered: newGate(GateType.Xor)
        shortcut: 'Ctrl+3'
        icon {
            source: 'qrc:/img/24x24/xorGate.png'
            color: 'transparent'
        }
    }

    Action {
        id: acAddNotGate
        text: qsTr("Add NOT/REPEATER gate")
        onTriggered: newGate(GateType.Not)
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
        RowLayout {
            ToolButton {
                action: acFileOpen
                display: AbstractButton.IconOnly
                icon.color: "transparent"
            }
            ToolButton {
                action: acFileSave
                display: AbstractButton.IconOnly
                icon.color: "transparent"
            }
            ToolButton {
                action: acAppExit
                display: AbstractButton.IconOnly
                icon.color: "transparent"
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
            }
            SpinBox {
                id: inPins

                enabled: mArea.current !== null && !mArea.dragging
                value: mArea.current !== null ? mArea.current.inputs : 0
                from: 1
                to: 8
                onValueModified: if(mArea.current !== null) mArea.current.inputs = value
            }
        }
    }

    Item {
        id: ii
        property var gates: []
        anchors.fill: parent
        x: 0; y: 0
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
            property var startP: Qt.point

            onPressed: {
                console.log("Press")
                moved = false
                var g = ii.mapToGlobal(mouse.x, mouse.y)
                var obj = ii.findFromPoint(g)
                if(obj !== null) {
                    dragging = false
                    dragObj = obj
                    startP.x = obj.x
                    startP.y  = obj.y
                    op = obj.mapFromGlobal(g.x, g.y)
                }
            }

            onClicked: {
                console.log("Clik")
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


            onReleased: {
                console.log("Rls")
                if(dragObj && ii.checkOverlap(dragObj)) {
                    dragObj.x = startP.x
                    dragObj.y = startP.y
                    dragObj.alert = false
                }

                dragging = false
                op = null
            }

            onPositionChanged: {
                if(dragObj) {
                    dragging = true
                    moved = true
                    dragObj.x = mouse.x - op.x
                    dragObj.y = mouse.y - op.y
                    dragObj.alert = ii.checkOverlap(dragObj)

                }
            }

            onWheel: {

            }
        }



/*            GAnd {
            id: andGate
        }
        GOr {
            id: orGate
        }
        GXor {
            id: xorGate
        }
    }
*/
        Component.onCompleted: {
            GL.preload();
        }
    }
}
