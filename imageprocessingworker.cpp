#include "imageprocessingworker.h"
#include "render_face.cpp"

using namespace dlib;
using namespace std;

#define FACE_DOWNSAMPLE_RATIO 4
#define SKIP_FRAMES 2

#define EYE_AR_THRESH 0.2
#define EYE_AR_CONSEC_FRAMES 4

cv::Mat imageProcessingWorker::im_display;

imageProcessingWorker::imageProcessingWorker(QObject *webCam,  QObject *togglePose, QObject *toggleEyes)
{
    this->webCam = webCam;
    this->togglePose = togglePose;
    this->toggleEyes = toggleEyes;
}

imageProcessingWorker::~imageProcessingWorker()
{

}

std::vector<cv::Point3d> get_3d_model_points() {
    std::vector<cv::Point3d> modelPoints;

    modelPoints.push_back(cv::Point3d(0.0f, 0.0f, 0.0f)); //The first must be (0,0,0) while using POSIT
    modelPoints.push_back(cv::Point3d(0.0f, -330.0f, -65.0f));
    modelPoints.push_back(cv::Point3d(-225.0f, 170.0f, -135.0f));
    modelPoints.push_back(cv::Point3d(225.0f, 170.0f, -135.0f));
    modelPoints.push_back(cv::Point3d(-150.0f, -150.0f, -125.0f));
    modelPoints.push_back(cv::Point3d(150.0f, -150.0f, -125.0f));

    return modelPoints;

}

std::vector<cv::Point2d> get_2d_image_points(full_object_detection &d) {
    std::vector<cv::Point2d> image_points;
    image_points.push_back( cv::Point2d( d.part(30).x(), d.part(30).y() ) );    // Nose tip
    image_points.push_back( cv::Point2d( d.part(8).x(), d.part(8).y() ) );      // Chin
    image_points.push_back( cv::Point2d( d.part(36).x(), d.part(36).y() ) );    // Left eye left corner
    image_points.push_back( cv::Point2d( d.part(45).x(), d.part(45).y() ) );    // Right eye right corner
    image_points.push_back( cv::Point2d( d.part(48).x(), d.part(48).y() ) );    // Left Mouth corner
    image_points.push_back( cv::Point2d( d.part(54).x(), d.part(54).y() ) );    // Right mouth corner
    return image_points;

}

cv::Mat get_camera_matrix(float focal_length, cv::Point2d center) {
    cv::Mat camera_matrix = (cv::Mat_<double>(3,3) << focal_length, 0, center.x, 0 , focal_length, center.y, 0, 0, 1);
    return camera_matrix;
}

double imageProcessingWorker::eyeAspectRatio(std::vector<cv::Point2d> eye) {
    // Compute vertical euclidean distances
    double A = sqrt( (eye[1].x - eye[5].x)*(eye[1].x - eye[5].x) + (eye[1].y - eye[5].y)*(eye[1].y - eye[5].y) );
    double B = sqrt( (eye[2].x - eye[4].x)*(eye[2].x - eye[4].x) + (eye[2].y - eye[4].y)*(eye[2].y - eye[4].y) );

    // Compute horizontal euclidean distance
    double C = sqrt( (eye[0].x - eye[3].x)*(eye[0].x - eye[3].x) + (eye[0].y - eye[3].y)*(eye[0].y - eye[3].y) );

    double ear = (A + B) / (2 * C);
    return ear;
}

void imageProcessingWorker::initialize() {
    // INITIALIZE WEBCAM INTERFACE
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
    cv::resize(im, imageProcessingWorker::im_display, cv::Size(), 0.5, 0.5);

    cv::Size size = im.size();

    // LOAD PREDICTOR MODEL
    deserialize("C:/Users/Samu/Documents/QT-PROJECTS/shape_predictor_68_face_landmarks.dat") >> pose_model;

    connect(this, SIGNAL(frameUpdated()), webCam, SLOT(updateFrame()));

    // PROCESS LOOP FOR POLLING IMAGE UPDATES
    processLoopTimer = new QTimer(this);
    connect(processLoopTimer, SIGNAL(timeout()), this, SLOT(process()));
    processLoopTimer->start(10);   // start timer, set to cycle every 10 msec (100x per sec), it will not actually cycle this often
}

