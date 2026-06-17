#include "vehicle.h"

Vehicle::Vehicle(QObject* parent) : QObject(parent),
    m_name("Unknown"),
    m_status(Idle),
    m_battery(100.0),
    m_latitude(0.0),
    m_longitude(0.0)
{}

Vehicle::Vehicle(const QString &name, Status status, double battery, double lat, double lon, QObject* parent) : QObject(parent)
    , m_name(name)
    , m_status(status)
    , m_battery(battery)
    , m_latitude(lat)
    , m_longitude(lon)
{}


