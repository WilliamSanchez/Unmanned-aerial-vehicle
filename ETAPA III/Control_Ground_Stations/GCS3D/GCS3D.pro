#-------------------------------------------------
#  Copyright 2023 ESRI
#
#  All rights reserved under the copyright laws of the United States
#  and applicable international laws, treaties, and conventions.
#
#  You may freely redistribute and use this sample code, with or
#  without modification, provided you include the original copyright
#  notice and use restrictions.
#
#  See the Sample code usage restrictions document for further information.
#-------------------------------------------------

mac {
    cache()
}

#-------------------------------------------------------------------------------

CONFIG += c++17

# additional modules are pulled in via arcgisruntime.pri
QT += qml quick

ARCGIS_RUNTIME_VERSION = 200.1.0
include($$PWD/arcgisruntime.pri)

TEMPLATE = app
TARGET = GCS3D

lessThan(QT_MAJOR_VERSION, 6) {
    error("$$TARGET requires Qt 6.2.4")
}

equals(QT_MAJOR_VERSION, 6) {
    lessThan(QT_MINOR_VERSION, 2) {
        error("$$TARGET requires Qt 6.2.4")
    }
	equals(QT_MINOR_VERSION, 2) : lessThan(QT_PATCH_VERSION, 4) {
		error("$$TARGET requires Qt 6.2.4")
	}
}

#-------------------------------------------------------------------------------

SOURCES += \
    datauav.cpp \
    main.cpp

RESOURCES += \
    qml/qml.qrc

OTHER_FILES += \
    wizard.xml \
    wizard.png

#-------------------------------------------------------------------------------

HEADERS += \
    datauav.h

DISTFILES += \
    ui/OrientationBar/ArtificialHorizon.qml

