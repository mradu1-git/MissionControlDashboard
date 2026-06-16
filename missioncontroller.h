#pragma once
#include <QObject>
#include <QTimer>
#include <QtQml/qqml.h>
#include "vehiclemodel.h"

class MissionController : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(VehicleModel* model READ model CONSTANT)
    Q_PROPERTY(int activeCount READ activeCount NOTIFY activeCountChanged)
    Q_PROPERTY(QString missionStatus READ missionStatus NOTIFY missionStatusChanged)
public:
    explicit MissionController(QObject* parent = nullptr);
    VehicleModel* model() {
        return m_model;
    }
    int activeCount() const;
    QString missionStatus() const { return m_missionStatus; }
    Q_INVOKABLE void startSimulation();
    Q_INVOKABLE void stopSimulation();
    Q_INVOKABLE void addVehicle(const QString& name);
    Q_INVOKABLE void removeVehicle(int index);

signals:
    void activeCountChanged();
    void missionStatusChanged();
private slots:
    void onSimulationTick();
private:
    VehicleModel* m_model;
    QTimer* m_timer;
    QString m_missionStatus = "Standby";
};


