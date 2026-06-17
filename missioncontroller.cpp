#include "missioncontroller.h"

#include <QRandomGenerator>

MissionController::MissionController(QObject* parent) : QObject(parent)
    , m_model(new VehicleModel(this))
    , m_timer(new QTimer(this))
{
    connect(m_timer, &QTimer::timeout, this, &MissionController::onSimulationTick);
}

int MissionController::activeCount() const {
    int count = 0;
    for (int i = 0; i < m_model->rowCount(); i++) {
        Vehicle* v = m_model->getVehicle(i);
        if (v && v->status() == Vehicle::Active) {
            count++;
        }
    }
    return count;
}

void MissionController::startSimulation() {
    m_missionStatus = "Running";
    emit missionStatusChanged();
    m_timer->start(1500);
}

void MissionController::stopSimulation() {
    m_timer->stop();
    m_missionStatus = "Standby";
    emit missionStatusChanged();
}

void MissionController::addVehicle(const QString& name) {
    m_model->addVehicle(name);
    emit activeCountChanged();
}

void MissionController::removeVehicle(int index) {
    m_model->removeVehicle(index);
    emit activeCountChanged();
}

void MissionController::onSimulationTick() {
    int count = m_model->rowCount();
    if (count == 0) return;
    for (int i = 0; i < count; i++) {
        Vehicle *v = m_model->getVehicle(i);
        if (!v) continue;

        double newBattery = qMax(0.0, v->battery() - QRandomGenerator::global()->bounded(5) - 1.0);
        m_model->updateBattery(i, newBattery);

        if (newBattery <= 0.0) {
            m_model->updateStatus(i, Vehicle::Error);
            continue;
        }

        if (QRandomGenerator::global()->bounded(100) < 20) {
            int randomStatus = QRandomGenerator::global()->bounded(3);
            m_model->updateStatus(i, static_cast<Vehicle::Status>(randomStatus));
        }
    }
    emit activeCountChanged();

    int active = activeCount();
    if (active == 0) {
        m_missionStatus = "All Idle";
    } else if (active == count) {
        m_missionStatus = "All Active";
    } else {
        m_missionStatus = QString("%1/%2 Active").arg(active).arg(count);
    }
    emit missionStatusChanged();
}
