pragma ComponentBehavior: Bound
import QtQuick

import Quickshell

PanelWindow {
  id: session

  property var activeItems: baseItems
  property var baseItems: [
    {
      icon: "󰍃",
      label: "Sign out",
      action: "logout",
      needsConfirm: true,
      confirmText: "Sign out?"
    },
    {
      icon: "󰌾",
      label: "Lock",
      action: "lock",
      needsConfirm: false
    },
    {
      icon: "󰜉",
      label: "Reboot",
      action: "reboot",
      needsConfirm: true,
      confirmText: "Reboot?"
    },
    {
      icon: "󰐥",
      label: "Shutdown",
      action: "shutdown",
      needsConfirm: true,
      confirmText: "Shutdown?"
    }
  ]
  property var confirmItems: [
    {
      icon: "󰄬",
      label: "No",
      action: "cancel"
    },
    {
      icon: "󰄭",
      label: "Yes",
      action: "confirm"
    }
  ]
  property var pendingItem: null
  property int selectedIndex: 0
  property string titleText: "Session"

  function activateSelection() {
    if (selectedIndex < 0 || selectedIndex >= activeItems.length)
      return;
    var item = activeItems[selectedIndex];

    if (pendingItem) {
      if (item.action === "confirm") {
        runAction(pendingItem.action);
        closeSession();
      } else {
        pendingItem = null;
        titleText = "Session";
        scaffold.setQuery("");
        refilter();
      }
      return;
    }

    if (item.needsConfirm) {
      pendingItem = item;
      titleText = item.confirmText;
      scaffold.setQuery("");
      refilter();
      return;
    }

    runAction(item.action);
    closeSession();
  }

  function closeSession() {
    visible = false;
  }

  function openSession() {
    pendingItem = null;
    activeItems = baseItems;
    titleText = "Session";
    selectedIndex = activeItems.length > 0 ? 0 : -1;
    scaffold.setQuery("");
    visible = true;
    scaffold.focusPrompt();
  }

  function refilter() {
    var q = scaffold.queryText.toLowerCase();
    var source = pendingItem ? confirmItems : baseItems;
    var out = [];

    for (var i = 0; i < source.length; i++) {
      var item = source[i];
      var text = (item.icon + " " + item.label).toLowerCase();
      if (q.length === 0 || text.indexOf(q) !== -1) {
        out.push(item);
      }
    }

    activeItems = out;
    selectedIndex = out.length > 0 ? 0 : -1;
  }

  function runAction(action) {
    if (action === "lock") {
      Quickshell.execDetached(["hyprlock"]);
    } else if (action === "logout") {
      Quickshell.execDetached(["hyprctl", "dispatch", "exit"]);
    } else if (action === "reboot") {
      Quickshell.execDetached(["systemctl", "reboot"]);
    } else if (action === "shutdown") {
      Quickshell.execDetached(["systemctl", "poweroff"]);
    }
  }

  aboveWindows: true
  color: "transparent"
  focusable: true
  implicitHeight: 320
  implicitWidth: 520
  visible: false

  anchors {
    left: true
    top: true
  }

  margins {
    left: screen ? Math.floor((screen.width - implicitWidth) / 2) : 0
    top: screen ? Math.floor((screen.height - implicitHeight) / 2) : 0
  }

  Scaffold {
    id: scaffold

    anchors.fill: parent
    model: session.activeItems
    placeholderText: session.titleText
    selectedIndex: session.selectedIndex

    delegate: Rectangle {
      id: row

      required property int index
      required property var modelData

      color: row.index === session.selectedIndex ? "#ffffff" : "transparent"
      height: 40
      width: scaffold.listWidth

      Text {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        color: row.index === session.selectedIndex ? "#000000" : "#ffffff"
        elide: Text.ElideRight
        font.family: "VictorMono NFM"
        font.pixelSize: 14
        text: row.modelData.icon + "  " + row.modelData.label
        verticalAlignment: Text.AlignVCenter
      }

      MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
          session.selectedIndex = row.index;
          session.activateSelection();
        }
        onEntered: session.selectedIndex = row.index
      }
    }

    onActivateRequested: session.activateSelection()
    onCloseRequested: session.closeSession()
    onQueryChanged: session.refilter()
    onSelectedIndexChanged: session.selectedIndex = selectedIndex
  }
}
