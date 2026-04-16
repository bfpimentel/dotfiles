pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts

import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Item {
  id: volumeWidget

  property int currentVolume: 0
  property bool isMuted: false
  property bool showPopup: false

  function getVolumeIcon() {
    if (isMuted || currentVolume === 0)
      return "MUTE";
    if (currentVolume < 30)
      return "LOW";
    if (currentVolume < 60)
      return "MID";
    return "HIGH";
  }

  function get_change_volume_command(operation) {
    return ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%+", ">/dev/null", "2>&1", ";", "wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"];
  }

  function lower() {
    volumeWidget.showPopup = true;
    process.command = ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%-"];
    process.running = true;
  }

  function raise() {
    volumeWidget.showPopup = true;
    process.command = ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%+", ">/dev/null", "2>&1", ";", "wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"];
    process.running = true;
  }

  function toggle() {
    volumeWidget.showPopup = true;
    process.command = ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"];
    process.running = true;
  }

  function updateVolume(output) {
    var text = String(output).trim();
    if (text.length === 0)
      return;
    var parts = text.split(":");
    if (parts.length < 2)
      return;
    var volStr = parts[1].trim();
    var muteFlag = volStr.indexOf("[MUTED]") !== -1;
    var volNum = parseFloat(volStr.replace("[MUTED]", "").trim());

    if (!isNaN(volNum)) {
      currentVolume = Math.round(volNum * 100);
      isMuted = muteFlag;
    }
  }

  Component.onCompleted: {
    process.command = ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"];
    process.running = true;
  }

  Process {
    id: process

    command: []
    running: false

    stdout: StdioCollector {
      onStreamFinished: volumeWidget.updateVolume(this.text)
    }
  }

  Timer {
    id: popupTimer

    interval: 2000
    repeat: false
    running: false

    onTriggered: {
      volumeWidget.showPopup = false;
    }
  }

  PanelWindow {
    id: volumePopup

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell-volume-popup"
    aboveWindows: true
    color: "transparent"
    focusable: false
    implicitHeight: 60
    implicitWidth: 200
    visible: volumeWidget.showPopup

    anchors {
      left: true
      top: true
    }

    margins {
      left: screen ? Math.floor((screen.width - implicitWidth) / 2) : 0
      top: 40
    }

    Rectangle {
      anchors.fill: parent
      border.color: "#47ffffff"
      border.width: 1
      color: "#cc000000"

      RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        Text {
          color: "#ffffff"
          font.bold: true
          font.family: "VictorMono NFM"
          font.pixelSize: 14
          text: volumeWidget.getVolumeIcon()
        }

        ColumnLayout {
          Layout.fillWidth: true
          spacing: 4

          Text {
            color: "#ffffff"
            font.bold: true
            font.family: "VictorMono NFM"
            font.pixelSize: 14
            text: volumeWidget.isMuted ? "0%" : volumeWidget.currentVolume + "%"
          }

          Rectangle {
            Layout.fillWidth: true
            color: "#33ffffff"
            implicitHeight: 4

            Rectangle {
              color: "#ffffff"
              height: parent.height
              width: parent.width * (volumeWidget.isMuted ? 0 : volumeWidget.currentVolume / 100)
            }
          }
        }
      }
    }
  }
}
