import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2
import io.qt.examples.backend 1.0

ApplicationWindow {
    property int windowScaleFactor: 2

    id: root
    visible: true
    title: qsTr("Username Validation Software - v1.0")

    width: Screen.width / windowScaleFactor
    height: Screen.height / windowScaleFactor

    minimumWidth: 1280 / windowScaleFactor
    minimumHeight: 720 / windowScaleFactor

    maximumWidth: 2560 / windowScaleFactor
    maximumHeight: 1440 / windowScaleFactor

    BackEnd {
        id: backend
    }

//    TextField {
//        text: backend.userName
//        placeholderText: qsTr("User name")
//        anchors.centerIn: parent
//        width: parent.width / 3

//        onTextChanged: backend.userName = text
//    }

//    Label {
//        anchors.horizontalCenter: parent.horizontalCenter
//        anchors.top: parent.top
//        anchors.topMargin: 20

//        text: "Username: " + backend.userName
//        color: mouseArea.containsMouse ? "midnightblue" : "steelblue"
//        font.pointSize: 20

//        scale:  mouseArea.containsMouse ? 1.5 : 1.0
//        smooth: mouseArea.containsMouse

//        MouseArea {
//            id: mouseArea
//            anchors.fill: parent
//            hoverEnabled: true
//        }
//    }

    NavMenu {
        anchors.right: parent.right
        anchors.top: parent.top
    }

//    Rectangle {
//        property int btnHeight: btnMenu.height / 4
//        id: btnMenu
//        anchors.right: parent.right
//        anchors.top: parent.top
//        width: btnHeight
//        height: parent.height

//        Rectangle {
//            id: redBtn
//            color: "red"
//            width: parent.width
//            height: btnMenu.btnHeight
//            z: 2

//            MouseArea {
//                id: redBtnArea
//                anchors.fill: parent
//                hoverEnabled: true
//            }

//            states: State {
//                name: "hover"; when: redBtnArea.containsMouse
//                PropertyChanges { target: redBtn; height: btnMenu.btnHeight*2 }
//            }

//            transitions: Transition {
//                NumberAnimation { properties: "height"; easing.type: Easing.OutCubic; duration: 500 }
//            }
//        }
//    }
}
