#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDirIterator>
#include <QLocale>
#include <QTranslator>
#include <QQmlContext>
#include <QImage>
#include "diolib.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    DIOlib iolib;
    iolib.registerToQML();
    QGuiApplication app(argc, argv);

    QTranslator translator;
    const QStringList uiLanguages = QLocale::system().uiLanguages();
    for (const QString &locale : uiLanguages) {
        const QString baseName = "dilosi_" + QLocale(locale).name();
        if (translator.load(":/i18n/" + baseName)) {
            app.installTranslator(&translator);
            break;
        }
    }
    QTextStream(stdout) << "Start\n";

    QQmlApplicationEngine engine;
    engine.addImportPath("qrc:");

    // test resource path
    QImage img(":/img/24x24/andGate.png");
    qDebug() << img.width();

    iolib.setEngine(engine);

    engine.rootContext()->setContextProperty("iolib", &iolib);

    const QUrl url(QStringLiteral("qrc:/main.qml"));

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
