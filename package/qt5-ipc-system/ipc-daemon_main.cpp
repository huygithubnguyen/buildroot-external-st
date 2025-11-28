#include <QCoreApplication>
#include <QDebug>
#include <csignal>
#include "ipc_server_enhanced.h"

static IPCServerEnhanced* g_server = nullptr;

void signalHandler(int signal) {
    qDebug() << "Received signal" << signal << "- shutting down IPC daemon";
    if (g_server) {
        g_server->stop();
    }
    QCoreApplication::exit(0);
}

int main(int argc, char *argv[]) {
    QCoreApplication app(argc, argv);

    // Set up signal handlers
    signal(SIGTERM, signalHandler);
    signal(SIGINT, signalHandler);

    g_server = new IPCServerEnhanced(&app);

    // Start the enhanced IPC server
    if (!g_server->start()) {
        qCritical() << "Failed to start enhanced IPC server";
        return 1;
    }

    qDebug() << "Enhanced IPC daemon started successfully";
    qDebug() << "Server listening on:" << IPC_SOCKET_PATH;
    qDebug() << "Authentication: ENABLED";
    qDebug() << "Zero-copy: ENABLED";
    qDebug() << "Performance monitoring: ENABLED";

    return app.exec();
}
