pragma ComponentBehavior: Bound

import Quickshell
import QtQuick

PanelWindow {
    id: screenshot
    visible: false
    focusable: true
    color: "transparent"
    aboveWindows: true
    implicitWidth: 640
    implicitHeight: 420

    anchors {
        top: true
        left: true
    }

    margins {
        top: screen ? Math.floor((screen.height - implicitHeight) / 2) : 0
        left: screen ? Math.floor((screen.width - implicitWidth) / 2) : 0
    }

    property var allItems: [
        { key: "full-save", text: "󰆞  Full Screen (Save)" },
        { key: "full-clip", text: "󰆞  Full Screen (Clipboard)" },
        { key: "full-annotate", text: "󰇄  Full Screen (Annotate)" },
        { key: "area-save", text: "󰆿  Area (Save)" },
        { key: "area-clip", text: "󰆿  Area (Clipboard)" },
        { key: "area-annotate", text: "󰇄  Area (Annotate)" },
        { key: "win-save", text: "󰖲  Window (Save)" },
        { key: "win-annotate", text: "󰖲  Window (Annotate)" }
    ]
    property var filteredItems: []
    property int selectedIndex: -1

    function openScreenshot() {
        scaffold.setQuery("")
        visible = true
        scaffold.focusPrompt()
        refilter()
    }

    function closeScreenshot() {
        visible = false
    }

    function screenshotsDir() {
        return "${HOME}/Documents/Screenshots"
    }

    function timestampExpr() {
        return "$(date +%Y%m%d-%H%M%S)"
    }

    function focusedWindowGeometryExpr() {
        return "$(hyprctl -j activewindow | jq -r '\"\\(.at[0]),\\(.at[1]) \\(.size[0])x\\(.size[1])\"')"
    }

    function runScript(script) {
        Quickshell.execDetached(["sh", "-lc", script])
        closeScreenshot()
    }

    function scriptFor(key) {
        var dir = screenshotsDir()
        var ts = timestampExpr()
        var file = dir + "/screenshot-" + ts + ".png"
        var geom = focusedWindowGeometryExpr()

        if (key === "full-save") return "mkdir -p \"" + dir + "\"; grim \"" + file + "\""
        if (key === "full-clip") return "grim - | wl-copy"
        if (key === "full-annotate") return "mkdir -p \"" + dir + "\"; grim - | satty --filename - --output-filename \"" + file + "\""

        if (key === "area-save") return "g=$(slurp); [ -n \"$g\" ] || exit 0; mkdir -p \"" + dir + "\"; grim -g \"$g\" \"" + file + "\""
        if (key === "area-clip") return "g=$(slurp); [ -n \"$g\" ] || exit 0; grim -g \"$g\" - | wl-copy"
        if (key === "area-annotate") return "g=$(slurp); [ -n \"$g\" ] || exit 0; mkdir -p \"" + dir + "\"; grim -g \"$g\" - | satty --filename - --output-filename \"" + file + "\""

        if (key === "win-save") return "g=" + geom + "; [ -n \"$g\" ] || exit 0; [ \"$g\" = \"null,null nullxnull\" ] && exit 0; mkdir -p \"" + dir + "\"; grim -g \"$g\" \"" + file + "\""
        if (key === "win-annotate") return "g=" + geom + "; [ -n \"$g\" ] || exit 0; [ \"$g\" = \"null,null nullxnull\" ] && exit 0; mkdir -p \"" + dir + "\"; grim -g \"$g\" - | satty --filename - --output-filename \"" + file + "\""

        return ""
    }

    function refilter() {
        var q = scaffold.queryText.toLowerCase()
        var out = []

        for (var i = 0; i < allItems.length; i++) {
            var item = allItems[i]
            if (q.length === 0 || item.text.toLowerCase().indexOf(q) !== -1) {
                out.push(item)
            }
        }

        filteredItems = out
        selectedIndex = out.length > 0 ? 0 : -1
    }

    function activateSelection() {
        if (selectedIndex < 0 || selectedIndex >= filteredItems.length) return
        var item = filteredItems[selectedIndex]
        var script = scriptFor(item.key)
        if (script.length === 0) return
        runScript(script)
    }

    Scaffold {
        id: scaffold
        anchors.fill: parent
        placeholderText: "Screenshot"
        model: screenshot.filteredItems
        selectedIndex: screenshot.selectedIndex
        onSelectedIndexChanged: screenshot.selectedIndex = selectedIndex
        onQueryChanged: screenshot.refilter()
        onActivateRequested: screenshot.activateSelection()
        onCloseRequested: screenshot.closeScreenshot()

        delegate: Rectangle {
            id: row
            required property int index
            required property var modelData

            width: scaffold.listWidth
            height: 40
            color: row.index === screenshot.selectedIndex ? "#ffffff" : "transparent"

            Text {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                text: row.modelData.text
                color: row.index === screenshot.selectedIndex ? "#000000" : "#ffffff"
                font.family: "VictorMono NFM"
                font.pixelSize: 14
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: screenshot.selectedIndex = row.index
                onClicked: {
                    screenshot.selectedIndex = row.index
                    screenshot.activateSelection()
                }
            }
        }
    }
}
