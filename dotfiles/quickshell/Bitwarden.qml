pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

PanelWindow {
    id: bitwarden
    visible: false
    focusable: true
    color: "transparent"
    aboveWindows: true
    implicitWidth: 700
    implicitHeight: 460

    anchors {
        top: true
        left: true
    }

    margins {
        top: screen ? Math.floor((screen.height - implicitHeight) / 2) : 0
        left: screen ? Math.floor((screen.width - implicitWidth) / 2) : 0
    }

    property string mode: "items"
    property bool loading: false
    property string sessionToken: ""
    property string pendingOp: ""
    property var vaultItems: []
    property var visibleItems: []
    property int selectedIndex: -1
    property var selectedItem: null
    property var actionItems: []
    property string currentName: "Bitwarden"
    property string authPassword: ""
    property string authStatusText: ""

    function openBitwarden() {
        visible = true
        selectedItem = null
        actionItems = []
        currentName = "Bitwarden"
        scaffold.setQuery("")

        if (sessionToken.length > 0) {
            checkSession()
        } else {
            showAuth()
        }
    }

    function closeBitwarden() {
        visible = false
    }

    function showAuth() {
        mode = "auth"
        loading = false
        authPassword = ""
        authStatusText = ""
        authFocusTimer.restart()
    }

    function setLoading(value) {
        loading = value
    }

    function runBwScript(op, script, arg1, arg2) {
        pendingOp = op
        bwProcess.running = false

        var cmd = ["sh", "-lc", script]
        if (arg1 !== undefined) cmd.push("_", String(arg1))
        if (arg2 !== undefined) cmd.push(String(arg2))

        bwProcess.command = cmd
        bwProcess.running = true
    }

    function checkSession() {
        setLoading(true)
        runBwScript(
            "check",
            "BW_SESSION=\"$1\" bw unlock --check >/dev/null 2>&1; if [ $? -eq 0 ]; then printf 'OK\\n'; else printf 'ERR\\n'; fi",
            sessionToken
        )
    }

    function unlock() {
        var password = authPassword
        if (!password || password.length === 0) return
        setLoading(true)
        authStatusText = ""

        runBwScript(
            "unlock",
            "BW_WOFI_MASTER_PASSWORD=\"$1\"; out=$(BW_WOFI_MASTER_PASSWORD=\"$1\" bw unlock --raw --passwordenv BW_WOFI_MASTER_PASSWORD 2>/dev/null); rc=$?; if [ $rc -eq 0 ] && [ -n \"$out\" ]; then printf 'OK\\n%s\\n' \"$out\"; else printf 'ERR\\n'; fi",
            password
        )

        authPassword = ""
    }

    function loadItems() {
        setLoading(true)
        runBwScript(
            "list",
            "out=$(BW_SESSION=\"$1\" bw list items 2>/dev/null); rc=$?; if [ $rc -eq 0 ]; then printf 'OK\\n%s' \"$out\"; else err=$(BW_SESSION=\"$1\" bw list items 2>&1 >/dev/null); printf 'ERR\\n%s' \"$err\"; fi",
            sessionToken
        )
    }

    function loadTotp(itemId) {
        setLoading(true)
        runBwScript(
            "totp",
            "out=$(BW_SESSION=\"$1\" bw get totp \"$2\" 2>&1); rc=$?; if [ $rc -eq 0 ]; then printf 'OK\\n%s\\n' \"$out\"; else printf 'ERR\\n%s\\n' \"$out\"; fi",
            sessionToken,
            itemId
        )
    }

    function needsReauth(text) {
        var s = (text || "").toLowerCase()
        return s.indexOf("vault is locked") !== -1
            || s.indexOf("invalid session") !== -1
            || s.indexOf("session key") !== -1
            || s.indexOf("not logged in") !== -1
            || s.indexOf("log in") !== -1
    }

    function notifyCopied(itemName, field) {
        Quickshell.execDetached(["sh", "-lc", "command -v notify-send >/dev/null 2>&1 && notify-send \"$1 $2 copied to clipboard!\"", "_", itemName, field])
    }

    function copyValue(value, itemName, field) {
        Quickshell.execDetached(["sh", "-lc", "printf '%s' \"$1\" | wl-copy", "_", value])
        notifyCopied(itemName, field)
        closeBitwarden()
    }

    function parseItems(jsonText) {
        var parsed
        var cleaned = (jsonText || "").trim()
        try {
            parsed = JSON.parse(cleaned)
        } catch (e) {
            authStatusText = "Failed to parse vault items"
            showAuth()
            authStatusText = "Failed to parse vault items"
            return
        }

        if (!Array.isArray(parsed) || parsed.length === 0) {
            vaultItems = []
            visibleItems = []
            mode = "items"
            selectedIndex = -1
            scaffold.focusPrompt()
            return
        }

        var entries = []
        for (var i = 0; i < parsed.length; i++) {
            var item = parsed[i]
            if (!item || typeof item !== "object") continue
            if (!item.id) continue

            var name = item.name || "(unnamed)"
            var login = item.login || {}
            var username = login.username || ""
            var label = username && username.length > 0 ? (name + " - [" + username + "]") : name

            entries.push({
                id: item.id,
                name: name,
                username: username,
                password: login.password || "",
                hasTotp: !!login.totp,
                baseLabel: label,
                text: label
            })
        }

        entries.sort(function(a, b) {
            return a.baseLabel.toLowerCase().localeCompare(b.baseLabel.toLowerCase())
        })

        var counts = {}
        for (var j = 0; j < entries.length; j++) {
            var key = entries[j].baseLabel
            var seen = (counts[key] || 0) + 1
            counts[key] = seen
            entries[j].text = seen === 1 ? key : (key + " (" + seen + ")")
        }

        vaultItems = entries
        mode = "items"
        scaffold.setQuery("")
        refilter()
        scaffold.focusPrompt()
    }

    function handleBwOutput(op, text) {
        setLoading(false)

        if (op === "check") {
            if ((text || "").indexOf("OK") === 0) {
                loadItems()
            } else {
                sessionToken = ""
                showAuth()
            }
            return
        }

        if (op === "unlock") {
            var lines = (text || "").split("\n")
            if (lines.length >= 2 && lines[0] === "OK" && lines[1].length > 0) {
                sessionToken = lines[1].trim()
                loadItems()
            } else {
                authStatusText = "Unable to unlock Bitwarden"
                showAuth()
                authStatusText = "Unable to unlock Bitwarden"
            }
            return
        }

        if (op === "list") {
            var output = text || ""
            var split = output.indexOf("\n")
            var status = split === -1 ? output.trim() : output.slice(0, split).trim()
            var payload = split === -1 ? "" : output.slice(split + 1)

            if (status !== "OK") {
                if (needsReauth(payload)) {
                    sessionToken = ""
                    showAuth()
                    authStatusText = "Session expired. Unlock again."
                } else {
                    showAuth()
                    authStatusText = "Failed to read vault items"
                }
                return
            }

            parseItems(payload)
            return
        }

        if (op === "totp") {
            var totpLines = (text || "").split("\n")
            if (totpLines.length >= 2 && totpLines[0] === "OK") {
                copyValue(totpLines[1].trim(), currentName, "totp")
            } else {
                if (needsReauth(text)) {
                    sessionToken = ""
                    showAuth()
                    authStatusText = "Session expired. Unlock again."
                }
            }
            return
        }
    }

    function openActionsFor(item) {
        selectedItem = item
        currentName = item.name || "item"

        var out = []
        if (item.username && item.username.length > 0) out.push({ key: "username", text: "Copy username" })
        if (item.password && item.password.length > 0) out.push({ key: "password", text: "Copy password" })
        if (item.hasTotp) out.push({ key: "totp", text: "Copy TOTP" })

        actionItems = out
        mode = "actions"
        scaffold.setQuery("")
        refilter()
        scaffold.focusPrompt()
    }

    function refilter() {
        var q = scaffold.queryText.toLowerCase()
        var source = mode === "actions" ? actionItems : vaultItems
        var out = []

        for (var i = 0; i < source.length; i++) {
            var item = source[i]
            var t = (item.text || "").toLowerCase()
            if (q.length === 0 || t.indexOf(q) !== -1) out.push(item)
        }

        visibleItems = out
        selectedIndex = out.length > 0 ? 0 : -1
    }

    function backOrClose() {
        if (mode === "actions") {
            mode = "items"
            scaffold.setQuery("")
            refilter()
            return
        }

        if (mode === "auth") {
            closeBitwarden()
            return
        }

        closeBitwarden()
    }

    function activateSelection() {
        if (selectedIndex < 0 || selectedIndex >= visibleItems.length) return

        if (mode === "items") {
            openActionsFor(visibleItems[selectedIndex])
            return
        }

        if (mode === "actions" && selectedItem) {
            var action = visibleItems[selectedIndex]
            if (action.key === "username") {
                copyValue(selectedItem.username, currentName, "username")
            } else if (action.key === "password") {
                copyValue(selectedItem.password, currentName, "password")
            } else if (action.key === "totp") {
                loadTotp(selectedItem.id)
            }
        }
    }

    Process {
        id: bwProcess
        stdout: StdioCollector {
            onStreamFinished: bitwarden.handleBwOutput(bitwarden.pendingOp, this.text)
        }
    }

    Timer {
        id: authFocusTimer
        interval: 1
        repeat: false
        onTriggered: authPasswordInput.forceActiveFocus()
    }

    Rectangle {
        anchors.fill: parent
        color: "#33000000"
        border.width: 1
        border.color: "#3fffffff"

        Item {
            anchors.fill: parent
            visible: bitwarden.mode === "auth"

            Rectangle {
                anchors.fill: parent
                color: "transparent"
            }

            ColumnLayout {
                anchors.centerIn: parent
                width: Math.min(parent.width - 48, 420)
                spacing: 10

                Text {
                    Layout.fillWidth: true
                    text: "Unlock Bitwarden"
                    color: "#ffffff"
                    font.family: "VictorMono NFM"
                    font.pixelSize: 18
                }

                TextField {
                    id: authPasswordInput
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    echoMode: TextInput.Password
                    placeholderText: "Master password"
                    color: "#ffffff"
                    placeholderTextColor: "#88ffffff"
                    font.family: "VictorMono NFM"
                    font.pixelSize: 14
                    text: bitwarden.authPassword
                    onTextChanged: bitwarden.authPassword = text

                    background: Rectangle {
                        color: "#14ffffff"
                        border.width: 1
                        border.color: "#4dffffff"
                    }

                    Keys.onPressed: function(event) {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            bitwarden.unlock()
                            event.accepted = true
                        } else if (event.key === Qt.Key_Escape) {
                            bitwarden.closeBitwarden()
                            event.accepted = true
                        }
                    }
                }

                Button {
                    id: unlockButton
                    Layout.fillWidth: true
                    text: "Unlock"
                    enabled: !bitwarden.loading && bitwarden.authPassword.length > 0
                    onClicked: bitwarden.unlock()

                    background: Rectangle {
                        radius: 0
                        color: unlockButton.enabled ? (unlockButton.down ? "#e5ffffff" : "#ffffff") : "#33ffffff"
                        border.width: 1
                        border.color: unlockButton.enabled ? "#ffffff" : "#55ffffff"
                    }

                    contentItem: Text {
                        text: unlockButton.text
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: unlockButton.enabled ? "#000000" : "#a0a0a0"
                        font.family: "VictorMono NFM"
                        font.pixelSize: 14
                    }
                }

                Text {
                    Layout.fillWidth: true
                    text: bitwarden.authStatusText
                    color: "#ff9f9f"
                    font.family: "VictorMono NFM"
                    font.pixelSize: 12
                    wrapMode: Text.WordWrap
                }
            }
        }

        Scaffold {
            id: scaffold
            anchors.fill: parent
            visible: bitwarden.mode !== "auth"
            placeholderText: bitwarden.mode === "actions" ? bitwarden.currentName : "Bitwarden"
            model: bitwarden.visibleItems
            selectedIndex: bitwarden.selectedIndex
            onSelectedIndexChanged: bitwarden.selectedIndex = selectedIndex
            onQueryChanged: bitwarden.refilter()
            onActivateRequested: bitwarden.activateSelection()
            onCloseRequested: bitwarden.backOrClose()

            delegate: Rectangle {
                id: row
                required property int index
                required property var modelData

                width: scaffold.listWidth
                height: 40
                color: row.index === bitwarden.selectedIndex ? "#ffffff" : "transparent"

                Text {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    text: row.modelData.text
                    color: row.index === bitwarden.selectedIndex ? "#000000" : "#ffffff"
                    font.family: "VictorMono NFM"
                    font.pixelSize: 14
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: bitwarden.selectedIndex = row.index
                    onClicked: {
                        bitwarden.selectedIndex = row.index
                        bitwarden.activateSelection()
                    }
                }
            }
        }

        Rectangle {
            anchors.fill: parent
            visible: bitwarden.loading
            color: "#7a000000"

            Text {
                anchors.centerIn: parent
                text: "Loading..."
                color: "#ffffff"
                font.family: "VictorMono NFM"
                font.pixelSize: 16
            }
        }
    }
}
