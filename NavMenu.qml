import QtQuick 2.0

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

            }
        }

        states: State {
            name: "hover"; when: navProfileBtn.containsMouse
            PropertyChanges { target: navProfile; color: "#CCC" }
        }

        transitions: [
                Transition {
                    to: "hover"
                    ColorAnimation { easing.type: Easing.OutCubic; duration: 500 }
                },
                Transition {
                    to: ""
                    ColorAnimation { easing.type: Easing.OutCubic; duration: 500 }
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
        state: "start"

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
                    ColorAnimation { easing.type: Easing.OutCubic; duration: 500 }
                },
                Transition {
                    to: ""
                    ColorAnimation { easing.type: Easing.OutCubic; duration: 500 }
                }
        ]

    }

}
