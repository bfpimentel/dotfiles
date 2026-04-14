import QtQuick 2.15
import QtQuick.Layouts 1.15
import SddmComponents 2.0 as SDDM

Rectangle {
    id: root
    width: 2560
    height: 1440
    color: "#000000"

    property string statusMessage: ""

    function formatTime(d) {
        var hh = d.getHours().toString().padStart(2, "0")
        var mm = d.getMinutes().toString().padStart(2, "0")
        return hh + ":" + mm
    }

    function formatDate(d) {
        var days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        var dd = d.getDate().toString().padStart(2, "0")
        return days[d.getDay()] + " " + dd + " " + months[d.getMonth()]
    }

    function doLogin() {
        sddm.login(userInput.text, passInput.text, sessionBox.index)
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            root.statusMessage = "Login failed"
            passInput.text = ""
            passInput.forceActiveFocus()
        }
        function onInformationMessage(message) {
            root.statusMessage = message
        }
    }

    Timer {
        id: clockTimer
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            var now = new Date()
            clockLabel.text = root.formatTime(now)
            dateLabel.text = root.formatDate(now)
        }
        Component.onCompleted: onTriggered()
    }

    Timer {
        id: initialFocusTimer
        interval: 1
        running: true
        repeat: false
        onTriggered: passInput.forceActiveFocus()
    }

    Rectangle {
        id: card
        width: 620
        anchors.centerIn: parent
        color: "#4d000000"
        border.width: 1
        border.color: "#47ffffff"
        implicitHeight: content.implicitHeight + 44

        ColumnLayout {
            id: content
            anchors.fill: parent
            anchors.margins: 22
            spacing: 14

            Text {
                id: clockLabel
                Layout.fillWidth: true
                color: "#ffffff"
                font.family: "VictorMono NFM"
                font.pixelSize: 44
                font.bold: true
            }

            Text {
                id: dateLabel
                Layout.fillWidth: true
                color: "#a7ffffff"
                font.family: "VictorMono NFM"
                font.pixelSize: 16
            }

            SDDM.ComboBox {
                id: sessionBox
                Layout.fillWidth: true
                model: sessionModel
                index: sessionModel.lastIndex
                color: "#14000000"
                borderColor: "#47ffffff"
                focusColor: "#1fffffff"
                hoverColor: "#1fffffff"
                menuColor: "#26000000"
                textColor: "#ffffff"
                borderWidth: 1
                arrowColor: "#ffffff"
                arrowIcon: ""
                font.family: "VictorMono NFM"
                font.pixelSize: 16

                Text {
                    anchors.right: parent.right
                    anchors.rightMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                    text: "v"
                    color: "#ffffff"
                    font.family: "VictorMono NFM"
                    font.pixelSize: 14
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 42
                color: "#14000000"
                border.width: 1
                border.color: "#47ffffff"

                TextInput {
                    id: userInput
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    clip: true
                    color: "#ffffff"
                    text: userModel.lastUser
                    font.family: "VictorMono NFM"
                    font.pixelSize: 16
                    verticalAlignment: TextInput.AlignVCenter
                    selectByMouse: true
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 42
                color: "#14000000"
                border.width: 1
                border.color: "#47ffffff"

                TextInput {
                    id: passInput
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    clip: true
                    color: "#ffffff"
                    echoMode: TextInput.Password
                    font.family: "VictorMono NFM"
                    font.pixelSize: 16
                    verticalAlignment: TextInput.AlignVCenter
                    selectByMouse: true

                    Keys.onPressed: function(event) {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            root.doLogin()
                            event.accepted = true
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 42
                color: "#ffffff"
                border.width: 1
                border.color: "#47ffffff"

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.doLogin()
                }

                Text {
                    anchors.centerIn: parent
                    text: "Login"
                    color: "#000000"
                    font.family: "VictorMono NFM"
                    font.pixelSize: 16
                }
            }

            Text {
                Layout.fillWidth: true
                text: __sddm_errors !== "" ? __sddm_errors : root.statusMessage
                color: "#ff9f9f"
                font.family: "VictorMono NFM"
                font.pixelSize: 13
                wrapMode: Text.Wrap
                visible: text.length > 0
            }
        }
    }
}
