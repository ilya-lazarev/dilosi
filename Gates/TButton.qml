import QtQuick.Controls 2.15

ToolButton {
    property string tooltip
    display: AbstractButton.IconOnly
    icon.color: "transparent"
    hoverEnabled: true

    ToolTip {
        text: parent.tooltip
        delay: 500
        visible: parent.hovered
    }
}
