#include "pbif.h"

using namespace dlib;
using namespace std;

#include "render_face.cpp"

cv::Mat PBIF::im_display;
std::vector<cv::Point2d> PBIF::poseEstimation;

PBIF::PBIF(QObject *parent, QGuiApplication *app, QQmlApplicationEngine *engine) : QObject(parent)
{
    this->app               = app;
    this->engine            = engine;

    this->applicationState  = idle;
    this->stop              = false;
}

void PBIF::loadQMLComponents() {
    webCam = engine->rootObjects().at(0)->findChild<QObject*>("settingsView")->findChild<QObject*>("webCam");
    togglePose = engine->rootObjects().at(0)->findChild<QObject*>("settingsView")->findChild<QObject*>("togglePoseTracker");
    toggleEyes = engine->rootObjects().at(0)->findChild<QObject*>("settingsView")->findChild<QObject*>("toggleEyeTracker");

    connect(this, SIGNAL(frameUpdated()), webCam, SLOT(updateFrame()));
}

void PBIF::exit() {
    qDebug() << "PBIF: EXIT METHOD CALLED";
    stop = true;
    std::exit(0);
}

//void PBIF::exec() {

//    cap.open(0);

//    if (!cap.isOpened()) {
//        qDebug() << "capWebcam not accessed successfully";
//        return;
//    } else {
//        qDebug() << "capWebcam was successfully opened";
//    }

//    // ALLOCATE MEMORY
//    cap >> im;
//    cv::resize(im, im_small, cv::Size(), 1.0/FACE_DOWNSAMPLE_RATIO, 1.0/FACE_DOWNSAMPLE_RATIO);
//    cv::resize(im, PBIF::im_display, cv::Size(), 0.5, 0.5);

//    cv::Size size = im.size();

//    // LOAD PREDICTOR MODEL
//    deserialize("C:/Users/Samu/Documents/QT-PROJECTS/shape_predictor_68_face_landmarks.dat") >> pose_model;

//    // CORE PROCESSING LOOP
//    processLoopTimer = new QTimer(this);    // instantiate timer
//    connect(processLoopTimer, SIGNAL(timeout()), this, SLOT(processFrameAndUpdateGUI()));   // associate timer to processFrameAndUpdateGUI
//    processLoopTimer->start(100);   // start timer, set to cycle every 100 msec (10x per sec), it will not actually cycle this often

//    // LOAD SETTINGS

//    // QT EVENT LOOP
//    while (!stop) {
//        // QT EVENT LOOP
//        app->processEvents();
//    };

//}

void PBIF::exec() {
    QThread* thread = new QThread;
    imageProcessingWorker* worker = new imageProcessingWorker(webCam, togglePose, toggleEyes);
    worker->moveToThread(thread);
    //connect(worker, SIGNAL(error(QString)), this, SLOT(errorString(QString)));
    connect(thread, SIGNAL(started()), worker, SLOT(initialize()));
    connect(worker, SIGNAL(finished()), thread, SLOT(quit()));
    connect(worker, SIGNAL(finished()), worker, SLOT(deleteLater()));
    connect(thread, SIGNAL(finished()), thread, SLOT(deleteLater()));
    thread->start();
}

//void PBIF::processFrameAndUpdateGUI() {
//    try {
//        // GRAB FRAME
//        cap >> src;
//        cv::flip(src, im, 1);

//        // RESIZE IMAGE FOR FACE DETECTION - OPTIMIZATION
//        cv::resize(im, im_small, cv::Size(), 1.0/FACE_DOWNSAMPLE_RATIO, 1.0/FACE_DOWNSAMPLE_RATIO);

//        // CHANGE TO DLIB'S IMAGE FORMAT. NO MEMORY IS COPIED.
//        cv_image<bgr_pixel> cimg_small(im_small);
//        cv_image<bgr_pixel> cimg(im);

//        // DETECT FACES
//        faces = detector(cimg_small);

//        ////////// POSE ESTIMATION ////////////////////////////////////////////////////////////////////////////////
//        std::vector<cv::Point3d> model_points = get_3d_model_points();

//        // Find the pose of each face.
//        std::vector<full_object_detection> shapes;

