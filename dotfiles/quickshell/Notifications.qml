pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

Item {
    id: notifications

    property var popupItems: []

    function toArray(source) {
        if (!source) return []
        if (Array.isArray(source)) return source
        if (source.values) return source.values

        var out = []
        if (typeof source.count === "number" && typeof source.get === "function") {
            for (var i = 0; i < source.count; i++) {
                var item = source.get(i)
                if (item) out.push(item)
            }
        }
        return out
    }

    function removePopupById(id) {
        var out = []
        for (var i = 0; i < popupItems.length; i++) {
            var n = popupItems[i]
            if (!n || n.id === id) continue
            out.push(n)
        }
        popupItems = out
    }

    function addPopup(notification) {
        removePopupById(notification.id)
        popupItems = popupItems.concat([notification])
    }

    function clearAll() {
        var all = toArray(server.trackedNotifications)
        for (var i = 0; i < all.length; i++) {
            if (all[i]) all[i].dismiss()
        }
        popupItems = []
    }

    function openCenter() {
        center.visible = true
    }

    function iconSourceFor(notification) {
        if (!notification) return Quickshell.iconPath("dialog-information", "application-x-executable")

        function asSource(value) {
            if (!value) return ""
            var text = String(value)
            if (text.length === 0) return ""
            if (text.indexOf("://") !== -1) return text
            if (text.charAt(0) === "/") return "file://" + text

            var resolved = Quickshell.iconPath(text, "")
            return resolved && resolved.length > 0 ? resolved : ""
        }

        var direct = [
            notification.image,
            notification.imagePath,
            notification.appIcon,
            notification.appIconName
        ]

        for (var i = 0; i < direct.length; i++) {
            var src = asSource(direct[i])
            if (src.length > 0) return src
        }

        var desktop = notification.desktopEntry ? String(notification.desktopEntry) : ""
        if (desktop.length > 0) {
            var slash = desktop.lastIndexOf("/")
            var base = slash >= 0 ? desktop.slice(slash + 1) : desktop
            if (base.endsWith(".desktop")) base = base.slice(0, -8)
            var desktopSrc = asSource(base)
            if (desktopSrc.length > 0) return desktopSrc
        }

        var appNameSrc = asSource(notification.appName)
        if (appNameSrc.length > 0) return appNameSrc

        return Quickshell.iconPath("dialog-information", "application-x-executable")
    }

    function closeCenter() {
        center.visible = false
    }

    function toggleCenter() {
        if (center.visible) closeCenter()
        else openCenter()
    }

    NotificationServer {
        id: server
        actionsSupported: true
        bodyMarkupSupported: true
        bodyHyperlinksSupported: false
        imageSupported: true
        bodyImagesSupported: true
        persistenceSupported: true

        onNotification: function(notification) {
            notification.tracked = true
            notifications.addPopup(notification)
        }
    }

    PanelWindow {
        id: popup
        visible: notifications.popupItems.length > 0
        focusable: false
        color: "transparent"
        aboveWindows: true
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "quickshell-notifications-popup"
        implicitWidth: 360
        implicitHeight: Math.min(700, popupColumn.implicitHeight)

        anchors {
            top: true
            right: true
        }

        margins {
            top: 8
            right: 8
        }

        ColumnLayout {
            id: popupColumn
            anchors.fill: parent
            spacing: 8

            Repeater {
                model: notifications.popupItems

                delegate: Rectangle {
                    id: toast
                    required property var modelData

                    Layout.fillWidth: true
                    implicitHeight: content.implicitHeight + 20
                    radius: 0
                    color: "#cc000000"
                    border.width: 1
                    border.color: "#47ffffff"

                    Timer {
                        interval: {
                            var t = toast.modelData && toast.modelData.expireTimeout ? Number(toast.modelData.expireTimeout) : 5
                            if (!Number.isFinite(t) || t <= 0) t = 5
                            return Math.floor(t * 1000)
                        }
                        running: true
                        repeat: false
                        onTriggered: {
                            notifications.removePopupById(toast.modelData ? toast.modelData.id : -1)
                        }
                    }

                    ColumnLayout {
                        id: content
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 6

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            IconImage {
                                Layout.preferredWidth: 16
                                Layout.preferredHeight: 16
                                source: notifications.iconSourceFor(toast.modelData)
                            }

                            Text {
                                Layout.fillWidth: true
                                text: toast.modelData && toast.modelData.appName ? toast.modelData.appName : "Notification"
                                color: "#ffffff"
                                font.family: "VictorMono NFM"
                                font.pixelSize: 13
                                elide: Text.ElideRight
                            }

                            MouseArea {
                                Layout.preferredWidth: 18
                                Layout.preferredHeight: 18
                                onClicked: {
                                    if (toast.modelData) toast.modelData.dismiss()
                                    notifications.removePopupById(toast.modelData ? toast.modelData.id : -1)
                                }

                                Text {
                                    anchors.centerIn: parent
                                    text: "x"
                                    color: "#cfcfcf"
                                    font.family: "VictorMono NFM"
                                    font.pixelSize: 12
                                }
                            }
                        }

                        Text {
                            Layout.fillWidth: true
                            text: toast.modelData && toast.modelData.summary ? toast.modelData.summary : ""
                            color: "#ffffff"
                            font.family: "VictorMono NFM"
                            font.pixelSize: 14
                            font.bold: true
                            wrapMode: Text.Wrap
                        }

                        Text {
                            Layout.fillWidth: true
                            text: toast.modelData && toast.modelData.body ? toast.modelData.body : ""
                            textFormat: Text.PlainText
                            color: "#d4d4d4"
                            font.family: "VictorMono NFM"
                            font.pixelSize: 13
                            wrapMode: Text.Wrap
                            visible: text.length > 0
                        }
                    }
                }
            }
        }
    }

    PanelWindow {
        id: center
        visible: false
        focusable: true
        color: "transparent"
        aboveWindows: true
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "quickshell-notifications-center"
        implicitWidth: 380
        implicitHeight: screen ? Math.floor(screen.height * 0.85) : 700

        anchors {
            top: true
            right: true
        }

        margins {
            top: 8
            right: 8
        }

        Rectangle {
            anchors.fill: parent
            color: "#cc000000"
            border.width: 1
            border.color: "#47ffffff"

            Keys.onPressed: function(event) {
                if (event.key === Qt.Key_Escape) {
                    center.visible = false
                    event.accepted = true
                }
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 8

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        Layout.fillWidth: true
                        text: "Notifications"
                        color: "#ffffff"
                        font.family: "VictorMono NFM"
                        font.pixelSize: 16
                        font.bold: true
                    }

                    Rectangle {
                        Layout.preferredHeight: 26
                        Layout.preferredWidth: 58
                        color: "#22ffffff"
                        border.width: 1
                        border.color: "#47ffffff"

                        MouseArea {
                            anchors.fill: parent
                            onClicked: notifications.clearAll()
                        }

                        Text {
                            anchors.centerIn: parent
                            text: "Clear"
                            color: "#ffffff"
                            font.family: "VictorMono NFM"
                            font.pixelSize: 12
                        }
                    }
                }

                Flickable {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    contentWidth: width
                    contentHeight: centerList.implicitHeight
                    clip: true

                    ColumnLayout {
                        id: centerList
                        width: parent.width
                        spacing: 8

                        Repeater {
                            model: server.trackedNotifications

                            delegate: Rectangle {
                                id: card
                                required property var modelData
                                width: centerList.width
                                implicitHeight: cardContent.implicitHeight + 20
                                color: "#1bffffff"
                                border.width: 1
                                border.color: "#47ffffff"

                                ColumnLayout {
                                    id: cardContent
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    spacing: 6

                                    RowLayout {
                                        Layout.fillWidth: true
                                        spacing: 8

                                        IconImage {
                                            Layout.preferredWidth: 16
                                            Layout.preferredHeight: 16
                                            source: notifications.iconSourceFor(card.modelData)
                                        }

                                        Text {
                                            Layout.fillWidth: true
                                            text: card.modelData && card.modelData.appName ? card.modelData.appName : "Notification"
                                            color: "#ffffff"
                                            font.family: "VictorMono NFM"
                                            font.pixelSize: 12
                                            elide: Text.ElideRight
                                        }

                                        MouseArea {
                                            Layout.preferredWidth: 18
                                            Layout.preferredHeight: 18
                                            onClicked: {
                                                if (card.modelData) card.modelData.dismiss()
                                                notifications.removePopupById(card.modelData ? card.modelData.id : -1)
                                            }

                                            Text {
                                                anchors.centerIn: parent
                                                text: "x"
                                                color: "#cfcfcf"
                                                font.family: "VictorMono NFM"
                                                font.pixelSize: 12
                                            }
                                        }
                                    }

                                    Text {
                                        Layout.fillWidth: true
                                        text: card.modelData && card.modelData.summary ? card.modelData.summary : ""
                                        color: "#ffffff"
                                        font.family: "VictorMono NFM"
                                        font.pixelSize: 14
                                        font.bold: true
                                        wrapMode: Text.Wrap
                                    }

                                    Text {
                                        Layout.fillWidth: true
                                        text: card.modelData && card.modelData.body ? card.modelData.body : ""
                                        textFormat: Text.PlainText
                                        color: "#d4d4d4"
                                        font.family: "VictorMono NFM"
                                        font.pixelSize: 13
                                        wrapMode: Text.Wrap
                                        visible: text.length > 0
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
