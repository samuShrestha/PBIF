import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0

import io.qt.examples.backend 1.0

ApplicationWindow {
    property int windowScaleFactor: 2
    property int windowWidth

    // WINDOW INITIALIZATION
    id: root
    visible: true
    title: qsTr("Username Validation Software - v1.0")

    width: Screen.width / windowScaleFactor
    height: Screen.height / windowScaleFactor

    minimumWidth: 0
    minimumHeight: Screen.height * 0.35

    maximumWidth: Screen.width * 0.75
    maximumHeight: Screen.height * 0.75

    // C++ INTEGRATION
    BackEnd {
        id: backend
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
        z: 1

        onClicked: {
            console.log(root.width);
            if (state !== "rotated") root.windowWidth = root.width
            state == "rotated" ? state = "" : state = "rotated";
            if (state == "rotated") {
                minimizeWindow.running = true
                root.flags = Qt.FramelessWindowHint
            } else {
                maximizeWindow.running = true
                root.flags = Qt.Window;
            }

            stack.currentItem.visible = (state == "rotated") ? false : true
        }

        // Minimize Window Animation
        NumberAnimation {
            id: minimizeWindow
            target: root
            property: "width"
            to: (navMenu.btnSize + screenToggle.minimizedMargin + screenToggle.width)
            duration: 500
            easing.type: Easing.OutCubic
            running: false

        }

        // Maximize Window Animation
        NumberAnimation {
            id: maximizeWindow
            target: root
            property: "width"
            to: 1280
            duration: 500
            easing.type: Easing.OutCubic
            running: false

        }

        function minimizeWindow() {
            root.windowWidth = root.width
        }

        function maximizeWindow() {

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
        initialItem: profileView

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
    }

    // VIEWS
    Component {
        id: profileView

        Rectangle {
            objectName: "profileView"
            border.color: "red"

            Text {
                text: stack.currentItem.objectName
                font.pointSize: 30
                anchors.centerIn: parent
            }
        }

    }

    Component {
        id: settingsView

        Rectangle {
            objectName: "settingsView"
            border.color: "red"

            Text {
                text: stack.currentItem.objectName
                font.pointSize: 30
                anchors.centerIn: parent
            }
        }
    }
}
