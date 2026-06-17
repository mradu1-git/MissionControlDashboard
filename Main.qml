import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MissionDashboard

ApplicationWindow {
    visible: true
    width: 900
    height: 600
    title: "Mission Control Dashboard"
    color: "#1A1A2E"

    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        VehicleList {
            id: vehicleList
            Layout.preferredWidth: 320
            Layout.fillHeight: true
        }

        StatusPanel {
            Layout.fillWidth: true
            Layout.fillHeight: true
            // Direct binding to the alias — no signal handler needed
            selectedIndex: vehicleList.selectedIndex
        }
    }
}
