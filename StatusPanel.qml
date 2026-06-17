import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MissionDashboard

Rectangle {
    color: "#16213E"
    radius: 10

    // Listen to currentIndex changes in the vehicle list
    // to show selected vehicle details
    property int selectedIndex: 0

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 14

        // ── Mission Status Header ──────────────────────────
        Rectangle {
            Layout.fillWidth: true
            height: 60
            radius: 8
            color: "#0F3460"

            RowLayout {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 12

                Column {
                    spacing: 4
                    Text {
                        text: "MISSION STATUS"
                        color: "#4FC3F7"
                        font.pixelSize: 11
                        font.bold: true
                        font.letterSpacing: 2
                    }
                    Text {
                        // Bound to Q_PROPERTY via context property
                        // When C++ emits missionStatusChanged(),
                        // this text updates automatically
                        text: controller.missionStatus
                        color: "white"
                        font.pixelSize: 20
                        font.bold: true
                    }
                }

                Item { Layout.fillWidth: true }

                Column {
                    spacing: 4
                    Text {
                        text: "ACTIVE VEHICLES"
                        color: "#4FC3F7"
                        font.pixelSize: 11
                        font.bold: true
                        font.letterSpacing: 2
                    }
                    Text {
                        // controller.activeCount is a Q_PROPERTY(int)
                        // QML auto-binds to it via activeCountChanged signal
                        text: controller.activeCount
                        color: "#81C784"
                        font.pixelSize: 20
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }
        }

        // ── Selected Vehicle Detail ────────────────────────
        Text {
            text: "VEHICLE DETAIL"
            color: "#4FC3F7"
            font.pixelSize: 11
            font.bold: true
            font.letterSpacing: 2
        }

        // Use Repeater with model index to show selected vehicle
        // This demonstrates accessing QAbstractListModel by index
        Loader {
            id: detailLoader
            Layout.fillWidth: true
            Layout.preferredHeight: 180

            // Get the vehicle object via Q_INVOKABLE getVehicle()
            // Returns QVariant(Vehicle*) which QML unwraps to Vehicle object
            property var selectedVehicle: controller.model.getVehicle(selectedIndex)

            sourceComponent: selectedVehicle ? detailComponent : emptyComponent

            Component {
                id: emptyComponent
                Text {
                    text: "No vehicle selected"
                    color: "#666"
                    font.pixelSize: 13
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Component {
                id: detailComponent
                Rectangle {
                    color: "#0F3460"
                    radius: 8

                    // selectedVehicle is a Vehicle* exposed as QVariant
                    // QML engine unwraps it so we can access Q_PROPERTYs
                    // directly: selectedVehicle.name, .battery, .status etc
                    property var v: detailLoader.selectedVehicle

                    GridLayout {
                        anchors.fill: parent
                        anchors.margins: 14
                        columns: 2
                        rowSpacing: 10
                        columnSpacing: 20

                        // Name
                        Text { text: "Name";     color: "#888"; font.pixelSize: 12 }
                        Text { text: v ? v.name : ""; color: "white"; font.pixelSize: 14; font.bold: true }

                        // Status — using Q_ENUM comparison
                        Text { text: "Status";   color: "#888"; font.pixelSize: 12 }
                        Text {
                            text: {
                                if (!v) return ""
                                // Comparing QVariant(enum) unpacked by QML
                                switch(v.status) {
                                    case Vehicle.Active:    return "● Active"
                                    case Vehicle.Idle:      return "● Idle"
                                    case Vehicle.Returning: return "● Returning"
                                    case Vehicle.Error:     return "● Error"
                                    default: return "Unknown"
                                }
                            }
                            color: {
                                if (!v) return "white"
                                switch(v.status) {
                                    case Vehicle.Active:    return "#4CAF50"
                                    case Vehicle.Idle:      return "#2196F3"
                                    case Vehicle.Returning: return "#FF9800"
                                    case Vehicle.Error:     return "#F44336"
                                    default: return "white"
                                }
                            }
                            font.pixelSize: 14
                            font.bold: true
                        }

                        // Battery
                        Text { text: "Battery";  color: "#888"; font.pixelSize: 12 }
                        RowLayout {
                            spacing: 8
                            Text {
                                text: v ? v.battery.toFixed(1) + "%" : ""
                                color: (v && v.battery < 20) ? "#F44336" : "#81C784"
                                font.pixelSize: 14
                                font.bold: true
                            }
                            Rectangle {
                                width: 80; height: 10; radius: 5
                                color: "#333"
                                Rectangle {
                                    width: v ? parent.width * (v.battery / 100) : 0
                                    height: parent.height
                                    radius: parent.radius
                                    color: (v && v.battery < 20) ? "#F44336" : "#4CAF50"
                                    Behavior on width { NumberAnimation { duration: 300 } }
                                }
                            }
                        }

                        // Coordinates
                        Text { text: "Latitude";  color: "#888"; font.pixelSize: 12 }
                        Text { text: v ? v.latitude.toFixed(4) : "";  color: "white"; font.pixelSize: 13 }

                        Text { text: "Longitude"; color: "#888"; font.pixelSize: 12 }
                        Text { text: v ? v.longitude.toFixed(4) : ""; color: "white"; font.pixelSize: 13 }
                    }
                }
            }
        }

        // ── Manual Status Override ─────────────────────────
        Text {
            text: "OVERRIDE STATUS"
            color: "#4FC3F7"
            font.pixelSize: 11
            font.bold: true
            font.letterSpacing: 2
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            // These buttons call Q_INVOKABLE methods on the C++ model
            // passing Vehicle enum values from QML — full round trip!
            Repeater {
                model: [
                    { label: "Active",    status: Vehicle.Active,    color: "#4CAF50" },
                    { label: "Idle",      status: Vehicle.Idle,      color: "#2196F3" },
                    { label: "Returning", status: Vehicle.Returning,  color: "#FF9800" },
                    { label: "Error",     status: Vehicle.Error,     color: "#F44336" }
                ]

                Button {
                    text: modelData.label
                    Layout.fillWidth: true
                    implicitHeight: 34
                    onClicked: {
                        // Q_INVOKABLE call from QML to C++
                        // passing Q_ENUM value back to C++
                        controller.model.updateStatus(
                            selectedIndex,
                            modelData.status
                        )
                    }
                    background: Rectangle {
                        color: parent.pressed
                               ? Qt.darker(modelData.color, 1.5)
                               : Qt.darker(modelData.color, 2.0)
                        radius: 4
                        border.color: modelData.color
                        border.width: 1
                    }
                    contentItem: Text {
                        text: parent.text
                        color: modelData.color
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 11
                        font.bold: true
                    }
                }
            }
        }

        Item { Layout.fillHeight: true }

        // ── Key concept reminder (remove before interview!) ──
        Rectangle {
            Layout.fillWidth: true
            height: 60
            color: "#0A0A1A"
            radius: 6
            border.color: "#333"

            Column {
                anchors.centerIn: parent
                spacing: 3
                Text { text: "Data flow: C++ VehicleModel → QVariant roles → QML delegate properties"
                       color: "#555"; font.pixelSize: 10; anchors.horizontalCenter: parent.horizontalCenter }
                Text { text: "Q_ENUM lets QML use Vehicle.Active, Vehicle.Error etc directly"
                       color: "#555"; font.pixelSize: 10; anchors.horizontalCenter: parent.horizontalCenter }
                Text { text: "Q_INVOKABLE lets QML call C++ methods like updateStatus()"
                       color: "#555"; font.pixelSize: 10; anchors.horizontalCenter: parent.horizontalCenter }
            }
        }
    }
}