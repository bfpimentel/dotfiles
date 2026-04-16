pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts

import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Wayland
import Quickshell.Widgets

Item {
  id: notifications

  property var popupItems: []

  function addPopup(notification) {
    removePopupById(notification.id);
    popupItems = popupItems.concat([notification]);
  }

  function clearAll() {
    var all = toArray(server.trackedNotifications);
    for (var i = 0; i < all.length; i++) {
      if (all[i])
        all[i].dismiss();
    }
    popupItems = [];
  }

  function closeCenter() {
    center.visible = false;
  }

  function iconSourceFor(notification) {
    if (!notification)
      return Quickshell.iconPath("dialog-information", "application-x-executable");

    function asSource(value) {
      if (!value)
        return "";
      var text = String(value);
      if (text.length === 0)
        return "";
      if (text.indexOf("://") !== -1)
        return text;
      if (text.charAt(0) === "/")
        return "file://" + text;

      var resolved = Quickshell.iconPath(text, "");
      return resolved && resolved.length > 0 ? resolved : "";
    }

    var direct = [notification.image, notification.imagePath, notification.appIcon, notification.appIconName];

    for (var i = 0; i < direct.length; i++) {
      var src = asSource(direct[i]);
      if (src.length > 0)
        return src;
    }

    var desktop = notification.desktopEntry ? String(notification.desktopEntry) : "";
    if (desktop.length > 0) {
      var slash = desktop.lastIndexOf("/");
      var base = slash >= 0 ? desktop.slice(slash + 1) : desktop;
      if (base.endsWith(".desktop"))
        base = base.slice(0, -8);
      var desktopSrc = asSource(base);
      if (desktopSrc.length > 0)
        return desktopSrc;
    }

    var appNameSrc = asSource(notification.appName);
    if (appNameSrc.length > 0)
      return appNameSrc;

    return Quickshell.iconPath("dialog-information", "application-x-executable");
  }

  function openCenter() {
    center.visible = true;
  }

  function removePopupById(id) {
    var out = [];
    for (var i = 0; i < popupItems.length; i++) {
      var n = popupItems[i];
      if (!n || n.id === id)
        continue;
      out.push(n);
    }
    popupItems = out;
  }

  function toArray(source) {
    if (!source)
      return [];
    if (Array.isArray(source))
      return source;
    if (source.values)
      return source.values;

    var out = [];
    if (typeof source.count === "number" && typeof source.get === "function") {
      for (var i = 0; i < source.count; i++) {
        var item = source.get(i);
        if (item)
          out.push(item);
      }
    }
    return out;
  }

  function toggleCenter() {
    if (center.visible)
      closeCenter();
    else
      openCenter();
  }

  NotificationServer {
    id: server

    actionsSupported: true
    bodyHyperlinksSupported: false
    bodyImagesSupported: true
    bodyMarkupSupported: true
    imageSupported: true
    persistenceSupported: true

    onNotification: function (notification) {
      notification.tracked = true;
      notifications.addPopup(notification);
    }
  }

  PanelWindow {
    id: popup

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell-notifications-popup"
    aboveWindows: true
    color: "transparent"
    focusable: false
    implicitHeight: Math.min(700, popupColumn.implicitHeight)
    implicitWidth: 360
    visible: notifications.popupItems.length > 0

    anchors {
      right: true
      top: true
    }

    margins {
      right: 8
      top: 8
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
          border.color: "#47ffffff"
          border.width: 1
          color: "#cc000000"
          implicitHeight: content.implicitHeight + 20
          radius: 0

          Timer {
            interval: {
              var t = toast.modelData && toast.modelData.expireTimeout ? Number(toast.modelData.expireTimeout) : 5;
              if (!Number.isFinite(t) || t <= 0)
                t = 5;
              return Math.floor(t * 1000);
            }
            repeat: false
            running: true

            onTriggered: {
              notifications.removePopupById(toast.modelData ? toast.modelData.id : -1);
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
                Layout.preferredHeight: 16
                Layout.preferredWidth: 16
                source: notifications.iconSourceFor(toast.modelData)
              }

              Text {
                Layout.fillWidth: true
                color: "#ffffff"
                elide: Text.ElideRight
                font.family: "VictorMono NFM"
                font.pixelSize: 13
                text: toast.modelData && toast.modelData.appName ? toast.modelData.appName : "Notification"
              }

              MouseArea {
                Layout.preferredHeight: 18
                Layout.preferredWidth: 18

                onClicked: {
                  if (toast.modelData)
                    toast.modelData.dismiss();
                  notifications.removePopupById(toast.modelData ? toast.modelData.id : -1);
                }

                Text {
                  anchors.centerIn: parent
                  color: "#cfcfcf"
                  font.family: "VictorMono NFM"
                  font.pixelSize: 12
                  text: "x"
                }
              }
            }

            Text {
              Layout.fillWidth: true
              color: "#ffffff"
              font.bold: true
              font.family: "VictorMono NFM"
              font.pixelSize: 14
              text: toast.modelData && toast.modelData.summary ? toast.modelData.summary : ""
              wrapMode: Text.Wrap
            }

            Text {
              Layout.fillWidth: true
              color: "#d4d4d4"
              font.family: "VictorMono NFM"
              font.pixelSize: 13
              text: toast.modelData && toast.modelData.body ? toast.modelData.body : ""
              textFormat: Text.PlainText
              visible: text.length > 0
              wrapMode: Text.Wrap
            }
          }
        }
      }
    }
  }

  PanelWindow {
    id: center

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell-notifications-center"
    aboveWindows: true
    color: "transparent"
    focusable: true
    implicitHeight: screen ? Math.floor(screen.height * 0.85) : 700
    implicitWidth: 380
    visible: false

    anchors {
      right: true
      top: true
    }

    margins {
      right: 8
      top: 8
    }

    Rectangle {
      anchors.fill: parent
      border.color: "#47ffffff"
      border.width: 1
      color: "#cc000000"

      Keys.onPressed: function (event) {
        if (event.key === Qt.Key_Escape) {
          center.visible = false;
          event.accepted = true;
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
            color: "#ffffff"
            font.bold: true
            font.family: "VictorMono NFM"
            font.pixelSize: 16
            text: "Notifications"
          }

          Rectangle {
            Layout.preferredHeight: 26
            Layout.preferredWidth: 58
            border.color: "#47ffffff"
            border.width: 1
            color: "#22ffffff"

            MouseArea {
              anchors.fill: parent

              onClicked: notifications.clearAll()
            }

            Text {
              anchors.centerIn: parent
              color: "#ffffff"
              font.family: "VictorMono NFM"
              font.pixelSize: 12
              text: "Clear"
            }
          }
        }

        Flickable {
          Layout.fillHeight: true
          Layout.fillWidth: true
          clip: true
          contentHeight: centerList.implicitHeight
          contentWidth: width

          ColumnLayout {
            id: centerList

            spacing: 8
            width: parent.width

            Repeater {
              model: server.trackedNotifications

              delegate: Rectangle {
                id: card

                required property var modelData

                border.color: "#47ffffff"
                border.width: 1
                color: "#1bffffff"
                implicitHeight: cardContent.implicitHeight + 20
                width: centerList.width

                ColumnLayout {
                  id: cardContent

                  anchors.fill: parent
                  anchors.margins: 10
                  spacing: 6

                  RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    IconImage {
                      Layout.preferredHeight: 16
                      Layout.preferredWidth: 16
                      source: notifications.iconSourceFor(card.modelData)
                    }

                    Text {
                      Layout.fillWidth: true
                      color: "#ffffff"
                      elide: Text.ElideRight
                      font.family: "VictorMono NFM"
                      font.pixelSize: 12
                      text: card.modelData && card.modelData.appName ? card.modelData.appName : "Notification"
                    }

                    MouseArea {
                      Layout.preferredHeight: 18
                      Layout.preferredWidth: 18

                      onClicked: {
                        if (card.modelData)
                          card.modelData.dismiss();
                        notifications.removePopupById(card.modelData ? card.modelData.id : -1);
                      }

                      Text {
                        anchors.centerIn: parent
                        color: "#cfcfcf"
                        font.family: "VictorMono NFM"
                        font.pixelSize: 12
                        text: "x"
                      }
                    }
                  }

                  Text {
                    Layout.fillWidth: true
                    color: "#ffffff"
                    font.bold: true
                    font.family: "VictorMono NFM"
                    font.pixelSize: 14
                    text: card.modelData && card.modelData.summary ? card.modelData.summary : ""
                    wrapMode: Text.Wrap
                  }

                  Text {
                    Layout.fillWidth: true
                    color: "#d4d4d4"
                    font.family: "VictorMono NFM"
                    font.pixelSize: 13
                    text: card.modelData && card.modelData.body ? card.modelData.body : ""
                    textFormat: Text.PlainText
                    visible: text.length > 0
                    wrapMode: Text.Wrap
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