void imageProcessingWorker::process() {
    callsToUpdate++;
    if (callsToUpdate % 10 == 0) {
        callsToUpdateSecs++;
        qDebug() << "Process has been running for: " << callsToUpdateSecs << " seconds.";
    }

    try {
        // GRAB FRAME
        cap >> src;
        cv::flip(src, im, 1);

        // RESIZE IMAGE FOR FACE DETECTION - OPTIMIZATION
        cv::resize(im, im_small, cv::Size(), 1.0/FACE_DOWNSAMPLE_RATIO, 1.0/FACE_DOWNSAMPLE_RATIO);

        // CHANGE TO DLIB'S IMAGE FORMAT. NO MEMORY IS COPIED.
        cv_image<bgr_pixel> cimg_small(im_small);
        cv_image<bgr_pixel> cimg(im);

        // DETECT FACES
        faces = detector(cimg_small);

        ////////// POSE ESTIMATION ////////////////////////////////////////////////////////////////////////////////
        std::vector<cv::Point3d> model_points = get_3d_model_points();

        // Find the pose of each face.
        std::vector<full_object_detection> shapes;

        for (unsigned long i = 0; i < faces.size(); ++i)
        {
            rectangle r(
                        (long)(faces[i].left() * FACE_DOWNSAMPLE_RATIO),
                        (long)(faces[i].top() * FACE_DOWNSAMPLE_RATIO),
                        (long)(faces[i].right() * FACE_DOWNSAMPLE_RATIO),
                        (long)(faces[i].bottom() * FACE_DOWNSAMPLE_RATIO)
                        );
            full_object_detection shape = pose_model(cimg, r);
            shapes.push_back(shape);
            if (togglePose->property("checked").toBool()) render_face(im, shape);
            //render_face(im, shape);

            std::vector<cv::Point2d> image_points = get_2d_image_points(shape);
            double focal_length = im.cols;
            cv::Mat camera_matrix = get_camera_matrix(focal_length, cv::Point2d(im.cols/2,im.rows/2));
            cv::Mat rotation_vector;
            cv::Mat rotation_matrix;
            cv::Mat translation_vector;

            cv::Mat dist_coeffs = cv::Mat::zeros(4,1,cv::DataType<double>::type);

            cv::solvePnP(model_points, image_points, camera_matrix, dist_coeffs, rotation_vector, translation_vector);

            //cv::Rodrigues(rotation_vector, rotation_matrix); //REF: converts rotation vector to matrix

            std::vector<cv::Point3d> nose_end_point3D;
            std::vector<cv::Point2d> nose_end_point2D;
            nose_end_point3D.push_back(cv::Point3d(0,0,1000.0));

            cv::projectPoints(nose_end_point3D, rotation_vector, translation_vector, camera_matrix, dist_coeffs, nose_end_point2D);
            if (togglePose->property("checked").toBool()) cv::line(im,image_points[0], nose_end_point2D[0], cv::Scalar(255,0,0), 2);
            //cv::line(im,image_points[0], nose_end_point2D[0], cv::Scalar(255,0,0), 2);

            poseEstimation = nose_end_point2D;

            //Alternate method of drawing pose estimation
            //cv::Point2d projected_point = find_projected_point(rotation_matrix, translation_vector, camera_matrix, cv::Point3d(0,0,1000.0));
            //cv::line(im,image_points[0], projected_point, cv::Scalar(0,0,255), 2);

            ////////// BLINK DETECTION ////////////////////////////////////////////////////////////////////////////////
            // CREATE VECTOR OF EYE LANDMARKS
            std::vector<cv::Point2d> leftEye;
            for (unsigned long i = 36; i <= 41; ++i) {
                //l += shape.part(i);
                leftEye.push_back( cv::Point2d( shape.part(i).x(), shape.part(i).y() ) );
            }
            // DRAW OUT EYE LANDMARKS IN OPENCV
            if (toggleEyes->property("checked").toBool()) {
                for (i = 0; i < leftEye.size(); ++i) {
                    cv::circle(im, leftEye[i], 2, cv::Scalar(0, 255, 0), CV_FILLED);
                }
            }
            // UPDATE ONSCREEN LABEL
            //if (cursorTracking) ui->txtEAR->append(QString::number(eyeAspectRatio(leftEye)));

            // COUNT/SIMULATE CLICKS
            if (eyeAspectRatio(leftEye) < EYE_AR_THRESH) {
                ++blinkFrameCount;
                //ui->lblBlinks->setText(QString("BLINKS: ") + QString::number(totalBlinks));
            } else {
                if (blinkFrameCount >= EYE_AR_CONSEC_FRAMES) {
                    ++totalBlinks;
                    //if (cursorTracking) mouse_event(MOUSEEVENTF_ABSOLUTE | MOUSEEVENTF_LEFTDOWN | MOUSEEVENTF_LEFTUP, 1, 1, 0, 0);
                }
                blinkFrameCount = 0;
            }

            //cout << "Total Blinks: " << totalBlinks << endl;

        }

        // Display it all on the screen
        // Resize image for display
        imageProcessingWorker::im_display = im;
        cv::resize(im, imageProcessingWorker::im_display, cv::Size(), 0.5, 0.5);

        emit frameUpdated();

    } catch(serialization_error& e) {

        cout << "You need dlib's default face landmarking model file to run this example." << endl;
        cout << "You can get it from the following URL: " << endl;
        cout << "   http://dlib.net/files/shape_predictor_68_face_landmarks.dat.bz2" << endl;
        cout << endl << e.what() << endl;

    } catch(exception& e) {
        cout << e.what() << endl;
    }
}
