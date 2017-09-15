#include "webcam.h"

using namespace dlib;
using namespace std;

#define FACE_DOWNSAMPLE_RATIO 4
#define SKIP_FRAMES 2

#define EYE_AR_THRESH 0.2
#define EYE_AR_CONSEC_FRAMES 4

WebCam::WebCam(QQuickItem *parent)
    : QQuickPaintedItem(parent)
{
    this->setRenderTarget(QQuickPaintedItem::FramebufferObject);

    cap.open(0);

    if (!cap.isOpened()) {
        cout << "capWebcam not accessed successfully";
        return;
    } else {
        cout << "capWebcam was successfully opened";
    }

    // ALLOCATE MEMORY
    cap >> im;
    cv::resize(im, im_small, cv::Size(), 1.0/FACE_DOWNSAMPLE_RATIO, 1.0/FACE_DOWNSAMPLE_RATIO);
    cv::resize(im, im_display, cv::Size(), 0.5, 0.5);

    cv::Size size = im.size();

    // Core Processing Loop
    processLoopTimer = new QTimer(this);    // instantiate timer
    connect(processLoopTimer, SIGNAL(timeout()), this, SLOT(processFrameAndUpdateGUI()));   // associate timer to processFrameAndUpdateGUI
    processLoopTimer->start(100);   // start timer, set to cycle every 100 msec (10x per sec), it will not actually cycle this often

}

void WebCam::processFrameAndUpdateGUI() {
    // GRAB FRAME
    cap >> src;
    cv::flip(src, im, 1);

    // Resize image for display
    im_display = im;
    cv::resize(im, im_display, cv::Size(), 0.5, 0.5);

    qimgDisplay = WebCam::convertOpenCVMatToQtQImage(im_display);

    update();
}

void WebCam::paint(QPainter *painter)
{
    painter->drawImage(this->boundingRect(), qimgDisplay);
    cout << "PBIF: IMAGE DRAWN";
}

QImage WebCam::convertOpenCVMatToQtQImage(cv::Mat mat) {
    if(mat.channels() == 1) {                                   // if 1 channel (grayscale or black and white) image
        return QImage((uchar*)mat.data, mat.cols, mat.rows, mat.step, QImage::Format_Indexed8);     // return QImage
    } else if(mat.channels() == 3) {                            // if 3 channel color image
        cv::cvtColor(mat, mat, CV_BGR2RGB);                     // flip colors
        return QImage((uchar*)mat.data, mat.cols, mat.rows, mat.step, QImage::Format_RGB888);       // return QImage
    } else {
        qDebug() << "in convertOpenCVMatToQtQImage, image was not 1 channel or 3 channel, should never get here";
    }
    return QImage();        // return a blank QImage if the above did not work
}
