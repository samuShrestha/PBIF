import QtQuick 2.0
import QtQuick.Controls 2.0

Rectangle {
    property alias navIcon: navIcon.source
    property alias navLabel: navLabel.text
    property alias labelOpacity: navLabel.opacity

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

    Label {
        id: navLabel

        opacity: 0
        font.pointSize: (root.height < 425) ? 12 : 15
        transform: Rotation { origin.x: navLabel.contentWidth / 2; origin.y: navLabel.contentHeight / 2; angle: 90 }

        anchors.top: navIcon.bottom
        anchors.topMargin: (root.height < 425) ? 27 : 35
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
