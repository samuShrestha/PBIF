#ifndef IMAGEPROCESSINGWORKER_H
#define IMAGEPROCESSINGWORKER_H

#include <QDebug>
#include <QObject>
#include <QQmlApplicationEngine>
#include <QString>
#include <QTimer>

#include <iostream>
#include <stdio.h>

#include <dlib/opencv.h>
#include <opencv2/opencv.hpp>
#include <dlib/image_processing/frontal_face_detector.h>
#include <dlib/image_processing/render_face_detections.h>
#include <dlib/image_processing.h>
#include <dlib/gui_widgets.h>

#include "pbif.h"

class imageProcessingWorker : public QObject {
    Q_OBJECT

public slots:
    void initialize();
    void process();

signals:
    void finished();
    void error(QString err);

    void frameUpdated();

// FUNCTIONS
public:
    imageProcessingWorker(QQmlApplicationEngine* engine);
    ~imageProcessingWorker();

private:
    double eyeAspectRatio(std::vector<cv::Point2d> eye);

// VARIABLES
public:
    QTimer* processLoopTimer;
    static cv::Mat im_display;
    int totalBlinks;
private:
    // ==== QML COMPONENTS ====
    QObject* webCam;
    QObject* togglePose;
    QObject* toggleEyes;

    QObject* outputPose;

    // ==== TRACKING ====
    // Capture object to use w/ webcam
    cv::VideoCapture cap;

    // Load face detection and pose estimation models.
    dlib::frontal_face_detector detector = dlib::get_frontal_face_detector();
    dlib::shape_predictor pose_model;

    cv::Mat src, im;
    cv::Mat im_small;

    std::vector<dlib::rectangle> faces;

    std::vector<cv::Point2d> poseEstimation;

    int blinkFrameCount;
};

#endif // IMAGEPROCESSINGWORKER_H
