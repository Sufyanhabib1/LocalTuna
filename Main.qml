import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    visible: true
    width: 1200
    height: 750
    title: "Local Tuna"
    color: "#0F0F0F"

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // 🔴 TOP BAR
        Rectangle {
            Layout.fillWidth: true
            height: 64
            color: "#181818"

            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 10

                Image {
                    source: "qrc:/ui/localtunalogo.png"
                    width: 32
                    height: 32
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    text: "Local Tuna"
                    font.pixelSize: 24
                    font.bold: true
                    color: "#E50914"
                }

                Item { Layout.fillWidth: true }

                TextField {
                    width: 380
                    height: 42
                    placeholderText: "Search songs, artists, genres"
                    color: "white"
                    font.pixelSize: 14

                    background: Rectangle {
                        radius: 21
                        color: "#2A2A2A"
                    }
                }
            }
        }

        // 🧱 MAIN AREA
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            // 📁 SIDEBAR
            Rectangle {
                width: 240
                color: "#121212"

                Column {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 20
                    spacing: 16

                    Text {
                        text: "Library"
                        color: "white"
                        font.pixelSize: 18
                        font.bold: true
                    }

                    Button {
                        text: "All Songs"
                        width: parent.width
                    }

                    Button {
                        text: "By Artist"
                        width: parent.width
                    }

                    Button {
                        text: "By Genre"
                        width: parent.width
                    }
                }
            }

            // 🎶 CONTENT AREA
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#0F0F0F"

                Column {
                    anchors.fill: parent
                    anchors.margins: 25
                    spacing: 12

                    Text {
                        text: "All Songs"
                        font.pixelSize: 22
                        font.bold: true
                        color: "white"
                    }

                    // HEADER
                    Row {
                        spacing: 40
                        Text { text: "TITLE"; color: "#A7A7A7"; width: 220 }
                        Text { text: "ARTIST"; color: "#A7A7A7"; width: 180 }
                        Text { text: "GENRE"; color: "#A7A7A7"; width: 120 }
                    }

                    Rectangle {
                        height: 1
                        width: parent.width
                        color: "#2A2A2A"
                    }

                    // SONG ROW 1
                    Rectangle {
                        width: parent.width
                        height: 46
                        radius: 6
                        color: "#181818"

                        Row {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 40

                            Text { text: "Believer"; color: "white"; width: 220 }
                            Text { text: "Imagine Dragons"; color: "#A7A7A7"; width: 180 }
                            Text { text: "Pop"; color: "#A7A7A7"; width: 120 }
                        }
                    }

                    // SONG ROW 2
                    Rectangle {
                        width: parent.width
                        height: 46
                        radius: 6
                        color: "#181818"

                        Row {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 40

                            Text { text: "Heat Waves"; color: "white"; width: 220 }
                            Text { text: "Glass Animals"; color: "#A7A7A7"; width: 180 }
                            Text { text: "Indie"; color: "#A7A7A7"; width: 120 }
                        }
                    }
                }
            }
        }

        // ▶️ PLAYER BAR
        Rectangle {
            Layout.fillWidth: true
            height: 90
            color: "#181818"

            Row {
                anchors.centerIn: parent
                spacing: 28

                // Previous
                Button {
                    width: 44
                    height: 44
                    background: Rectangle {
                        radius: 22
                        color: "#2A2A2A"
                    }
                    contentItem: Image {
                        source: "assets/previous.png"
                        anchors.centerIn: parent
                        width: 20
                        height: 20
                    }
                }

                // Play / Pause (ONE BUTTON)
                Button {
                    id: playPauseBtn
                    width: 56
                    height: 56

                    property bool isPlaying: false

                    background: Rectangle {
                        radius: 28
                        color: "#E50914"
                    }

                    contentItem: Image {
                        source: playPauseBtn.isPlaying
                                ? "assets/pause.png"
                                : "assets/play.png"
                        anchors.centerIn: parent
                        width: 22
                        height: 22
                    }

                    onClicked: {
                        isPlaying = !isPlaying
                        console.log(isPlaying ? "Play" : "Pause")
                    }
                }

                // Next
                Button {
                    width: 44
                    height: 44
                    background: Rectangle {
                        radius: 22
                        color: "#2A2A2A"
                    }
                    contentItem: Image {
                        source: "assets/next.png"
                        anchors.centerIn: parent
                        width: 20
                        height: 20
                    }
                }

                // Repeat
                Button {
                    width: 44
                    height: 44
                    background: Rectangle {
                        radius: 22
                        color: "#2A2A2A"
                    }
                    contentItem: Image {
                        source: "assets/repeat.png"
                        anchors.centerIn: parent
                        width: 20
                        height: 20
                    }
                }

                // Shuffle
                Button {
                    width: 44
                    height: 44
                    background: Rectangle {
                        radius: 22
                    }
                    contentItem: Image {
                        source: "qrc: /uni/assets/pause.png"
                        anchors.centerIn: parent
                        width: 20
                        height: 20
                    }
                }
            }
        }
    }
}
