#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QmlVlc.h>
#include <QmlVlc/QmlVlcConfig.h>

int main(int argc, char *argv[])
{
    RegisterQmlVlc();
    QmlVlcConfig& config = QmlVlcConfig::instance();
    config.enableAdjustFilter( true );
    config.enableMarqueeFilter( true );
    config.enableLogoFilter( true );
    config.enableDebug( false );

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    return app.exec();
}
