import QtQuick 2.0

Column {
    default property alias item: ld.sourceComponent
    property string title: "title"
    Rectangle {
        width: settingsAccordion.width
        height: 50
        color: info.show ? "#CCCCCC" : "#E6E6E6"
        MouseArea {
            anchors.fill: parent
            onClicked: info.show = !info.show
        }
        Text{
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 15

            text: title
        }
    }
    Rectangle {
        id: info
        width: settingsAccordion.width
        height: show ? ld.height + 40 : 0
        property bool show : false
        clip: true
        Loader {
            id: ld
            y: info.height - height
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 20
            //anchors.topMargin: 20
            //anchors.bottomMargin: 20
        }
        Behavior on height {
            NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
        }
    }
}
