#ifndef APP_H
#define APP_H

#include <QObject>
#include <QQmlApplicationEngine>
#include <QQmlEngine>
#include <QQmlComponent>
#include <QQuickPaintedItem>
#include <QGuiApplication>
#include <QDebug>
#include <QTimer>
#include <QThread>

#include <dlib/opencv.h>
#include <opencv2/opencv.hpp>
#include <dlib/image_processing/frontal_face_detector.h>
#include <dlib/image_processing/render_face_detections.h>
#include <dlib/image_processing.h>
#include <dlib/gui_widgets.h>

#include <iostream>
#include <stdio.h>

#include "imageprocessingworker.h"

class PBIF : public QObject {
    Q_OBJECT
signals:
public slots:
public:
    // ==== APPLICATION ====
    explicit PBIF(QObject *parent = nullptr, QGuiApplication *app = nullptr, QQmlApplicationEngine *engine = nullptr);
    ~PBIF();
    void exec();
    Q_INVOKABLE void exit();

    enum AppState { tracking, idle };
    AppState applicationState;

    void loadQMLComponents();

    // ALGORITHM
    static cv::Mat im_display;
    static std::vector<cv::Point2d> poseEstimation;

private:
    bool stop;

    QGuiApplication* app;
    QQmlApplicationEngine* engine;

    QTimer* processLoopTimer;


    // ==== QML COMPONENTS ====
    QObject* webCam;
    QObject* togglePose;
    QObject* toggleEyes;
    QObject* loadingMessage;
};

#endif // APP_H
