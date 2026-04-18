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
      trigger: "A",
      action: "launcher"
    },
    {
      icon: "󰟵 ",
      label: "Bitwarden",
      trigger: "B",
      action: "bitwarden"
    },
    {
      icon: "󰅌 ",
      label: "Clipboard",
      trigger: "C",
      action: "clipboard"
    },
    {
      icon: "󰍹 ",
      label: "Processes",
      trigger: "P",
      action: "processes"
    },
    {
      icon: "󰄄 ",
      trigger: "S",
      label: "Screenshots",
      action: "screenshot"
    },
    {
      icon: "󰐥 ",
      trigger: "Q",
      label: "Session",
      action: "session"
    }
  ]
  property var workspaceNames: ["B", "M", "T", "W", "X"]

  signal requestBitwarden
  signal requestClipboard
  signal requestLauncher
  signal requestProcesses
  signal requestScreenshot
  signal requestSession

  function closeDashboard() {
    visible = false;
  }

  function openDashboard() {
    refreshClock();
    visible = true;
    dashboardRoot.forceActiveFocus();
  }

  function refreshClock() {
    var now = new Date();
    currentTime = Qt.formatTime(now, "hh:mm");
    currentDate = Qt.formatDate(now, "ddd dd MMM");
  }

  function requestAndClose(action) {
    switch (action) {
    case ("launcher"):
      dashboard.requestLauncher();
      break;
    case "bitwarden":
      dashboard.requestBitwarden();
      break;
    case "clipboard":
      dashboard.requestClipboard();
      break;
    case "processes":
      dashboard.requestProcesses();
      break;
    case "screenshot":
      dashboard.requestScreenshot();
      break;
    case "session":
      dashboard.requestSession();
      break;
    default:
      return;
    }

    closeDashboard();
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
      // Actions
      if (event.key === Qt.Key_Escape) {
        dashboard.closeDashboard();
        event.accepted = true;
        return;
      }

      // Items
      switch (event.key) {
      case Qt.Key_A:
        dashboard.requestLauncher();
        break;
      case Qt.Key_B:
        dashboard.requestBitwarden();
        break;
      case Qt.Key_C:
        dashboard.requestClipboard();
        break;
      case Qt.Key_P:
        dashboard.requestProcesses();
        break;
      case Qt.Key_S:
        dashboard.requestScreenshot();
        break;
      case Qt.Key_Q:
        dashboard.requestSession();
        break;
      default:
        return;
      }

      closeDashboard();
      event.accepted = true;
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
        spacing: 10

        Repeater {
          model: dashboard.menuItems

          delegate: RowLayout {
            id: menuItem

            required property int index
            required property var modelData

            Layout.fillWidth: true
            Layout.leftMargin: 4
            Layout.rightMargin: 4

            Text {
              Layout.fillWidth: true
              color: "#ffffff"
              font.family: "VictorMono NFM"
              font.pixelSize: 16
              horizontalAlignment: Text.AlignLeft
              text: menuItem.modelData.icon + " " + menuItem.modelData.label
              verticalAlignment: Text.AlignVCenter
            }

            Text {
              color: "#cccccc"
              font.family: "VictorMono NFM"
              font.pixelSize: 16
              horizontalAlignment: Text.AlignRight
              text: menuItem.modelData.trigger
              verticalAlignment: Text.AlignVCenter
            }
          }
        }
      }
    }
  }
}
