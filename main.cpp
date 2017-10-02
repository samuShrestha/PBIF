#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>
#include <QQmlProperty>

#include "pbif.h"
#include "webcam.h"

int main(int argc, char *argv[])
{
    // GUI/QML - APPLICATION INIT
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    // DEFINE CONTEXT ENGINE + INIT PBIF
    QQmlContext* context = engine.rootContext();
    PBIF pbif(nullptr, &app, &engine);
    context->setContextProperty("pbif", &pbif);

    qmlRegisterType<WebCam>("io.qt.webcam", 1, 0, "WebCam");

    engine.load(QUrl(QLatin1String("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    // PASS THROUGH QOBJECTS
    //QList<QQuickItem*> x = engine.rootObjects().at(0)->findChild<QQuickItem*>("settingsView")->findChildren<QQuickItem*>(); - left here for reference
    pbif.loadQMLComponents();

    // RUN PBIF EVENT LOOP
    try{
        pbif.exec();
    } catch (...) {
        std::cout << "Exception occured while attempting to run program loop";
    }

    return app.exec();
}
