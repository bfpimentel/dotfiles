pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: launcher
    visible: false
    focusable: true
    color: "transparent"
    aboveWindows: true
    implicitWidth: 600
    implicitHeight: 420

    anchors {
        top: true
        left: true
    }

    margins {
        top: screen ? Math.floor((screen.height - implicitHeight) / 2) : 0
        left: screen ? Math.floor((screen.width - implicitWidth) / 2) : 0
    }

    property var allApps: []
    property var filteredApps: []
    property int selectedIndex: -1
    property var hiddenAppIds: [
        "kbd-layout-viewer5.desktop",
        "kbd-layout-viewer5",
        "nvim.desktop",
        "nvim",
        "nixos-manual.desktop",
        "nixos-manual"
    ]
    property var hiddenIdPrefixes: [
        "fcitx5-",
        "kcm_fcitx5",
        "org.fcitx.",
        "peazip"
    ]

    function openLauncher() {
        allApps = DesktopEntries.applications && DesktopEntries.applications.values ? DesktopEntries.applications.values : []
        scaffold.setQuery("")
        refilter()
        visible = true
        scaffold.focusPrompt()
    }

    function closeLauncher() {
        visible = false
    }

    function matches(app, query) {
        if (query.length === 0) return true

        function has(text) {
            return text && text.toLowerCase().indexOf(query) !== -1
        }

        if (has(app.name) || has(app.comment) || has(app.genericName)) return true

        if (app.categories) {
            for (var i = 0; i < app.categories.length; i++) {
                if (has(app.categories[i])) return true
            }
        }

        if (app.keywords) {
            for (var j = 0; j < app.keywords.length; j++) {
                if (has(app.keywords[j])) return true
            }
        }

        return false
    }

    function iconSource(iconName) {
        if (!iconName) return ""

        var icon = String(iconName)
        if (icon.length === 0) return ""

        if (icon.indexOf("://") !== -1) return icon
        if (icon.charAt(0) === "/") return "file://" + icon

        return Quickshell.iconPath(icon, "application-x-executable")
    }

    function isHiddenApp(app) {
        if (!app) return false

        var id = app.id ? String(app.id) : ""
        for (var i = 0; i < hiddenAppIds.length; i++) {
            if (id === hiddenAppIds[i]) return true
        }

        for (var j = 0; j < hiddenIdPrefixes.length; j++) {
            if (id.indexOf(hiddenIdPrefixes[j]) === 0) return true
        }

        var name = app.name ? String(app.name).toLowerCase() : ""
        if (name.indexOf("neovim wrapper") !== -1) return true
        if (name.indexOf("keyboard layout viewer") !== -1) return true
        if (name.indexOf("nixos manual") !== -1) return true

        return false
    }

    function refilter() {
        var q = scaffold.queryText.toLowerCase()
        var out = []

        for (var i = 0; i < allApps.length; i++) {
            var app = allApps[i]
            if (!app.noDisplay && !isHiddenApp(app) && matches(app, q)) {
                out.push(app)
            }
        }

        out.sort(function(a, b) {
            var aName = (a && a.name) ? String(a.name) : ""
            var bName = (b && b.name) ? String(b.name) : ""
            return aName.localeCompare(bName, undefined, { sensitivity: "base" })
        })

        filteredApps = out
        selectedIndex = out.length > 0 ? 0 : -1
    }

    function move(delta) {
        scaffold.moveSelection(delta)
    }

    function activate() {
        if (selectedIndex < 0 || selectedIndex >= filteredApps.length) return
        filteredApps[selectedIndex].execute()
        closeLauncher()
    }

    Scaffold {
        id: scaffold
        anchors.fill: parent
        color: "#4d000000"
        border.color: "#47ffffff"
        placeholderText: "Run"
        model: launcher.filteredApps
        selectedIndex: launcher.selectedIndex
        onSelectedIndexChanged: launcher.selectedIndex = selectedIndex
        onQueryChanged: launcher.refilter()
        onActivateRequested: launcher.activate()
        onCloseRequested: launcher.closeLauncher()

        delegate: Rectangle {
            id: appRow
            required property int index
            required property var modelData

            width: scaffold.listWidth
            height: 36
            color: index === launcher.selectedIndex ? "#ffffff" : "transparent"

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                spacing: 8

                IconImage {
                    id: appIcon
                    Layout.preferredWidth: 18
                    Layout.preferredHeight: 18
                    source: launcher.iconSource(appRow.modelData.icon)
                    visible: source && source.toString().length > 0
                    asynchronous: true
                    mipmap: true
                }

                Item {
                    Layout.preferredWidth: 18
                    Layout.preferredHeight: 18
                    visible: !appIcon.visible
                }

                Text {
                    Layout.fillWidth: true
                    text: appRow.modelData.name
                    color: appRow.index === launcher.selectedIndex ? "#000000" : "#ffffff"
                    font.family: "VictorMono NFM"
                    font.pixelSize: 14
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: launcher.selectedIndex = appRow.index
                onClicked: {
                    launcher.selectedIndex = appRow.index
                    launcher.activate()
                }
            }
        }
    }
}
