#include "pbif.h"

using namespace dlib;
using namespace std;

#define FACE_DOWNSAMPLE_RATIO 4
#define SKIP_FRAMES 2

#define EYE_AR_THRESH 0.2
#define EYE_AR_CONSEC_FRAMES 4

cv::Mat PBIF::im_display;

PBIF::PBIF(QObject *parent, QGuiApplication *app) : QObject(parent)
{
    this->app               = app;
    this->applicationState  = idle;
    this->stop              = false;
}

void PBIF::exit() {
    qDebug() << "PBIF: EXIT METHOD CALLED";
    stop = true;
    std::exit(0);
}

void PBIF::setWebCam(QObject *webCam) {
    connect(this, SIGNAL(frameUpdated()), webCam, SLOT(updateFrame()));
}

void PBIF::exec() {

    cap.open(0);

    if (!cap.isOpened()) {
        qDebug() << "capWebcam not accessed successfully";
        return;
    } else {
        qDebug() << "capWebcam was successfully opened";
    }

    // ALLOCATE MEMORY
    cap >> im;
    cv::resize(im, im_small, cv::Size(), 1.0/FACE_DOWNSAMPLE_RATIO, 1.0/FACE_DOWNSAMPLE_RATIO);
    cv::resize(im, PBIF::im_display, cv::Size(), 0.5, 0.5);

    cv::Size size = im.size();

    // Core Processing Loop
    processLoopTimer = new QTimer(this);    // instantiate timer
    connect(processLoopTimer, SIGNAL(timeout()), this, SLOT(processFrameAndUpdateGUI()));   // associate timer to processFrameAndUpdateGUI
    processLoopTimer->start(100);   // start timer, set to cycle every 100 msec (10x per sec), it will not actually cycle this often

    while (!stop) {
        // QT EVENT LOOP
        app->processEvents();


    };

}

void PBIF::processFrameAndUpdateGUI() {
    // GRAB FRAME
    cap >> src;
    cv::flip(src, im, 1);

    // RESIZE IMAGE FOR FACE DETECTION - OPTIMIZATION
    cv::resize(im, im_small, cv::Size(), 1.0/FACE_DOWNSAMPLE_RATIO, 1.0/FACE_DOWNSAMPLE_RATIO);

    // CHANGE TO DLIB'S IMAGE FORMAT. NO MEMORY IS COPIED.
    cv_image<bgr_pixel> cimg_small(im_small);
    cv_image<bgr_pixel> cimg(im);

    // Display it all on the screen
    // Resize image for display
    PBIF::im_display = im;
    cv::resize(im, PBIF::im_display, cv::Size(), 0.5, 0.5);

    emit frameUpdated();
}


