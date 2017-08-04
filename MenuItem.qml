import QtQuick 2.0
import QtGraphicalEffects 1.0

Rectangle {
    property alias navIcon: navIcon.source
    property alias navIconColor: iconColor.color

    id: button

    color: "#E6E6E6"
    width: parent.width
    height: parent.width

    Image {
        id: navIcon

        anchors.top: parent.top
        anchors.topMargin: (navMenu.btnSize / 2) - (height / 2)
        anchors.horizontalCenter: parent.horizontalCenter

        sourceSize.width: navMenu.btnSize / 2; sourceSize.height: navMenu.btnSize / 2
        fillMode: Image.PreserveAspectFit
    }

    // Icon Color
    ColorOverlay {
        id: iconColor

        anchors.fill: navIcon
        source: navIcon
        color: "#ffffff"
    }
}
