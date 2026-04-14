pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: scaffold

    property string placeholderText: ""
    property var model: []
    property int selectedIndex: -1
    property Component delegate
    readonly property real listWidth: list.width
    readonly property string queryText: input.text

    signal queryChanged(string query)
    signal activateRequested()
    signal closeRequested()

    color: "#d9111116"
    border.width: 1
    border.color: "#3fffffff"

    function setQuery(query) {
        input.text = query
    }

    function focusPrompt() {
        input.forceActiveFocus()
    }

    function moveSelection(delta) {
        if (!model || model.length === 0) return
        var next = selectedIndex + delta
        if (next < 0) next = 0
        if (next >= model.length) next = model.length - 1
        selectedIndex = next
        list.positionViewAtIndex(selectedIndex, ListView.Contain)
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        TextField {
            id: input
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            placeholderText: scaffold.placeholderText
            color: "#ffffff"
            placeholderTextColor: "#88ffffff"
            font.family: "VictorMono NFM"
            font.pixelSize: 14

            background: Rectangle {
                color: "#14ffffff"
                border.width: 1
                border.color: "#4dffffff"
            }

            onTextChanged: scaffold.queryChanged(text)

            Keys.onPressed: function(event) {
                if (event.key === Qt.Key_Down || (event.key === Qt.Key_N && (event.modifiers & Qt.ControlModifier))) {
                    scaffold.moveSelection(1)
                    event.accepted = true
                } else if (event.key === Qt.Key_Up || (event.key === Qt.Key_P && (event.modifiers & Qt.ControlModifier))) {
                    scaffold.moveSelection(-1)
                    event.accepted = true
                } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    scaffold.activateRequested()
                    event.accepted = true
                } else if (event.key === Qt.Key_Escape) {
                    scaffold.closeRequested()
                    event.accepted = true
                }
            }
        }

        ListView {
            id: list
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: scaffold.model
            delegate: scaffold.delegate
        }
    }
}
