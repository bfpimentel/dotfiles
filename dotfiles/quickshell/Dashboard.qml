pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: dashboard
    signal requestLauncher()
    signal requestBitwarden()
    signal requestClipboard()
    signal requestSession()
    signal requestProcesses()
    signal requestScreenshot()

    visible: false
    focusable: true
    color: "transparent"
    aboveWindows: true
    implicitWidth: 600
    implicitHeight: dashboardRoot.implicitHeight

    anchors {
        top: true
        left: true
    }

    margins {
        top: screen ? Math.floor((screen.height - implicitHeight) / 2) : 0
        left: screen ? Math.floor((screen.width - implicitWidth) / 2) : 0
    }

    property int selectedIndex: 0
    property string currentTime: ""
    property string currentDate: ""
    property string currentWorkspace: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.name : ""
    property var workspaceNames: ["B", "M", "T", "W", "X"]
    property var menuItems: [
        { icon: "󰀻 ", label: "Applications", action: "launcher" },
        { icon: "󰟵 ", label: "Bitwarden", action: "bitwarden" },
        { icon: "󰅌 ", label: "Clipboard", action: "clipboard" },
        { icon: "󰍹 ", label: "Processes", action: "processes" },
        { icon: "󰄄 ", label: "Screenshots", action: "screenshot" },
        { icon: "󰐥 ", label: "Session", action: "session" }
    ]

    function refreshClock() {
        var now = new Date()
        currentTime = Qt.formatTime(now, "hh:mm")
        currentDate = Qt.formatDate(now, "ddd dd MMM")
    }

    function openDashboard() {
        refreshClock()
        selectedIndex = 0
        visible = true
        dashboardRoot.forceActiveFocus()
    }

    function closeDashboard() {
        visible = false
    }

    function move(delta) {
        if (menuItems.length === 0) return
        var next = selectedIndex + delta
        if (next < 0) next = menuItems.length - 1
        if (next >= menuItems.length) next = 0
        selectedIndex = next
    }

    function activateSelection() {
        if (selectedIndex < 0 || selectedIndex >= menuItems.length) return
        var item = menuItems[selectedIndex]

        if (item.action === "launcher") {
            dashboard.requestLauncher()
            closeDashboard()
            return
        }

        if (item.action === "bitwarden") {
            dashboard.requestBitwarden()
            closeDashboard()
            return
        }

        if (item.action === "clipboard") {
            dashboard.requestClipboard()
            closeDashboard()
            return
        }

        if (item.action === "session") {
            dashboard.requestSession()
            closeDashboard()
            return
        }

        if (item.action === "processes") {
            dashboard.requestProcesses()
            closeDashboard()
            return
        }

        if (item.action === "screenshot") {
            dashboard.requestScreenshot()
            closeDashboard()
            return
        }

        Quickshell.execDetached(item.command)
        closeDashboard()
    }

    Timer {
        interval: 1000
        running: dashboard.visible
        repeat: true
        onTriggered: dashboard.refreshClock()
    }

    Rectangle {
        id: dashboardRoot
        anchors.fill: parent
        implicitHeight: contentColumn.implicitHeight + 32
        color: "#33000000"
        border.width: 1
        border.color: "#3fffffff"
        focus: true

        Keys.onPressed: function(event) {
            if (event.key === Qt.Key_Escape) {
                dashboard.closeDashboard()
                event.accepted = true
            } else if (event.key === Qt.Key_Down || (event.key === Qt.Key_N && (event.modifiers & Qt.ControlModifier))) {
                dashboard.move(1)
                event.accepted = true
            } else if (event.key === Qt.Key_Up || (event.key === Qt.Key_P && (event.modifiers & Qt.ControlModifier))) {
                dashboard.move(-1)
                event.accepted = true
            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                dashboard.activateSelection()
                event.accepted = true
            }
        }

        ColumnLayout {
            id: contentColumn
            anchors.fill: parent
            anchors.margins: 16
            spacing: 14

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0

                Text {
                    text: dashboard.currentTime
                    color: "#ffffff"
                    font.family: "VictorMono NFM"
                    font.pixelSize: 38
                    font.bold: true
                }

                Text {
                    text: dashboard.currentDate
                    color: "#a7ffffff"
                    font.family: "VictorMono NFM"
                    font.pixelSize: 14
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Repeater {
                    model: dashboard.workspaceNames

                    delegate: Rectangle {
                        id: workspacePill
                        required property string modelData
                        implicitWidth: 34
                        implicitHeight: 26
                        color: dashboard.currentWorkspace === workspacePill.modelData ? "#f0ffffff" : "#1cffffff"
                        border.width: 1
                        border.color: dashboard.currentWorkspace === workspacePill.modelData ? "#ffffff" : "#44ffffff"

                        Text {
                            anchors.centerIn: parent
                            text: workspacePill.modelData
                            color: dashboard.currentWorkspace === workspacePill.modelData ? "#000000" : "#ffffff"
                            font.family: "VictorMono NFM"
                            font.pixelSize: 13
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0

                Repeater {
                    model: dashboard.menuItems

                    delegate: Rectangle {
                        id: menuRow
                        required property int index
                        required property var modelData
                        Layout.fillWidth: true
                        implicitHeight: 40
                        color: dashboard.selectedIndex === menuRow.index ? "#ffffff" : "transparent"

                        Text {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            text: menuRow.modelData.icon + "  " + menuRow.modelData.label
                            color: dashboard.selectedIndex === menuRow.index ? "#000000" : "#ffffff"
                            font.family: "VictorMono NFM"
                            font.pixelSize: 15
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: dashboard.selectedIndex = menuRow.index
                            onClicked: {
                                dashboard.selectedIndex = menuRow.index
                                dashboard.activateSelection()
                            }
                        }
                    }
                }
            }
        }
    }
}
