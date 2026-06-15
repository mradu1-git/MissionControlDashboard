#pragma once
#include <QObject>
#include <QString>
#include <QtQml/qqml.h>

class Vehicle : public QObject {
    Q_OBJECT
    QML_ELEMENT  // lets you use Vehicle type directly in QML

    // Q_ENUM — this is what your last videos covered
    Q_PROPERTY(Status status READ status WRITE setStatus NOTIFY statusChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(double battery READ battery WRITE setBattery NOTIFY batteryChanged)
    Q_PROPERTY(double latitude READ latitude WRITE setLatitude NOTIFY latitudeChanged)
    Q_PROPERTY(double longitude READ longitude WRITE setLongitude NOTIFY longitudeChanged)

public:
    // Q_ENUM makes this enum available in QML as Vehicle.Active etc.
    enum Status {
        Idle,
        Active,
        Returning,
        Error
    };
    Q_ENUM(Status)

    explicit Vehicle(QObject* parent = nullptr);
    Vehicle(const QString& name, Status status, double battery,
            double lat, double lon, QObject* parent = nullptr);

    QString name() const { return m_name; }
    Status  status() const { return m_status; }
    double  battery() const { return m_battery; }
    double  latitude() const { return m_latitude; }
    double  longitude() const { return m_longitude; }

    void setName(const QString& v)  { if(m_name!=v){ m_name=v; emit nameChanged(); } }
    void setStatus(Status v)        { if(m_status!=v){ m_status=v; emit statusChanged(); } }
    void setBattery(double v)       { if(m_battery!=v){ m_battery=v; emit batteryChanged(); } }
    void setLatitude(double v)      { if(m_latitude!=v){ m_latitude=v; emit latitudeChanged(); } }
    void setLongitude(double v)     { if(m_longitude!=v){ m_longitude=v; emit longitudeChanged(); } }

signals:
    void nameChanged();
    void statusChanged();
    void batteryChanged();
    void latitudeChanged();
    void longitudeChanged();

private:
    QString m_name;
    Status  m_status = Idle;
    double  m_battery = 100.0;
    double  m_latitude = 0.0;
    double  m_longitude = 0.0;
};