pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts

import Quickshell
import Quickshell.Io

PanelWindow {
  id: clipboard

  property var allEntries: []
  property var filteredEntries: []
  property int selectedIndex: -1
  property string thumbDir: String(Quickshell.env("HOME") || "") + "/.cache/quickshell/cliphist-thumbs"
  property int thumbVersion: 0

  function activateSelection() {
    if (selectedIndex < 0 || selectedIndex >= filteredEntries.length)
      return;
    var choice = filteredEntries[selectedIndex];
    if (!choice || !choice.id)
      return;
    Quickshell.execDetached(["sh", "-lc", "printf '%s\\t\\n' \"$1\" | cliphist decode | wl-copy", "_", choice.id]);
    closeClipboard();
  }

  function closeClipboard() {
    visible = false;
  }

  function generateThumbnails(entries) {
    var scripts = ["mkdir -p \"$1\""];

    for (var i = 0; i < entries.length; i++) {
      var item = entries[i];
      if (!item || !item.isImage || !item.thumbPath)
        continue;
      scripts.push("printf '%s\\t\\n' '" + item.id + "' | cliphist decode > \"" + item.thumbPath + "\" 2>/dev/null");
    }

    if (scripts.length <= 1) {
      thumbVersion += 1;
      return;
    }

    thumbProcess.command = ["sh", "-lc", scripts.join("; "), "_", thumbDir];
    thumbProcess.running = false;
    thumbProcess.running = true;
  }

  function move(delta) {
    scaffold.moveSelection(delta);
  }

  function openClipboard() {
    scaffold.setQuery("");
    visible = true;
    scaffold.focusPrompt();
    refreshHistory();
  }

  function refilter() {
    var q = scaffold.queryText.toLowerCase();
    var out = [];

    for (var i = 0; i < allEntries.length; i++) {
      var item = allEntries[i];
      var text = ((item && item.preview) ? item.preview : "").toLowerCase();
      if (q.length === 0 || text.indexOf(q) !== -1) {
        out.push(item);
      }
    }

    filteredEntries = out;
    selectedIndex = out.length > 0 ? 0 : -1;
  }

  function refreshHistory() {
    allEntries = [];
    filteredEntries = [];
    selectedIndex = -1;
    listProcess.running = false;
    listProcess.running = true;
  }

  function setEntries(raw) {
    if (!raw || raw.trim().length === 0) {
      allEntries = [];
      filteredEntries = [];
      selectedIndex = -1;
      return;
    }

    var lines = raw.split("\n");
    var out = [];
    for (var i = 0; i < lines.length; i++) {
      var line = lines[i].trim();
      if (line.length === 0)
        continue;
      var tabIdx = line.indexOf("\t");
      var id = tabIdx >= 0 ? line.slice(0, tabIdx) : line;
      var preview = tabIdx >= 0 ? line.slice(tabIdx + 1) : "";
      if (!/^\d+$/.test(id))
        continue;
      var lower = preview.toLowerCase();
      var match = lower.match(/binary data[^\n]*(png|jpg|jpeg|bmp|gif|webp)/);
      var ext = match ? match[1] : "";
      if (ext === "jpeg")
        ext = "jpg";

      out.push({
        id: id,
        preview: preview,
        isImage: ext.length > 0,
        thumbPath: ext.length > 0 ? (thumbDir + "/" + id + "." + ext) : "",
        display: id + "\t" + preview
      });
    }

    allEntries = out;
    generateThumbnails(out);
    refilter();
  }

  aboveWindows: true
  color: "transparent"
  focusable: true
  implicitHeight: 440
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

  Process {
    id: listProcess

    command: ["cliphist", "list"]

    stdout: StdioCollector {
      onStreamFinished: clipboard.setEntries(this.text)
    }
  }

  Process {
    id: thumbProcess

    onRunningChanged: if (!running)
      clipboard.thumbVersion += 1
  }

  Scaffold {
    id: scaffold

    anchors.fill: parent
    model: clipboard.filteredEntries
    placeholderText: "Clipboard"
    selectedIndex: clipboard.selectedIndex

    delegate: Rectangle {
      id: row

      required property int index
      required property var modelData

      color: row.index === clipboard.selectedIndex ? "#ffffff" : "transparent"
      height: row.modelData.isImage ? 52 : 40
      width: scaffold.listWidth

      RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: row.modelData.isImage ? 54 : 10
        spacing: 8

        Text {
          Layout.preferredWidth: 56
          color: row.index === clipboard.selectedIndex ? "#000000" : "#ffffff"
          font.family: "VictorMono NFM"
          font.pixelSize: 13
          text: row.modelData.id
          verticalAlignment: Text.AlignVCenter
        }

        Text {
          Layout.fillWidth: true
          color: row.index === clipboard.selectedIndex ? "#000000" : "#ffffff"
          elide: Text.ElideRight
          font.family: "VictorMono NFM"
          font.pixelSize: 14
          text: row.modelData.preview
          verticalAlignment: Text.AlignVCenter
        }
      }

      Image {
        id: thumb

        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        asynchronous: true
        cache: false
        fillMode: Image.PreserveAspectFit
        height: 36
        source: row.modelData.isImage ? ("file://" + row.modelData.thumbPath + "?v=" + clipboard.thumbVersion) : ""
        visible: !!row.modelData.isImage
        width: 36

        Rectangle {
          anchors.fill: parent
          border.color: "#47ffffff"
          border.width: 1
          color: "transparent"
          visible: thumb.visible
        }
      }
    }

    onActivateRequested: clipboard.activateSelection()
    onCloseRequested: clipboard.closeClipboard()
    onQueryChanged: clipboard.refilter()
    onSelectedIndexChanged: clipboard.selectedIndex = selectedIndex
  }
}
