#include "webcam.h"
#include "pbif.h"

WebCam::WebCam(QQuickItem *parent)
    : QQuickPaintedItem(parent)
{
    this->setRenderTarget(QQuickPaintedItem::FramebufferObject);
}

void WebCam::updateFrame() {
    qimgDisplay = WebCam::convertOpenCVMatToQtQImage(PBIF::im_display);
    update();
}

void WebCam::paint(QPainter *painter)
{
    painter->drawImage(this->boundingRect(), qimgDisplay);
    std::cout << "PBIF: IMAGE DRAWN";
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
