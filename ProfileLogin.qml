import QtQuick 2.0
import QtQuick.Window 2.2

Window {
    id: profileLogin
    objectName: "profileLogin"

    x: Screen.width / 2 - (width/2)
    y: Screen.height / 2 - (height/2)
    width: Screen.width / 5
    height: Screen.height / 3

    maximumWidth: 768
    maximumHeight: 720

    minimumWidth: 256
    minimumHeight: 240

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 25

        text: "Sign In"
        font.pointSize: 24
    }
}
