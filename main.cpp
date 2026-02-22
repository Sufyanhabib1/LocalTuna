#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QTimer>
#include <QQuickStyle>

#include "backend/musicmanager.h"

int main(int argc, char *argv[])
{
    QQuickStyle::setStyle("Fusion");
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    MusicManager manager;
    engine.rootContext()->setContextProperty("musicManager", &manager);
    engine.load(QUrl(QStringLiteral("qrc:/Main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    // Load songs AFTER QML is ready
    QTimer::singleShot(0, &manager, &MusicManager::loadSongs);

    return app.exec();
}
