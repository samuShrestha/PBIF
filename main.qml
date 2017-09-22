import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0

import io.qt.webcam 1.0

ApplicationWindow {
    property int windowScaleFactor: 2
    property int windowWidth

    // WINDOW INITIALIZATION
    id: root
    objectName: "root"
    visible: true
    title: qsTr("Username Validation Software - v1.0")

    onClosing: {
        pbif.exit()
    }

    Component.onCompleted: {
        width = Screen.width / windowScaleFactor
        height = Screen.height / windowScaleFactor

        root.minimumWidth = 0;
        root.minimumHeight = Screen.height * 0.35;

        root.maximumWidth = Screen.width * 0.5;
        root.maximumHeight = Screen.height * 0.5;
    }

    Behavior on width {
        NumberAnimation {
            duration: 500
            easing.type: Easing.OutCubic
        }
    }

    // NAVIGATION MENU
    NavMenu {
        id: navMenu
        anchors.right: parent.right
        anchors.top: parent.top
        z: 1
    }

    // MAIN APPLICATION STACK TOGGLE BUTTON
    MouseArea {
        property bool toggle: false
        property int minimizedMargin: (root.height < 540) ? 20 : 40

        id: screenToggle

        width: (root.height < 540) ? 25 : 30; height: (root.height < 540) ? 25 : 30

        anchors.left: parent.left
        anchors.leftMargin: (root.height < 540) ? 15 : 20
        anchors.verticalCenter: parent.verticalCenter
        z: 2

        onClicked: {
            state == "rotated" ? state = "" : state = "rotated";
            if (state != "rotated") windowWidth = root.width

            if (state == "rotated") {
                root.flags = Qt.FramelessWindowHint
                stack.currentItem.visible = false
                root.width = navMenu.btnSize
            } else {
                root.flags = Qt.Window;
                stack.currentItem.visible = true
                root.width = 1280
            }
        }

        // Set Icon + Icon Color
        Image {
            id: arrow
            source: "qrc:/img/icons/right-arrow.svg"
            fillMode: Image.PreserveAspectFit
            sourceSize.width: parent.width; sourceSize.height: parent.height

            anchors.centerIn: parent
        }

        ColorOverlay {
            anchors.fill: arrow
            source: arrow
            color: "#CCC"
        }

        states: State {
            name: "rotated"
            PropertyChanges { target: screenToggle; rotation: 180 }
        }

        transitions: [
            Transition {
                to: "rotated"
                RotationAnimation { duration: 500; easing.type: Easing.OutCubic; direction: RotationAnimation.Clockwise }
            },
            Transition {
                to: ""
                RotationAnimation { duration: 500; easing.type: Easing.OutCubic; direction: RotationAnimation.Counterclockwise }
            }
        ]
    }


    // MAIN APPLICATION STACKVIEW
    StackView {
        id: stack
        objectName: "stackView"
        initialItem: settingsViewComponent

        // ANCHORS
        anchors.left: screenToggle.right
        anchors.top: parent.top
        anchors.right: navMenu.left
        anchors.bottom: parent.bottom

        // TRANSITIONS
        replaceEnter: Transition {
            PropertyAnimation {
                property: "x"
                from: width * 2
                to: 0
                duration: 350
                easing: Easing.OutQuint
            }
        }
        replaceExit: Transition {
            PropertyAnimation {
                property: "x"
                from: 0
                to: 0 - width
                duration: 350
                easing: Easing.InQuint
            }
        }

        //Component.onCompleted: console.log(stack.currentItem.objectName);
    }

    // VIEWS

    Component{
        id:profileViewComponent
        ProfileView{}
    }

    Component{
        id:settingsViewComponent
        SettingsView{}
    }
}
