#include <QApplication>
#include <QLabel>
#include <QPushButton>
#include <QVBoxLayout>
#include "ipc_client_enhanced.h"

class Qt5DemoIPC : public QWidget {
    Q_OBJECT

public:
    Qt5DemoIPC(QWidget* parent = nullptr) : QWidget(parent) {
        // Initialize enhanced IPC client
        m_ipc = new IPCClientEnhanced(IPC_SERVICE_QT5_DEMO, this);
        
        // Connect IPC signals
        connect(m_ipc, &IPCClientEnhanced::connected, this, &Qt5DemoIPC::onIPCConnected);
        connect(m_ipc, &IPCClientEnhanced::messageReceived, this, &Qt5DemoIPC::onIPCMessage);
        connect(m_ipc, &IPCClientEnhanced::error, this, &Qt5DemoIPC::onIPCError);
        connect(m_ipc, &IPCClientEnhanced::disconnected, this, &Qt5DemoIPC::onIPCDisconnected);
        
        // Connect to IPC server
        m_ipc->connectToServer(IPC_AUTH_BASIC);
        
        // Setup UI
        auto* layout = new QVBoxLayout(this);
        
        m_status_label = new QLabel("Connecting to IPC...");
        m_status_label->setAlignment(Qt::AlignCenter);
        layout->addWidget(m_status_label);
        
        auto* button = new QPushButton("Send IPC Event");
        connect(button, &QPushButton::clicked, this, &Qt5DemoIPC::onSendIPCEvent);
        layout->addWidget(button);
        
        auto* heartbeat_label = new QLabel("Heartbeat: --");
        heartbeat_label->setAlignment(Qt::AlignCenter);
        layout->addWidget(heartbeat_label);
        
        setLayout(layout);
    }

private slots:
    void onIPCConnected() {
        m_status_label->setText("✅ Connected to IPC Server");
        m_ipc->registerService("Qt5-Demo-Enhanced");
        m_ipc->sendStatus("Qt5 Demo with Enhanced IPC ready");
    }
    
    void onIPCMessage(const ipc_message_enhanced_t& msg) {
        QString data = QString::fromUtf8(reinterpret_cast<const char*>(msg.data), msg.data_len);
        m_status_label->setText(QString("Received: %1").arg(data));
        
        // Handle heartbeat messages
        if (msg.msg_type == IPC_MSG_HEARTBEAT) {
            heartbeat_label->setText("✅ Heartbeat received");
        }
    }
    
    void onIPCError(const QString& error) {
        m_status_label->setText(QString("❌ IPC Error: %1").arg(error));
    }
    
    void onIPCDisconnected() {
        m_status_label->setText("❌ Disconnected from IPC Server");
    }
    
    void onSendIPCEvent() {
        static int event_count = 0;
        event_count++;
        
        QString event_data = QString("{\"event\":\"button_click\",\"count\":%1}")
                                .arg(event_count);
        
        m_ipc->sendEventWithPriority(event_data, 200); // High priority
        m_status_label->setText(QString("Sent event %1").arg(event_count));
    }

private:
    IPCClientEnhanced* m_ipc;
    QLabel* m_status_label;
    QLabel* m_heartbeat_label;
};

#include "qt5-demo-ipc.moc"
