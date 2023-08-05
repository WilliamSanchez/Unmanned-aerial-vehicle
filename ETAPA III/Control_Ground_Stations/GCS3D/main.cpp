// Copyright 2023 ESRI
//
// All rights reserved under the copyright laws of the United States
// and applicable international laws, treaties, and conventions.
//
// You may freely redistribute and use this sample code, with or
// without modification, provided you include the original copyright
// notice and use restrictions.
//
// See the Sample code usage restrictions document for further information.
//

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>
#include <QDir>
#include <QtPlugin>
#include <QSurfaceFormat>

#include "QQmlContext"
#include "datauav.h"

//------------------------------------------------------------------------------

int main(int argc, char *argv[])
{
    qDebug() << "Initializing application";

#if defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID)
    // Linux requires 3.2 OpenGL Context
    // in order to instance 3D symbols
    QSurfaceFormat fmt = QSurfaceFormat::defaultFormat();
    fmt.setVersion(3, 2);
    QSurfaceFormat::setDefaultFormat(fmt);
#endif

#if defined(Q_OS_IOS)
#  if QT_VERSION >= QT_VERSION_CHECK(6, 3, 0)
    extern const QStaticPlugin qt_static_plugin_ArcGISRuntimePlugin_compatibility();
    qRegisterStaticPluginFunction(qt_static_plugin_ArcGISRuntimePlugin_compatibility());
#  endif
#endif

    QGuiApplication app(argc, argv);

    qmlRegisterType<dataUAV>("DQdata",1,0,"DataUAV");

    // Use of Esri location services, including basemaps and geocoding, requires
    // either an ArcGIS identity or an API key. For more information see
    // https://links.esri.com/arcgis-runtime-security-auth.

    // 1. ArcGIS identity: An ArcGIS named user account that is a member of an
    // organization in ArcGIS Online or ArcGIS Enterprise.

    // 2. API key: A permanent key that gives your application access to Esri
    // location services. Create a new API key or access existing API keys from
    // your ArcGIS for Developers dashboard (https://links.esri.com/arcgis-api-keys).

    const QString apiKey = QString("AAPKf4af4f16bdbd45af87f2c6d407a776baZQCQ2zXKSszFf9rebrTF2TOEbpoe-s0KDTv86kYGyzYqgNgWAYAnY_6CWO-Sx9oU");
    if (apiKey.isEmpty())
    {
        qWarning() << "Use of Esri location services, including basemaps, requires" <<
                      "you to authenticate with an ArcGIS identity or set the API Key property.";
    }
    else
    {
        QCoreApplication::instance()->setProperty("Esri.ArcGISRuntime.apiKey", apiKey);
    }

    // Production deployment of applications built with ArcGIS Maps SDK requires you to
    // license ArcGIS Maps SDK functionality. For more information see
    // https://links.esri.com/arcgis-runtime-license-and-deploy.

    // QCoreApplication::instance()->setProperty("Esri.ArcGISRuntime.license", "licenseString");

    // Intialize application window
    QQmlApplicationEngine appEngine;
    appEngine.addImportPath(QDir(QCoreApplication::applicationDirPath()).filePath("qml"));

#ifdef ARCGIS_RUNTIME_IMPORT_PATH_2
    appEngine.addImportPath(ARCGIS_RUNTIME_IMPORT_PATH_2);
#endif

    appEngine.load(QUrl("qrc:/qml/main.qml"));

    auto topLevelObject = appEngine.rootObjects().value(0);
    auto window = qobject_cast<QQuickWindow*>(topLevelObject);
    if (!window)
    {
        qCritical("Error: Your root item has to be a Window.");

        return -1;
    }

    window->show();

    return app.exec();
}
