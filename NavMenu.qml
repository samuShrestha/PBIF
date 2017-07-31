import QtQuick 2.0

Rectangle {
    id: navMenu
    property int btnSize: (parent.height < 625) ? parent.height / 7 : parent.height / 9

    width: btnSize
    height: parent.height
    color: "#E6E6E6"

    MenuItem {
        id: navProfile
        navIcon: "qrc:/img/icons/profile.svg"
        navLabel: "Profile"
        z: 2

        MouseArea {
            id: navProfileBtn
            anchors.fill: parent
            hoverEnabled: true
        }

        states: State {
            name: "hover"; when: navProfileBtn.containsMouse
            PropertyChanges { target: navProfile; color: "#CCCCCC"; labelOpacity: 1; height: (root.height < 625) ? btnSize*2.5 : btnSize*3 }
        }

        transitions: [
                Transition {
                    to: "hover"
                    NumberAnimation { properties: "height"; easing.type: Easing.OutCubic; duration: 500 }
                    NumberAnimation { properties: "labelOpacity"; easing.type: Easing.OutCubic; duration: 1100 }
                    ColorAnimation { easing.type: Easing.OutCubic; duration: 500 }
                },
                Transition {
                    to: ""
                    NumberAnimation { properties: "height"; easing.type: Easing.InCubic; duration: 500 }
                    NumberAnimation { properties: "labelOpacity"; easing.type: Easing.OutCubic; duration: 500 }
                    ColorAnimation { easing.type: Easing.InCubic; duration: 500 }
                }
        ]

    }

}
