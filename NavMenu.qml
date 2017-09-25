import QtQuick 2.0
import QtQuick.Window 2.2

Rectangle {
    id: navMenu
    property int btnSize: (parent.height < 625) ? parent.height / 7 : parent.height / 9

    width: btnSize
    height: parent.height
    color: "#E6E6E6"


    // Top Profile Button
    MenuItem {
        id: navProfile
        navIcon: "qrc:/img/icons/profile.svg"
        navIconColor: "#000"

        MouseArea {
            id: navProfileBtn
            anchors.fill: parent
            hoverEnabled: true

            onClicked: {
                profileLogin.show();
                //if (stack.currentItem.objectName !== "profileView") stack.replace(profileViewComponent, {"objectName": "profileView"});
            }
        }

        states: [
            State {
                name: "hover"; when: navProfileBtn.containsMouse
                PropertyChanges { target: navProfile; color: "#CCC" }
            }, State {
                name: "clicked"; when: stack.currentItem.objectName === "profileView"
                PropertyChanges { target: navProfile; color: "#CCC" }
            }
        ]

        transitions: [
                Transition {
                    to: "hover"
                    ColorAnimation { easing.type: Easing.OutCubic; duration: 350 }
                },
                Transition {
                    to: ""
                    ColorAnimation { easing.type: Easing.InCubic; duration: 250 }
                }
        ]

    }

    // Bottom Buttons - Bottom Up

    // Start/Stop Button
    MenuItem {
        property bool toggle: false

        id: navToggle
        navIcon: toggle ? "qrc:/img/icons/pause.svg" : "qrc:/img/icons/play.svg"
        navIconColor: "#fff"

        // Overrides
        color: toggle ? "#E81123" : "#16C60C"
        anchors.bottom: parent.bottom

        MouseArea {
            id: navToggleBtn
            anchors.fill: parent
            hoverEnabled: true

            onClicked: {
                parent.toggle = !parent.toggle
            }
        }

        states: [
            State {
                name: "hover"; when: navToggleBtn.containsMouse
                PropertyChanges { target: navToggle; color: toggle ? "#C50F1F" : "#13A10E" }
            }
        ]

        transitions: [
                Transition {
                    to: "hover"
                    ColorAnimation { easing.type: Easing.OutCubic; duration: 350 }
                },
                Transition {
                    to: ""
                    ColorAnimation { easing.type: Easing.InCubic; duration: 250 }
                }
        ]

    }

    // Minimize Button
    MenuItem {
        id: navMinimize
        navIcon: "qrc:/img/icons/minimize.svg"
        navIconColor: "#000"

        // Overrides
        anchors.bottom: navToggle.top

        MouseArea {
            id: navMinimizeBtn
            anchors.fill: parent
            hoverEnabled: true

            onClicked: {
                root.showMinimized()
            }
        }

        states: State {
            name: "hover"; when: navMinimizeBtn.containsMouse
            PropertyChanges { target: navMinimize; color: "#CCC" }
        }

        transitions: [
                Transition {
                    to: "hover"
                    ColorAnimation { easing.type: Easing.OutCubic; duration: 350 }
                },
                Transition {
                    to: ""
                    ColorAnimation { easing.type: Easing.InCubic; duration: 250 }
                }
        ]

    }

    // Settings Button
//    MenuItem {
//        id: navSettings
//        navIcon: "qrc:/img/icons/settings.svg"
//        navIconColor: "#000"

//        // Overrides
//        anchors.bottom: navMinimize.top

//        MouseArea {
//            id: navSettingsBtn
//            anchors.fill: parent
//            hoverEnabled: true

//            onClicked: {
//                if (stack.currentItem.objectName !== "settingsView") stack.replace(settingsViewComponent, {"objectName": "settingsView"});
//            }
//        }

//        states: [
//            State {
//                name: "hover"; when: navSettingsBtn.containsMouse
//                PropertyChanges { target: navSettings; color: "#CCC" }
//            }, State {
//                name: "clicked"; when: stack.currentItem.objectName === "settingsView"
//                PropertyChanges { target: navSettings; color: "#CCC" }
//            }
//        ]

//        transitions: [
//                Transition {
//                    to: "hover"
//                    ColorAnimation { easing.type: Easing.OutCubic; duration: 350 }
//                },
//                Transition {
//                    to: ""
//                    ColorAnimation { easing.type: Easing.InCubic; duration: 250 }
//                }
//        ]

//    }

    // Draggable Area
    MouseArea {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: navProfile.bottom
        anchors.bottom: navMinimize.top
        property variant clickPos: "1,1"

        onPressed: {
            clickPos = Qt.point(mouse.x,mouse.y)
            console.log(clickPos)
        }

        onPositionChanged: {
            var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y)
            var new_x = root.x + delta.x
            var new_y = root.y + delta.y
            if (new_y <= 0)
                root.visibility = Window.Maximized
            else
            {
                if (root.visibility === Window.Maximized)
                    root.visibility = Window.Windowed
                root.x = new_x
                root.y = new_y
            }
        }
    }

}
