import QtQml 2.15
import QtQuick 2.15
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

    function newGate(type, args) {
        var g;
        if(!args) {
            console.log("Default args")
            var p = cona.mapToItem(ii, cona.width/2, cona.height/2)
            console.log("map ", cona.width/2, cona.height/2, "=>", p)
            args = {type: type, x: p.x, y: p.y}
        }

        g = GL.createGate(ii, args)

        if(g !== null)
            ii.gates.push(g)
        return g;
    }

    Action {
        id: acFileOpen
        text: qsTr("&Open")
        shortcut: 'Ctrl+O'
        onTriggered: {
            console.log("OpenFile")
            var gg = iolib.loadFile();
            for(var i in gg) {
                newGate(gg[i].type, gg[i])
            }
        }
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
            iolib.writeFile(ii.gates.map( x => x.gate ))
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
                enabled: ii.current != null && !mArea.dragging
                checked: ii.current != null  ? ii.current.inv : false
                onToggled: {
                    if(ii.current != null)
                        ii.current.inv = checked
                    checked = ii.current.inv
                }
                ToolTip {
                    enabled: true
                    text: qsTr("Toggle output iversion")
                    delay: 500
                    visible: parent.hovered
                }
            }

            SpinBox {
                id: inPins

                enabled: ii.current != null && !mArea.dragging && ii.current.type !== GateType.Not
                value:  ii.current != null ? ii.current.inputs : 0
                from: 1
                to: 8
                onValueModified: {
                    if(ii.getSelected() !== null)
                        ii.getSelected().inputs = value
                    value = ii.getSelected().inputs
                }
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
        id: sP
        property int fontSize: 10
//        implicitHeight: ypos.height
        padding: 2
        anchors.margins: 4

        RowLayout {
            Layout.fillWidth: true
//            implicitHeight: ypos.height

            Label {
                id: status
                text: qsTr("Status:")
                font.pointSize: sP.fontSize
            }
            Label {
                id: xpos
                text: sP.padding
                font.pointSize: sP.fontSize
            }

            Label {
                id: sep
                text: ';'
                font.pointSize: sP.fontSize
            }

            Label {
                id: ypos
                text: filler.padding
                font.pointSize: sP.fontSize
            }
            Pane {
                id: filler
                padding: 2
                Layout.fillWidth: true
//                implicitHeight: ypos.height
            }
        }
    }


    Item {
        id: cona
        anchors.fill: parent

        Item {
            id: ii
            z: -1
            property var gates: []
            property var selection: []
            property real scaleF: 1.0
            property int scX: 0 // scale center x
            property int scY: 0 // scale center y
            property var current: null

    //        anchors.fill: parent
            anchors.centerIn: parent

            width: Screen.width
            height: Screen.height
            clip: true

            transform: Scale {
                xScale: ii.scaleF
                yScale: ii.scaleF
                origin {
                    x: ii.scX
                    y: ii.scY
                }
            }

//            signal selectionChanged();

            onWidthChanged: updateLimits()
            onHeightChanged: updateLimits()

            Rectangle {
                x: 0; y: 0
                anchors.fill: parent
                color: '#77007700'
                z: -1
                border {
                    color: '#88000000'
                    width: 4
                }
                enabled: false
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

            // Update transformOrigin (scale center) point for ii
            function updateLimits() {
                ii.scX = Math.min(Math.max(ii.scX, 0), ii.width)
                ii.scY = Math.min(Math.max(ii.scY, 0), ii.height)
            }

            function numSelection() { return selection.length }

            // return only 1st selection

            function getSelected() {
                if( selection.length == 1 ) {
                    console.log("Get sel=", selection[0].objectName)
                    return selection[0]
                }
                return null
            }

            function updateCurrent() {
                if( selection.length == 1 )
                    current = selection[0]
                else if( selection.length == 0 )
                    current = null
            }

            function addSelection(obj) {
                if( selection.indexOf(obj) == -1) {
                    selection.push(obj)
                    obj.selected = true
                    console.log("Add sel", obj.objectName)
                }
                updateCurrent()
            }

            function delSelection(obj) {
                var i = selection.indexOf(obj)

                if( i != -1 ) {
                    obj.selected = false
                    selection.splice(i,1)
                    console.log("Del sel", obj.objectName)
                    updateCurrent()
                }
            }

            function clearSelection() {
                selection.map( x => x.selected = false)
                selection = []
                console.log("Clr sel")
                updateCurrent()
            }

            MouseArea {
                id: mArea
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                anchors.fill: parent
                hoverEnabled: true

                property bool dragging: false
//                property var current: null
                property var dragObj: null
                property point op: Qt.point(0,0)
                property bool moved: false
                property bool panning: false
                property point startP: Qt.point(0,0)
                property point centerP: Qt.point(0,0)

                onPressed: {
                    if( mouse.button == Qt.LeftButton) {
                        moved = false
                        var obj = ii.childAt(mouse.x, mouse.y)
                        if(obj !== null && obj.objectName.startsWith("gate_")) {
                            dragging = false
                            dragObj = obj
                            startP.x = obj.x
                            startP.y  = obj.y
                            op = ii.mapToItem(obj, mouse.x, mouse.y)
                        } else {
                            // clear selection
                            ii.clearSelection()
                        }
                    } else if(mouse.button == Qt.MiddleButton) {
                        startP = ii.mapToGlobal(mouse.x, mouse.y)
                        centerP.x = ii.scX
                        centerP.y = ii.scY
                        panning = true
                    }
                }

                onClicked: {
                    if( mouse.button == Qt.LeftButton) {
                        if( dragObj && !moved ) {
                            if( ! dragObj.selected ) {
                                ii.clearSelection()
                                ii.addSelection(dragObj)
                            } else {
                                ii.delSelection(dragObj)
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
                    } else if(mouse.button == Qt.MiddleButton) {
                        panning = false
                    }

                }

                onPositionChanged: {
                    if(dragObj) {
                        dragging = true
                        moved = true
                        dragObj.x = Math.round(mouse.x - op.x)
                        dragObj.y = Math.round(mouse.y - op.y)
                        dragObj.alert = ii.checkOverlap(dragObj)
                    } else if((mouse.buttons & Qt.MiddleButton) && panning) {
                        var p = ii.mapToGlobal(mouse.x, mouse.y)
                        p.x -= startP.x
                        p.y -= startP.y
                        ii.scX = Math.min(Math.max(centerP.x - p.x * ii.scaleF, 0), ii.width)
                        ii.scY = Math.min(Math.max(centerP.y - p.y * ii.scaleF, 0), ii.height)
                        xpos.text = ii.scX
                        ypos.text = ii.scY
                    }

                }

                onWheel: {
                    if(wheel.angleDelta.y > 0 && ii.scaleF <= zoomView.to / 100.0) {
                        ii.scX = wheel.x
                        ii.scY = wheel.y
                        ii.scaleF += .05
                    } else if(ii.scaleF > zoomView.from / 100.0){
                        ii.scX = wheel.x
                        ii.scY = wheel.y
                        ii.scaleF -= .05
                    }
                }
            }
        }
    }
    Component.onCompleted: {
        GL.preload();
    }
}
