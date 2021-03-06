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
        root.width = Screen.width / windowScaleFactor
        root.height = Screen.height / windowScaleFactor

        root.minimumWidth = 0;
        root.minimumHeight = Screen.height * 0.35;

        root.maximumWidth = Screen.width * 0.5;
        root.maximumHeight = Screen.height * 0.5;

        root.x = Screen.width / 2 - (root.width/2)
        root.y = Screen.height / 2 - (root.height/2)
    }

    Behavior on width {
        NumberAnimation {
            duration: 500
            easing.type: Easing.OutCubic
        }
    }

    ProfileLogin {
        id: profileLogin
        objectName: "profileLogin"
        visibility: "Hidden"
    }

    // NAVIGATION MENU
    NavMenu {
        id: navMenu
        anchors.right: parent.right
        anchors.top: parent.top
        z: 1
    }

    // APPLICATION TOGGLE BUTTON
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
                settingsView.visible = false
                root.width = navMenu.btnSize
            } else {
                root.flags = Qt.Window;
                settingsView.visible = true
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

    // MAIN APPLICATION WINDOW
    RowLayout {
        id: settingsView
        objectName: "settingsView"

        // ANCHORS / SPACING
        anchors.left: screenToggle.right
        anchors.top: parent.top
        anchors.right: navMenu.left
        anchors.bottom: parent.bottom
        height: parent.height
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

                        // LOADING MESSAGE
                        Text {
                            id: webcamLoadingMessage
                            objectName: "webcamLoadingMessage"
                            anchors.centerIn: parent
                            text: "Your webcam is currently loading..."
                        }

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

                Column {
                    anchors.bottom: root.bottom
                    width: parent.width

                    Text {
                        id: outputPose
                        objectName: "outputPose"
                        text: "Pose Estimation: ~~~~"
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
}
