QT += qml quick

CONFIG += c++11

SOURCES += main.cpp \
    webcam.cpp \
    ../../../../../dlib/dlib/all/source.cpp \
    render_face.cpp \
    pbif.cpp \
    imageprocessingworker.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    webcam.h \
    pbif.h \
    imageprocessingworker.h

# OpenCV Libs
INCLUDEPATH += C:\\OpenCV-3.2.0\\opencv\\build\\include

LIBS += -LC:\\OpenCV-3.2.0\\mybuild\\lib\\Debug \
    -lopencv_core320d \
    -lopencv_stitching320d \
    -lopencv_videostab320d \
    -lopencv_calib3d320d \
    -lopencv_ts320d \
    -lopencv_features2d320d \
    -lopencv_objdetect320d \
    -lopencv_highgui320d \
    -lopencv_superres320d \
    -lopencv_videoio320d \
    -lopencv_shape320d \
    -lopencv_photo320d \
    -lopencv_imgcodecs320d \
    -lopencv_video320d \
    -lopencv_imgproc320d \
    -lopencv_flann320d \
    -lopencv_ml320d

# Dlibs Libs
#INCLUDEPATH += C:\\dlib-19.4\\include
#LIBS += -LC:\dlib-19.4\lib -ldlib
INCLUDEPATH += C:\dlib
LIBS+= -lgdi32 -lcomctl32 -luser32 -lwinmm -lws2_32

DISTFILES +=
