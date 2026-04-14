pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

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
    property int thumbVersion: 0
    property string thumbDir: String(Quickshell.env("HOME") || "") + "/.cache/quickshell/cliphist-thumbs"

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
            if (line.length === 0) continue

            var tabIdx = line.indexOf("\t")
            var id = tabIdx >= 0 ? line.slice(0, tabIdx) : line
            var preview = tabIdx >= 0 ? line.slice(tabIdx + 1) : ""
            if (!/^\d+$/.test(id)) continue

            var lower = preview.toLowerCase()
            var match = lower.match(/binary data[^\n]*(png|jpg|jpeg|bmp|gif|webp)/)
            var ext = match ? match[1] : ""
            if (ext === "jpeg") ext = "jpg"

            out.push({
                id: id,
                preview: preview,
                isImage: ext.length > 0,
                thumbPath: ext.length > 0 ? (thumbDir + "/" + id + "." + ext) : "",
                display: id + "\t" + preview
            })
        }

        allEntries = out
        generateThumbnails(out)
        refilter()
    }

    function generateThumbnails(entries) {
        var scripts = ["mkdir -p \"$1\""]

        for (var i = 0; i < entries.length; i++) {
            var item = entries[i]
            if (!item || !item.isImage || !item.thumbPath) continue
            scripts.push("printf '%s\\t\\n' '" + item.id + "' | cliphist decode > \"" + item.thumbPath + "\" 2>/dev/null")
        }

        if (scripts.length <= 1) {
            thumbVersion += 1
            return
        }

        thumbProcess.command = ["sh", "-lc", scripts.join("; "), "_", thumbDir]
        thumbProcess.running = false
        thumbProcess.running = true
    }

    function refilter() {
        var q = scaffold.queryText.toLowerCase()
        var out = []

        for (var i = 0; i < allEntries.length; i++) {
            var item = allEntries[i]
            var text = ((item && item.preview) ? item.preview : "").toLowerCase()
            if (q.length === 0 || text.indexOf(q) !== -1) {
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
        if (!choice || !choice.id) return
        Quickshell.execDetached(["sh", "-lc", "printf '%s\\t\\n' \"$1\" | cliphist decode | wl-copy", "_", choice.id])
        closeClipboard()
    }

    Process {
        id: listProcess
        command: ["cliphist", "list"]
        stdout: StdioCollector {
            onStreamFinished: clipboard.setEntries(this.text)
        }
    }

    Process {
        id: thumbProcess
        onRunningChanged: if (!running) clipboard.thumbVersion += 1
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
            required property var modelData

            width: scaffold.listWidth
            height: row.modelData.isImage ? 52 : 40
            color: row.index === clipboard.selectedIndex ? "#ffffff" : "transparent"

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: row.modelData.isImage ? 54 : 10
                spacing: 8

                Text {
                    Layout.preferredWidth: 56
                    text: row.modelData.id
                    color: row.index === clipboard.selectedIndex ? "#000000" : "#ffffff"
                    font.family: "VictorMono NFM"
                    font.pixelSize: 13
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    Layout.fillWidth: true
                    text: row.modelData.preview
                    color: row.index === clipboard.selectedIndex ? "#000000" : "#ffffff"
                    font.family: "VictorMono NFM"
                    font.pixelSize: 14
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Image {
                id: thumb
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                width: 36
                height: 36
                fillMode: Image.PreserveAspectFit
                asynchronous: true
                cache: false
                visible: !!row.modelData.isImage
                source: row.modelData.isImage ? ("file://" + row.modelData.thumbPath + "?v=" + clipboard.thumbVersion) : ""

                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    border.width: 1
                    border.color: "#47ffffff"
                    visible: thumb.visible
                }
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
