import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets

Scope {
  id: root

  property bool shouldShowOsd: false

  PwObjectTracker {
    objects: [Pipewire.defaultAudioSink]
  }

  Connections {
    function onVolumeChanged() {
      Pipewire.defaultAudioSink?.audio;
      root.shouldShowOsd = true;
      hideTimer.restart();
    }

    target: Pipewire.defaultAudioSink?.audio
  }

  Timer {
    id: hideTimer

    interval: 1000

    onTriggered: root.shouldShowOsd = false
  }

  LazyLoader {
    active: root.shouldShowOsd

    PanelWindow {
      anchors.top: true
      color: "transparent"
      exclusiveZone: 0
      focusable: false
      implicitHeight: 50
      implicitWidth: 200
      margins.top: 16

      // An empty click mask prevents the window from blocking mouse events.
      mask: Region {
      }

      Rectangle {
        anchors.fill: parent
        border.color: "#47ffffff"
        border.width: 1
        color: "#cc000000"
        radius: 0

        RowLayout {
          anchors {
            fill: parent
            leftMargin: 12
            rightMargin: 12
          }

          Text {
            color: "#ffffffff"
            font.family: "VictorMono NFM"
            font.pixelSize: 14
            text: "VOL"
            verticalAlignment: Text.AlignVCenter
          }

          Rectangle {
            Layout.fillWidth: true
            Layout.leftMargin: 4
            Layout.rightMargin: 4
            color: "#ff474747"
            implicitHeight: 10
            radius: 0

            Rectangle {
              color: "#ffffffff"
              implicitWidth: parent.width * (Pipewire.defaultAudioSink?.audio.volume ?? 0)
              radius: 0

              anchors {
                bottom: parent.bottom
                left: parent.left
                top: parent.top
              }
            }
          }

          Text {
            color: "#ffffffff"
            font.family: "VictorMono NFM"
            font.pixelSize: 14
            text: {
              var currentVolume = Math.round((Pipewire.defaultAudioSink?.audio.volume ?? 0) * 100);
              return `${currentVolume}%`;
            }
            verticalAlignment: Text.AlignVCenter
          }
        }
      }
    }
  }
}
