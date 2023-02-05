import QtQuick.Controls 2.15
import QtQuick 2.15

ToolButton {
    id: tb
    property string tooltip
    display: AbstractButton.IconOnly
    icon.color: "transparent"
    hoverEnabled: true

    ToolTip {
        text: parent.tooltip
        delay: 500
        visible: parent.hovered
    }

    background: Rectangle {
        color: tb.hovered ? '#471199ff' : '#00000000'
        anchors.fill: parent
        radius: 4
    }
}
