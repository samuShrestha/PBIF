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
#include <QImage>

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

#include <pbif.h>

class WebCam : public QQuickPaintedItem
{
    Q_OBJECT
public:
    WebCam(QQuickItem *parent = 0);
    void paint(QPainter *painter);

    QImage qimgDisplay;

    static QImage convertOpenCVMatToQtQImage(cv::Mat mat);

private:

signals:

public slots:
    void updateFrame();

};

#endif // WEBCAM_H
