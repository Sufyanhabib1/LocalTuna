import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: recRoot

     signal backRequested()
    anchors.fill: parent

    property var recommendedModel: []
    property string currentSong: ""
     property string menuSong: ""

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // 🔴 TOP BAR
        Rectangle {
            Layout.fillWidth: true
            height: 64
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#1F1F1F" }
                GradientStop { position: 0.5; color: "#151515" }
                GradientStop { position: 1.0; color: "#1F1F1F" }
            }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12

                Image {
                    source: "qrc:/u/assets/localtunalogo.png"
                    fillMode: Image.PreserveAspectFit
                    Layout.preferredWidth: 32
                    Layout.preferredHeight: 40
                    Layout.alignment: Qt.AlignVCenter
                }

                Text {
                    text: "Local Tuna"
                    font.pixelSize: 26
                    font.bold: true
                    color: "#E50914"
                }

                Item { Layout.fillWidth: true }

                // BACK BUTTON
                Button {
                    width: 110
                    height: 42
                    onClicked: recRoot.backRequested()


                    background: Rectangle {
                        radius: 21
                        color: "#E50914"
                    }
                    contentItem: Text {
                        text: "← Back"
                        color: "white"
                        font.bold: true
                        font.pixelSize: 16
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }

        // 🧱 MAIN AREA
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#2A0F12" }
                GradientStop { position: 0.25; color: "#0F0F0F" }
                GradientStop { position: 0.5; color: "#0F0F0F" }
                GradientStop { position: 0.75; color: "#0F0F0F" }
                GradientStop { position: 1.0; color: "#2A0F12" }
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 25
                spacing: 16

                Text {
                    text: "Recommendations"
                    font.pixelSize: 27
                    font.bold: true
                    color: "white"
                }

                Item { height: 5 }

                // Header
                Rectangle {
                    Layout.fillWidth: true
                    height: 28
                    color: "transparent"
                    Row {
                        spacing: 40
                        Text { text: "TITLE"; width: 220; color: "#A7A7A7" }
                        Text { text: "ARTIST"; width: 180; color: "#A7A7A7" }
                        Text { text: "GENRE"; width: 120; color: "#A7A7A7" }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: "#2A2A2A"
                }

                // 🎯 RECOMMENDED LIST
                ListView {
                    id: recList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: recommendedModel
                    clip: true
                    spacing: 6

                    delegate: Rectangle {
                        height: 46
                        width: recList.width
                        color: mouseArea.containsMouse ? "transparent" : "#181818"
                        radius: 6

                        Row {
                            spacing: 40
                            Text { text: modelData.split("|")[0]; width: 220; color: "white" }
                            Text { text: modelData.split("|")[1]; width: 180; color: "#A7A7A7" }
                            Text { text: modelData.split("|")[2]; width: 120; color: "#A7A7A7" }
                        }

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            acceptedButtons: Qt.LeftButton | Qt.RightButton

                            onClicked: (mouse) => {
                                recRoot.menuSong = modelData

                                if (mouse.button === Qt.RightButton) {
                                               const globalPos = mouseArea.mapToGlobal(mouse.x, mouse.y)
                                                        recSongMenu.popup(globalPos.x, globalPos.y)
                                } else {
                                    // optional: play on left click
                                    musicManager.playSong(modelData)
                                }
                            }
                        }
                    }


                    ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }
                }
                Menu {
                    id: recSongMenu

                    MenuItem {
                        text: "Add to Queue"
                        onTriggered: musicManager.addToQueue(recRoot.menuSong)
                    }
                }
            }
        }
    }
}
