#include "pbif.h"

using namespace dlib;
using namespace std;

#include "render_face.cpp"

cv::Mat PBIF::im_display;
std::vector<cv::Point2d> PBIF::poseEstimation;

PBIF::PBIF(QObject *parent, QGuiApplication *app, QQmlApplicationEngine *engine) : QObject(parent) {
    this->app               = app;
    this->engine            = engine;

    this->applicationState  = idle;
    this->stop              = false;
}

PBIF::~PBIF() {

}

void PBIF::exit() {
    qDebug() << "PBIF: EXIT METHOD CALLED";
    stop = true;
    std::exit(0);
}

void PBIF::loadQMLComponents() {
    webCam = engine->rootObjects().at(0)->findChild<QObject*>("settingsView")->findChild<QObject*>("webCam");
    togglePose = engine->rootObjects().at(0)->findChild<QObject*>("settingsView")->findChild<QObject*>("togglePoseTracker");
    toggleEyes = engine->rootObjects().at(0)->findChild<QObject*>("settingsView")->findChild<QObject*>("toggleEyeTracker");
    loadingMessage = engine->rootObjects().at(0)->findChild<QObject*>("settingsView")->findChild<QObject*>("webcamLoadingMessage");
}

void PBIF::exec() {
    QThread* thread = new QThread;
    imageProcessingWorker* worker = new imageProcessingWorker(engine);
    worker->moveToThread(thread);
    //connect(worker, SIGNAL(error(QString)), this, SLOT(errorString(QString)));
    connect(thread, SIGNAL(started()), worker, SLOT(initialize()));
    connect(worker, SIGNAL(finished()), thread, SLOT(quit()));
    connect(worker, SIGNAL(finished()), worker, SLOT(deleteLater()));
    connect(thread, SIGNAL(finished()), thread, SLOT(deleteLater()));
    thread->start();
    QTimer::singleShot(6000, [=] {
        loadingMessage->setProperty("visible", false);
    });
}
