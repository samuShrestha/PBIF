#ifndef APP_H
#define APP_H

#include <QObject>
#include <QQmlEngine>
#include <QQmlComponent>
#include <QQuickPaintedItem>
#include <QGuiApplication>
#include <QDebug>
#include <QTimer>

#include <dlib/opencv.h>
#include <opencv2/opencv.hpp>
#include <dlib/image_processing/frontal_face_detector.h>
#include <dlib/image_processing/render_face_detections.h>
#include <dlib/image_processing.h>
#include <dlib/gui_widgets.h>

#include <iostream>
#include <stdio.h>

class PBIF : public QObject {
    Q_OBJECT
public:
    explicit PBIF(QObject *parent = nullptr, QGuiApplication *app = nullptr);
    void exec();
    Q_INVOKABLE void exit();

    enum AppState { tracking, idle };
    AppState applicationState;

    void setWebCam(QObject *webCam);
    void setTogglePose(QObject *togglePose);
    void setToggleEyes(QObject *toggleEyes);

    cv::VideoCapture cap; // Capture object to use w/ webcam

    // Load face detection and pose estimation models.
    dlib::frontal_face_detector detector = dlib::get_frontal_face_detector();
    dlib::shape_predictor pose_model;

    cv::Mat src, im;
    cv::Mat im_small;
    static cv::Mat im_display;

    std::vector<dlib::rectangle> faces;

    std::vector<cv::Point2d> poseEstimation;

    int blinkFrameCount;
    int totalBlinks;

    double eyeAspectRatio(std::vector<cv::Point2d> eye);


private:
    QGuiApplication *app;

    QTimer *processLoopTimer;

    QObject *togglePose;
    QObject *toggleEyes;

    bool stop;

signals:
    void frameUpdated();
public slots:
    void processFrameAndUpdateGUI();
    //void togglePose();
    //void toggleEyeMarkers();
};

#endif // APP_H
