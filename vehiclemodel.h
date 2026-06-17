#pragma once
#include <QAbstractTableModel>
#include <QList>
#include <QtQml/qqml.h>
#include "vehicle.h"

class VehicleModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    enum VehicleRoles {
        NameRole = Qt::UserRole + 1,
        StatusRole,
        BatteryRole,
        LatitudeRole,
        LongitudeRole,
        VehicleObjectRole
    };
    explicit VehicleModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void addVehicle(const QString &name);
    Q_INVOKABLE void removeVehicle(int index);
    Q_INVOKABLE void updateStatus(int index, Vehicle::Status status);
    Q_INVOKABLE void updateBattery(int index, double battery);
    Q_INVOKABLE Vehicle* getVehicle(int index);
private:
    QList<Vehicle*> m_vehicles;
};
// VEHICLEMODEL_H
