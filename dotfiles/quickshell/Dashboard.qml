pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts

import Quickshell
import Quickshell.Hyprland

PanelWindow {
  id: dashboard

  property string currentDate: ""
  property string currentTime: ""
  property string currentWorkspace: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.name : ""
  property var menuItems: [
    {
      icon: "󰀻 ",
      label: "Applications",
      action: "launcher"
    },
    {
      icon: "󰟵 ",
      label: "Bitwarden",
      action: "bitwarden"
    },
    {
      icon: "󰅌 ",
      label: "Clipboard",
      action: "clipboard"
    },
    {
      icon: "󰍹 ",
      label: "Processes",
      action: "processes"
    },
    {
      icon: "󰄄 ",
      label: "Screenshots",
      action: "screenshot"
    },
    {
      icon: "󰐥 ",
      label: "Session",
      action: "session"
    }
  ]
  property int selectedIndex: 0
  property var workspaceNames: ["B", "M", "T", "W", "X"]

  signal requestBitwarden
  signal requestClipboard
  signal requestLauncher
  signal requestProcesses
  signal requestScreenshot
  signal requestSession

  function activateSelection() {
    if (selectedIndex < 0 || selectedIndex >= menuItems.length)
      return;
    var item = menuItems[selectedIndex];

    if (item.action === "launcher") {
      dashboard.requestLauncher();
      closeDashboard();
      return;
    }

    if (item.action === "bitwarden") {
      dashboard.requestBitwarden();
      closeDashboard();
      return;
    }

    if (item.action === "clipboard") {
      dashboard.requestClipboard();
      closeDashboard();
      return;
    }

    if (item.action === "session") {
      dashboard.requestSession();
      closeDashboard();
      return;
    }

    if (item.action === "processes") {
      dashboard.requestProcesses();
      closeDashboard();
      return;
    }

    if (item.action === "screenshot") {
      dashboard.requestScreenshot();
      closeDashboard();
      return;
    }

    Quickshell.execDetached(item.command);
    closeDashboard();
  }

  function closeDashboard() {
    visible = false;
  }

  function move(delta) {
    if (menuItems.length === 0)
      return;
    var next = selectedIndex + delta;
    if (next < 0)
      next = menuItems.length - 1;
    if (next >= menuItems.length)
      next = 0;
    selectedIndex = next;
  }

  function openDashboard() {
    refreshClock();
    selectedIndex = 0;
    visible = true;
    dashboardRoot.forceActiveFocus();
  }

  function refreshClock() {
    var now = new Date();
    currentTime = Qt.formatTime(now, "hh:mm");
    currentDate = Qt.formatDate(now, "ddd dd MMM");
  }

  aboveWindows: true
  color: "transparent"
  focusable: true
  implicitHeight: dashboardRoot.implicitHeight
  implicitWidth: 600
  visible: false

  anchors {
    left: true
    top: true
  }

  margins {
    left: screen ? Math.floor((screen.width - implicitWidth) / 2) : 0
    top: screen ? Math.floor((screen.height - implicitHeight) / 2) : 0
  }

  Timer {
    interval: 1000
    repeat: true
    running: dashboard.visible

    onTriggered: dashboard.refreshClock()
  }

  Rectangle {
    id: dashboardRoot

    anchors.fill: parent
    border.color: "#47ffffff"
    border.width: 1
    color: "#cc000000"
    focus: true
    implicitHeight: contentColumn.implicitHeight + 32

    Keys.onPressed: function (event) {
      if (event.key === Qt.Key_Escape) {
        dashboard.closeDashboard();
        event.accepted = true;
      } else if (event.key === Qt.Key_Down || (event.key === Qt.Key_N && (event.modifiers & Qt.ControlModifier))) {
        dashboard.move(1);
        event.accepted = true;
      } else if (event.key === Qt.Key_Up || (event.key === Qt.Key_P && (event.modifiers & Qt.ControlModifier))) {
        dashboard.move(-1);
        event.accepted = true;
      } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
        dashboard.activateSelection();
        event.accepted = true;
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
          color: "#ffffff"
          font.bold: true
          font.family: "VictorMono NFM"
          font.pixelSize: 38
          text: dashboard.currentTime
        }

        Text {
          color: "#a7ffffff"
          font.family: "VictorMono NFM"
          font.pixelSize: 14
          text: dashboard.currentDate
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

            border.color: dashboard.currentWorkspace === workspacePill.modelData ? "#ffffff" : "#44ffffff"
            border.width: 1
            color: dashboard.currentWorkspace === workspacePill.modelData ? "#f0ffffff" : "#1cffffff"
            implicitHeight: 26
            implicitWidth: 34

            Text {
              anchors.centerIn: parent
              color: dashboard.currentWorkspace === workspacePill.modelData ? "#000000" : "#ffffff"
              font.family: "VictorMono NFM"
              font.pixelSize: 13
              text: workspacePill.modelData
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
            color: dashboard.selectedIndex === menuRow.index ? "#ffffff" : "transparent"
            implicitHeight: 40

            Text {
              anchors.fill: parent
              anchors.leftMargin: 12
              anchors.rightMargin: 12
              color: dashboard.selectedIndex === menuRow.index ? "#000000" : "#ffffff"
              font.family: "VictorMono NFM"
              font.pixelSize: 15
              horizontalAlignment: Text.AlignLeft
              text: menuRow.modelData.icon + "  " + menuRow.modelData.label
              verticalAlignment: Text.AlignVCenter
            }

            MouseArea {
              anchors.fill: parent
              hoverEnabled: true

              onClicked: {
                dashboard.selectedIndex = menuRow.index;
                dashboard.activateSelection();
              }
              onEntered: dashboard.selectedIndex = menuRow.index
            }
          }
        }
      }
    }
  }
}
