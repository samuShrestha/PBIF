#ifndef WEBCAM_H
#define WEBCAM_H


#include <QQmlEngine>
#include <QQmlComponent>
#include <QQmlProperty>
#include <QQuickItem>
#include <QQuickPaintedItem>

#include <QObject>
#include <QPainter>
#include <QPixmap>

#include <QThread>
#include <QDebug>
#include <QTimer>
#include <QPoint>
#include <QCursor>
#include <QScreen>

#include <dlib/opencv.h>
#include <opencv2/opencv.hpp>
#include <dlib/image_processing/frontal_face_detector.h>
#include <dlib/image_processing/render_face_detections.h>
#include <dlib/image_processing.h>
#include <dlib/gui_widgets.h>

class WebCam : public QQuickPaintedItem
{
    Q_OBJECT
public:
    WebCam(QQuickItem *parent = 0);
    void paint(QPainter *painter);

    // Load face detection and pose estimation models.
    dlib::frontal_face_detector detector = dlib::get_frontal_face_detector();
    dlib::shape_predictor pose_model;

    cv::Mat src, im;
    cv::Mat im_small, im_display;

    std::vector<dlib::rectangle> faces;

    std::vector<cv::Point2d> poseEstimation;

    QImage qimgDisplay;

private:
    cv::VideoCapture cap; // Capture object to use w/ webcam
    QImage WebCam::convertOpenCVMatToQtQImage(cv::Mat mat);

    QTimer* processLoopTimer;                 // timer for processFrameAndUpdateGUI()

signals:

public slots:
    void processFrameAndUpdateGUI();
};

#endif // WEBCAM_H
