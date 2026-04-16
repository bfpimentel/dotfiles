pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts

import Quickshell
import Quickshell.Widgets

PanelWindow {
  id: launcher

  property var allApps: []
  property var filteredApps: []
  property var hiddenAppIds: ["kbd-layout-viewer5.desktop", "kbd-layout-viewer5", "nvim.desktop", "nvim", "nixos-manual.desktop", "nixos-manual"]
  property var hiddenIdPrefixes: ["fcitx5-", "kcm_fcitx5", "org.fcitx.", "peazip"]
  property int selectedIndex: -1

  function activate() {
    if (selectedIndex < 0 || selectedIndex >= filteredApps.length)
      return;
    filteredApps[selectedIndex].execute();
    closeLauncher();
  }

  function closeLauncher() {
    visible = false;
  }

  function iconSource(iconName) {
    if (!iconName)
      return "";

    var icon = String(iconName);
    if (icon.length === 0)
      return "";

    if (icon.indexOf("://") !== -1)
      return icon;
    if (icon.charAt(0) === "/")
      return "file://" + icon;

    return Quickshell.iconPath(icon, "application-x-executable");
  }

  function isHiddenApp(app) {
    if (!app)
      return false;

    var id = app.id ? String(app.id) : "";
    for (var i = 0; i < hiddenAppIds.length; i++) {
      if (id === hiddenAppIds[i])
        return true;
    }

    for (var j = 0; j < hiddenIdPrefixes.length; j++) {
      if (id.indexOf(hiddenIdPrefixes[j]) === 0)
        return true;
    }

    var name = app.name ? String(app.name).toLowerCase() : "";

    if (name.indexOf("neovim wrapper") !== -1)
      return true;
    if (name.indexOf("keyboard layout viewer") !== -1)
      return true;
    if (name.indexOf("nixos manual") !== -1)
      return true;

    return false;
  }

  function matches(app, query) {
    if (query.length === 0)
      return true;

    function has(text) {
      return text && text.toLowerCase().indexOf(query) !== -1;
    }

    if (has(app.name) || has(app.comment) || has(app.genericName))
      return true;

    // if (app.categories) {
    //     for (var i = 0; i < app.categories.length; i++) {
    //         if (has(app.categories[i])) return true
    //     }
    // }
    //
    // if (app.keywords) {
    //     for (var j = 0; j < app.keywords.length; j++) {
    //         if (has(app.keywords[j])) return true
    //     }
    // }

    return false;
  }

  function move(delta) {
    scaffold.moveSelection(delta);
  }

  function openLauncher() {
    allApps = DesktopEntries.applications && DesktopEntries.applications.values ? DesktopEntries.applications.values : [];
    scaffold.setQuery("");
    refilter();
    visible = true;
    scaffold.focusPrompt();
  }

  function refilter() {
    var q = scaffold.queryText.toLowerCase();
    var out = [];

    for (var i = 0; i < allApps.length; i++) {
      var app = allApps[i];
      if (!app.noDisplay && !isHiddenApp(app) && matches(app, q)) {
        out.push(app);
      }
    }

    out.sort(function (a, b) {
      var aName = (a && a.name) ? String(a.name) : "";
      var bName = (b && b.name) ? String(b.name) : "";
      return aName.localeCompare(bName, undefined, {
        sensitivity: "base"
      });
    });

    filteredApps = out;
    selectedIndex = out.length > 0 ? 0 : -1;
  }

  aboveWindows: true
  color: "transparent"
  focusable: true
  implicitHeight: 420
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

  Scaffold {
    id: scaffold

    anchors.fill: parent
    border.color: "#47ffffff"
    color: "#cc000000"
    model: launcher.filteredApps
    placeholderText: "Run"
    selectedIndex: launcher.selectedIndex

    delegate: Rectangle {
      id: appRow

      required property int index
      required property var modelData

      color: index === launcher.selectedIndex ? "#ffffff" : "transparent"
      height: 36
      width: scaffold.listWidth

      RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        spacing: 8

        IconImage {
          id: appIcon

          Layout.preferredHeight: 18
          Layout.preferredWidth: 18
          asynchronous: true
          mipmap: true
          source: launcher.iconSource(appRow.modelData.icon)
          visible: source && source.toString().length > 0
        }

        Item {
          Layout.preferredHeight: 18
          Layout.preferredWidth: 18
          visible: !appIcon.visible
        }

        Text {
          Layout.fillWidth: true
          color: appRow.index === launcher.selectedIndex ? "#000000" : "#ffffff"
          elide: Text.ElideRight
          font.family: "VictorMono NFM"
          font.pixelSize: 14
          text: appRow.modelData.name
          verticalAlignment: Text.AlignVCenter
        }
      }

      MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
          launcher.selectedIndex = appRow.index;
          launcher.activate();
        }
        onEntered: launcher.selectedIndex = appRow.index
      }
    }

    onActivateRequested: launcher.activate()
    onCloseRequested: launcher.closeLauncher()
    onQueryChanged: launcher.refilter()
    onSelectedIndexChanged: launcher.selectedIndex = selectedIndex
  }
}
