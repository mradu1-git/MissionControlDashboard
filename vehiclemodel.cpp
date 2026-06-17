#include "vehiclemodel.h"

VehicleModel::VehicleModel(QObject *parent) : QAbstractListModel(parent) {
    m_vehicles << new Vehicle("Alpha-1", Vehicle::Active,   87.5, 28.6139, 77.2090, this)
    << new Vehicle("Beta-2",  Vehicle::Idle,     100.0, 28.7041, 77.1025, this)
    << new Vehicle("Gamma-3", Vehicle::Returning, 23.1, 28.5355, 77.3910, this)
    << new Vehicle("Delta-4", Vehicle::Error,    0.0,  28.4595, 77.0266, this);
}

int VehicleModel::rowCount(const QModelIndex& parent) const {
    if (parent.isValid()) return 0;
    return m_vehicles.size();
}

void VehicleModel::updateBattery(int index, double battery) {
    if (index < 0 || index >= m_vehicles.size()) return;
    m_vehicles[index]->setBattery(battery);
    emit dataChanged(this->index(index), this->index(index), {BatteryRole});
}

QVariant VehicleModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() >= m_vehicles.size()) {
        return QVariant();
    }
    Vehicle *v = m_vehicles[index.row()];
    switch (role) {
        case NameRole:          return v->name();           // QString → QVariant
        case StatusRole:        return v->status();         // enum → QVariant (via Q_ENUM)
        case BatteryRole:       return v->battery();        // double → QVariant
        case LatitudeRole:      return v->latitude();
        case LongitudeRole:     return v->longitude();
        case VehicleObjectRole: return QVariant::fromValue(v); // QObject* → QVariant
        default:                return QVariant();
    }
}

QHash<int, QByteArray> VehicleModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[NameRole]          = "name";
    roles[StatusRole]        = "status";
    roles[BatteryRole]       = "battery";
    roles[LatitudeRole]      = "latitude";
    roles[LongitudeRole]     = "longitude";
    roles[VehicleObjectRole] = "vehicle";
    return roles;
}

void VehicleModel::addVehicle(const QString& name) {
    beginInsertRows(QModelIndex(), m_vehicles.size(), m_vehicles.size());
    m_vehicles << new Vehicle(name, Vehicle::Idle, 100.0, 0, 0, this);
    endInsertRows();
}

void VehicleModel::removeVehicle(int index) {
    if (index < 0 || index >= m_vehicles.size()) return;
    beginRemoveRows(QModelIndex(), index, index);
    delete m_vehicles.takeAt(index);
    endRemoveRows();
}
void VehicleModel::updateStatus(int index, Vehicle::Status status) {
    if (index < 0 || index >= m_vehicles.size()) return;
    m_vehicles[index]->setStatus(status);
    emit dataChanged(this->index(index), this->index(index), {StatusRole});
}

Vehicle* VehicleModel::getVehicle(int index) {
    if (index < 0 || index >= m_vehicles.size()) return nullptr;
    return m_vehicles[index];
}
