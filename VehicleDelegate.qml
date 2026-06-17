import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MissionDashboard

Rectangle {
    id: root
    width: ListView.view.width
    height: 72
    radius: 8
    color: root.ListView.isCurrentItem ? "#2A2A4A" : "#16213E"
    border.color: statusColor()
    border.width: 1

    function statusColor() {
        switch(model.status) {
        case Vehicle.Active:    return "#4CAF50"
            case Vehicle.Idle:      return "#2196F3"
            case Vehicle.Returning: return "#FF9800"
            case Vehicle.Error:     return "#F44336"
            default:                return "#666"
        }
    }
    function statusText() {
        switch(model.status) {
            case Vehicle.Active:    return "ACTIVE"
            case Vehicle.Idle:      return "IDLE"
            case Vehicle.Returning: return "RETURNING"
            case Vehicle.Error:     return "ERROR"
            default:                return "UNKNOWN"
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        Rectangle {
            width: 10; height: 10; radius: 5
            color: statusColor()
        }

        Column {
            Layout.fillwidth: true
            spacing: 4

            Text {
                text: model.name
                color: "white"
                font.pixelSize: 14
                font.bold: true
            }

            Text {
                text: statusText()
                color: statusColor()
                font.pixelSize: 11
            }
        }

        Column {
            spacing: 2

            Text {
                text: model.battery.toFixed(1) + "%"  // QVariant(double) → number
                color: model.battery < 20 ? "#F44336" : "#81C784"
                font.pixelSize: 12
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Rectangle {
                width: 50; height: 8; radius: 4
                color: "#333"
                Rectangle {
                    width: parent.width * (model.battery / 100)
                    height: parent.height
                    radius: parent.radius
                    color: model.battery < 20 ? "#F44336" : "#4CAF50"
                }
            }
        }

        Button {
            text: "X"
            implicitWidth: 28; implicitHeight: 28
            onClicked: controller.removeVehicle(index)
            background: Rectangle {
                color: parent.pressed ? "#7B2424" : "#2A2A2A"
                radius: 4
            }
            contentItem: Text {
                text: parent.text
                color: "#EF9A9A"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.ListView.view.currentIndex = index;
        }
    }
}