//        for (unsigned long i = 0; i < faces.size(); ++i)
//        {
//            rectangle r(
//                        (long)(faces[i].left() * FACE_DOWNSAMPLE_RATIO),
//                        (long)(faces[i].top() * FACE_DOWNSAMPLE_RATIO),
//                        (long)(faces[i].right() * FACE_DOWNSAMPLE_RATIO),
//                        (long)(faces[i].bottom() * FACE_DOWNSAMPLE_RATIO)
//                        );
//            full_object_detection shape = pose_model(cimg, r);
//            shapes.push_back(shape);
//            if (togglePose->property("checked").toBool()) render_face(im, shape);

//            std::vector<cv::Point2d> image_points = get_2d_image_points(shape);
//            double focal_length = im.cols;
//            cv::Mat camera_matrix = get_camera_matrix(focal_length, cv::Point2d(im.cols/2,im.rows/2));
//            cv::Mat rotation_vector;
//            cv::Mat rotation_matrix;
//            cv::Mat translation_vector;

//            cv::Mat dist_coeffs = cv::Mat::zeros(4,1,cv::DataType<double>::type);

//            cv::solvePnP(model_points, image_points, camera_matrix, dist_coeffs, rotation_vector, translation_vector);

//            //cv::Rodrigues(rotation_vector, rotation_matrix); //REF: converts rotation vector to matrix

//            std::vector<cv::Point3d> nose_end_point3D;
//            std::vector<cv::Point2d> nose_end_point2D;
//            nose_end_point3D.push_back(cv::Point3d(0,0,1000.0));

//            cv::projectPoints(nose_end_point3D, rotation_vector, translation_vector, camera_matrix, dist_coeffs, nose_end_point2D);
//            if (togglePose->property("checked").toBool()) cv::line(im,image_points[0], nose_end_point2D[0], cv::Scalar(255,0,0), 2);

//            poseEstimation = nose_end_point2D;

//            //Alternate method of drawing pose estimation
//            //cv::Point2d projected_point = find_projected_point(rotation_matrix, translation_vector, camera_matrix, cv::Point3d(0,0,1000.0));
//            //cv::line(im,image_points[0], projected_point, cv::Scalar(0,0,255), 2);

//            ////////// BLINK DETECTION ////////////////////////////////////////////////////////////////////////////////
//            // CREATE VECTOR OF EYE LANDMARKS
//            std::vector<cv::Point2d> leftEye;
//            for (unsigned long i = 36; i <= 41; ++i) {
//                //l += shape.part(i);
//                leftEye.push_back( cv::Point2d( shape.part(i).x(), shape.part(i).y() ) );
//            }
//            // DRAW OUT EYE LANDMARKS IN OPENCV
//            if (toggleEyes->property("checked").toBool()) {
//                for (i = 0; i < leftEye.size(); ++i) {
//                    cv::circle(im, leftEye[i], 2, cv::Scalar(0, 255, 0), CV_FILLED);
//                }
//            }
//            // UPDATE ONSCREEN LABEL
//            //if (cursorTracking) ui->txtEAR->append(QString::number(eyeAspectRatio(leftEye)));

//            // COUNT/SIMULATE CLICKS
//            if (eyeAspectRatio(leftEye) < EYE_AR_THRESH) {
//                ++blinkFrameCount;
//                //ui->lblBlinks->setText(QString("BLINKS: ") + QString::number(totalBlinks));
//            } else {
//                if (blinkFrameCount >= EYE_AR_CONSEC_FRAMES) {
//                    ++totalBlinks;
//                    //if (cursorTracking) mouse_event(MOUSEEVENTF_ABSOLUTE | MOUSEEVENTF_LEFTDOWN | MOUSEEVENTF_LEFTUP, 1, 1, 0, 0);
//                }
//                blinkFrameCount = 0;
//            }

//            //cout << "Total Blinks: " << totalBlinks << endl;

//        }

//        // Display it all on the screen
//        // Resize image for display
//        PBIF::im_display = im;
//        cv::resize(im, PBIF::im_display, cv::Size(), 0.5, 0.5);

//        emit frameUpdated();

//    } catch(serialization_error& e) {

//        cout << "You need dlib's default face landmarking model file to run this example." << endl;
//        cout << "You can get it from the following URL: " << endl;
//        cout << "   http://dlib.net/files/shape_predictor_68_face_landmarks.dat.bz2" << endl;
//        cout << endl << e.what() << endl;

//    } catch(exception& e) {
//        cout << e.what() << endl;
//    }
//}
