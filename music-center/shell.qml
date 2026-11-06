import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    visible: true
    implicitWidth: 520
    implicitHeight: 560

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: "#99000000"

        MouseArea {
            anchors.fill: parent
            onClicked: root.visible = false
        }
    }

    Rectangle {
        id: panel

        width: 480
        height: 520
        anchors.centerIn: parent

        radius: 24
        color: "#171521"
        border.color: "#393348"
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 28
            spacing: 18

            RowLayout {
                Layout.fillWidth: true

                ColumnLayout {
                    spacing: 3

                    Text {
                        text: "MUSIC CENTER"
                        color: "#ffffff"
                        font.pixelSize: 22
                        font.bold: true
                    }

                    Text {
                        text: "Your music, your atmosphere."
                        color: "#aaa4bb"
                        font.pixelSize: 12
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                Rectangle {
                    width: 12
                    height: 12
                    radius: 6
                    color: "#b58cff"
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "#393348"
            }

            Text {
                text: "CHOOSE YOUR EXPERIENCE"
                color: "#aaa4bb"
                font.pixelSize: 11
                font.bold: true
            }

            // Mode 1
            ModeCard {
                title: "Lyrics only"
                subtitle: "Spotify + synchronized lyrics"
                symbol: "♫"
                selected: modeSelector.selectedMode === 0
                onClicked: modeSelector.selectedMode = 0
            }

            // Mode 2
            ModeCard {
                title: "Lyrics + Visualizer"
                subtitle: "Lyrics with reactive audio visuals"
                symbol: "✦"
                selected: modeSelector.selectedMode === 1
                onClicked: modeSelector.selectedMode = 1
            }

            // Mode 3
            ModeCard {
                title: "Audio only"
                subtitle: "Just Spotify. No overlays."
                symbol: "♪"
                selected: modeSelector.selectedMode === 2
                onClicked: modeSelector.selectedMode = 2
            }

            Item {
                Layout.fillHeight: true
            }

            Rectangle {
                Layout.fillWidth: true
                height: 48
                radius: 14
                color: "#b58cff"

                Text {
                    anchors.centerIn: parent
                    text: "START MUSIC"
                    color: "#171521"
                    font.bold: true
                    font.pixelSize: 13
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        const modes = ["lyrics", "visualizer", "audio"]
                        Quickshell.execDetached([
                            "/bin/sh", "-c",
                            'exec "$HOME/.local/bin/music-center" ' + modes[modeSelector.selectedMode]
                        ])
                        root.visible = false
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 42
                radius: 12
                color: "#302b3b"
                border.color: "#51465f"

                Text {
                    anchors.centerIn: parent
                    text: "STOP OVERLAYS"
                    color: "#e5dcef"
                    font.bold: true
                    font.pixelSize: 12
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        Quickshell.execDetached([
                            "/bin/sh", "-c",
                            'exec "$HOME/.local/bin/music-center" stop'
                        ])
                    }
                }
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "Spotify Music Center"
                color: "#777184"
                font.pixelSize: 10
            }
        }
    }

    QtObject {
        id: modeSelector
        property int selectedMode: 1
    }

    component ModeCard: Rectangle {
        id: card

        property string title
        property string subtitle
        property string symbol
        property bool selected: false

        signal clicked()

        Layout.fillWidth: true
        height: 76
        radius: 15

        color: selected ? "#302642" : "#211e2b"
        border.width: selected ? 2 : 1
        border.color: selected ? "#b58cff" : "#393348"

        RowLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 14

            Rectangle {
                width: 42
                height: 42
                radius: 12
                color: selected ? "#b58cff" : "#393348"

                Text {
                    anchors.centerIn: parent
                    text: card.symbol
                    color: selected ? "#171521" : "#d5c8ed"
                    font.pixelSize: 22
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                Text {
                    text: card.title
                    color: "#ffffff"
                    font.pixelSize: 14
                    font.bold: true
                }

                Text {
                    text: card.subtitle
                    color: "#aaa4bb"
                    font.pixelSize: 11
                }
            }

            Text {
                visible: selected
                text: "✓"
                color: "#c7a7ff"
                font.pixelSize: 20
                font.bold: true
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: card.clicked()
        }
    }
}




