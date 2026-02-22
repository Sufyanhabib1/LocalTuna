import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    visible: true
    width: 1200
    height: 750
    title: "Local Tuna"
    color: "#0F0F0F"
    id: root
    visibility:  Window.Maximized  //visibility: Window.FullScreen
    flags: Qt.Window
    property string currentSong: ""
    property var songListModel: musicManager.songs
    property var itemToLoad: []
    Connections {
        target: musicManager
        function onCurrentSongChanged(displayText) {
            currentSong = displayText
        }
    }

    Loader {
        id: recommendationsLoader
        anchors.fill: parent
        visible: false
        source: ""

        onLoaded: {
            if (item) {
                item.recommendedModel = itemToLoad

                // 🔁 handle back signal HERE
                item.backRequested.connect(() => {
                    recommendationsLoader.source = ""
                    recommendationsLoader.visible = false
                    mainContent.visible = true
                })
            }
        }
    }



    ColumnLayout {
         id: mainContent
        anchors.fill: parent
        spacing: 0

        // 🔴 TOP BAR
        Rectangle {
            Layout.fillWidth: true
            height: 64
            gradient: Gradient {
                    GradientStop { position: 0.0; color: "#1F1F1F" }
                    GradientStop { position: 0.5; color: "#151515" }
                    GradientStop { position: 1.0; color: "#1F1F1F" }}

            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 10

                Image {
                    source: "qrc:/u/assets/localtunalogo.png"
                    fillMode: Image.PreserveAspectFit
                    Layout.preferredWidth: 32
                    Layout.preferredHeight: 40
                    Layout.alignment: Qt.AlignVCenter
                }

                Text {
                    text: "Local Tuna"
                    font.pixelSize: 24
                    font.bold: true
                    color: "#E50914"
                }

                Item { Layout.fillWidth: true
                }

                TextField {
                    id: searchField
                    Layout.preferredWidth: 300
                    Layout.preferredHeight: 36

                     placeholderText: "Search songs, artists, genres"
                     color: "white"
                     background: Rectangle {
                         radius: 21
                         color: "#2A2A2A"
                     }
                     onTextChanged: {
                           if (text.trim() === "") {
                               songListModel = musicManager.songs
                           } else {
                               songListModel = musicManager.searchSongs(text)
                           }
                       }
                }
            }
        }

        // 🧱 MAIN AREA
        // 🧱 MAIN AREA
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            gradient: Gradient {
                  GradientStop { position: 0.0; color: "#2A0F12" }
                  GradientStop { position: 0.25; color: "#0F0F0F" }// subtle red top
                  GradientStop { position: 0.5  ; color: "#0F0F0F" }
                  GradientStop { position: 0.75; color: "#0F0F0F" }// deep black middle
                  GradientStop { position: 1.0; color: "#2A0F12" }  // subtle red bottom
              }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 25
                spacing: 14

                // Title
                Text {
                    text: "All Songs"
                    font.pixelSize: 27
                    font.bold: true
                    color: "white"
                    Layout.alignment: Qt.AlignLeft
                }
                Item {
                    height: 5  // increase this value for more space (e.g. 30, 40)
                }
                // Header row
                Rectangle {
                    Layout.fillWidth: true
                    height: 28
                    color: "transparent"

                    Row {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 40

                        Text { text: "TITLE";  width: 220; color: "#A7A7A7" }
                        Text { text: "ARTIST"; width: 180; color: "#A7A7A7" }
                        Text { text: "GENRE";  width: 120; color: "#A7A7A7" }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: "#2A2A2A"
                }
            //song display and play section
                ListView {
                    id: songList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    model: songListModel
                    spacing: 6

                    property string menuSong: ""

                    delegate: Rectangle {
                        width: songList.width
                        height: 46
                        radius: 6
                        color: {
                             if (currentSong === modelData)
                                 return "transparent"
                             if (mouseArea.containsMouse)
                                 return "transparent"
                             return "#181818"
                         }

                        property var fields: modelData.split("|")
                        property string title: fields[0].trim()
                        property string artist: fields[1].trim()
                        property string genre: fields[2].trim()

                        Row {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 40

                            Text {
                                text: title
                                width: 220
                                elide: Text.ElideRight
                                color: "white"
                            }

                            Text {
                                text: artist
                                width: 180
                                color: "#A7A7A7"
                            }

                            Text {
                                text: genre
                                width: 120
                                color: "#A7A7A7"
                            }
                        }

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            acceptedButtons: Qt.LeftButton | Qt.RightButton

                            onClicked: (mouse) => {
                                             songList.menuSong = modelData
                                if (mouse.button === Qt.RightButton) {

                                               // convert delegate-local coords to window coords
                                                    const p = mouseArea.mapToItem(null, mouse.x, mouse.y)
                                                    songMenu.popup(p.x, p.y)
                                } else {

                                    musicManager.playSong(modelData)
                                    currentSong = modelData
                                }
                            }
                        }
                    }

                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded
                    }
                }
            }
        }
        Menu {
            id: songMenu

            MenuItem {
                text: "Add to Queue"
                onTriggered: musicManager.addToQueue(songList.menuSong)
            }

            MenuItem {
                text: "View Similar"
                onTriggered: {
                      // Store the recommended list first
                      itemToLoad = musicManager.viewSimilar(songList.menuSong)

                      // Load the page (onLoaded will automatically set recommendedModel)
                      recommendationsLoader.source = "Recommendations.qml"
                      recommendationsLoader.visible = true
                     mainContent.visible = false   // ✅ THIS IS KEY
                  }
              }
        }

        // ▶️ PLAYER BAR
        Rectangle {
            Layout.fillWidth: true
            height: 90
            gradient: Gradient {
                    GradientStop { position: 0.0; color: "#1F1F1F" }
                    GradientStop { position: 0.5; color: "#151515" }
                    GradientStop { position: 1.0; color: "#1F1F1F" }}


            Row {
                anchors.centerIn: parent
                spacing: 28


                // Previous
                Button {
                    width: 44; height: 44; hoverEnabled: false
                    background: Rectangle { radius: 22; color: "#FF1438" }
                    contentItem: Image { source: "qrc:/u/assets/previous.png"; anchors.centerIn: parent; width: 15; height: 15 }
                    onClicked: musicManager.prevSong()
                }
                //play pause
                Button {
                                id: playPauseBtn
                                width: 56
                                height: 56
                                focus: true



                                background: Rectangle {
                                    radius: 28
                                    color: "#E50914"
                                }

                                contentItem: Image {
                                    source: musicManager.playing
                                            ? "qrc:/u/assets/pause.png"
                                            : "qrc:/u/assets/play.png"
                                    anchors.centerIn: parent
                                    width: 22; height: 22
                                }

                                onClicked: {
                                    if (currentSong === "")
                                        return

                                    if (musicManager.playing) {
                                        musicManager.pause()

                                    } else {
                                        musicManager.resume()

                                    }
                                }
                            }

                // Next
                Button {
                    width: 44; height: 44; hoverEnabled: false
                    background: Rectangle { radius: 22; color: "#FF1438" }
                    contentItem: Image { source: "qrc:/u/assets/next.png"; anchors.centerIn: parent; width: 20; height: 20 }
                       onClicked: musicManager.nextSong()
                }
                // Shuffle
                Button {
                    width: 44; height: 44; hoverEnabled: false
                    background: Rectangle { radius: 22; color: "#FF1438" }
                    contentItem: Image { source: "qrc:/u/assets/shuffle.png"; anchors.centerIn: parent; width: 20; height: 20 }
                    onClicked: musicManager.shuffleSong();
                }

            }
        }
    }
}
