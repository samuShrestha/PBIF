import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

import io.qt.webcam 1.0

RowLayout {
    id: settingsView
    objectName: "settingsView"
    spacing: 0

    // ==================== WEBCAM VIEW ====================
    Rectangle{
        Layout.fillHeight: true
        Layout.preferredWidth: (settingsView.width / 8)*3

        Column {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15

            // VIEW TOGGLE
            MouseArea{
                id: showWebcamTextMouseArea
                height: showWebcamText.contentHeight
                width: parent.width
                hoverEnabled: true

                Text{
                    id: showWebcamText
                    text: webcamView.show ? "Show Webcam ▲" : "Show Webcam ▼"

                    renderType: Text.NativeRendering

                    font.pointSize: 10
                    //font.underline: parent.containsMouse
                }

                onClicked: {
                    state = ""
                    webcamView.show = !webcamView.show
                }

                // Handle Hover Transition Effects
                states: [
                    State {
                        name: "hover"; when: showWebcamTextMouseArea.containsMouse
                        PropertyChanges { target: showWebcamText; color: "#767676" }
                    }
                ]

                transitions: [
                        Transition {
                            to: "hover"
                            ColorAnimation { easing.type: Easing.OutCubic; duration: 250 }
                        },
                        Transition {
                            to: ""
                            ColorAnimation { easing.type: Easing.InCubic; duration: 150 }
                        }
                ]
            }

            // WEBCAM VIEW
            Rectangle{
                id: webcamView
                property bool show: true

                width: parent.width
                height: show ? webcam.height + toggleBtns.height + 15 : 0
                clip: true

                Behavior on height {
                  NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
                }

                // WEBCAM
                Rectangle {
                    id: webcam
                    objectName: "webcamView"

                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    height: (3*width)/4

                    border.color: "black"
                    border.width: 1

                    WebCam{
                        id: webCamSource
                        objectName: "webCam"
                        anchors.fill: parent
                    }
                }

                // MARKER TOGGLE BUTTONS
                Row{
                    id: toggleBtns
                    anchors.top: webcam.bottom
                    anchors.topMargin: 15
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 15

                    Button{
                        id: togglePoseTracker
                        objectName: "togglePoseTracker"
                        checkable: true

                        text: "Pose Estimation"

                        //onClicked: checked ? pbif.displayPose() : pbif.hidePose()
                    }
                    Button{
                        id: toggleEyeTracker
                        objectName: "toggleEyeTracker"
                        checkable: true

                        text: "Eye Markers"

                        //onClicked: checked ? pbif.displayEyeMarkers() : pbif.hideEyeMarkers()
                    }
                }
            }


        }
    }

    // ==================== SETTINGS LIST ====================
    GroupBox{
        Layout.fillHeight: true
        Layout.preferredWidth: ((settingsView.width / 8)*5) - navMenu.btnSize
        Layout.margins: 20
        Layout.leftMargin: 0
        clip: true

        label: Text {
            text: "Settings"
            font.pointSize: 10
            renderType: Text.NativeRendering
        }

        // ACCORDION
        Column {
            id: settingsAccordion
            anchors.fill: parent
            spacing: 5
            AccItem {
                title: "Settings Menu 1"
                Column{
                    Row{
                        Text{
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Setting: "
                        }
                        Slider{
                            value: 0.5
                        }
                    }
                    Row{
                        Text{
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Setting: "
                        }
                        Slider{
                            value: 0.5
                        }
                    }
                    Row{
                        Text{
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Setting: "
                        }
                        Slider{
                            value: 0.5
                        }
                    }
                }
            }
            AccItem {
                title: "Settings Menu 2"
                Rectangle {
                    anchors.margins: 100
                    width: 100
                    height: 100
                    radius: 50
                    color: "yellow"
                    anchors.centerIn: parent
                }
            }
            AccItem {
                title: "Settings Menu 3"
                Rectangle {
                    width: 75
                    height: 75
                    radius: 50
                    color: "cyan"
                    anchors.centerIn: parent
                }
            }
        }
    }
}
