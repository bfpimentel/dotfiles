pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick

PanelWindow {
    id: clipboard
    visible: false
    focusable: true
    color: "transparent"
    aboveWindows: true
    implicitWidth: 700
    implicitHeight: 440

    anchors {
        top: true
        left: true
    }

    margins {
        top: screen ? Math.floor((screen.height - implicitHeight) / 2) : 0
        left: screen ? Math.floor((screen.width - implicitWidth) / 2) : 0
    }

    property var allEntries: []
    property var filteredEntries: []
    property int selectedIndex: -1

    function openClipboard() {
        scaffold.setQuery("")
        visible = true
        scaffold.focusPrompt()
        refreshHistory()
    }

    function closeClipboard() {
        visible = false
    }

    function refreshHistory() {
        allEntries = []
        filteredEntries = []
        selectedIndex = -1
        listProcess.running = false
        listProcess.running = true
    }

    function setEntries(raw) {
        if (!raw || raw.trim().length === 0) {
            allEntries = []
            filteredEntries = []
            selectedIndex = -1
            return
        }

        var lines = raw.split("\n")
        var out = []
        for (var i = 0; i < lines.length; i++) {
            var line = lines[i].trim()
            if (line.length > 0) out.push(line)
        }

        allEntries = out
        refilter()
    }

    function refilter() {
        var q = scaffold.queryText.toLowerCase()
        var out = []

        for (var i = 0; i < allEntries.length; i++) {
            var item = allEntries[i]
            if (q.length === 0 || item.toLowerCase().indexOf(q) !== -1) {
                out.push(item)
            }
        }

        filteredEntries = out
        selectedIndex = out.length > 0 ? 0 : -1
    }

    function move(delta) {
        scaffold.moveSelection(delta)
    }

    function activateSelection() {
        if (selectedIndex < 0 || selectedIndex >= filteredEntries.length) return
        var choice = filteredEntries[selectedIndex]
        Quickshell.execDetached(["sh", "-lc", "printf '%s\\n' \"$1\" | cliphist decode | wl-copy", "_", choice])
        closeClipboard()
    }

    Process {
        id: listProcess
        command: ["cliphist", "list"]
        stdout: StdioCollector {
            onStreamFinished: clipboard.setEntries(this.text)
        }
    }

    Scaffold {
        id: scaffold
        anchors.fill: parent
        placeholderText: "Clipboard"
        model: clipboard.filteredEntries
        selectedIndex: clipboard.selectedIndex
        onSelectedIndexChanged: clipboard.selectedIndex = selectedIndex
        onQueryChanged: clipboard.refilter()
        onActivateRequested: clipboard.activateSelection()
        onCloseRequested: clipboard.closeClipboard()

        delegate: Rectangle {
            id: row
            required property int index
            required property string modelData

            width: scaffold.listWidth
            height: 40
            color: row.index === clipboard.selectedIndex ? "#ffffff" : "transparent"

            Text {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                text: row.modelData
                color: row.index === clipboard.selectedIndex ? "#000000" : "#ffffff"
                font.family: "VictorMono NFM"
                font.pixelSize: 14
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: clipboard.selectedIndex = row.index
                onClicked: {
                    clipboard.selectedIndex = row.index
                    clipboard.activateSelection()
                }
            }
        }
    }
}
