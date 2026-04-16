pragma ComponentBehavior: Bound
import QtQuick

import Quickshell
import Quickshell.Io

PanelWindow {
  id: processes

  property var actionRows: [
    {
      key: "term",
      text: "󰆴  Terminate"
    },
    {
      key: "details",
      text: "󰗼  Details"
    },
    {
      key: "stop",
      text: "󰜺  Stop"
    },
    {
      key: "cont",
      text: "󰠳  Continue"
    },
    {
      key: "kill",
      text: "󰅖  Kill"
    }
  ]
  property var activeItems: []
  property var confirmRows: [
    {
      key: "no",
      text: "󰄬  No"
    },
    {
      key: "yes",
      text: "󰄭  Yes"
    }
  ]
  property string mode: "list"
  property var pendingAction: null
  property var processRows: []
  property int selectedIndex: -1
  property var selectedProcess: null
  property string titleText: "Processes"

  function activateSelection() {
    if (selectedIndex < 0 || selectedIndex >= activeItems.length)
      return;
    var item = activeItems[selectedIndex];

    if (mode === "list") {
      showActions(item);
      return;
    }

    if (mode === "action") {
      if (item.key === "details") {
        showDetails();
        return;
      }
      showConfirmation(item);
      return;
    }

    if (mode === "confirm") {
      if (item.key === "yes") {
        executeSignal(pendingAction.key);
        closeProcesses();
      } else {
        back();
      }
      return;
    }

    if (mode === "details") {
      back();
    }
  }

  function back() {
    if (mode === "confirm" || mode === "details") {
      mode = "action";
      pendingAction = null;
      titleText = "Action: " + selectedProcess.name + " (" + selectedProcess.pid + ")";
      scaffold.setQuery("");
      refilter();
      return;
    }

    if (mode === "action") {
      mode = "list";
      titleText = "Processes";
      selectedProcess = null;
      pendingAction = null;
      scaffold.setQuery("");
      refilter();
      return;
    }

    closeProcesses();
  }

  function closeProcesses() {
    visible = false;
  }

  function executeSignal(actionKey) {
    if (!selectedProcess)
      return;
    if (actionKey === "term") {
      Quickshell.execDetached(["kill", "-TERM", String(selectedProcess.pid)]);
    } else if (actionKey === "stop") {
      Quickshell.execDetached(["kill", "-STOP", String(selectedProcess.pid)]);
    } else if (actionKey === "cont") {
      Quickshell.execDetached(["kill", "-CONT", String(selectedProcess.pid)]);
    } else if (actionKey === "kill") {
      Quickshell.execDetached(["kill", "-KILL", String(selectedProcess.pid)]);
    }
  }

  function openProcesses() {
    mode = "list";
    titleText = "Processes";
    selectedProcess = null;
    pendingAction = null;
    scaffold.setQuery("");
    visible = true;
    scaffold.focusPrompt();
    refreshProcesses();
  }

  function refilter() {
    var q = scaffold.queryText.toLowerCase();
    var source = sourceItems();
    var out = [];

    for (var i = 0; i < source.length; i++) {
      var item = source[i];
      if (mode !== "list") {
        out.push(item);
        continue;
      }
      var text = item.text ? String(item.text).toLowerCase() : "";
      if (q.length === 0 || text.indexOf(q) !== -1) {
        out.push(item);
      }
    }

    activeItems = out;
    selectedIndex = out.length > 0 ? 0 : -1;
  }

  function refreshProcesses() {
    processRows = [];
    activeItems = [];
    selectedIndex = -1;
    listProcess.running = false;
    listProcess.running = true;
  }

  function setDetails(raw) {
    var details = (raw || "").trim();
    if (details.length === 0)
      details = "Process no longer exists";
    mode = "details";
    titleText = "Process " + selectedProcess.pid;
    activeItems = [
      {
        key: "details",
        text: details
      }
    ];
    selectedIndex = 0;
  }

  function setProcesses(raw) {
    var out = [];
    var lines = raw ? raw.split("\n") : [];

    for (var i = 0; i < lines.length; i++) {
      var line = lines[i].trim();
      if (line.length === 0)
        continue;
      var parts = line.split(/\s+/, 2);
      var pidText = parts.length > 0 ? parts[0] : "";
      var name = parts.length > 1 ? parts[1] : "unknown";
      if (!/^\d+$/.test(pidText))
        continue;
      out.push({
        pid: Number(pidText),
        name: name,
        text: pidText + "\t" + name
      });
    }

    processRows = out;
    mode = "list";
    titleText = "Processes";
    selectedProcess = null;
    pendingAction = null;
    refilter();
  }

  function showActions(procRow) {
    selectedProcess = procRow;
    mode = "action";
    titleText = "Action: " + procRow.name + " (" + procRow.pid + ")";
    scaffold.setQuery("");
    refilter();
  }

  function showConfirmation(actionRow) {
    pendingAction = actionRow;
    mode = "confirm";

    var verb = actionRow.text.replace(/^\S+\s+/, "");
    titleText = verb + " " + selectedProcess.name + " (" + selectedProcess.pid + ")?";
    scaffold.setQuery("");
    refilter();
  }

  function showDetails() {
    if (!selectedProcess)
      return;
    detailsProcess.command = ["ps", "-p", String(selectedProcess.pid), "-o", "pid=,ppid=,state=,%cpu=,%mem=,etime=,comm="];
    detailsProcess.running = false;
    detailsProcess.running = true;
  }

  function sourceItems() {
    if (mode === "list")
      return processRows;
    if (mode === "action")
      return actionRows;
    if (mode === "confirm")
      return confirmRows;
    return activeItems;
  }

  aboveWindows: true
  color: "transparent"
  focusable: true
  implicitHeight: 480
  implicitWidth: 760
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

    command: ["sh", "-lc", "ps -u \"${USER:-$(id -un)}\" -o pid=,comm= --sort=comm,pid"]

    stdout: StdioCollector {
      onStreamFinished: processes.setProcesses(this.text)
    }
  }

  Process {
    id: detailsProcess

    stdout: StdioCollector {
      onStreamFinished: processes.setDetails(this.text)
    }
  }

  Scaffold {
    id: scaffold

    anchors.fill: parent
    model: processes.activeItems
    placeholderText: processes.titleText
    selectedIndex: processes.selectedIndex

    delegate: Rectangle {
      id: row

      required property int index
      required property var modelData

      color: row.index === processes.selectedIndex ? "#ffffff" : "transparent"
      height: 40
      width: scaffold.listWidth

      Text {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        color: row.index === processes.selectedIndex ? "#000000" : "#ffffff"
        elide: Text.ElideRight
        font.family: "VictorMono NFM"
        font.pixelSize: 14
        text: row.modelData.text || ""
        verticalAlignment: Text.AlignVCenter
      }

      MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
          processes.selectedIndex = row.index;
          processes.activateSelection();
        }
        onEntered: processes.selectedIndex = row.index
      }
    }

    onActivateRequested: processes.activateSelection()
    onCloseRequested: processes.back()
    onQueryChanged: processes.refilter()
    onSelectedIndexChanged: processes.selectedIndex = selectedIndex
  }
}
