#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "missioncontroller.h"
#include "vehicle.h"
#include "vehiclemodel.h"

int main(int argc, char* argv[]) {
    QGuiApplication app(argc, argv);
    qmlRegisterType<VehicleModel>("MissionDashboard", 1, 0, "VehicleModel");
    qmlRegisterUncreatableType<Vehicle>("MissionDashboard", 1, 0, "Vehicle", "Vehicle is created by Vehicle Model");
    QQmlApplicationEngine engine;
    MissionController controller;
    engine.rootContext()->setContextProperty("controller", &controller);
    engine.loadFromModule("MissionDashboard", "Main");
    return app.exec();
}