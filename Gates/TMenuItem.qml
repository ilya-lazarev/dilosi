import QtQuick 2.0
import QtQuick.Controls 2.15

MenuItem {
    id: mi

    property alias fSize: mi.font.pointSize
    font.pointSize: menuBar.fontSize
    icon.color: action.icon.color
}
