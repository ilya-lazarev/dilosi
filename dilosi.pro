QT += quick

CONFIG += c++11

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        diolib.cpp \
        main.cpp

RESOURCES += qml.qrc Gates/Gates.qrc


TRANSLATIONS += \
    dilosi_en_US.ts
CONFIG += lrelease
CONFIG += embed_translations

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH += $$PWD/Gates

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH += $$PWD/Gates

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    img/24x24/filenew.png \
    img/24x24/fileopen.png \
    img/24x24/filesave.png \
    img/24x24/filesaveas.png \
    img/24x24/finish.png

HEADERS += \
    diolib.h
