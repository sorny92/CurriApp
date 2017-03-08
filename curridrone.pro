QT += qml quick websockets multimedia

include(deps/QmlVlc/QmlVlc.pri)

INCLUDEPATH += deps

CONFIG += c++11

SOURCES += main.cpp

RESOURCES += qml.qrc

android {
    LIBS += -L$$PWD/android/libs/armeabi-v7a -lvlcjni

    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
}
# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
