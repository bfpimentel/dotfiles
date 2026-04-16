pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
  id: scaffold

  property Component delegate
  readonly property real listWidth: list.width
  property var model: []
  property string placeholderText: ""
  readonly property string queryText: input.text
  property int selectedIndex: 0

  signal activateRequested
  signal closeRequested
  signal queryChanged(string query)

  function focusPrompt() {
    input.forceActiveFocus();
  }

  function moveSelection(delta) {
    if (!model || model.length === 0)
      return;
    var next = selectedIndex + delta;
    if (next < 0)
      next = 0;
    if (next >= model.length)
      next = model.length - 1;
    selectedIndex = next;
    list.positionViewAtIndex(selectedIndex, ListView.Contain);
  }

  function reset() {
    selectedIndex = 0;
  }

  function setQuery(query) {
    input.text = query;
  }

  border.color: "#47ffffff"
  border.width: 1
  color: "#cc000000"

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: 12
    spacing: 10

    TextField {
      id: input

      Layout.fillWidth: true
      Layout.preferredHeight: 40
      color: "#ffffff"
      font.family: "VictorMono NFM"
      font.pixelSize: 14
      placeholderText: scaffold.placeholderText
      placeholderTextColor: "#88ffffff"

      background: Rectangle {
        border.color: "#47ffffff"
        border.width: 1
        color: "#14ffffff"
      }

      Keys.onPressed: function (event) {
        if (event.key === Qt.Key_Down || (event.key === Qt.Key_N && (event.modifiers & Qt.ControlModifier))) {
          scaffold.moveSelection(1);
          event.accepted = true;
        } else if (event.key === Qt.Key_Up || (event.key === Qt.Key_P && (event.modifiers & Qt.ControlModifier))) {
          scaffold.moveSelection(-1);
          event.accepted = true;
        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
          scaffold.activateRequested();
          scaffold.reset();
          event.accepted = true;
        } else if (event.key === Qt.Key_Escape) {
          scaffold.closeRequested();
          scaffold.reset();
          event.accepted = true;
        }
      }
      onTextChanged: scaffold.queryChanged(text)
    }

    ListView {
      id: list

      Layout.fillHeight: true
      Layout.fillWidth: true
      clip: true
      delegate: scaffold.delegate
      model: scaffold.model
    }
  }
}
