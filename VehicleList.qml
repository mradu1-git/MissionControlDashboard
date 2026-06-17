import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    color: "#16213E"
    radius: 10

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8
        RowLayout {
            Layout.fillWidth: true
            Text {
                text: "Vehicles (" + controller.activeCount + " active)"
                color: "#4FC3F7"
                font.pixelSize: 15
                font.bold: true
            }

            Item {
                Layout.fillWidth: true
            }

            Button {
                text: "+ Add"
                onClicked: addDialog.open()
                implicitHeight: 30
                background: Rectangle {
                    color: parent.pressed ? "1565C0" : "#1976D2"
                    radius: 4
                }
                contentItem: Text {
                    text: parent.text;
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 12
                }
            }
        }
        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: controller.model
            delegate: VehicleDelegate {}
            spacing: 6
            clip: true
        }

        RowLayout {
            Layout.fillWidth: true
            Button {
                text: "▶ Simulate"
                Layout.fillWidth: true
                onClicked: controller.startSimulation()
                background: Rectangle {
                    color: parent.pressed ? "#2E7D32" : "#388E3C"; radius: 4
                }
                contentItem: Text {
                    text: parent.text; color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            Button {
                text: "■ Stop"
                Layout.fillWidth: true
                onClicked: controller.stopSimulation()
                background: Rectangle {
                    color: parent.pressed ? "#7B2424" : "#C62828"; radius: 4
                }
                contentItem: Text {
                    text: parent.text; color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        Dialog {
            id: addDialog
            title: "Add Vehicle"
            anchors.centerIn: parent
            standardButtons: Dialog.Ok | Dialog.Cancel

            TextField {
                id: nameField
                placeholderText: "Vehicle name"
                width: 200
            }

            onAccepted: {
                if (nameField.text.trim() !== "")
                    controller.addVehicle(nameField.text.trim())
                nameField.text = ""
            }
        }
    }
}
